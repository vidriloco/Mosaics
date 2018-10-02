//
//  UIGradientButton.h
//  QuantusActive
//
//  Created by Alejandro on 3/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface UIGradientButton : UIButton {
    CAGradientLayer *gradientLayer;
    UIColor *topColor;
    UIColor *bottomColor;
}

@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) UIColor *topColor;
@property (nonatomic, strong) UIColor *bottomColor;

- (id) initWithFrame:(CGRect)frame topColor:(UIColor*)topColor andBottomColor:(UIColor*)bottomColor;
@end
