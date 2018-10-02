//
//  FormBoxView.m
//  QuantusActive
//
//  Created by Alejandro on 3/17/12.
//  Copyright (c) 2012 Quantus. All rights reserved.
//

#import "FormBoxView.h"
#import "Viewport.h"
#import "UIGradientButton.h"
#import "UIColor+Extras.h"
#import "UITextFieldExt.h"
#import "SurveyDefaults.h"

@implementation FormBoxView
@synthesize usernameField, passwordField;

- (id)init
{
    if(self = [super initWithFrame:[Viewport bounds]]) {
        UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quantus_form_overlay.png"]];
        background.alpha = 0.9;
        [self addSubview:background];
        
        [self loadFields];
    }    
    return self;
}

- (void) loadFields
{
    UIFont *font = [UIFont systemFontOfSize:29];
    CGRect fieldFrame = CGRectMake(0, 0, 400, 55);
    
    usernameField = [[UITextFieldExt alloc] initWithFrame:fieldFrame withFont:font andRadius: 7];
    usernameField.center = CGPointMake(self.frame.size.width / 2.0, 450);
    [usernameField setPlaceholder:@"Nombre de usuario"];
    
    [self addSubview:usernameField];
    
    passwordField = [[UITextFieldExt alloc] initWithFrame:fieldFrame withFont:font andRadius: 7];
    passwordField.center = CGPointMake(self.frame.size.width / 2.0, 530);
    [passwordField setPlaceholder:@"Contraseña"];
    [passwordField setSecureTextEntry:YES];
    
    [self addSubview:passwordField];
}

- (void) addButton:(LaunchPadViewController *)controller
{
    UIGradientButton *nextButton = [[UIGradientButton alloc]initWithFrame:CGRectMake(0, 0, 230, 60) 
                                                                 topColor:[UIColor colorWithRGB:0xB01C20] 
                                                           andBottomColor:[UIColor colorWithRGB:0x641C20]];
    nextButton.center = CGPointMake(self.frame.size.width / 2.0, 625);
    [nextButton setTitle:@"Iniciar Sesión" forState:UIControlStateNormal];
    [nextButton.titleLabel setFont:[SurveyDefaults controlsFont]];
    [nextButton.titleLabel setTextColor:[UIColor whiteColor]];
	[self addSubview:nextButton];
    
    [nextButton addTarget:controller action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
}

@end
