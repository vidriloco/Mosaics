//
//  SurveyQuestionViewController.m
//  QuantusActive
//
//  Created by Workstation on 3/12/12.
//  Copyright (c) 2012 Quantus. All rights reserved.
//

#import "SurveyQuestionBaseController+Protected.h"
#import "SurveyQuestionMultiScreenProtocol.h"
#import "SurveyQuestionProtocol.h"
#import "UILabel+Shadow.h"
#import "SurveyDefaults.h"
#import "Viewport.h"

static const NSTimeInterval dimmingDuration = 0.35;

static NSMutableDictionary *registeredClasses = nil;

@interface SurveyQuestionBaseController() {
    @private
    UIView         *darkOverlay;
    NSMutableArray *subscreens;
    NSUInteger      currentSubscreen;
}
@end

@implementation SurveyQuestionBaseController
@synthesize hasValidAnswers, marshaller;

+ (void)load
{
    if ([self conformsToProtocol:@protocol(SurveyQuestionProtocol)]) {
        // Lazy init
        if (!registeredClasses)
            @autoreleasepool {
                registeredClasses = [NSMutableDictionary dictionary];
            }
        
        id class = self;
        
        NSLog(@"Registering question class: %@ with id: %d", [[self class] description], [class questionId]);
        [registeredClasses setObject:self forKey:[NSNumber numberWithInt:[class questionId]]];
    }

}

+ (NSDictionary *)getRegisteredQuestions
{
    return registeredClasses;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithMarshaller:(Marshaller*)aMarshaller
{
    if ((self = [super init])) {
        self.marshaller = aMarshaller;
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

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[Viewport bounds]];
    
    // Load subscreens
    if ([self conformsToProtocol:@protocol(SurveyQuestionMultiScreenProtocol)]) {
        subscreens = [NSMutableArray array];
        id this = self;
        for (int i = 0; i < [this numberOfSubscreens]; ++i)
            [subscreens addObject:[this subscreenAtIndex:i]];
    }
    
    currentSubscreen = -1;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    darkOverlay = [[UIView alloc] initWithFrame:self.view.frame];
    darkOverlay.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    darkOverlay.hidden = YES;
    darkOverlay.alpha = 0.0;
    [self.view addSubview:darkOverlay];

    // Create quesiton label       
    UILabel *questionLabel = [[UILabel_Shadow alloc] initWithFrame:CGRectInset(CGRectMake(0, 0, 768, 256), 30, 30)];
    questionLabel.text = [marshaller title];
    questionLabel.backgroundColor = [UIColor clearColor];
    questionLabel.textColor = [UIColor whiteColor];
    questionLabel.font = [SurveyDefaults H2Font];
    questionLabel.textAlignment = UITextAlignmentCenter;        
    questionLabel.lineBreakMode = UILineBreakModeWordWrap;
    questionLabel.numberOfLines = 0;        
    [self.view addSubview:questionLabel];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

// TODO: Leave this flag as override or remove?

- (void)presentSubscreenAtIndex:(NSUInteger)index
{
    if (![self conformsToProtocol:@protocol(SurveyQuestionMultiScreenProtocol)])
        return;
    
    if (index >= [subscreens count])
        return;
        
    SurveyQuestionSubscreen *screen = [subscreens objectAtIndex:index];
    
    // No animations
    if (!screen.animationOptions || screen.animationDuration == 0.0) {
        [self.view addSubview:screen];
        return;
    }
        
    // Animations
    CGFloat presentationAlpha = screen.alpha;
    if (screen.animationOptions & QuestionSubscreenAnimationOptionCrossDissolve)
        screen.alpha = 0.0;
    
    CGPoint presentationPosition = screen.center;
    if (screen.animationOptions & QuestionSubscreenAnimationOptionTranslate)
        screen.center = screen.animationStartPosition;
    
    [self.view addSubview:screen];
    [UIView animateWithDuration:screen.animationDuration 
                     animations:^{
                         screen.alpha  = presentationAlpha;
                         screen.center = presentationPosition;
                     }];
}

- (void)dismissSubscreenAtIndex:(NSUInteger)index
{
    if (![self conformsToProtocol:@protocol(SurveyQuestionMultiScreenProtocol)])
        return;
    
    if (index >= [subscreens count])
        return;
    
    SurveyQuestionSubscreen *screen = [subscreens objectAtIndex:index];
    
    // No animations
    if (!screen.animationOptions || screen.animationDuration == 0.0) {
        [screen removeFromSuperview];
        return;
    }
    
    // Animations
    CGFloat presentationAlpha = screen.alpha;
    if (screen.animationOptions & QuestionSubscreenAnimationOptionCrossDissolve)
        presentationAlpha = 0.0;
    
    CGPoint presentationPosition = screen.center;
    if (screen.animationOptions & QuestionSubscreenAnimationOptionTranslate)
        presentationPosition = screen.animationEndPosition;
    
    [UIView animateWithDuration:screen.animationDuration 
                     animations:^{
                         screen.alpha  = presentationAlpha;
                         screen.center = presentationPosition;
                     }
                     completion:^(BOOL finished) {
                         [screen removeFromSuperview];
                     }];   
}

- (void)presentNextSubscreen;
{
    [self dismissSubscreenAtIndex:currentSubscreen];
    currentSubscreen++;
    [self presentSubscreenAtIndex:currentSubscreen];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// Return YES for supported orientations
	return [self.parentViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

- (void)disableInteractions
{
    self.view.userInteractionEnabled = NO;
    darkOverlay.hidden = NO;
    [darkOverlay.superview bringSubviewToFront:darkOverlay];
    [UIView animateWithDuration:dimmingDuration
                     animations:^{
                         darkOverlay.alpha = 1.0;
                     }];
}

- (void)enableInteractions
{
    [UIView animateWithDuration:dimmingDuration
                     animations:^{
                         darkOverlay.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         darkOverlay.hidden = YES;
                         self.view.userInteractionEnabled = YES;
                     }];    
}

- (BOOL)needsConfirmation
{
    return NO;
}

- (BOOL)canBeReset
{
    return NO;
}

- (BOOL)skipsNavigation
{
    return NO;
}

- (BOOL)collectsAnswers
{
    return YES;
}

- (void)reset
{
    // Override needed
}
@end
