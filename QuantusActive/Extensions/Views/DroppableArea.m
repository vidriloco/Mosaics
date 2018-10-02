//
//  DroppableArea.m
//  QuantusActive
//
//  Created by Alejandro on 3/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DroppableArea.h"

@implementation DroppableArea

@synthesize name;

- (id) initWithFrame:(CGRect)frame withName:(NSString *)name_
{
    if((self=[super initWithFrame:frame]))
    {
        self.name = name_;
    }
    return self;
}

- (int) initialColor
{
    return 0xFCFAD0;
}

- (void) itemDroppedWithAnimation
{
    
}

@end
