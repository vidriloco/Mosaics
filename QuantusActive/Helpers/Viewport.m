//
//  Viewport.m
//  QuantusActive
//
//  Created by Workstation on 3/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Viewport.h"

@implementation Viewport

+ (CGRect)bounds
{
    return [[UIScreen mainScreen] bounds];
}

+ (CGRect)navFrame
{
    return CGRectMake(0, 0, [self bounds].size.width, [self bounds].size.height / 3);
}

@end
