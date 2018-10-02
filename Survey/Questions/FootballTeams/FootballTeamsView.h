//
//  FootballTeamView.h
//  QuantusActive
//
//  Created by Alejandro on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DroppableArea.h"

#define categoryPositionY 500
#define categorySeparation 90
#define categorySize 250

#define categoryFontSize 35

@interface FootballTeamsView : DroppableArea

- (DroppableArea*) placeDroppableWithCenter:(CGPoint)center withName:(NSString*)name;

@end
