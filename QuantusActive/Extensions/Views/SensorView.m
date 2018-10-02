//
//  SensorView.m
//  QuantusActive
//
//  Created by Workstation on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SensorView.h"

@interface SensorView() {
    
}

- (BOOL)hitTest:(CGPoint)somePoint;

@end

@implementation SensorView
@synthesize delegate, hitPath;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)trackView:(UIView *)someView
{
    [someView addObserver:self
               forKeyPath:@"center"
                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                  context:nil];
}

- (void)untrackView:(UIView *)someView
{
    [someView removeObserver:self
                  forKeyPath:@"center"];
}

- (BOOL)isViewInsideSensorArea:(UIView *)someView
{
    return [self hitTest:someView.center];
}

- (BOOL)hitTest:(CGPoint)somePoint
{
    BOOL isPointInside = CGRectContainsPoint(self.frame, somePoint);
    if (self.hitPath)
            isPointInside = [hitPath containsPoint:somePoint];

    return isPointInside;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    // Ignore other fields for now
    if (keyPath != @"center")
        return;
    
    CGPoint oldPos = [[change objectForKey:NSKeyValueChangeOldKey] CGPointValue];
    CGPoint newPos = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue];
    BOOL isOldPosInside = [self hitTest:oldPos];
    BOOL isNewPosInside = [self hitTest:newPos];
    
    // Entered
    if (!isOldPosInside && isNewPosInside) {
        if ([self.delegate respondsToSelector:@selector(object:didEnterSensorArea:)])
            [self.delegate object:object didEnterSensorArea:self];
        
        return;
    }
    
    // Left
    if (isOldPosInside && !isNewPosInside) {
        if ([self.delegate respondsToSelector:@selector(object:didLeaveSensorArea:)])
            [self.delegate object:object didLeaveSensorArea:self];
        
        return;
    }
}

@end
