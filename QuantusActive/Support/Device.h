//
//  Device.h
//  QuantusActive
//
//  Created by Alejandro on 3/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@interface Device : NSObject

+ (NSString *)getMacAddress;

@end
