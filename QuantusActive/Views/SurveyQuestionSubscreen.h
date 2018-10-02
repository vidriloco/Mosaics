//
//  SurveyQuestionSubscreen.h
//  QuantusActive
//
//  Created by Workstation on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

enum QuestionSubscreenAnimationOptions {
    QuestionSubscreenAnimationOptionNone          = 1 << 0,
    QuestionSubscreenAnimationOptionTranslate     = 1 << 1,
    QuestionSubscreenAnimationOptionCrossDissolve = 1 << 2
};

@interface SurveyQuestionSubscreen : UIView

@property (nonatomic, assign) enum QuestionSubscreenAnimationOptions animationOptions;
@property (nonatomic, assign) CGPoint animationStartPosition;
@property (nonatomic, assign) CGPoint animationEndPosition;
@property (nonatomic, assign) CGFloat animationDuration;

@end
