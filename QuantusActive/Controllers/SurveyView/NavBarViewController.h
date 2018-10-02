//
//  NavBarViewController.h
//  QuantusActive
//
//  Created by Workstation on 3/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SurveyQuestionBaseController.h"
#import "SurveyControlDelegate.h"
#import "SurveyQuestionProtocol.h"

enum LeftNavButtonControlState {
    LeftNavButtonControlStateDisplayExit          = UIControlStateApplication << 0,
    LeftNavButtonControlStateDisplayChangeAnswers = UIControlStateApplication << 1
};

enum RightNavButtonControlState {
    RightNavButtonControlStateDisplayHelp    = UIControlStateApplication << 0,
    RightNavButtonControlStateDisplayConfirm = UIControlStateApplication << 1,
    RightNavButtonControlStateDisplayNext    = UIControlStateApplication << 2
};

enum SurveyQuestionState {
    SurveyQuestionStateInProcess,
    SurveyQuestionStateAwaitingConfirmation,
    SurveyQuestionStateShowingReset,
    SurveyQuestionStateAnswered,
    SurveyQuestionStateIllegal
};

@interface NavBarViewController : UIViewController<UIAlertViewDelegate> {
    SurveyQuestionBaseController *surveyQuestionController;
    id<SurveyControlDelegate>     surveyControlDelegate;
}
@property (nonatomic, retain) SurveyQuestionBaseController *surveyQuestionController;
@property (nonatomic, retain) id<SurveyControlDelegate>    surveyControlDelegate;

- (void)hide;
- (void)show;

@end
