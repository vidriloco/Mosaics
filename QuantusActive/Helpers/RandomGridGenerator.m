//
//  GridGenerator.m
//  QuantusActive
//
//  Created by Alejandro on 3/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RandomGridGenerator.h"
#include <stdlib.h>


@interface RandomGridGenerator()
@property (nonatomic, assign) CGPoint upperBound;
@property (nonatomic, assign) CGPoint lowerBound;

- (float) randomNumberWithinMin:(float)min andMax:(float)max; 

@end

@implementation RandomGridGenerator

@synthesize upperBound, lowerBound;

- (id) initWithLowerBounds:(CGPoint)lBounds andUpperBounds:(CGPoint)uBounds
{
    if((self = [super init]))
    {
        self.upperBound = uBounds;
        self.lowerBound = lBounds;
    }
    return self;
}

- (CGPoint) nextRandomCenterWithWidth:(float)width withHeight:(float)height
{
    return CGPointMake([self randomNumberWithinMin:lowerBound.x andMax:upperBound.x], 
                                [self randomNumberWithinMin:lowerBound.y andMax:upperBound.y]);
}

- (float) randomNumberWithinMin:(float)min andMax:(float)max
{
    float diff = max - min;
    return (((float) arc4random() / RAND_MAX) * diff) + min;
}



@end
