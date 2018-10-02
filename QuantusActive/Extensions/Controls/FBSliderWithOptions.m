//
//  FBSliderWithGhost.m
//  Fubu
//
//  Created by Remote on 03/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FBSliderWithOptions.h"

@implementation FBSliderWithOptions
@synthesize currentOption, used, options;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *transparent = [UIImage imageNamed:@"transparent.png"];        
        [self setMinimumTrackImage:transparent forState:UIControlStateNormal];
        [self setMaximumTrackImage:transparent forState:UIControlStateNormal];
        [self setThumbImage:transparent forState:UIControlStateNormal];
    }    
    return self;
}

- (void)useOptions:(NSArray*)optionList {
    options = optionList;
    self.minimumValue = 1;
    self.maximumValue = [options count];
    super.value = floor((self.minimumValue + self.maximumValue) / 2.0);
    self.stops = self.maximumValue;
}

- (NSString *)selectedOption
{
    return [options objectAtIndex:(int) (self.value - 1)];
}

- (void)setValue:(CGFloat)value
{
    [super setValue:value];
    currentOption = [options objectAtIndex:(int) self.value - 1];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{    
    // settings
    CGFloat diameter = 30;
    CGFloat left  = diameter / 2.0;
    CGFloat right = rect.size.width - diameter / 2.0;
    UIColor *trackColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
//    UIColor *barColor   = [UIColor colorWithRed:0.4 green:0.6 blue:0.9 alpha:1.0];
    
    
    // glow
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSaveGState(context);
//    CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 10,
//                                [UIColor whiteColor].CGColor);    
    // track                
    UIBezierPath *track = [UIBezierPath bezierPath];
    [track moveToPoint:CGPointMake(left, rect.size.height / 2.0)];
    [track addLineToPoint:CGPointMake(right, rect.size.height / 2.0)];
    track.lineWidth = diameter;
    track.lineCapStyle = kCGLineCapRound;
    [trackColor setStroke];
    [track stroke];
    
    if (self.enabled) {            
        // handle          
        CGFloat t = (self.value - self.minimumValue) / (self.maximumValue - self.minimumValue);        
        CGRect handleRect = CGRectMake(0, -diameter / 2.0, diameter, diameter);
        handleRect = CGRectOffset(handleRect, t * (rect.size.width - diameter), rect.size.height / 2.0);
        UIBezierPath *handle = [UIBezierPath bezierPathWithOvalInRect:handleRect];    
        if (self.used) 
            [[UIColor blackColor] setFill];
        else {
            // options
            for (int i = 0; i < self.stops; i++) {
                CGFloat t = (CGFloat) i / (self.stops - 1);
                CGRect oRect = CGRectInset(CGRectMake(0, -diameter / 2.0, diameter, diameter), diameter / 4.0, diameter / 4.0);
                oRect = CGRectOffset(oRect, t * (rect.size.width - diameter), rect.size.height / 2.0);
                UIBezierPath *o = [UIBezierPath bezierPathWithOvalInRect:oRect];    
                [[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.25] setFill];
                [o fill];
            }
            [[UIColor whiteColor] setFill];              
        }            
        [handle fill];  
    }
    
//    CGContextRestoreGState(context);
}

@end
