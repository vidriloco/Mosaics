//
//  FBTooltipView.m
//  Fubu
//
//  Created by Remote on 22/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TooltipView.h"
#import <QuartzCore/QuartzCore.h>
#define RADIUS      8.0
#define BGCOLOR     [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.75]
#define Y_OFFSET    40.0

@implementation TooltipView
@synthesize autoHideDelay, textLabel;

static TooltipView *sharedInstance = nil;

// Get the shared instance and create it if necessary.
+ (TooltipView *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    
    return sharedInstance;
}

// We can still have a regular init method, that will get called the first time the Singleton is used.
- (id)init
{
    self = [super init];
    
    if (self) {
        // Work your initialising magic here as you normally would
        self.hidden = YES;                        
        self.userInteractionEnabled = NO;
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        self.autoHideDelay = 0.5;

        // Prepares the text view
        textLabel = [[UILabel alloc] init];
        textLabel.font = [UIFont systemFontOfSize:18.0];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textColor = [UIColor whiteColor];        
        textLabel.hidden = YES;
        [self addSubview:textLabel];        
    }
    
    return self;
}

+ (void)show
{
    if (sharedInstance == nil)
        sharedInstance = [TooltipView sharedInstance];
            
//    [sharedInstance.layer removeAllAnimations];
    [sharedInstance.superview bringSubviewToFront:sharedInstance];
    
    // Align to integral positions
    sharedInstance.frame = CGRectIntegral(CGRectStandardize(sharedInstance.frame));
           
    sharedInstance.alpha = 1.0;
    if (sharedInstance.hidden)
        sharedInstance.hidden = NO;
    [sharedInstance setNeedsDisplay];    
    
    if (sharedInstance.autoHideDelay > 0.0) {        
        [UIView animateWithDuration:1.0         
                              delay:sharedInstance.autoHideDelay
                            options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             sharedInstance.alpha = 0.0; 
                         }
                         completion:^(BOOL finished){
                             if (finished)
                                 sharedInstance.hidden = YES;
                         }];
    }
}

+ (void)setAnchorPoint:(CGPoint)anchorPoint
{
    if (sharedInstance == nil)
        sharedInstance = [TooltipView sharedInstance];
    
    // TODO: Rectangle positioning logic
    sharedInstance.center = CGPointMake(anchorPoint.x, anchorPoint.y - Y_OFFSET);      
}

+ (void)setAnchorView:(UIView*)anchorView
{   
    [TooltipView setAnchorPoint:anchorView.center];
}

+ (void)displayText:(NSString*)text
{    
    if (sharedInstance == nil)
        sharedInstance = [TooltipView sharedInstance];

    // Prepares the next view
    sharedInstance.textLabel.text = text;    
    sharedInstance.textLabel.frame = CGRectMake(0, 0, [text sizeWithFont:sharedInstance.textLabel.font].width, [text sizeWithFont:sharedInstance.textLabel.font].height);
    sharedInstance.bounds = CGRectInset(sharedInstance.textLabel.bounds, -RADIUS, -RADIUS);    
    sharedInstance.textLabel.hidden = NO;   
    
    // Show the tooltip
    [TooltipView show];
}

- (void)drawRect:(CGRect)rect
{                
    UIBezierPath *back = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:RADIUS];
    [BGCOLOR setFill];
    [back fill];    
}
@end
