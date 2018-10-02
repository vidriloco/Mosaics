//
//  ModelSilo.m
//  PersistenceGroup
//
//  Created by Alejandro on 3/15/12.
//  Copyright (c) 2012 Quantus. All rights reserved.
//

#import "ModelSilo.h"
#import "Model.h"
#import "App.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"

#define maxNumber               100000
#define archiveName             @"storedFile.archive"
#define storeId                 @"store"
#define tagNotEnabledValue      999999

static ModelSilo* instance;
static NSString* dirPath = @"storage/";
static id<SurveyAnswersCommitDelegate> answersCommitDelegate;

@interface ModelSilo()

/*+ (void) commitAnswerGroup:(NSMutableDictionary*) dictionary 
                 onSuccess:(MKNKResponseBlock)success 
                   onError:(MKNKErrorBlock)error;*/
@end

/*
 *  This class stores survey objects as returned from [Model mergeMetadata] in an array
 *  and attempts to push them in the background to the backend archiving them when not
 *  completing the pushing operation.
 */ 
@implementation ModelSilo

@synthesize store;

+ (void) loadOrInit
{
    if (instance == nil) {
        instance = [NSKeyedUnarchiver unarchiveObjectWithFile:archiveName]; 
    }
    
    if (instance == nil) {
        instance = [[self alloc] init];
    }
}

/*
 * First, it attempts to push this answer to backend. 
 * If it fails then this answer gets staged
 */
+ (void) commitAnswersForCurrentSurveyReportingTo:(id<SurveyAnswersCommitDelegate>)delegate
{
    NSLog(@"Sending ....");
    [self commitAnswers:[Model retrieveAnswersForCurrentSurvey] withIndex:tagNotEnabledValue withResponder:delegate];
}

+ (void) commitAnswers:(NSDictionary *)answers withIndex:(NSInteger)index withResponder:(id<SurveyAnswersCommitDelegate>)responder
{
    answersCommitDelegate = responder;
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[App commitPath]]];
    [request addRequestHeader: @"Content-Type" value: @"application/json; charset=utf-8"];
    [request setRequestMethod:@"POST"];
    [request appendPostData:[[answers JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setDelegate:[ModelSilo current]];

    [request setTag:index];
    [request startAsynchronous];
}

/*
 * Stages an answer to local persistence mechanism (Archive)
 */
+ (void) stageAnswersForCurrentSurveyForLaterCommit
{
    [self loadOrInit];
    [instance.store addObject:[Model retrieveAnswersForCurrentSurvey]];
    [NSKeyedArchiver archiveRootObject:instance toFile:archiveName];
}

/*
 * Performs a bulk commit for all the staged answers
 */
+ (void) commitStagedAnswersWithResponder:(id<SurveyAnswersCommitDelegate>)responder
{
    if ([instance.store count] > 0) {
        for (NSMutableDictionary *surveyAnswer in instance.store) {
            [self commitAnswers:surveyAnswer withIndex:[instance.store indexOfObject:surveyAnswer] withResponder:responder];
        }
    }
}

+ (ModelSilo*) current
{
    if (instance == NULL) {
        [ModelSilo loadOrInit];
    }
    return instance;
}

+ (void) clearCurrent
{
    instance = NULL;
}

+ (void) destroyStorage
{
    [[NSFileManager defaultManager] removeItemAtPath:archiveName error:NULL];
}

- (id) init
{
    if (self=[super init]) {
        srandom(time(NULL));
        self.store  = [NSMutableArray array];
    }
    return self;
}

- (id) initWithCoder:(NSKeyedUnarchiver *)decoder {
    self = [self init];
    self.store = [decoder decodeObjectForKey:storeId];
    return self;
}

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.store forKey:storeId];
}

#pragma mark - Request response status

- (void) requestFinished:(ASIHTTPRequest *)request {
    if (request.tag != tagNotEnabledValue) {
        [instance.store removeObjectAtIndex:request.tag];
        [NSKeyedArchiver archiveRootObject:instance toFile:archiveName];
    }
    
    if (answersCommitDelegate != nil) {
        if ([answersCommitDelegate respondsToSelector:@selector(answersForSurveyCommitSucceded)]) {
            [answersCommitDelegate answersForSurveyCommitSucceded];
        }
    }
    
    if ([instance.store count] == 0) {
        if ([answersCommitDelegate respondsToSelector:@selector(allAnswersCommitSucceded)]) {
            [answersCommitDelegate allAnswersCommitSucceded];
        }
    }
}

- (void) requestFailed:(ASIHTTPRequest *)request {
    if (answersCommitDelegate != nil && [answersCommitDelegate respondsToSelector:@selector(answersForSurveyCommitFailed)]) {
        [answersCommitDelegate answersForSurveyCommitFailed];
    }
    
    if ([instance.store count] > 0) {
        if ([answersCommitDelegate respondsToSelector:@selector(someAnswersCommitFailed)]) {
            [answersCommitDelegate someAnswersCommitFailed];
        }
    }
}

@end
