//
//  MultipleAnswerInputViewController.h
//  Fubu
//
//  Copyright 2011 Mosaics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SurveyQuestionBaseController+Protected.h"
#import "SurveyQuestionProtocol.h"

@interface VideoViewController : SurveyQuestionBaseController<SurveyQuestionProtocol, UITextFieldDelegate> {
    
}
@end
