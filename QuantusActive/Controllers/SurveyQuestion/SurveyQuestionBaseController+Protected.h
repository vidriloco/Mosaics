//
//  SurveyQuestionViewController+Protected.h
//  QuantusActive
//
//  Created by Workstation on 3/12/12.
//  Copyright (c) 2012 Quantus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SurveyQuestionBaseController.h"
#import "Marshaller.h"

@interface SurveyQuestionBaseController() {
    BOOL hasValidAnswers;
}
@property (nonatomic, assign) BOOL hasValidAnswers;

@end
