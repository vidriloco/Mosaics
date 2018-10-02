//
//  UITextFieldExt.m
//  Fubu
//
//  Created by Alejandro on 7/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UITextFieldExt.h"
#import <QuartzCore/QuartzCore.h>

@implementation UITextFieldExt


- (id)initWithFrame:(CGRect)frame withFont:(UIFont*)font andRadius:(int)radius
{
    if((self = [super initWithFrame:frame]))
    {
        [self setFont:font];
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setAutocorrectionType:UITextAutocorrectionTypeNo];
        [self setKeyboardType:UIKeyboardTypeDefault];
        [self setClearButtonMode:UITextFieldViewModeWhileEditing];
        self.layer.cornerRadius = 10;
    }
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + 10, bounds.origin.y + 10,
                      bounds.size.width - 20, bounds.size.height - 16);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}


@end
