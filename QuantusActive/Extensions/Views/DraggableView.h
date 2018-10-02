//
//  DraggableView.h
//  QuantusActive
//
//  Created by Remote on 26/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DraggableViewDelegate.h"

@interface DraggableView : UIView {
    CGRect targetArea;
    id<DraggableViewDelegate> delegate;
}
- (id)initWithImage:(UIImage *)anImage;
- (void)setCenter:(CGPoint)center animated:(BOOL)animated;
@property (nonatomic, retain) id<DraggableViewDelegate> delegate;
@property (nonatomic, assign) CGRect targetArea;

@end
