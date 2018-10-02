//
//  GreetingViewController.m
//  QuantusActive
//
//  Created by Workstation on 3/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "GreetingViewController.h"
#import "SurveyDefaults.h"
#import "Viewport.h"
#import "UIGradientButton.h"
#import "UIColor+Extras.h"
#import "DialogBalloonView.h"
#import "ModelSilo.h"

@interface GreetingViewController() {
    DialogBalloonView *dialogBalloon;
    UIView *stagedSurveysResultsBand;
    BOOL commitingSurveyAnswers;
    BOOL animatingCommitFailure;
}
- (void) addStagedResultsStatus;
- (void) attemptRecommitOfStagedSurveyAnswers:(id)sender;
- (void) blinkStagedSurveyAnswersButton:(UIButton*)button;
- (void) animateCommitFailureWithAnimation:(NSInteger)animationNumber;
@end

@implementation GreetingViewController

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Logic
- (void)buttonPressed:(UIButton *)button
{
    self.hasValidAnswers = YES;
}

#pragma mark - View lifecycle
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"quantus_background.png"]];
    
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quantus_logo.png"]];
    logo.frame = CGRectOffset(logo.frame,
                              floorf((self.view.bounds.size.width - logo.bounds.size.width) / 2.0),
                              200);
    [self.view addSubview:logo];
    
    UIImageView *message = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"greeting_message.png"]];
    message.frame = CGRectOffset(message.frame,
                                 floorf((self.view.bounds.size.width - message.bounds.size.width) / 2.0),
                                 475);
    [self.view addSubview:message];
    
    UIGradientButton *nextButton = [[UIGradientButton alloc]initWithFrame:CGRectMake(0, 0, 160, 60) 
                                                                 topColor:[UIColor colorWithRGB:0xB01C20] 
                                                           andBottomColor:[UIColor colorWithRGB:0x641C20]];
    nextButton.center = CGPointMake(self.view.frame.size.width / 2.0, 696);
    [nextButton setTitle:@"Comenzar" forState:UIControlStateNormal];
    [nextButton.titleLabel setFont:[SurveyDefaults controlsFont]];
    [nextButton.titleLabel setTextColor:[UIColor whiteColor]];
	[self.view addSubview:nextButton];

    [nextButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
    dialogBalloon = [[DialogBalloonView alloc] initWithFrame:CGRectMake(100, 50, 450, 150)];
    dialogBalloon.emitterPosition = CGPointMake(self.view.bounds.size.width / 2.0, 50);
    dialogBalloon.textLabel.text = @"Presione o arrastre la pestaña del menú para navegar la encuesta o consultar las instrucciones.";
    dialogBalloon.alpha = 0.0;
//    [self.view addSubview:dialogBalloon];
}

- (void)showBalloon
{
    [UIView animateWithDuration:1.0
                     animations:^{
                         dialogBalloon.alpha = 1.0;
                     }];
}

- (void)hideBalloon
{
    [UIView animateWithDuration:0.25
                     animations:^{
                         dialogBalloon.alpha = 0.0;
                     }];
}

- (void) addStagedResultsStatus
{
    
    NSUInteger surveysCount = [[[ModelSilo current] store] count];
    if (surveysCount > 0) {
        
        stagedSurveysResultsBand = [[UIView alloc] initWithFrame:CGRectMake(0, [Viewport bounds].size.height-100, 
                                                                            [Viewport bounds].size.width, 60)];
        [stagedSurveysResultsBand setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
        [self.view addSubview:stagedSurveysResultsBand];
        
        UILabel *stagedSurveysLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 500, 40)];
        NSString *pluralMsj = [NSString stringWithFormat:@"%d encuestas levantadas por subir", surveysCount];
        if (surveysCount == 1) {
            pluralMsj = [NSString stringWithFormat:@"%d encuesta levantada por subir", surveysCount];
        }
        [stagedSurveysLabel setText:pluralMsj];
        [stagedSurveysLabel setTextColor:[UIColor whiteColor]];
        [stagedSurveysLabel setBackgroundColor:[UIColor clearColor]];
        [stagedSurveysLabel setTextAlignment:UITextAlignmentCenter];
        [stagedSurveysLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
        
        UIImage *image = [UIImage imageNamed:@"recommit.png"];
        
        UIButton *recommitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [recommitButton setBackgroundImage:image forState:UIControlStateNormal];
        [recommitButton setFrame:CGRectMake(600, 10, image.size.width, image.size.height)];
        [recommitButton addTarget:self action:@selector(attemptRecommitOfStagedSurveyAnswers:) forControlEvents:UIControlEventTouchUpInside];
        
        [stagedSurveysResultsBand addSubview:recommitButton];
        [stagedSurveysResultsBand addSubview:stagedSurveysLabel]; 

    }
}

- (void) blinkStagedSurveyAnswersButton:(UIButton *)button
{
    [UIView animateWithDuration:2 animations:^{
        [button setAlpha:0.1];
    } completion:^(BOOL finished) {
        [button setAlpha:1];
        if (commitingSurveyAnswers) {
            [self blinkStagedSurveyAnswersButton:button];
        }
    }];
}

- (void) attemptRecommitOfStagedSurveyAnswers:(id)sender
{
    commitingSurveyAnswers = YES;
    [self blinkStagedSurveyAnswersButton:sender];
    [ModelSilo commitStagedAnswersWithResponder:self];
}

- (void) allAnswersCommitSucceded {
    [UIView animateWithDuration:1 animations:^{
        stagedSurveysResultsBand.transform = CGAffineTransformMakeTranslation(0, 200);
    }];
}

- (void) someAnswersCommitFailed {
    commitingSurveyAnswers = FALSE;
        
    if (!animatingCommitFailure) {
        animatingCommitFailure = YES;
        [self animateCommitFailureWithAnimation:3];
    }
}


- (void) animateCommitFailureWithAnimation:(NSInteger)animationNumber
{
    [UIView animateWithDuration:0.5 animations:^{
        stagedSurveysResultsBand.transform = CGAffineTransformMakeTranslation(20, 0);
    } completion:^(BOOL finished) {
        if (animationNumber > 0) {
            stagedSurveysResultsBand.transform = CGAffineTransformMakeTranslation(-20, 0);
            [self animateCommitFailureWithAnimation:animationNumber-1];
        } else {
            stagedSurveysResultsBand.transform = CGAffineTransformMakeTranslation(0, 0);
            animatingCommitFailure = NO;
        }
    }];
}

- (void)receiveNotification:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"NavBarWasShown"])
        [self hideBalloon];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:) 
                                                 name:@"NavBarWasShown"
                                               object:nil];

    [self performSelector:@selector(showBalloon) withObject:nil afterDelay:1.0];
    [self addStagedResultsStatus];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - Protocol methods
// Override needed for the question class to be registered at runtime
+ (void)load
{
    [super load];
}

+ (NSUInteger)questionId
{
    return kGreetingQuestionId;
}

- (BOOL)needsConfirmation
{
    return NO;
}

- (BOOL)canBeReset
{
    return NO;
}

- (BOOL)collectsAnswers
{
    return NO;
}

@end
