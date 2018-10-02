//
//  OpenAnswerViewController.h
//  Fubu
//
//  Created by Alejandro on 11/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SurveyQuestionBaseController+Protected.h"
#import "SurveyQuestionProtocol.h"

@interface ElectionsOpenViewController : SurveyQuestionBaseController<SurveyQuestionProtocol, UITextViewDelegate> {
}

@end
