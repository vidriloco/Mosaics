//
//  BankAgrouperView.m
//  QuantusActive
//
//  Created by Alejandro on 3/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BankAgrouperView.h"
#define EXPANSION_DURATION      0.5
#define SIZE_INCREMENT          100

@implementation BankAgrouperView

- (int) initialColor
{
    return 0x111;
}

- (void) itemDroppedWithAnimation
{

    [UIView animateWithDuration:EXPANSION_DURATION         
                          delay:0
                        options:UIViewAnimationCurveLinear
                     animations:^{
                         self.transform = CGAffineTransformScale(self.transform, 1.2, 1.2);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:EXPANSION_DURATION         
                                               delay:0
                                             options:UIViewAnimationCurveLinear
                                          animations:^{
                                              self.transform = CGAffineTransformScale(self.transform, 0.9, 0.9);
                                          }
                                          completion:nil];
                     }];
}

@end
