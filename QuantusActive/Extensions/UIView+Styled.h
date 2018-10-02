//
//  UIView+Styled.h
//  QuantusActive
//
//  Created by Alejandro on 3/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIView (Styled)


+ (id) circleWithFrame:(CGRect)frame withBorderWidth:(int)width;
+ (id) rectangleWithFrame:(CGRect)frame withBorderWidth:(int)width withCornerRadius:(float)radius;

- (id) initWithFrame:(CGRect)frame withBorderWidth:(int)width withRadius:(float)radius;

- (void) blink;

- (void) hoverIn:(void (^)(BOOL finished))completion;
- (void) hoverOut:(void (^)(BOOL finished))completion;

- (void) setBorderAndBackgroundColorWithColor:(int)color;
- (int) initialColor;
- (float) minAlpha;
- (float) maxAlpha;

@end
