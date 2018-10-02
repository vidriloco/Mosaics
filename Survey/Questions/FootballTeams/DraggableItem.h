//
//  DraggableItem.h
//  QuantusActive
//
//  Created by Alejandro on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DraggableView.h"
#import "DraggableViewDelegate.h"
#import "UIView+Styled.h"
#import "PlaceableItemDelegate.h"

@interface DraggableItem : DraggableView {
    id currentSensor;
    BOOL dropped;
    NSString *name;
}

@property (nonatomic, strong) id currentSensor;
@property (nonatomic, assign) BOOL dropped;
@property (nonatomic, strong) NSString *name; 

+ (DraggableItem*) newWithName:(NSString*)name;

- (void) droppedWithAnimation;
- (void) changeDroppedStatusToDropped;
@end
