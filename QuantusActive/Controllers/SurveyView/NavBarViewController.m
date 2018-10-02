//
//  NavBarViewController.m
//  QuantusActive
//
//  Created by Workstation on 3/11/12.
//  Copyright (c) 2012 Quantus. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "NavBarViewController.h"
#import "Viewport.h"
#import "SideImageButton.h"
#import "SoundPlayerPool.h"
#import "SurveyDefaults.h"
#import "Model.h"

#define BUTTON_WIDTH  200
#define BUTTON_HEIGHT 72
#define BRAKE_TIME    0.35
#define GESTURE_AREA_HEIGHT BUTTON_HEIGHT
#define SHADOW_RADIUS 20.0

@interface NavBarViewController() {
@private
    UIWebView   *infoView;
    SideImageButton *leftButton;
    SideImageButton *rightButton;
    
    enum SurveyQuestionState currentQuestionState;
    NSArray *anchorPoints;
    int firstY;
}
- (void)showHelp;
- (void)updateButtonStates;
- (void)scrollTo:(CGFloat)y;
- (void)scrollTo:(CGFloat)y withAction:(void (^)(void))action;
- (void)disappearAndPerformAction:(void (^)(void))action;
- (NSInteger)anchorFor:(CGFloat)y;
@end

@implementation NavBarViewController
@synthesize surveyQuestionController, surveyControlDelegate;

- (id)init
{
    if ((self = [super init])) {
        anchorPoints = [NSArray arrayWithObjects:
                        [NSNumber numberWithInt:-[Viewport navFrame].size.height],
                        [NSNumber numberWithInt:-[Viewport navFrame].size.height + BUTTON_HEIGHT],
                        [NSNumber numberWithInt:0],
                        nil];

        [SoundPlayerPool preparePoolFor:@"nextQuestion.caf" play:NO];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Property handling
- (void)setSurveyQuestionController:(SurveyQuestionBaseController *)someController
{
    // Removes observer for previous controller
    [surveyQuestionController removeObserver:self
                                  forKeyPath:@"hasValidAnswers"
                                     context:nil];
    
    // Adds observer for current controller
    surveyQuestionController = someController;
    
    [surveyQuestionController addObserver:self
                               forKeyPath:@"hasValidAnswers"
                                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                  context:nil];
    
    // Load info page
    NSString *fileName = [[[someController class] description]
                          stringByReplacingOccurrencesOfString:@"ViewController"
                          withString:@""];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName
                                                         ofType:@"html"];
    
    if (!filePath) {
        // TODO: Emit error
        NSLog(@"Instruction page not found: %@", fileName);
        filePath = [[NSBundle mainBundle] pathForResource:@"no_instructions"
                                                   ofType:@"html"];
    }
    
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    [infoView loadRequest:[NSURLRequest requestWithURL:fileURL]];
    
    currentQuestionState = SurveyQuestionStateInProcess;
    [self updateButtonStates];
    
    [self hide];
    self.view.hidden = [someController skipsNavigation];
}

#pragma mark - Events
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context 
{    
    // Wrong keypath (shouldn't happen)
    if (![keyPath isEqualToString:@"hasValidAnswers"])
        return;
    
    // No change
    if ([[change objectForKey:NSKeyValueChangeNewKey] isEqual:[change objectForKey:NSKeyValueChangeOldKey]])
        return;
    
    if ([surveyQuestionController skipsNavigation] && surveyQuestionController.hasValidAnswers) {
        [surveyControlDelegate loadNextQuestion];
        return;
    }

    switch (currentQuestionState) {
        case SurveyQuestionStateInProcess:
            if (!surveyQuestionController.hasValidAnswers) {
                currentQuestionState = SurveyQuestionStateInProcess;
                [self hide];
                break;
            }
            currentQuestionState = [surveyQuestionController needsConfirmation]? SurveyQuestionStateAwaitingConfirmation :
            [surveyQuestionController canBeReset]? SurveyQuestionStateShowingReset :
            SurveyQuestionStateAnswered;
            
            if (currentQuestionState != SurveyQuestionStateAwaitingConfirmation)
                [surveyQuestionController disableInteractions];
            [self show];
            [SoundPlayerPool playFile:@"nextQuestion.caf"];
            break;
        case SurveyQuestionStateAwaitingConfirmation:
            if (!surveyQuestionController.hasValidAnswers) {
                currentQuestionState = SurveyQuestionStateInProcess;
                [self hide];
            }
            break;
        case SurveyQuestionStateAnswered:
        case SurveyQuestionStateShowingReset:
        case SurveyQuestionStateIllegal:
        default:
            // Should not be here
            [NSException raise:NSGenericException format:@"Illegal navigation state reached."];
            break;
    }
    [self updateButtonStates];
}

- (void)leftButtonPressed
{
    switch (currentQuestionState) {
        case SurveyQuestionStateInProcess:
        case SurveyQuestionStateAwaitingConfirmation:
        case SurveyQuestionStateAnswered:
        {
            [self disappearAndPerformAction:^{
                NSString *questionMessage = @"¿Desea usted salir de la encuesta?";
                if ([Model currentQuestionIndex] == kQuestionWelcomeIndex) {
                    questionMessage = @"¿Deseas cerrar tu sesión?";
                }
                
                UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Quantus"
                                                                  message:questionMessage
                                                                 delegate:self
                                                        cancelButtonTitle:@"No"
                                                        otherButtonTitles:@"Si", nil];
                [message show];
            }];
            break;       
        }
        case SurveyQuestionStateShowingReset:
        {
            [surveyQuestionController reset];
            currentQuestionState = SurveyQuestionStateInProcess;
            [surveyQuestionController enableInteractions];
            break;
        }
        case SurveyQuestionStateIllegal:
        default:
            // Should not be here
            [NSException raise:NSGenericException format:@"Illegal navigation state reached."];
            break;
    }
    [self updateButtonStates];
}

