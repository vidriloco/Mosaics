//
//  GreetingViewController.h
//  QuantusActive
//
//  Created by Workstation on 3/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SurveyQuestionBaseController+Protected.h"
#import "SurveyQuestionProtocol.h"
#import "SurveyAnswersCommitDelegate.h"

@interface GreetingViewController : SurveyQuestionBaseController<SurveyQuestionProtocol, SurveyAnswersCommitDelegate>

@end
