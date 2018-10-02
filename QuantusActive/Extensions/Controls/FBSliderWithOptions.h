//
//  FBSliderWithGhost.h
//  Fubu
//
//  Created by Remote on 03/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FBSlider.h"

@interface FBSliderWithOptions : FBSlider {
    NSArray     *options;
    NSString    *currentOption;
    BOOL        used;
}
@property (nonatomic, readonly) NSString *currentOption;
@property (nonatomic, readonly) NSArray *options;
@property BOOL used;

- (void)useOptions:(NSArray*)optionList;
- (NSString *)selectedOption;

@end