- (void)rightButtonPressed
{
    switch (currentQuestionState) {
        case SurveyQuestionStateInProcess:
            if (!surveyQuestionController.hasValidAnswers)
                [self showHelp];
            else
                [surveyControlDelegate loadNextQuestion];
            break;
        case SurveyQuestionStateAwaitingConfirmation:
            if (surveyQuestionController.hasValidAnswers) {
                [surveyQuestionController disableInteractions];
                currentQuestionState = [surveyQuestionController canBeReset]? SurveyQuestionStateShowingReset : SurveyQuestionStateAnswered;
            }
            break;
        case SurveyQuestionStateAnswered:
        case SurveyQuestionStateShowingReset:
        {
            [self disappearAndPerformAction:^{
                [surveyControlDelegate loadNextQuestion];
            }];
            break;
        }
        case SurveyQuestionStateIllegal:
        default:
            // Should not be here
            [NSException raise:NSGenericException format:@"Illegal navigation state reached."];
            break;
    }
    [self updateButtonStates];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Si"]) {
        [surveyControlDelegate exitSurvey];
    } else {
        [self hide];
    }

}


#pragma mark - Visibility
- (void)show
{
    [self scrollTo:[[anchorPoints objectAtIndex:1] floatValue]];
}

- (void)hide
{
    [self scrollTo:[[anchorPoints objectAtIndex:0] floatValue]];
}

- (void)toggle
{
    int hiddenOffset = [[anchorPoints objectAtIndex:0] intValue];
    
    if ([self anchorFor:self.view.frame.origin.y] == hiddenOffset)
        [self show];
    else
        [self hide];
}

- (void)disappearAndPerformAction:(void (^)(void))action
{
    [self scrollTo:-self.view.bounds.size.height
        withAction:action];
}

- (void)showHelp
{
    int helpOffset = [[anchorPoints lastObject] intValue];
    
    if ([self anchorFor:self.view.frame.origin.y] == helpOffset)
        [self hide];
    else
        [self scrollTo:helpOffset];
}

