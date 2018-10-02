//
//  NSMutableArray+Shuffle.m
//  Fubu
//
//  Created by Remote on 26/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSMutableArray+Shuffle.h"

@implementation NSMutableArray (NSMutableArray_Shuffle)

- (void)shuffle
{
    for (int i = [self count] - 1; i > 0; --i) {
        int pos = rand() % (i + 1);
        id tmp = [self objectAtIndex:pos];
        [self replaceObjectAtIndex:pos withObject:[self objectAtIndex:i]];
        [self replaceObjectAtIndex:i withObject:tmp];
    }
}

@end
