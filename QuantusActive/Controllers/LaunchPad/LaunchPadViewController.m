//
//  LaunchPadViewController.m
//  QuantusActive
//
//  Created by Alejandro on 3/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SurveyViewController.h"
#import "LaunchPadViewController.h"
#import "PrologueView.h"
#import "Viewport.h"
#import "Session.h"
#import "SoundPlayerPool.h"

@implementation LaunchPadViewController

- (void) login
{
    PrologueView *loginView = (PrologueView*) self.view;
    if ([loginView formFieldsAreNotEmpty]) {
        NSDictionary *credentials = [loginView retrieveFormFieldValues];
        [Session startAuthenticationWithUsername:[credentials objectForKey:@"username"] 
                                     andPassword:[credentials objectForKey:@"password"]];
        if ([Session exists]) {
            [self presentViewController:[[SurveyViewController alloc] init] animated:YES completion:nil];
        } else {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Quantus"
                                                              message:@"El nombre de usuario o contraseña es incorrecto"
                                                             delegate:self
                                                    cancelButtonTitle:@"Aceptar"
                                                    otherButtonTitles:nil, nil];
            [message show];
        }
    }
}

- (void)loadView
{
    self.view = [[PrologueView alloc] initWithFrame:[Viewport bounds] withController:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [SoundPlayerPool playFile:@"startup.caf"];
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

@end
