//
//  ModelSilo.h
//  PersistenceGroup
//
//  Created by Alejandro on 3/15/12.
//  Copyright (c) 2012 Quantus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Session.h"
#import "ASIHTTPRequestDelegate.h"
#import "SurveyAnswersCommitDelegate.h"

@interface ModelSilo : NSObject<NSCoding, ASIHTTPRequestDelegate> {
    NSMutableArray* store;
}

@property (atomic, strong) NSMutableArray* store;

+ (void) loadOrInit;

+ (void) commitAnswersForCurrentSurveyReportingTo:(id<SurveyAnswersCommitDelegate>)responder;
+ (void) commitAnswers:(NSDictionary *)answers withIndex:(NSInteger)index withResponder:(id<SurveyAnswersCommitDelegate>)responder;

+ (void) stageAnswersForCurrentSurveyForLaterCommit;
+ (void) commitStagedAnswersWithResponder:(id<SurveyAnswersCommitDelegate>)responder;

+ (ModelSilo*) current;
+ (void) clearCurrent;

+ (void) destroyStorage;

@end
