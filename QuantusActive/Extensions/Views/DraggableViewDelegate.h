//
//  DraggableViewDelegate.h
//  QuantusActive
//
//  Created by Workstation on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DraggableViewDelegate <NSObject>
@optional
- (void)draggableViewWillBeginDragging:(id)draggableView;
- (void)draggableViewDidDrag:(id)draggableView;
- (void)draggableViewDidStopDragging:(id)draggableView;
@end
