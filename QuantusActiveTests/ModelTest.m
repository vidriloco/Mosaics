//
//  ModelTest.m
//  QuantusActive
//
//  Created by Alejandro on 3/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "ModelTest.h"
#import "Session.h"

@implementation ModelTest

- (void) setUp
{
    model = [Model loadWithFile:@"test_descriptor"];
}

- (void) testLoadsTheRequestedQuestionFromLoadedDescriptor
{
    NSString *expectedTitle = @"Seleccione cada restaurante y encierre los conceptos con los que esté de acuerdo";
    NSString *expectedType = @"MOS";
    NSArray *expectedOpts = [NSArray arrayWithObjects:@"Económico", @"Delicioso", @"Saludable", @"Completo", nil];
    NSArray *expectedItems = [NSArray arrayWithObjects: @"Subway", @"Domino's Pizza", @"Burger King", nil];
    
    [model setActiveQuestion:1];
    NSDictionary* questionSelected = [model viewDataForNextQuestion];
    STAssertNotNil([model activeQuestionStartDate], @"Date nil for question");
    STAssertTrue([[model activeQuestionType] isEqualToString:expectedType], @"Bad question type");
    
    STAssertTrue([[questionSelected objectForKey:@"title"] isEqualToString:expectedTitle], @"Bad title");
    STAssertTrue([[questionSelected objectForKey:@"options"] isEqualToArray:expectedOpts], @"Bad options");
    STAssertTrue([[questionSelected objectForKey:@"items"] isEqualToArray:expectedItems], @"Bad items");
}

- (void) testMergesAnswersForMultipleOptionMultipleAnswerQuestion
{
    [model setActiveQuestion:1];
    [model viewDataForNextQuestion];
    // For question 1: { "BurgerKing" => ["Económico", "Delicioso"], "Subway" => ... }
    NSMutableDictionary* answer = [NSMutableDictionary dictionary];
    [answer setObject:[NSArray arrayWithObjects:@"Económico", @"Delicioso", nil] forKey:@"Burger King"];
    [answer setObject:[NSArray arrayWithObjects:@"Completo", @"Saludable", nil] forKey:@"Subway"];
    [answer setObject:[NSArray array] forKey:@"Domino's Pizza"];
    
    [model mergeAnswers:answer];
    
    NSDictionary *translatedAnswer = [[[model collectedAnswers] objectForKey:@"10016"] objectForKey:@"answers"];

    // Translation 10016: { 20044 => [1,4], 20046 => ... }
    NSArray *expectAns = [NSArray arrayWithObjects:@"4", @"1", nil];
    STAssertTrue([[translatedAnswer objectForKey:@"20044"] isEqualToArray:expectAns], @"Translation failed");
    expectAns = [NSArray arrayWithObjects:@"3", @"2", nil];
    STAssertTrue([[translatedAnswer objectForKey:@"20046"] isEqualToArray:expectAns], @"Translation failed");
    expectAns = [NSArray array];
    STAssertTrue([[translatedAnswer objectForKey:@"20045"] isEqualToArray:expectAns], @"Translation failed");
    
}

- (void) testMergesAnswersForMapQuestion
{
    [model setActiveQuestion:2];
    [model viewDataForNextQuestion];
    // For question 2: { "Audi" => [X, Y], "Volkswagen" => ... }
    NSMutableDictionary* answer = [NSMutableDictionary dictionary];
    [answer setObject:[NSArray arrayWithObjects:@"0.5", @"0.5", nil] forKey:@"Audi"];
    [answer setObject:[NSArray arrayWithObjects:@"0.4", @"0.3", nil] forKey:@"Volkswagen"];
    [answer setObject:[NSArray arrayWithObjects:@"0.2", @"0.5", nil] forKey:@"Nissan"];
    
    [model mergeAnswers:answer];
    
    NSDictionary *translatedAnswer = [[[model collectedAnswers] objectForKey:@"10017"] objectForKey:@"answers"];
    
    // Translation 10017: { 20048 => [1,4], 20046 => ... }
    NSArray *expectAns = [NSArray arrayWithObjects:@"0.5", @"0.5", nil];
    STAssertTrue([[translatedAnswer objectForKey:@"20048"] isEqualToArray:expectAns], @"Translation failed");
    expectAns = [NSArray arrayWithObjects:@"0.4", @"0.3", nil];
    STAssertTrue([[translatedAnswer objectForKey:@"20051"] isEqualToArray:expectAns], @"Translation failed");
    expectAns = [NSArray arrayWithObjects:@"0.2", @"0.5", nil];
    STAssertTrue([[translatedAnswer objectForKey:@"20047"] isEqualToArray:expectAns], @"Translation failed");
    
}

