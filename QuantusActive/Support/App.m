//
//  AppConfig.m
//  QuantusActive
//
//  Created by Alejandro on 4/26/12.
//  Copyright (c) 2012 Quantus. All rights reserved.
//

#import "App.h"

// TODO: Load configurations used in this file from Plist
@implementation App

static Mode environment;

+ (NSString*)backendURL
{
    return @"http://www.quantus-activ.com";
}

+ (NSString*)commitPath
{
    return [[App backendURL] stringByAppendingString:@"/api/collect.json"];
}

+ (NSString*)loginPath
{
    return [[App backendURL] stringByAppendingString:@"/api/authenticate.json"];
}

+ (void) setEnvironmentMode:(Mode)mode
{
    environment = mode;
}

+ (BOOL) isRunningOn:(Mode)mode 
{
    return environment == mode;
}


@end
