//
//  PrologueView.h
//  QuantusActive
//
//  Created by Alejandro on 3/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LaunchPadViewController.h"
#import "WelcomeBoxView.h"
#import "FormBoxView.h"

@interface PrologueView : UIView {
    WelcomeBoxView *welcomeView;
    FormBoxView *formView;
}

- (id) initWithFrame:(CGRect)frame withController:(LaunchPadViewController*)controller;
- (void) showFormBoxView;
- (NSDictionary*) retrieveFormFieldValues;
- (BOOL) formFieldsAreNotEmpty;

@property (nonatomic, strong) WelcomeBoxView* welcomeView;
@property (nonatomic, strong) FormBoxView *formView;

@end