- (void) testMergesAnswersForOpenAnswerQuestion
{
    [model setActiveQuestion:3];
    [model viewDataForNextQuestion];
    // For question 3: { "Open 1" => [text] }
    NSMutableDictionary* answer = [NSMutableDictionary dictionary];
    [answer setObject:[NSArray arrayWithObjects:@"Opino que no se nada", nil] forKey:@"Open 1"];
    
    [model mergeAnswers:answer];
    
    NSDictionary *translatedAnswer = [[[model collectedAnswers] objectForKey:@"10018"] objectForKey:@"answers"];

    
    // Translation 10018: { 20055 => ["Opino que no se nada"] }
    NSArray *expectAns = [NSArray arrayWithObjects:@"Opino que no se nada", nil];
    STAssertTrue([[translatedAnswer objectForKey:@"20055"] isEqualToArray:expectAns], @"Translation failed");
}

- (void) testMergesAnswersForMultipleOptionTwoAnswersQuestion
{
    [model setActiveQuestion:4];
    [model viewDataForNextQuestion];
    // For question 4: { "American Express" => ["Lo uso"], "HSBC" => ["No lo uso"], "VISA" => ["Lo uso"] }
    NSMutableDictionary* answer = [NSMutableDictionary dictionary];
    [answer setObject:[NSArray arrayWithObjects:@"No lo uso", nil] forKey:@"HSBC"];
    [answer setObject:[NSArray arrayWithObjects:@"Lo uso", nil] forKey:@"American Express"];
    [answer setObject:[NSArray arrayWithObjects:@"Lo uso", nil] forKey:@"VISA"];

    [model mergeAnswers:answer];
    
    NSDictionary *translatedAnswer = [[[model collectedAnswers] objectForKey:@"10019"] objectForKey:@"answers"];

    // Translation 10019: { 20058 => [6], 20060 => [5], 20063 => [5] }
    NSArray *expectAns = [NSArray arrayWithObjects:@"6", nil];
    STAssertTrue([[translatedAnswer objectForKey:@"20058"] isEqualToArray:expectAns], @"Translation failed");

    expectAns = [NSArray arrayWithObjects:@"5", nil];
    STAssertTrue([[translatedAnswer objectForKey:@"20060"] isEqualToArray:expectAns], @"Translation failed");    
    STAssertTrue([[translatedAnswer objectForKey:@"20063"] isEqualToArray:expectAns], @"Translation failed");
}

- (void) testMergesAnswersForDichotomicQuestion
{
    [model setActiveQuestion:5];
    [model viewDataForNextQuestion];
    // For question 5: { "No" => ["T"], "Si" => ["F"] }
    NSMutableDictionary* answer = [NSMutableDictionary dictionary];
    [answer setObject:[NSArray arrayWithObjects:@"T", nil] forKey:@"No"];
    [answer setObject:[NSArray arrayWithObjects:@"F", nil] forKey:@"Si"];
    
    [model mergeAnswers:answer];
    
    NSDictionary *translatedAnswer = [[[model collectedAnswers] objectForKey:@"10020"] objectForKey:@"answers"];
    
    // Translation 10020: { 20065 => ["T"], 20064 => ["F"] }
    NSArray *expectAns = [NSArray arrayWithObjects:@"T", nil];
    STAssertTrue([[translatedAnswer objectForKey:@"20065"] isEqualToArray:expectAns], @"Translation failed");
    
    expectAns = [NSArray arrayWithObjects:@"F", nil];
    STAssertTrue([[translatedAnswer objectForKey:@"20064"] isEqualToArray:expectAns], @"Translation failed");    
}

- (void) testMergesAnswersForMultipleOpenAnswerQuestion
{
    [model setActiveQuestion:7];
    [model viewDataForNextQuestion];
    // For question 7: { "Open 1" => ["SNFC"], "Open 2" => ["Amtrak"], "Open 3" => ["CAF"] }
    NSMutableDictionary* answer = [NSMutableDictionary dictionary];
    [answer setObject:[NSArray arrayWithObjects:@"SNFC", nil] forKey:@"Open 1"];
    [answer setObject:[NSArray arrayWithObjects:@"Amtrak", nil] forKey:@"Open 2"];
    [answer setObject:[NSArray arrayWithObjects:@"CAF", nil] forKey:@"Open 3"];
    [model mergeAnswers:answer];
    
    NSDictionary *translatedAnswer = [[[model collectedAnswers] objectForKey:@"10022"] objectForKey:@"answers"];
    
    
    // Translation 10022: { 20072 => ["SNFC"], 20073 => ["Amtrak"], 20074 => ["CAF"] }
    NSArray* expectAns = [NSArray arrayWithObjects:@"SNFC", nil];
    STAssertTrue([[translatedAnswer objectForKey:@"20072"] isEqualToArray:expectAns], @"Translation failed");
    expectAns = [NSArray arrayWithObjects:@"Amtrak", nil];
    STAssertTrue([[translatedAnswer objectForKey:@"20073"] isEqualToArray:expectAns], @"Translation failed");
    expectAns = [NSArray arrayWithObjects:@"CAF", nil];
    STAssertTrue([[translatedAnswer objectForKey:@"20074"] isEqualToArray:expectAns], @"Translation failed");
}