- (void)updateButtonStates
{
    switch (currentQuestionState) {
        case SurveyQuestionStateInProcess:
            leftButton.customState  = LeftNavButtonControlStateDisplayExit;
            rightButton.customState = RightNavButtonControlStateDisplayHelp;
            break;
        case SurveyQuestionStateAwaitingConfirmation:
            leftButton.customState  = LeftNavButtonControlStateDisplayExit;
            rightButton.customState = RightNavButtonControlStateDisplayConfirm;
            break;
        case SurveyQuestionStateAnswered:
            leftButton.customState  = LeftNavButtonControlStateDisplayExit;
            rightButton.customState = RightNavButtonControlStateDisplayNext;
            break;
        case SurveyQuestionStateShowingReset:
            leftButton.customState  = LeftNavButtonControlStateDisplayChangeAnswers;
            rightButton.customState = RightNavButtonControlStateDisplayNext;
            break;
        case SurveyQuestionStateIllegal:
        default:
            // Do nothing
            break;
    }
}

- (NSInteger)anchorFor:(CGFloat)y
{    
    if (y <= [[anchorPoints objectAtIndex:0] intValue])
        return [[anchorPoints objectAtIndex:0] intValue];
    else if (y >= [anchorPoints.lastObject intValue])
        return [anchorPoints.lastObject intValue];
    else {
        for (int i = 0; i < [anchorPoints count] - 1; i++) {
            CGFloat min = [[anchorPoints objectAtIndex:i] intValue];
            CGFloat max = [[anchorPoints objectAtIndex:i + 1] intValue];
            if (y >= min && y <= max)
                return (int) round((y - min) / (max - min)) * (max - min) + min;
        }
    }
    return 0;
}

// TODO: Use enum names instead of anchorPoints array?

- (void)notifyAction
{
    if ([self anchorFor:self.view.frame.origin.y] == [[anchorPoints objectAtIndex:0] intValue])
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NavBarWasHidden" object:nil];
    
    else
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NavBarWasShown" object:nil];
}

- (void)scrollTo:(CGFloat)y
{
    [UIView animateWithDuration:BRAKE_TIME
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.view.frame = CGRectOffset(self.view.bounds, 0, y);
                     }
                     completion:^(BOOL finished) {
                         self.view.frame = CGRectIntegral(self.view.frame);
                         [self notifyAction];
                     }];   
}

- (void)scrollTo:(CGFloat)y withAction:(void (^)(void))action
{
    [UIView animateWithDuration:BRAKE_TIME
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.view.frame = CGRectOffset(self.view.bounds, 0, y);
                     }
                     completion:^(BOOL finished) {
                         self.view.frame = CGRectIntegral(self.view.frame);
                         action();
                         [self notifyAction];
                     }];   
}

- (void)move:(UIPanGestureRecognizer*)sender
{
    if (currentQuestionState == SurveyQuestionStateAnswered)
        return;
    
//	[self.view.layer removeAllAnimations];        
	CGPoint translatedPoint = [sender translationInView:self.view];
    
	if ([sender state] == UIGestureRecognizerStateBegan)   
		firstY = self.view.center.y;
    
	translatedPoint = CGPointMake(self.view.center.x, firstY + translatedPoint.y);
    translatedPoint.y = MIN(translatedPoint.y, self.view.frame.size.height / 2.0);
    self.view.center = translatedPoint;
    
	if ([sender state] == UIGestureRecognizerStateEnded) {        
		CGFloat finalY = translatedPoint.y + (BRAKE_TIME * BRAKE_TIME * [sender velocityInView:self.view].y);
        
        CGFloat y = finalY - self.view.frame.size.height / 2.0;
        finalY = [self anchorFor:y];
        
        [self scrollTo:finalY];;         
	}
}

- (void)tap:(UITapGestureRecognizer *)sender
{
    CGPoint location = [sender locationInView:self.view];
    CGRect bottomArea = CGRectMake(0, self.view.bounds.size.height - GESTURE_AREA_HEIGHT, self.view.bounds.size.width, GESTURE_AREA_HEIGHT);
    if (CGRectContainsPoint(bottomArea, location)) {
        [self toggle];
    }
}

