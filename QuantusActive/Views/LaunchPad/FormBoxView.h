//
//  FormBoxView.h
//  QuantusActive
//
//  Created by Alejandro on 3/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LaunchPadViewController.h"

@interface FormBoxView : UIView {
    UITextField *usernameField;
    UITextField *passwordField;
}

@property (nonatomic, strong) UITextField *usernameField;
@property (nonatomic, strong) UITextField *passwordField;

- (void) addButton:(LaunchPadViewController*)controller;
- (void) loadFields;

@end
