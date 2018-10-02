//
//  SurveyAnswersCommitDelegate.h
//  QuantusActive
//
//  Created by Alejandro on 6/12/12.
//  Copyright (c) 2012 Quantus. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SurveyAnswersCommitDelegate <NSObject>

@optional
- (void) answersForSurveyCommitSucceded;
- (void) answersForSurveyCommitFailed;
- (void) allAnswersCommitSucceded;
- (void) someAnswersCommitFailed;

@end
