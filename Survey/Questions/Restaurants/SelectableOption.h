//
//  SelectableOption.h
//  Fubu
//
//  Copyright 2011 Mosaics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectableOption : UILabel 

+ (id) newWithName:(NSString*)name andCenter:(CGPoint)center;

- (void) toogleDeselected;
- (void) toogleSelectedWithColor:(CGColorRef)color;

@end
