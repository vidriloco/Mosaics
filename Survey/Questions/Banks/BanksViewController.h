//
//  BanksViewController.h
//  QuantusActive
//
//  Created by Alejandro on 3/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SurveyQuestionBaseController+Protected.h"
#import "SurveyQuestionBaseController.h"
#import "SurveyQuestionProtocol.h"
#import "SensorViewDelegate.h"
#import "DraggableViewDelegate.h"

@interface BanksViewController : SurveyQuestionBaseController<SurveyQuestionProtocol, SensorViewDelegate, DraggableViewDelegate>

@end
