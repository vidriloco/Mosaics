//
//  DroppableArea.h
//  QuantusActive
//
//  Created by Alejandro on 3/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SensorView.h"

@interface DroppableArea : SensorView {
    NSString *name;
}

@property (nonatomic, strong) NSString *name;

- (id) initWithFrame:(CGRect)frame withName:(NSString*)name;
- (void) itemDroppedWithAnimation;

@end
