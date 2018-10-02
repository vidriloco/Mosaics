//
//  AppConfig.h
//  QuantusActive
//
//  Created by Alejandro on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum { Development, Production , Test } Mode;
@interface App : NSObject

+ (NSString *)backendURL;
+ (NSString *)commitPath;
+ (NSString *)loginPath;

+ (void) setEnvironmentMode:(Mode)mode;

+ (BOOL) isRunningOn:(Mode)mode;

@end
