//
//  GridGenerator.m
//  QuantusActive
//
//  Created by Workstation on 3/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GridGenerator.h"

@implementation GridGenerator
+ (NSArray *)regularGridWithFrame:(CGRect)frame numRows:(int)numRows numCols:(int)numCols
{
    NSMutableArray *output = [[NSMutableArray alloc] init];
    for (int i = 0; i < numRows; ++i) {
        for (int j = 0; j < numCols; ++j) {
            CGFloat x = CGRectGetMinX(frame) + (j + 0.5) * (CGRectGetMaxX(frame) - CGRectGetMinX(frame)) / numCols;
            CGFloat y = CGRectGetMinY(frame) + (i + 0.5) * (CGRectGetMaxY(frame) - CGRectGetMinY(frame)) / numRows;
            [output addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
        }
    }
    return output;
}

+ (NSArray *)jitteredGridWithFrame:(CGRect)frame numRows:(int)numRows numCols:(int)numCols
{
    NSMutableArray *output = [[NSMutableArray alloc] init];
    for (int i = 0; i < numRows; ++i) {
        for (int j = 0; j < numCols; ++j) {
            CGFloat x = CGRectGetMinX(frame) + (j + (CGFloat) random() / LONG_MAX) * (CGRectGetMaxX(frame) - CGRectGetMinX(frame)) / numCols;
            CGFloat y = CGRectGetMinY(frame) + (i + (CGFloat) random() / LONG_MAX) * (CGRectGetMaxY(frame) - CGRectGetMinY(frame)) / numRows;
            [output addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
        }
    }
    return output;
}
@end
