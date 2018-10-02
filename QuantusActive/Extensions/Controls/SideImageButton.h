//
//  SideImageButton.h
//  QuantusActive
//
//  Created by Workstation on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideImageButton : UIButton {
    UIControlState customState;
    BOOL           invertHorizontalLayout;
}
@property (nonatomic, assign) UIControlState customState;
@property (nonatomic, assign) BOOL invertHorizontalLayout;
+ (id)button;
@end
