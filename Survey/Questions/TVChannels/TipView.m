//
//  TipView.m
//  Fubu
//
//  Created by Remote on 28/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TipView.h"

@implementation TipView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(rect.size.width, 0)];
    [path addLineToPoint:CGPointMake(CGRectGetMidX(rect), rect.size.height)];
    [path closePath];
    [[UIColor whiteColor] setFill];
    [path fill];
}
@end
