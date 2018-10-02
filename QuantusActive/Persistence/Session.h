//
//  Session.h
//  PersistenceGroup
//
//  Created by Alejandro on 3/15/12.
//  Copyright (c) 2012 Quantus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Session : NSObject<NSCoding> {
}

@property (nonatomic, strong) NSString* username;
@property (nonatomic, strong) NSString* uid;

+ (void) buildWithData:(NSDictionary*)userData;
+ (void) buildWithUsername:(NSString*)username_ andUID:(NSString*)uid_;
+ (void) startAuthenticationWithUsername:(NSString*)username andPassword:(NSString*)password;
+ (Session*) getCurrent;
+ (BOOL) exists;
+ (void) clear;
+ (void) restoreLast;

- (id) initWithUserData:(NSDictionary *)dictionary;



@end
