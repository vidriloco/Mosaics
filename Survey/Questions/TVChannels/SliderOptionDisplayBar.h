//
//  SliderOptionDisplayBar.h
//  Fubu
//
//  Created by Remote on 27/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBSliderWithOptions.h"
#import "TipView.h"

@interface SliderOptionDisplayBar : UIView {
    NSMutableArray *labels;
    TipView *tip;
}
- (id)initWithSlider:(FBSliderWithOptions*)slider;
- (void)hilightOption:(int)option;
- (void)floatToPoint:(CGPoint)point;
- (void)floatToView:(UIView*)view;
@end
