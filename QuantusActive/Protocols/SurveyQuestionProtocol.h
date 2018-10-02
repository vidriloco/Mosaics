//
//  SurveyQuestionProtocol.h
//  QuantusActive
//
//  Created by Workstation on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SurveyQuestionProtocol <NSObject>

@required
+ (NSUInteger)questionId;

@optional
- (void)collectAnswers;

@end
