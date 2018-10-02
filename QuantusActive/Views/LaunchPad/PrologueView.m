//
//  PrologueView.m
//  QuantusActive
//
//  Created by Alejandro on 3/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PrologueView.h"
#import "Viewport.h"
#define FADEIN_DURATION 1


@implementation PrologueView

@synthesize welcomeView, formView;

- (id)initWithFrame:(CGRect)frame withController:(LaunchPadViewController *)controller
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quantus_background.png"]];
        [self addSubview:background];
        
        UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quantus_logo.png"]];
        logo.frame = CGRectOffset(logo.frame,
                                  floorf((self.bounds.size.width - logo.bounds.size.width) / 2.0),
                                  200);
        logo.alpha = 0;
        [self addSubview:logo];
        
        [UIView animateWithDuration:FADEIN_DURATION
                         animations:^{
                             logo.alpha = 0.8;
                         }];
        
        formView = [[FormBoxView alloc] init];
        [formView addButton:controller];
        
        welcomeView = [[WelcomeBoxView alloc] init];
        welcomeView.alpha = 0;
        [welcomeView addButton:self];
        [self addSubview:welcomeView];
        
        [UIView animateWithDuration:FADEIN_DURATION         
                              delay:0.8f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             welcomeView.alpha = 1;
                         }
                         completion:^(BOOL finished){
                         }];
    }
    return self;
}

- (void) showFormBoxView
{
    [self.welcomeView removeFromSuperview];
    [self addSubview:formView];
}

- (NSDictionary*) retrieveFormFieldValues
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[self.formView usernameField].text forKey:@"username"];
    [dict setObject:[self.formView passwordField].text forKey:@"password"];
    return [NSDictionary dictionaryWithDictionary:dict];
}

-(BOOL) formFieldsAreNotEmpty
{
    return [[self.formView usernameField].text length] > 0 && [[self.formView passwordField].text length] > 0;
}

@end
