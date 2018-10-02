//
//  CarrierBoxView.h
//  QuantusActive
//
//  Created by Alejandro on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Styled.h"
#import "UIColor+Extras.h"
#import "MobileCarriersViewController.h"

@interface CarrierBoxView : UIView {
    NSString* name;
    NSInteger currentCount;
}

@property (nonatomic, strong) NSString *name;
@property NSInteger currentCount;

+ (CarrierBoxView*) newWithName:(NSString*)name withMaxCount:(int)count;
- (void) setInitialCenter:(CGPoint)center;

@end
