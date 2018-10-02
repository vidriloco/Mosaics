//
//  WelcomeBoxView.m
//  QuantusActive
//
//  Created by Alejandro on 3/17/12.
//  Copyright (c) 2012 Quantus. All rights reserved.
//

#import "WelcomeBoxView.h"
#import "Viewport.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+Extras.h"
#import "UIGradientButton.h"
#import "SurveyDefaults.h"

@implementation WelcomeBoxView

- (id)init
{
    self = [super initWithFrame:[Viewport bounds]];
    if (self) {
        [self addSlogan];
    }
    return self;
}

- (void) addSlogan 
{
    UIImageView *slogan = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quantus_slogan.png"]];
    [self addSubview:slogan];
}

- (void) addButton:(UIView *)superview
{
    UIGradientButton *nextButton = [[UIGradientButton alloc]initWithFrame:CGRectMake(0, 0, 160, 60) 
                                                                 topColor:[UIColor colorWithRGB:0xB01C20] 
                                                           andBottomColor:[UIColor colorWithRGB:0x641C20]];
    nextButton.center = CGPointMake(self.frame.size.width / 2.0, 696);
    [nextButton setTitle:@"Ingresar" forState:UIControlStateNormal];
    [nextButton.titleLabel setFont:[SurveyDefaults controlsFont]];
    [nextButton.titleLabel setTextColor:[UIColor whiteColor]];
	[self addSubview:nextButton];
    
    [nextButton addTarget:superview action:@selector(showFormBoxView) forControlEvents:UIControlEventTouchUpInside];
}

@end
