//
//  FootballTeamView.m
//  QuantusActive
//
//  Created by Alejandro on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FootballTeamsView.h"
#import "UIView+Styled.h"

@implementation FootballTeamsView

- (id) initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]) {
        // Background image
        UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pitch.jpg"]];
        [self addSubview:background];
    }
    return self;
}

- (DroppableArea*) placeDroppableWithCenter:(CGPoint)center withName:(NSString*)someName
{
    DroppableArea *droppable = [DroppableArea circleWithFrame:CGRectMake(center.x, center.y, categorySize, categorySize)
                                                            withBorderWidth:5];
    [droppable setName:someName];
    [self addSubview:droppable];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0, categorySize, categorySize)];
    [label setText:someName];
    [label setTextAlignment:UITextAlignmentCenter];
    [label setShadowColor:[UIColor blackColor]];
    [label setShadowOffset:CGSizeMake(3, 3)];
    [label setTextColor:[UIColor whiteColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:categoryFontSize]];
    [droppable addSubview:label];
    
    return droppable;
}

@end
