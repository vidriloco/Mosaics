//
//  SoundPlayerPool.m
//  QuantusActive
//
//  Created by Workstation on 3/19/12.
//  Copyright (c) 2012 Quantus. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "SoundPlayerPool.h"

static const NSUInteger     kPlayersPerPool = 3;
static const NSTimeInterval kInactivePoolLifetime = 7 * 60; // 7 minutes

@interface SoundPlayerPool()
{
    NSMutableDictionary *pools;
    NSMutableDictionary *timers;
}
@end

static SoundPlayerPool *sharedInstance = nil;

@implementation SoundPlayerPool

+ (SoundPlayerPool *)sharedInstance {
    if (nil != sharedInstance) {
        return sharedInstance;
    }
    
    static dispatch_once_t pred;        // Lock
    dispatch_once(&pred, ^{             // This code is called at most once per app
        sharedInstance = [[SoundPlayerPool alloc] init];
    });
    
    return sharedInstance;
}

- (id)init
{
    if ((self = [super init])) {
        // Init
        pools  = [NSMutableDictionary dictionary];
        timers = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

+ (void)setTimer:(NSString *)fileName
{
    id timer = [[self sharedInstance]->timers objectForKey:fileName];
    if (timer)
        [timer invalidate];
    
    [[self sharedInstance]->timers setObject:[NSTimer scheduledTimerWithTimeInterval:kInactivePoolLifetime target:self selector:@selector(deletePool:) userInfo:fileName repeats:NO] forKey:fileName];
//    NSLog(@"Pool for %@ will be freed in %f seconds.", fileName, kInactivePoolLifetime);
}

+ (void)deletePool:(NSTimer *)timer
{
    NSString *fileName = [timer userInfo];
    id pool = [[self sharedInstance]->pools objectForKey:fileName];
    if (pool)
        [[self sharedInstance]->pools removeObjectForKey:fileName];
    
    [[self sharedInstance]->timers removeObjectForKey:fileName];
//    NSLog(@"Pool for %@ was freed.", fileName);
}

+ (void)preparePoolFor:(NSString *)fileName play:(BOOL)play
{
    if ([[self sharedInstance]->pools objectForKey:fileName])
        return;

    NSData *sampleData = [NSData dataWithContentsOfFile:[NSString stringWithFormat:[@"%@/" stringByAppendingString:fileName],
                                                         [[NSBundle mainBundle] resourcePath]]];
    
    NSMutableArray *players = [NSMutableArray array];
    for (int i = 0; i < kPlayersPerPool; ++i) {
        NSError *error;
        AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithData:sampleData error:&error];
        if (play && i < 1)
            [audioPlayer play]; // Lagtastic!
        else
            [audioPlayer performSelectorInBackground:@selector(prepareToPlay) withObject:nil];
        [players addObject:audioPlayer];
    }
    [[self sharedInstance]->pools setObject:players forKey:fileName];
}

+ (BOOL)playFile:(NSString *)fileName
{
    NSMutableArray *pool = [[self sharedInstance]->pools objectForKey:fileName];
    if (!pool)
        [self preparePoolFor:fileName play:YES];
 
    // Check for available players
    for (AVAudioPlayer *player in pool) {
        if (![player isPlaying]) {
            [player play];
            [self setTimer:fileName];
            return YES;
        }
    }

    // Grab the first one if no available ones are found and forcibly play
    AVAudioPlayer *player = [pool objectAtIndex:0];
    [player pause];
    player.currentTime = 0.0;
    [player play];
    [self setTimer:fileName];

    return YES;
}

@end
