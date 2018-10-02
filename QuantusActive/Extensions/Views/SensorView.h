//
//  SensorView.h
//  QuantusActive
//
//  Created by Workstation on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SensorViewDelegate.h"

@interface SensorView : UIView {
    id<SensorViewDelegate> delegate;
    UIBezierPath          *hitPath;
}
@property (nonatomic, retain) id<SensorViewDelegate> delegate;
@property (nonatomic, retain) UIBezierPath *hitPath;

- (void)trackView:(UIView *)someView;
- (void)untrackView:(UIView *)someView;
- (BOOL)isViewInsideSensorArea:(UIView *)someView;
@end
