//
//  SessionTest.m
//  QuantusActive
//
//  Created by Alejandro on 3/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SessionTest.h"

@implementation SessionTest

- (void) setUp
{
    // If user was authenticated, then the codeline below is called
    [Session buildWithData:[NSDictionary dictionaryWithObjectsAndKeys:@"userZero", @"username", @"808022ACME", @"uid", nil]];
}

- (void) testSessionCurrentIsSet
{
    STAssertNotNil([Session getCurrent], @"Session must not be nil");
    STAssertTrue([[[Session getCurrent] username] isEqualToString:@"userZero"], @"Bad session set");
    STAssertTrue([[[Session getCurrent] uid] isEqualToString:@"808022ACME"], @"Bad session set");
}

- (void) testClearsCurrentSession
{
    [Session clearCurrent];
    STAssertNil([Session getCurrent], @"Current session to null");
}

- (void) testLoadsLastSavedSession
{
    [Session clearCurrent];
    [Session restoreLast];
    STAssertTrue([[[Session getCurrent] username] isEqualToString:@"userZero"], @"Bad session set");
    STAssertTrue([[[Session getCurrent] uid] isEqualToString:@"808022ACME"], @"Bad session set");
}

@end
