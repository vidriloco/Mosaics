//
//  UILabel+Shadow.m
//  Fubu
//
//  Copyright 2011 Mosaics. All rights reserved.
//

#import "UILabel+Shadow.h"

@implementation UILabel_Shadow

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void) drawTextInRect:(CGRect)rect {    
    CGSize myShadowOffset = CGSizeMake(0, 2);
    float myColorValues[] = {0, 0, 0, 0.33};
    
    CGContextRef myContext = UIGraphicsGetCurrentContext();
    CGContextSaveGState(myContext);
    
    CGColorSpaceRef myColorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef myColor = CGColorCreate(myColorSpace, myColorValues);
    CGContextSetShadowWithColor(myContext, myShadowOffset, 5, myColor);    
    
    [super drawTextInRect:rect];    
    //[self.text drawInRect:self.bounds withFont:self.font lineBreakMode:self.lineBreakMode alignment:self.textAlignment];
    
    CGColorRelease(myColor);
    CGColorSpaceRelease(myColorSpace); 

    CGContextRestoreGState(myContext);
}
@end