- (void) testMergesAnswersForOrderingQuestion
{
    [model setActiveQuestion:9];
    [model viewDataForNextQuestion];
    // For question 9: { "Iusacell" => ["1"], "Movistar" => ["2"], "Telcel" => ["3"] }
    NSMutableDictionary* answer = [NSMutableDictionary dictionary];
    [answer setObject:[NSArray arrayWithObjects:@"1", nil] forKey:@"Iusacell"];
    [answer setObject:[NSArray arrayWithObjects:@"2", nil] forKey:@"Movistar"];
    [answer setObject:[NSArray arrayWithObjects:@"3", nil] forKey:@"Telcel"];
    [model mergeAnswers:answer];
    
    NSDictionary *translatedAnswer = [[[model collectedAnswers] objectForKey:@"10024"] objectForKey:@"answers"];
    
    
    // Translation 10024: { 20084 => ["1"], 20082 => ["2"], 20085 => ["3"] }
    NSArray* expectAns = [NSArray arrayWithObjects:@"1", nil];
    STAssertTrue([[translatedAnswer objectForKey:@"20084"] isEqualToArray:expectAns], @"Translation failed");
    expectAns = [NSArray arrayWithObjects:@"2", nil];
    STAssertTrue([[translatedAnswer objectForKey:@"20082"] isEqualToArray:expectAns], @"Translation failed");
    expectAns = [NSArray arrayWithObjects:@"3", nil];
    STAssertTrue([[translatedAnswer objectForKey:@"20085"] isEqualToArray:expectAns], @"Translation failed");
}

- (void) testMergesAnswersForConstantSumQuestion
{
    [model setActiveQuestion:10];
    [model viewDataForNextQuestion];
    // For question 10: { "Servicios" => ["30"], "Ubicación" => ["40"], "Precio Actual" => ["30"] }
    NSMutableDictionary* answer = [NSMutableDictionary dictionary];
    [answer setObject:[NSArray arrayWithObjects:@"15", nil] forKey:@"Servicios"];
    [answer setObject:[NSArray arrayWithObjects:@"65", nil] forKey:@"Ubicación"];
    [answer setObject:[NSArray arrayWithObjects:@"20", nil] forKey:@"Precio Actual"];
    [model mergeAnswers:answer];
    
    NSDictionary *translatedAnswer = [[[model collectedAnswers] objectForKey:@"10025"] objectForKey:@"answers"];
    
    
    // Translation 10025: { 20090 => ["15"], 20088 => ["65"], 20089 => ["20"] }
    NSArray* expectAns = [NSArray arrayWithObjects:@"15", nil];
    STAssertTrue([[translatedAnswer objectForKey:@"20090"] isEqualToArray:expectAns], @"Translation failed");
    expectAns = [NSArray arrayWithObjects:@"65", nil];
    STAssertTrue([[translatedAnswer objectForKey:@"20088"] isEqualToArray:expectAns], @"Translation failed");
    expectAns = [NSArray arrayWithObjects:@"20", nil];
    STAssertTrue([[translatedAnswer objectForKey:@"20089"] isEqualToArray:expectAns], @"Translation failed");
}

- (void) testMergesMetadata
{
    [Session buildWithData:[NSDictionary dictionaryWithObjectsAndKeys:@"userZero", @"username", @"808022ACME", @"uid", nil]];

    NSDictionary * dict = [model mergeMetadata];
    STAssertTrue([[dict objectForKey:@"questions"] isEqualToDictionary:[NSDictionary dictionary]], @"questions dictionary should match");
    STAssertTrue([[dict objectForKey:@"meta_survey_id"] isEqualToString:@"5"], @"surveyid should match");
    STAssertTrue([[dict objectForKey:@"pollster_uid"] isEqualToString:@"808022ACME"], @"pollster uid not matching");
    STAssertNotNil([dict objectForKey:@"device_id"], @"Device should not be empty");
}

@end