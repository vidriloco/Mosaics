//
//  SexBinaryViewController.m
//  Fubu
//
//  Created by Workstation on 3/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SexPickViewController.h"
#import "SlidingCurtainSwitch.h"
#import "Viewport.h"

@interface SexPickViewController() {
    SlidingCurtainSwitch *slidingSwitch;
}

@end

@implementation SexPickViewController

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Logic
- (void)controlChangedStatus:(SlidingCurtainSwitch *)control
{
    self.hasValidAnswers = YES;
}

#pragma mark - View lifecycle
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
    slidingSwitch = [[SlidingCurtainSwitch alloc] initWithFrame:self.view.bounds];
    slidingSwitch.bottomImage = [UIImage imageNamed:@"mujer.png"];
    slidingSwitch.topImage    = [UIImage imageNamed:@"hombre.png"];
    [slidingSwitch addTarget:self action:@selector(controlChangedStatus:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slidingSwitch];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

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
  return 1;
}

- (BOOL)needsConfirmation
{
    return YES;
}

- (void)collectAnswers
{
    [self.marshaller pushItem:(slidingSwitch.value == SlidingCurtainSwitchValueBottom)?
                              @"Femenino" : @"Masculino"
                   onCategory:@"Sexo"];
}

@end
