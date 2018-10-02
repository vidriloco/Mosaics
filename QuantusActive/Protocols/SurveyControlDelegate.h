//
//  SurveyControlDelegate.h
//  QuantusActive
//
//  Created by Workstation on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SurveyControlDelegate <NSObject>

- (void)loadNextQuestion;
- (void)exitSurvey;

@end
