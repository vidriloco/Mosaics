//
//  UIView+Styled.m
//  QuantusActive
//
//  Created by Alejandro on 3/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIView+Styled.h"
#import "UIColor+Extras.h"
#define BLINK_DURATION 0.4

@implementation UIView (Styled)


- (id) initWithFrame:(CGRect)frame withBorderWidth:(int)width withRadius:(float)radius
{
    if (self = [self initWithFrame:frame]) {
        
        [self setFrame:frame];
        
        [self.layer setCornerRadius:radius];
        [self.layer setBorderWidth:width];
        [self setBorderAndBackgroundColorWithColor:[self initialColor]];
    }
    return self;
}

+ (id) circleWithFrame:(CGRect)frame withBorderWidth:(int)width
{
    return [[self alloc] initWithFrame:frame withBorderWidth:width withRadius:frame.size.width/2];
}

+ (id) rectangleWithFrame:(CGRect)frame withBorderWidth:(int)width withCornerRadius:(float)radius
{
    return [[self alloc] initWithFrame:frame withBorderWidth:width withRadius:radius];
}

- (void) setBorderAndBackgroundColorWithColor:(int)color
{
    [self.layer setBorderColor:[UIColor colorWithRGB:color].CGColor];
    [self.layer setBackgroundColor:[[UIColor colorWithRGB:color] colorWithAlphaComponent:[self minAlpha]].CGColor];
}

- (void) hoverIn:(void (^)(BOOL))completion {
    [UIView animateWithDuration:BLINK_DURATION         
                          delay:0
                        options:UIViewAnimationCurveLinear | UIViewAnimationOptionAllowUserInteraction |UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self.layer setBackgroundColor:[[UIColor colorWithRGB:[self initialColor]] 
                                                         colorWithAlphaComponent:[self maxAlpha]].CGColor];
                     }completion:completion];
}

- (void) hoverOut:(void (^)(BOOL))completion {
    [UIView animateWithDuration:BLINK_DURATION         
                          delay:0
                        options:UIViewAnimationCurveLinear | UIViewAnimationOptionAllowUserInteraction |UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self.layer setBackgroundColor:[[UIColor colorWithRGB:[self initialColor]] 
                                                         colorWithAlphaComponent:[self minAlpha]].CGColor];
                     }
                     completion:completion];
}

- (void) blink
{
    [self hoverIn:^(BOOL finished) {
        [self hoverOut:nil];
    }];
}

- (int) initialColor
{
    return 0x111;
}

- (float) maxAlpha 
{
    return 0.8f;
}

- (float) minAlpha
{
    return 0.4f;
}

@end
