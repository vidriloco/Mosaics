//
//  Model.h
//  PersistenceGroup
//
//  Created by Alejandro on 3/13/12.
//  Copyright (c) 2012 Quantus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Marshaller.h"
#import "ASIHTTPRequestDelegate.h"

#define pListFile @"descriptor"
#define kQuestionCountStart 11


#define kQuestionWelcomeIndex 0

@interface Model : NSObject {
    NSMutableDictionary* collectedAnswers;
    NSString* activeQuestionType;
    NSDate* activeQuestionStartDate;    
    int activeQuestion;
}

@property (nonatomic, strong) NSMutableDictionary* collectedAnswers;
@property (nonatomic, strong) NSString *activeQuestionType;
@property (nonatomic, strong) NSDate *activeQuestionStartDate;
@property (nonatomic, assign) int activeQuestion;

+ (id)          loadWithDefaultFile;
+ (id)          loadWithFile:(NSString*)fileName;
+ (id)          current;
+ (void)        mergeAnswersFromMarshaller:(Marshaller*)marshaller;
+ (int)         nextQuestionIndex;
+ (Marshaller*) generateMarshallerForNextQuestion;
+ (void)        reset;
+ (int)         currentQuestionIndex;
+ (NSDictionary*) retrieveAnswersForCurrentSurvey;

@end
