//
//  SideImageButton.m
//  QuantusActive
//
//  Created by Workstation on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SideImageButton.h"
#define kFadeDuration 0.5

@implementation SideImageButton
@synthesize customState, invertHorizontalLayout;

+ (id)button
{
    return [SideImageButton buttonWithType:UIButtonTypeCustom];
}

- (UIControlState)state
{
    return [super state] | customState;
}

- (void)setCustomState:(UIControlState)aCustomState
{
    if (customState == aCustomState)
        return;
    
    customState = aCustomState;
    
    // Force update
    [UIView animateWithDuration:kFadeDuration
                     animations:^{
                         self.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         [self setNeedsLayout];
                     }];
    [UIView animateWithDuration:kFadeDuration
                     animations:^{
                         self.alpha = 1.0;
                     }];
}

- (void)layoutSubviews
{
//    self.backgroundColor = [UIColor purpleColor];
//    self.imageView.backgroundColor = [UIColor grayColor];
//    self.titleLabel.backgroundColor = [UIColor whiteColor];
    
    [super layoutSubviews];
    
    if(!invertHorizontalLayout)
        return;
    
    // Invert image-label positions
    UIImageView *imageView = [self imageView];
    UILabel *label = [self titleLabel];
    
    CGRect imageFrame = imageView.frame;
    CGRect labelFrame = label.frame;
    
    labelFrame.origin.x = self.bounds.size.width - labelFrame.origin.x - labelFrame.size.width;
    imageFrame.origin.x = self.bounds.size.width - imageFrame.origin.x - imageFrame.size.width;
    
    imageView.frame = CGRectIntegral(imageFrame);
    label.frame = CGRectIntegral(labelFrame);
}
@end
