//
//  SurveyQuestionMultiScreenProtocol.h
//  QuantusActive
//
//  Created by Workstation on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SurveyQuestionProtocol.h"
#import "SurveyQuestionSubscreen.h"

@protocol SurveyQuestionMultiScreenProtocol <SurveyQuestionProtocol, NSObject>

- (SurveyQuestionSubscreen *)subscreenAtIndex:(NSUInteger)index;
- (NSUInteger)numberOfSubscreens;

@end
