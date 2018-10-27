//
//  FUVolumeObserver.m
//  FULiveDemo
//
//  Created by 孙慕 on 2018/10/22.
//  Copyright © 2018年 L. All rights reserved.
//
//  音量按钮劫持

#import "FUVolumeObserver.h"
#import <AVFoundation/AVFoundation.h>

@interface FUVolumeObserver()
{
    UIView *_volumeView;
    float launchVolume;
    BOOL isObserving;
}
@end

@implementation FUVolumeObserver

+ (FUVolumeObserver*) sharedInstance;
{
    static FUVolumeObserver *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[FUVolumeObserver alloc] init];
    });
    
    return instance;
}

- (id) init
{
    self = [super init];
    if( self ){
        isObserving = NO;
        CGRect frame = CGRectMake(0, -100, 0, 0);
        _volumeView = [[MPVolumeView alloc] initWithFrame:frame];
        [[UIApplication sharedApplication].windows[0] addSubview:_volumeView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(suspendObserveVolumeChangeEvents:)name:UIApplicationWillResignActiveNotification     // -> Inactive
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(resumeObserveVolumeButtonEvents:)name:UIApplicationDidBecomeActiveNotification      // <- Active
                                                   object:nil];
        
    }
    return self;
}

- (void) startObserveVolumeChangeEvents{
    [[UIApplication sharedApplication].windows[0] addSubview:_volumeView];
    double delayInSeconds = 0.25;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self startObserve];
    });
}

- (void) startObserve
{
    if (isObserving) {
        return;
    }
    
    isObserving = YES;
    AudioSessionInitialize(NULL, NULL, NULL, NULL);
    SInt32  process = kAudioSessionCategory_AmbientSound;
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(process), &process);
    AudioSessionSetActive(YES);
    
//    launchVolume = [[MPMusicPlayerController applicationMusicPlayer] volume];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    launchVolume = audioSession.outputVolume;
    launchVolume = launchVolume == 0 ? 0.05 : launchVolume;
    launchVolume = launchVolume == 1 ? 0.95 : launchVolume;
    if (launchVolume == 0.05 || launchVolume == 0.95) {
        [[MPMusicPlayerController applicationMusicPlayer] setVolume:launchVolume];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChangeNotification:) name:@"SystemVolumeDidChange" object:nil];
    
}

- (void) volumeChangeNotification:(NSNotification *) no
{
    static id sender = nil;
    if (sender == nil && no.object) {
        sender = no.object;
    }
    
    if (no.object != sender || [[no.userInfo objectForKey:@"AudioVolume"] floatValue] == launchVolume) {
        return;
    }
    if(!_delegate) return;
    
    if ([[no.userInfo objectForKey:@"AudioVolume"] floatValue] > launchVolume) {
        if ([_delegate respondsToSelector:@selector(volumeButtonDidUp:)]) {
            [_delegate volumeButtonDidUp:self];
        }
    } else if ([[no.userInfo objectForKey:@"AudioVolume"] floatValue] < launchVolume) {
        if ([_delegate respondsToSelector:@selector(volumeButtonDidDown:)]) {
            [_delegate volumeButtonDidDown:self];
        }
    }
    
    [[MPMusicPlayerController applicationMusicPlayer] setVolume:launchVolume];
}


- (void) suspendObserveVolumeChangeEvents:(NSNotification *)notification
{
    [self stopObserveVolumeChangeEvents];
}

- (void) resumeObserveVolumeButtonEvents:(NSNotification *)notification
{
    [self startObserveVolumeChangeEvents];
}

- (void) stopObserveVolumeChangeEvents
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SystemVolumeDidChange" object:nil];
    
    AudioSessionRemovePropertyListenerWithUserData(kAudioSessionProperty_CurrentHardwareOutputVolume, NULL, (__bridge void *)(self));
    AudioSessionSetActive(NO);
    [_volumeView removeFromSuperview];
    isObserving = NO;
}

@end
