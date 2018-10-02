//
//  FBSliderWithGhost.h
//  Fubu
//
//  Created by Remote on 03/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FBSlider.h"

@interface FBSliderWithGhost : FBSlider {
    CGFloat ghostValue;
}

@property CGFloat ghostValue;

- (void)setGhostValue:(CGFloat)ghostValue;
- (CGFloat)ghostValue;

@end
