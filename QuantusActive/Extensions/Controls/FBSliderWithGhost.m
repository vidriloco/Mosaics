//
//  FBSliderWithGhost.m
//  Fubu
//
//  Created by Remote on 03/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FBSliderWithGhost.h"

@implementation FBSliderWithGhost
@synthesize ghostValue;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *transparent = [UIImage imageNamed:@"transparent.png"];
        UIImage *doubleArrow = [UIImage imageNamed:@"double_arrow.png"];
        [self setMinimumTrackImage:transparent forState:UIControlStateNormal];
        [self setMaximumTrackImage:transparent forState:UIControlStateNormal];
//        [self setThumbImage:transparent forState:UIControlStateNormal];
         [self setThumbImage:doubleArrow forState:UIControlStateNormal];
    }
    
    return self;
}

- (void)setValue:(CGFloat)value
{    
    if (value > ghostValue)
        value = ghostValue; 
    
    [super setValue:value];
    [self setNeedsDisplay];
}
/*
- (void)setGhostValue:(CGFloat)someValue
{
    self.ghostValue = MAX(self.minimumValue, MIN(self.maximumValue, someValue));
}
 */

- (void)drawRect:(CGRect)rect
{    
    // settings
    CGFloat diameter = 30;
    CGFloat left  = diameter / 2.0;
    CGFloat right = rect.size.width - diameter / 2.0;
    UIColor *trackColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.25];
    UIColor *ghostColor = trackColor;//[UIColor colorWithRed:0.1 green:0.2 blue:0.8 alpha:0.5];
    UIColor *barColor   = [UIColor colorWithRed:0.4 green:0.6 blue:0.9 alpha:1.0];
    UIColor *handleColor = ghostColor;
    
    // track    
    UIBezierPath *track = [UIBezierPath bezierPath];
    [track moveToPoint:CGPointMake(left, rect.size.height / 2.0)];
    [track addLineToPoint:CGPointMake(right, rect.size.height / 2.0)];
    track.lineWidth = diameter;
    track.lineCapStyle = kCGLineCapRound;
    [trackColor setStroke];
    [track stroke];
    
    // ghost
    CGFloat g = (self.ghostValue - self.minimumValue) / (self.maximumValue - self.minimumValue);    
    UIBezierPath *ghost = [UIBezierPath bezierPath];
    [ghost moveToPoint:CGPointMake(left, rect.size.height / 2.0)];
    [ghost addLineToPoint:CGPointMake(g * (right - left) + left, rect.size.height / 2.0)];
    ghost.lineWidth = diameter;
    ghost.lineCapStyle = kCGLineCapRound;
    [ghostColor setStroke];
    [ghost stroke];
    
    // bar
    CGFloat t = (self.value - self.minimumValue) / (self.maximumValue - self.minimumValue);    
    UIBezierPath *bar = [UIBezierPath bezierPath];
    [bar moveToPoint:CGPointMake(left, rect.size.height / 2.0)];
    [bar addLineToPoint:CGPointMake(t * (right - left) + left, rect.size.height / 2.0)];
    bar.lineWidth = diameter;
    bar.lineCapStyle = kCGLineCapRound;
    [barColor setStroke];
    [bar stroke];
    
    // handle    
    CGRect handleRect = CGRectMake(0, -diameter / 2.0, diameter, diameter);
    handleRect = CGRectOffset(handleRect, t * (rect.size.width - diameter), rect.size.height / 2.0);
    UIBezierPath *handle = [UIBezierPath bezierPathWithOvalInRect:handleRect];    
    [handleColor setFill];
    [handle fill];
}

@end
