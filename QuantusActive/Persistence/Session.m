//
//  Session.m
//  PersistenceGroup
//
//  Created by Alejandro on 3/15/12.
//  Copyright (c) 2012 Quantus. All rights reserved.
//

#import "Session.h"
#import "App.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"

#define archiveName         @"lastSession.archive"
#define usernameAttr        @"username"
#define uidAttr             @"uid"

static Session* current;


@implementation Session

@synthesize username, uid;

- (id) initWithUserData:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        [self setUsername:[dictionary objectForKey:usernameAttr]];
        [self setUid:[dictionary objectForKey:uidAttr]];
    }
    return self;
}

+ (void) buildWithData:(NSDictionary*)userData
{
    current = [[Session alloc] initWithUserData:userData];
    [NSKeyedArchiver archiveRootObject:current toFile:archiveName];
}

+ (void) buildWithUsername:(NSString *)username_ andUID:(NSString *)uid_
{
    [self buildWithData:[NSDictionary dictionaryWithObjectsAndKeys:username_, usernameAttr, uid_, uidAttr, nil]];
}

+ (void) startAuthenticationWithUsername:(NSString*)username andPassword:(NSString*)password
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[App loginPath]]];
    [request setTimeOutSeconds:20];

    [request setPostValue:username forKey:@"pollster[username]"];
    [request setPostValue:password	forKey:@"pollster[password]"];
    [request setUseCookiePersistence:NO];
    [request startSynchronous];
    if ([request responseStatusCode] == 200) {
        [self buildWithData:[[request responseString] JSONValue]];
    }
    
}

+ (BOOL) exists {
    return current != NULL;
}

+ (Session*) getCurrent {
    return current;
}

+ (void) clear
{
    current = NULL;
}

+ (void) restoreLast
{
    current = [NSKeyedUnarchiver unarchiveObjectWithFile:archiveName];
}

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.username forKey:usernameAttr];
    [encoder encodeObject:self.uid forKey:uidAttr];
}

- (id)initWithCoder:(NSKeyedUnarchiver *)decoder {
    self = [super init];
    
    self.username = [decoder decodeObjectForKey:usernameAttr];
    self.uid = [decoder decodeObjectForKey:uidAttr];
    return self;
}

@end
