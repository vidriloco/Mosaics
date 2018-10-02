//
//  SoundPlayerPool.h
//  QuantusActive
//
//  Created by Workstation on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoundPlayerPool : NSObject

+ (SoundPlayerPool *)sharedInstance;
+ (BOOL)playFile:(NSString *)fileName;
+ (void)preparePoolFor:(NSString *)fileName play:(BOOL)play;

@end
