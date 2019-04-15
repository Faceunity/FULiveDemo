//
//  FUVolumeObserver.h
//  FULiveDemo
//
//  Created by 孙慕 on 2018/10/22.
//  Copyright © 2018年 L. All rights reserved.
//
//  音量按钮劫持
#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>

@class FUVolumeObserver;

@protocol FUVolumeObserverProtocol <NSObject>

- (void)volumeButtonDidUp:(FUVolumeObserver *)button;
- (void)volumeButtonDidDown:(FUVolumeObserver *)button;

@end


@interface FUVolumeObserver : NSObject
@property (nonatomic, assign) id<FUVolumeObserverProtocol> delegate;

+ (FUVolumeObserver*) sharedInstance;
- (void)startObserveVolumeChangeEvents;
- (void)stopObserveVolumeChangeEvents;

@end

