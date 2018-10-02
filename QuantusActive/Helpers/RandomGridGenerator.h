//
//  RandomGridGenerator.h
//  QuantusActive
//
//  Created by Alejandro on 3/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RandomGridGenerator : NSObject

- (id) initWithLowerBounds:(CGPoint)lBounds andUpperBounds:(CGPoint)uBounds;
- (CGPoint) nextRandomCenterWithWidth:(float)width withHeight:(float)height;

@end
