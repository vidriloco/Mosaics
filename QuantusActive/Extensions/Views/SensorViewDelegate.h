//
//  SensorViewDelegate.h
//  QuantusActive
//
//  Created by Workstation on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SensorViewDelegate <NSObject>
@optional
- (void)object:(UIView *)object didEnterSensorArea:(UIView *)sensor;
- (void)object:(UIView *)object didLeaveSensorArea:(UIView *)sensor;
@end
