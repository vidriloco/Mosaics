//
//  Model.m
//  PersistenceGroup
//
//  Created by Alejandro on 3/13/12.
//  Copyright (c) 2012 Quantus. All rights reserved.
//

#import "Model.h"
#import "Session.h"
#import "Device.h"
#import "SurveyQuestionBaseController.h"

@interface Model()
NSInteger sortByIdFunction(id left, id right, void *context);

- (NSDictionary*)   metaQuestions;
- (NSDictionary*)   viewDataForNextQuestion;
- (void)            mergeAnswers:(NSDictionary*) answers;
- (BOOL)            doesNotRequireAnswerLookup;
- (int)             incrementActiveQuestionIndex;

@end

static Model *current;
static NSDictionary* pList;

@implementation Model
@synthesize collectedAnswers, activeQuestionType, activeQuestionStartDate, activeQuestion;

+ (id) loadWithDefaultFile
{
    return [Model loadWithFile:pListFile];
}

+ (id) loadWithFile:(NSString *)fileName
{
    current = [[Model alloc] init];
    
    if(pList == NULL) {
        NSString *file = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
        pList = [[NSDictionary alloc] initWithContentsOfFile:file];
    }
    return current;
}

+ (id) current
{
    if (!current)
        [self loadWithDefaultFile];
    
    return current;
}

+ (void) mergeAnswersFromMarshaller:(Marshaller *)marshaller
{
    [current mergeAnswers:[marshaller answers]];
}

+ (int) nextQuestionIndex
{
    // TODO: Fix this awesome hack
    if ([current activeQuestion] == 13)
        [Model reset];
    
    return [[Model current] incrementActiveQuestionIndex];
}

+ (void) reset
{
    current.activeQuestion = kQuestionCountStart;
    current.collectedAnswers = [NSMutableDictionary dictionary];
}

+ (Marshaller*) generateMarshallerForNextQuestion
{
    return [[Marshaller alloc] initWithQuestionMetaData:[current viewDataForNextQuestion]];
}

+ (int) currentQuestionIndex
{
    return [current activeQuestion];
}

- (id) init
{
    if ((self = [super init])) {
        collectedAnswers = [NSMutableDictionary dictionary];
        activeQuestion   = kQuestionCountStart;
    }
    
    return self;
}

- (int) incrementActiveQuestionIndex
{
    /*self.activeQuestion += 1;
    NSLog(@"%@", [NSString stringWithFormat:@"Model: Loading question: %d", activeQuestion]);
    NSDictionary *questionDescriptor = [self.metaQuestions objectForKey:[NSString stringWithFormat:@"%d", activeQuestion]];
    if(activeQuestion == kGreetingQuestionId || questionDescriptor)
    {
        return [[questionDescriptor objectForKey:@"meta_question_id"] intValue];
    }
    return kFarewellQuestionId;*/
    self.activeQuestion += 1;
    NSLog(@"%@", [NSString stringWithFormat:@"Model: Loading question: %d", activeQuestion]);
    if(activeQuestion == 0 || [self.metaQuestions objectForKey:[NSString stringWithFormat:@"%d", activeQuestion]])
    {
        return activeQuestion;
    }
    return NSIntegerMax;
}

- (NSDictionary*) metaQuestions
{
    return [pList objectForKey:@"meta_questions"];
}

NSInteger sortByIdFunction(id left, id right, void *context)
{
    NSDictionary *dict = (__bridge NSDictionary*)context;
    
    NSInteger id1 = [[[dict objectForKey:left] objectForKey:@"order_number"] integerValue];
    NSInteger id2 = [[[dict objectForKey:right] objectForKey:@"order_number"] integerValue];
    if (id1 > id2)
        return NSOrderedDescending;
    else if (id1 < id2)
        return NSOrderedAscending;
    return NSOrderedSame;
}

- (NSDictionary*) viewDataForNextQuestion
{
    NSDictionary *questionDescriptor = [self.metaQuestions objectForKey:[NSString stringWithFormat:@"%d", activeQuestion]];
    activeQuestionStartDate = [NSDate date];
    activeQuestionType = [questionDescriptor objectForKey:@"type_of"];
    
    // Sort options by nested id value
    NSDictionary *optionDict = [questionDescriptor objectForKey:@"meta_answer_options"];
    NSArray *optionArray = [[optionDict allKeys] sortedArrayUsingFunction:sortByIdFunction
                                                                  context:(__bridge void*)optionDict];
    // Sort items by nested id value
    NSDictionary *itemDict = [questionDescriptor objectForKey:@"meta_answer_items"];
    NSArray *itemArray = [[itemDict allKeys] sortedArrayUsingFunction:sortByIdFunction
                                                              context:(__bridge void*)itemDict];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[questionDescriptor objectForKey:@"title"] forKey:@"title"];
    [dict setValue:optionArray forKey:@"options"];
    [dict setValue:itemArray   forKey:@"items"];
    [dict setValue:activeQuestionType forKey:@"type"];
    
    return dict;
}

- (void) mergeAnswers:(NSDictionary*) answers
{
    NSDictionary *question = [self.metaQuestions objectForKey:[NSString stringWithFormat:@"%d", activeQuestion]];
    NSDictionary *metaItems = [question objectForKey:@"meta_answer_items"];
    NSDictionary *metaOptions = [question objectForKey:@"meta_answer_options"];
    
    NSMutableDictionary* translatedAnswers = [NSMutableDictionary dictionary];
    
    for (NSString* item in [answers allKeys]) {
        // translate item human value to id
        NSString *itemId = [[metaItems objectForKey:item] objectForKey:@"id"];
        NSMutableArray *optionsIds = [NSMutableArray array];
        if([self doesNotRequireAnswerLookup]) {
            optionsIds = [answers objectForKey:item];
        } else {
            for (NSString *option in [answers objectForKey:item]) {
                
                NSString *optionId = [[metaOptions objectForKey:option] objectForKey:@"id"]; 
                [optionsIds addObject:optionId];
            }
        }
        
        [translatedAnswers setObject:optionsIds forKey:itemId];
    }
    
    NSMutableDictionary* answerData = [NSMutableDictionary dictionary];
    [answerData setObject:translatedAnswers forKey:@"answers"];
    [answerData setObject:[[NSDate date] description] forKey:@"end_time"];
    [answerData setObject:[activeQuestionStartDate description] forKey:@"start_time"];
    
    [collectedAnswers setObject:answerData forKey:[question objectForKey:@"meta_question_id"]];
    
    // For testing successful send and receive of answers between questions
    // [ModelSilo pushAnswerGroup:[self mergeMetadata]];
}

+ (NSDictionary*) retrieveAnswersForCurrentSurvey
{
    NSMutableDictionary *surveyResults = [NSMutableDictionary dictionary];
    // Include survey metadata
    [surveyResults setObject:[pList objectForKey:@"meta_survey_id"] forKey:@"meta_survey_id"];
    [surveyResults setObject:[Session getCurrent].uid forKey:@"pollster_uid"];
    [surveyResults setObject:[Device getMacAddress] forKey:@"device_id"];
    [surveyResults setObject:[current collectedAnswers] forKey:@"questions"];
    return [NSDictionary dictionaryWithObjectsAndKeys:surveyResults, @"survey", nil];
}

- (BOOL) doesNotRequireAnswerLookup
{
    NSArray* nonTranslatingTypes = [NSArray arrayWithObjects:@"MOSM", @"OQ", @"MOQ", @"PO", @"CS", @"SD", nil];
    return [nonTranslatingTypes containsObject:activeQuestionType];
}

@end
