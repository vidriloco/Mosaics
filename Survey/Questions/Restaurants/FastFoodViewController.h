//
//  PerceptionViewController.h
//  Fubu
//
//  Copyright 2011 Mosaics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SurveyQuestionBaseController+Protected.h"
#import "SurveyQuestionBaseController.h"
#import "SurveyQuestionProtocol.h"
#import "EvaluationPanelDelegate.h"
#import "EvaluationPaneView.h"

@interface FastFoodViewController : SurveyQuestionBaseController<SurveyQuestionProtocol, EvaluationPanelDelegate> 

- (void) loadNextItemView;

@end