#pragma mark - View lifecycle
- (void)setupNavigationButtons
{
    UIImage *redBackground     = [[UIImage imageNamed:@"nav_background_red.png"]
                                  resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    UIImage *greenBackground   = [[UIImage imageNamed:@"nav_background_green.png"]
                                  resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    UIImage *cyanBackground    = [[UIImage imageNamed:@"nav_background_cyan.png"]
                                  resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    UIImage *yellowBackground  = [[UIImage imageNamed:@"nav_background_yellow.png"]
                                  resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    UIImage *magentaBackground = [[UIImage imageNamed:@"nav_background_magenta.png"]
                                  resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    CGRect navbarFrame = self.view.bounds;
    
    // Left side button
    leftButton = [SideImageButton button];
    leftButton.frame = CGRectIntegral(CGRectOffset(CGRectMake(0, 0, BUTTON_WIDTH, BUTTON_HEIGHT), 0, navbarFrame.size.height - BUTTON_HEIGHT));
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    leftButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    leftButton.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    leftButton.titleLabel.textAlignment = UITextAlignmentCenter;
    leftButton.titleLabel.font = [SurveyDefaults controlsFont];
    leftButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    
    [leftButton addTarget:self
                   action:@selector(leftButtonPressed)
         forControlEvents:UIControlEventTouchUpInside];
        
    // Exit
    [leftButton setImage:[UIImage imageNamed:@"nav_icon_cancel.png"]
                forState:LeftNavButtonControlStateDisplayExit];
    [leftButton setTitle:@"Salir" 
                forState:LeftNavButtonControlStateDisplayExit];
    
    [leftButton setImage:[UIImage imageNamed:@"nav_icon_cancel.png"]
                forState:LeftNavButtonControlStateDisplayExit | UIControlStateHighlighted];
    [leftButton setTitle:@"Salir"
                forState:LeftNavButtonControlStateDisplayExit | UIControlStateHighlighted];
    
    [leftButton setBackgroundImage:redBackground
                          forState:LeftNavButtonControlStateDisplayExit | UIControlStateHighlighted];
    
    // Change answers
    [leftButton setImage:[UIImage imageNamed:@"nav_icon_return.png"]
                forState:LeftNavButtonControlStateDisplayChangeAnswers];
    [leftButton setTitle:@"Cambiar respuesta"
                forState:LeftNavButtonControlStateDisplayChangeAnswers];
    
    [leftButton setImage:[UIImage imageNamed:@"nav_icon_return.png"]
                forState:LeftNavButtonControlStateDisplayChangeAnswers | UIControlStateHighlighted];
    [leftButton setTitle:@"Cambiar respuesta"
                forState:LeftNavButtonControlStateDisplayChangeAnswers | UIControlStateHighlighted];
    
    [leftButton setBackgroundImage:magentaBackground
                          forState:LeftNavButtonControlStateDisplayChangeAnswers | UIControlStateHighlighted];
    
    [self.view addSubview:leftButton];
    
    // Right side button
    rightButton = [SideImageButton button];
    rightButton.frame = CGRectIntegral(CGRectOffset(CGRectMake(navbarFrame.size.width - BUTTON_WIDTH, 0, BUTTON_WIDTH, BUTTON_HEIGHT), 0, navbarFrame.size.height - BUTTON_HEIGHT));
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    rightButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    rightButton.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    rightButton.titleLabel.textAlignment = UITextAlignmentCenter;
    rightButton.titleLabel.font = [SurveyDefaults controlsFont];
    rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    rightButton.invertHorizontalLayout = YES;
    
    [rightButton addTarget:self
                    action:@selector(rightButtonPressed)
          forControlEvents:UIControlEventTouchUpInside];
        
    // Help
    [rightButton setImage:[UIImage imageNamed:@"nav_icon_help.png"]
                 forState:RightNavButtonControlStateDisplayHelp];
    [rightButton setTitle:@"Ayuda" 
                 forState:RightNavButtonControlStateDisplayHelp];
    
    [rightButton setImage:[UIImage imageNamed:@"nav_icon_help.png"]
                 forState:RightNavButtonControlStateDisplayHelp | UIControlStateHighlighted];
    [rightButton setTitle:@"Ayuda"
                 forState:RightNavButtonControlStateDisplayHelp | UIControlStateHighlighted];
    
    [rightButton setBackgroundImage:yellowBackground
                           forState:RightNavButtonControlStateDisplayHelp | UIControlStateHighlighted];
    
    // Confirm
    [rightButton setImage:[UIImage imageNamed:@"nav_icon_confirm.png"]
                 forState:RightNavButtonControlStateDisplayConfirm];
    [rightButton setTitle:@"Confirmar" 
                 forState:RightNavButtonControlStateDisplayConfirm];
    
    [rightButton setImage:[UIImage imageNamed:@"nav_icon_confirm.png"]
                 forState:RightNavButtonControlStateDisplayConfirm | UIControlStateHighlighted];
    [rightButton setTitle:@"Confirmar"
                 forState:RightNavButtonControlStateDisplayConfirm | UIControlStateHighlighted];
    
    [rightButton setBackgroundImage:cyanBackground
                           forState:RightNavButtonControlStateDisplayConfirm | UIControlStateHighlighted];
    
    // Next
    [rightButton setImage:[UIImage imageNamed:@"nav_icon_next.png"]
                 forState:RightNavButtonControlStateDisplayNext];
    [rightButton setTitle:@"Siguiente" 
                 forState:RightNavButtonControlStateDisplayNext];
    
    [rightButton setImage:[UIImage imageNamed:@"nav_icon_next.png"]
                 forState:RightNavButtonControlStateDisplayNext | UIControlStateHighlighted];
    [rightButton setTitle:@"Siguiente"
                 forState:RightNavButtonControlStateDisplayNext | UIControlStateHighlighted];
    
    [rightButton setBackgroundImage:greenBackground
                           forState:RightNavButtonControlStateDisplayNext | UIControlStateHighlighted];
    
    [self.view addSubview:rightButton];
    
    // Gradient overlay
    UIImage *gradientOverlay = [UIImage imageNamed:@"nav_overlay.png"];
    gradientOverlay = [gradientOverlay resizableImageWithCapInsets:UIEdgeInsetsMake(gradientOverlay.size.height / 2.0, 0, gradientOverlay.size.height / 2.0, 0)];
    UIImageView *gradientView = [[UIImageView alloc] initWithImage:gradientOverlay];
    gradientView.frame = CGRectMake(0, navbarFrame.size.height - BUTTON_HEIGHT, navbarFrame.size.width, BUTTON_HEIGHT);
    [self.view addSubview:gradientView];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    // Setup the main view
    CGRect navbarFrame = [Viewport navFrame];
    self.view = [[UIView alloc] initWithFrame:navbarFrame];
    
    // Background view
    UIView *background = [[UIView alloc] initWithFrame:CGRectOffset(CGRectInset(navbarFrame, -SHADOW_RADIUS, -SHADOW_RADIUS), 0, -SHADOW_RADIUS)];
    background.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
    background.layer.shadowColor = [UIColor blackColor].CGColor;
    background.layer.shadowOffset = CGSizeMake(0, SHADOW_RADIUS);
    background.layer.shadowRadius = SHADOW_RADIUS;
    background.layer.shadowOpacity = 0.35;
    [self.view addSubview:background];
    
    // Setup the navigation buttons
    [self setupNavigationButtons];
    
    // Web info view
    infoView = [[UIWebView alloc] initWithFrame:CGRectOffset(CGRectInset(navbarFrame, 0, BUTTON_HEIGHT / 2.0),
                                                             0, -BUTTON_HEIGHT / 2.0)];
    infoView.backgroundColor = [UIColor clearColor];
    infoView.opaque = NO;
    [self.view addSubview:infoView];
    
    // Ribbon
//    UIButton *ribbon = [UIButton buttonWithType:UIButtonTypeCustom];
//    [ribbon setImage:[UIImage imageNamed:@"nav_ribbon.png"] forState:UIControlStateNormal];
//    ribbon.center = CGPointMake(navbarFrame.size.width * 0.9, 100.0);
//    [self.view addSubview:ribbon];
    UIImageView *infoTab = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_info_tab.png"]];
    infoTab.center = CGPointMake(navbarFrame.size.width / 2.0, navbarFrame.size.height - 25);
    infoTab.frame = CGRectIntegral(infoTab.frame);
    [self.view addSubview:infoTab];
    
    // Add transparent user interaction area
    self.view.frame = CGRectMake(0, 0, navbarFrame.size.width, navbarFrame.size.height + GESTURE_AREA_HEIGHT);
    self.view.frame = CGRectOffset(self.view.frame, 0, -self.view.bounds.size.height);
    
    // Add gesture recognizer
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [self.view addGestureRecognizer:panRecognizer];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapRecognizer];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return [self.parentViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

@end
