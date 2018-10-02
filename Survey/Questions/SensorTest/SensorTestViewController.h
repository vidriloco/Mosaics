//
//  SensorTestViewController.h
//  QuantusActive
//
//  Created by Workstation on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SurveyQuestionBaseController+Protected.h"
#import "SensorViewDelegate.h"
#import "SurveyQuestionProtocol.h"

@interface SensorTestViewController : SurveyQuestionBaseController<SurveyQuestionProtocol, SensorViewDelegate>

@end
