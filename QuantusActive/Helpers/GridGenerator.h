//
//  GridGenerator.h
//  QuantusActive
//
//  Created by Workstation on 3/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GridGenerator : NSObject
+ (NSArray *)regularGridWithFrame:(CGRect)frame numRows:(int)numRows numCols:(int)numCols;
+ (NSArray *)jitteredGridWithFrame:(CGRect)frame numRows:(int)numRows numCols:(int)numCols;
@end
