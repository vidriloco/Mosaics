//
//  ModelSiloTest.m
//  QuantusActive
//
//  Created by Alejandro on 3/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ModelSiloTest.h"

@implementation ModelSiloTest

+ (void) setUp
{
    // Mocked session
    [Session buildWithData:[NSDictionary dictionaryWithObjectsAndKeys:@"userZero", @"username", @"808022ACME", @"uid", nil]];
}

+ (void) tearDown
{
    [ModelSilo destroyStorage];
}

- (NSDictionary*) mockSurveyResultWithSurveyId:(NSString*)identifier
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:identifier forKey:@"meta_survey_id"];
    [dict setObject:[NSString stringWithFormat:@"%@-pollster", identifier] forKey:@"pollster_id"];
    [dict setObject:[NSArray array] forKey:@"questions"];
    
    return dict;
}

- (void) testRetrievesCurrentModelSilo
{
    
    [ModelSilo stageAnswerGroup:[self mockSurveyResultWithSurveyId:@"1"]];
    STAssertNotNil([ModelSilo getCurrent], @"Cannot be nil");
    
}

- (void) testResetsCurrentToNil
{
    
    [ModelSilo stageAnswerGroup:[self mockSurveyResultWithSurveyId:@"1"]];
    [ModelSilo clearCurrent];
    STAssertNil([ModelSilo getCurrent], @"Should be nil after reset");
}

- (void) testAnswerGroupStagingAndUnstaging
{

    NSDictionary *as1 = [self mockSurveyResultWithSurveyId:@"1"];
    [ModelSilo stageAnswerGroup:as1];
    NSDictionary *as1Stored = [[ModelSilo getCurrent].store objectAtIndex:0];
    STAssertTrue([[ModelSilo getCurrent].store count] == 1, @"Bad item count");
    STAssertTrue([as1 isEqualToDictionary:as1Stored], @"Bad dictionary stored");
    
    [ModelSilo clearCurrent];
    
    NSDictionary *as2 = [self mockSurveyResultWithSurveyId:@"2"];
    [ModelSilo stageAnswerGroup:as2];
    
    NSDictionary *as2Stored = [[ModelSilo getCurrent].store objectAtIndex:1];
    
    STAssertTrue([[ModelSilo getCurrent].store count] == 2, @"Bad item count");
    STAssertTrue([as2 isEqualToDictionary:as2Stored], @"Bad dictionary stored");
    
    [ModelSilo unstageAnswerGroup:as1];
    
    STAssertTrue([[ModelSilo getCurrent].store count] == 1, @"Bad item count");
    STAssertTrue([[[ModelSilo getCurrent].store objectAtIndex:0] isEqualToDictionary:as2Stored], @"Bad dictionary stored");
    
    [ModelSilo clearCurrent];
    [ModelSilo loadOrInit];
    
    STAssertTrue([[ModelSilo getCurrent].store count] == 1, @"Bad item count");
    STAssertTrue([[[ModelSilo getCurrent].store objectAtIndex:0] isEqualToDictionary:as2Stored], @"Bad dictionary stored");
    
}

@end
