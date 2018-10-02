//
//  UIGradientButton.m
//  QuantusActive
//
//  Created by Alejandro on 3/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIGradientButton.h"

#define radius 8

@implementation UIGradientButton

@synthesize gradientLayer, topColor, bottomColor;

- (id)initWithFrame:(CGRect)frame topColor:(UIColor *)topColor_ andBottomColor:(UIColor *)bottomColor_ 
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = radius;
        self.layer.borderWidth = 2.0f;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowRadius = radius;
        self.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);

        gradientLayer = [[CAGradientLayer alloc] init];
        gradientLayer.bounds = self.bounds;
        gradientLayer.cornerRadius = radius;
        gradientLayer.position = CGPointMake([self bounds].size.width/2, [self bounds].size.height/2);
        
        [self.layer insertSublayer:gradientLayer above:0];
        
        [self setTopColor:topColor_];
        [self setBottomColor:bottomColor_];
    }
    return self;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    self.contentEdgeInsets = UIEdgeInsetsMake(1.0,1.0,-1.0,-1.0);
    self.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.layer.shadowOpacity = 0.8;
    
    [super touchesBegan:touches withEvent:event];
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    self.contentEdgeInsets = UIEdgeInsetsMake(0.0,0.0,0.0,0.0);
    self.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    self.layer.shadowOpacity = 0.5;
    
    [super touchesEnded:touches withEvent:event];
    
}


- (void)drawRect:(CGRect)rect;
{
    if (bottomColor && topColor)
    {
        [gradientLayer setColors:
         [NSArray arrayWithObjects:
          (id)[topColor CGColor], 
          (id)[bottomColor CGColor], nil]];
    }
    [super drawRect:rect];
}

@end
