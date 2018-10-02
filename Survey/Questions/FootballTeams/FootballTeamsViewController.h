//
//  FootballTeamsViewController.h
//  QuantusActive
//
//  Created by Alejandro on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SurveyQuestionBaseController+Protected.h"
#import "SurveyQuestionProtocol.h"
#import "SensorViewDelegate.h"
#import "DraggableViewDelegate.h"

@interface FootballTeamsViewController : SurveyQuestionBaseController<SurveyQuestionProtocol, SensorViewDelegate, DraggableViewDelegate>

- (void) makeNextTeamItemVisibleAndSelectable;

@end
