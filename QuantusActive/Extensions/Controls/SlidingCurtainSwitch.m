//
//  SexBinaryView.m
//  Fubu
//
//  Created by Workstation on 3/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SlidingCurtainSwitch.h"
#define SLIDE_DURATION 0.5

@interface SlidingCurtainSwitch() {
    UIImageView *imageAView;
    UIImageView *imageBView;
    UIView *slidingCurtain;
    int divisionPos;
}
- (void)updateSubviews;
- (void)answer;
@end

@implementation SlidingCurtainSwitch
@synthesize value, topImage, bottomImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        imageAView = [[UIImageView alloc] initWithFrame:frame];
        imageBView = [[UIImageView alloc] initWithFrame:frame];
        slidingCurtain = [[UIView alloc] initWithFrame:frame];
        slidingCurtain.clipsToBounds = YES;
        [self addSubview:imageAView];
        [slidingCurtain addSubview:imageBView];        
        [self addSubview:slidingCurtain];
        
        // Undefined
        divisionPos = frame.size.width / 2.0;
        value = SlidingCurtainSwitchValueUndefined;
        
        [self updateSubviews];
    }
    return self;
}

- (void)setTopImage:(UIImage *)image
{
    imageBView.image = image;
}

- (void)setBottomImage:(UIImage *)image
{
    imageAView.image = image;
}

- (void)setEnabled:(BOOL)enabled
{
    self.userInteractionEnabled = enabled;
    // TODO: Fix weird behavior
//    self.alpha = enabled? 1.0 : 0.5;
    [super setEnabled:enabled];
}

- (void)answer
{
    value = -floor(divisionPos / self.bounds.size.width) * 2 + 1;    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)updateSubviews
{
    int width  = self.bounds.size.width;
    int height = self.bounds.size.height;
    slidingCurtain.frame  = CGRectMake( divisionPos, 0, width, height);
    imageBView.frame      = CGRectMake(-divisionPos, 0, width, height);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    divisionPos = [[touches anyObject] locationInView:self].x;
    [UIView animateWithDuration:SLIDE_DURATION / 2.0
                     animations:^{
                         [self updateSubviews];
                     }];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{    
    divisionPos = [[touches anyObject] locationInView:self].x;
    [self updateSubviews];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    divisionPos = [[touches anyObject] locationInView:self].x;
    divisionPos = round(divisionPos / self.bounds.size.width) * self.bounds.size.width;
    [UIView animateWithDuration:SLIDE_DURATION
                     animations:^{
                         [self updateSubviews];
                     }
                     completion:^(BOOL finished) {
                         [self answer];
                     }];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
     [self touchesEnded:touches withEvent:event];
}

@end
