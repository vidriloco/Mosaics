//
//  SelectableOption.m
//  Fubu
//
//  Copyright 2011 Mosaics. All rights reserved.
//

#import "SelectableOption.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+Extras.h"

@implementation SelectableOption

- (id) initWithFrame:(CGRect)frame andName:(NSString *)name
{
    if((self = [super initWithFrame:frame])){
        [self setText:name];
        [self setFont:[UIFont systemFontOfSize:30]];
        [self setTextColor:[UIColor whiteColor]];
        [self setTextAlignment:UITextAlignmentCenter];

        [self setBackgroundColor:[UIColor colorWithRGB:0x2B2E2E]];
        self.layer.cornerRadius = frame.size.height/2;
        
        [self toogleDeselected];
    }
    
    return self;
}

+ (id) newWithName:(NSString *)name andCenter:(CGPoint)center
{
    return [[SelectableOption alloc] initWithFrame:CGRectMake(center.x, center.y, 200, 70) andName:name];
}

- (void) toogleDeselected
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    
    self.layer.borderColor = [UIColor clearColor].CGColor;
    [self.layer setOpacity:0.5];

    [UIView commitAnimations];
}

- (void) toogleSelectedWithColor:(CGColorRef)color
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    
    self.layer.borderColor = color;
    self.layer.borderWidth = 4;
    [self.layer setOpacity:1];
    
    [UIView commitAnimations];
}

@end
