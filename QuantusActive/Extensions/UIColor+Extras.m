//
//  UIColor+Extras.m
//  QuantusActive
//
//  Created by Alejandro on 3/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIColor+Extras.h"

@implementation UIColor(Extras)

+ (UIColor *) colorWithRGB:(int)rgbValue
{
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 
                           green:((float)((rgbValue & 0xFF00) >> 8))/255.0 
                            blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
}

@end
