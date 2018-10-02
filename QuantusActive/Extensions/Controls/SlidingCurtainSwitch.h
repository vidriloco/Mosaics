//
//  SexBinaryView.h
//  Fubu
//
//  Created by Workstation on 3/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    SlidingCurtainSwitchValueBottom = -1,
    SlidingCurtainSwitchValueUndefined,
    SlidingCurtainSwitchValueTop
};

@interface SlidingCurtainSwitch : UIControl {
    UIImage *topImage;
    UIImage *bottomImage;
    int value;
}
// TODO: Setter?
@property (nonatomic, readonly) int value;
@property (nonatomic, retain) UIImage *topImage;
@property (nonatomic, retain) UIImage *bottomImage;

@end
