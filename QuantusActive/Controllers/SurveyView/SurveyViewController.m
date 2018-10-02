//
//  SurveyViewController.m
//  QuantusActive
//
//  Created by Workstation on 3/11/12.
//  Copyright (c) 2012 Quantus. All rights reserved.
//

#import "SurveyViewController.h"
#import "Viewport.h"
#import "NavBarViewController.h"
#import "SurveyQuestionBaseController.h"
#import "TooltipView.h"
#import "Marshaller.h"
#import "ModelSilo.h"
#import "Model.h"
#import "Session.h"

@interface SurveyViewController() {
@private
    NavBarViewController         *navBarController;
    SurveyQuestionBaseController *currentQuestionController;
}
@end

@implementation SurveyViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Full screen plox
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        
        // Add the navigation bar
        navBarController = [[NavBarViewController alloc] init];
        navBarController.surveyControlDelegate = self;
        [self addChildViewController:navBarController];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Protocol methods
- (void)exitSurvey
{
    if ([Model currentQuestionIndex] == kGreetingQuestionId) {
        [self dismissViewControllerAnimated:YES completion:^{
            [self removeFromParentViewController];
        }];
        
        [Model reset];
        [Session clear];
    } else {
        // TODO: Notify model that the survey was cancelled
        currentQuestionController = nil;
        [Model reset];
        [self loadNextQuestion];
    }
}

- (void)persistAnswers
{
    if (currentQuestionController) {
        if ([currentQuestionController respondsToSelector:@selector(collectAnswers)])
            [(id)currentQuestionController collectAnswers];
        
        // exclude Farewell and Greeting from the answer collection process
        if ([currentQuestionController collectsAnswers]) {
            [Model mergeAnswersFromMarshaller:[currentQuestionController marshaller]];
        }
    }
}

- (void)loadNextQuestion
{
    
    [self persistAnswers];

    // Fetch next
    int next = [Model nextQuestionIndex];
    id nextQuestionClass = [[SurveyQuestionBaseController getRegisteredQuestions] 
                            objectForKey:[NSNumber numberWithInt:next]];
    if (!nextQuestionClass) {
        [NSException raise:NSGenericException
                    format:@"Listed question controller not found"];
    }
   
    id nextQuestionController = [[nextQuestionClass alloc] initWithMarshaller:[Model generateMarshallerForNextQuestion]];
    [self addChildViewController:nextQuestionController];
    
    // Transition
    if (currentQuestionController) {
        [self transitionFromViewController:currentQuestionController
                          toViewController:nextQuestionController
                                  duration:1.0
                                   options:UIViewAnimationOptionTransitionCurlDown
                                animations:^{
                                    
                                }
                                completion:^(BOOL finished) {
                                    // Remove previous controller
                                    [currentQuestionController removeFromParentViewController];
                                    currentQuestionController = nextQuestionController;
                                    
                                    // Let the navigation controller observe
                                    navBarController.surveyQuestionController = currentQuestionController;
                                    [self.view bringSubviewToFront:navBarController.view];
                                }];
    } else {
        // Add first controller
        currentQuestionController = nextQuestionController;
        [self.view insertSubview:currentQuestionController.view belowSubview:navBarController.view];
        
        // Let the navigation controller observe
        navBarController.surveyQuestionController = currentQuestionController;        
    }
    
    // Commit result and reset if current view is Farewell
    if (next == kFarewellQuestionId)
        [ModelSilo commitAnswersForCurrentSurveyReportingTo:self];
}

#pragma mark - Request-response methods for ModelSilo

- (void) answersForSurveyCommitFailed
{
    [ModelSilo stageAnswersForCurrentSurveyForLaterCommit];
    [Model reset];
    NSLog(@"========= Commit failed ========");
}

- (void) answersForSurveyCommitSucceded
{
    NSLog(@"========= Commit succeded ========");
    [Model reset];
}


#pragma mark - View lifecycle
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[Viewport bounds]];
    self.view.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:navBarController.view];
    
    // Tooltip view
    [self.view addSubview:[TooltipView sharedInstance]];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];    
    [self loadNextQuestion];
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
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

@end
