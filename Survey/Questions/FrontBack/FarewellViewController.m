//
//  FarewellViewController.m
//  QuantusActive
//
//  Created by Workstation on 3/17/12.
//  Copyright (c) 2012 Quantus. All rights reserved.
//

#import "FarewellViewController.h"
#import "Viewport.h"

@interface FarewellViewController() {
    UIActivityIndicatorView* activityIndicator;
}
@end

@implementation FarewellViewController

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
    
    UIImageView *message = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"farewell_message.png"]];
    message.frame = CGRectOffset(message.frame,
                                 floorf((self.view.bounds.size.width - message.bounds.size.width) / 2.0),
                                 475);
    [self.view addSubview:message];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = CGPointMake([Viewport bounds].size.width/2, [Viewport bounds].size.height-400);
	[self.view addSubview: activityIndicator];
}

- (void)finish
{
    self.hasValidAnswers = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self performSelector:@selector(finish) withObject:nil afterDelay:2];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [activityIndicator startAnimating];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [activityIndicator stopAnimating];
}

#pragma mark - Protocol methods
// Override needed for the question class to be registered at runtime
+ (void)load
{
    [super load];
}

+ (NSUInteger)questionId
{
    return kFarewellQuestionId;
}

- (BOOL)skipsNavigation
{
    return YES;
}

- (BOOL)collectsAnswers
{
    return NO;
}

@end

