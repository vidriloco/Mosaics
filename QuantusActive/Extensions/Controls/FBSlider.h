//
//  BetterSlider.h
//  Fubu
//
//  Copyright 2011 Mosaics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBSlider : UISlider {
    BOOL       useTooltip;
    NSUInteger stops;
}
@property (nonatomic, assign) BOOL useTooltip;
@property (nonatomic, assign) NSUInteger stops;
- (void)setMinimumValueText:(NSString*)text;
- (void)setMaximumValueText:(NSString*)text;
@end