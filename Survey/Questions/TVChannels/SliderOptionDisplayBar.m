//
//  SliderOptionDisplayBar.m
//  Fubu
//
//  Created by Remote on 27/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SliderOptionDisplayBar.h"
#import "SurveyDefaults.h"
#define HEIGHT 50
#define OFFSET -70
#define TIP_SIZE 20
#define OPTION_COLOR [UIColor grayColor]
#define SELECTED_COLOR [UIColor blackColor]

@implementation SliderOptionDisplayBar

- (id)initWithSlider:(FBSliderWithOptions*)slider;
{
    self = [super initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, HEIGHT)];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = NO;
        self.opaque = YES;
//        self.alpha = 0.75;
                      
        int minX = CGRectGetMinX(slider.frame) + 15;
        int maxX = CGRectGetMaxX(slider.frame) - 15;   
        labels = [[NSMutableArray alloc] init];
        for (int i = 0; i < slider.options.count; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.text = [slider.options objectAtIndex:i];
            label.font = [SurveyDefaults textFont];
            label.textColor = OPTION_COLOR;
            label.backgroundColor = [UIColor clearColor];
            label.frame = CGRectMake(0, 0, [label.text sizeWithFont:label.font].width, [label.text sizeWithFont:label.font].height);
            label.center = CGPointMake(i * (maxX - minX) / (slider.options.count - 1) + minX, HEIGHT / 2.0);
            label.frame = CGRectIntegral(label.frame);
            [self addSubview:label];
            [labels addObject:label];
        }                        
        // tip
        tip = [[TipView alloc] initWithFrame:CGRectMake(-TIP_SIZE, HEIGHT, TIP_SIZE, TIP_SIZE)];
        [self addSubview:tip];
        
        // off the screen
        self.frame = CGRectOffset(self.frame, 0, -(HEIGHT + TIP_SIZE));
    }
    return self;
}

- (void)hilightOption:(int)option
{
    for (int i = 0; i < labels.count; i++) {
        UILabel *which = [labels objectAtIndex:i];
        if (i == option)            
            which.textColor = SELECTED_COLOR;
        else
            which.textColor = OPTION_COLOR;
    }                
    [UIView animateWithDuration:0.15
                          delay:0.0
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void) {
                         tip.center = CGPointMake(((UIView*) [labels objectAtIndex:option]).center.x, tip.center.y);
                     }
                     completion:^(BOOL finished) {
                         tip.frame = CGRectIntegral(tip.frame);
                     }];
}

- (void)floatToView:(UIView*)view
{
    [self floatToPoint:view.center];
}

- (void)floatToPoint:(CGPoint)point
{
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.center = CGPointMake(self.center.x, point.y + OFFSET); 
                     }
                     completion:^(BOOL finished) {
                         self.frame = CGRectIntegral(self.frame);
                     }];

}

@end
