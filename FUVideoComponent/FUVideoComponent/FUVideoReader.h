//
//  FUVideoReader.h
//  FUVideoComponent
//
//  Created by 项林平 on 2022/5/9.
//

#import <AVFoundation/AVFoundation.h>

#import "FUVideoComponentDefines.h"
#import "FUVideoSettings.h"

@class FUVideoWriter;

NS_ASSUME_NONNULL_BEGIN

@protocol FUVideoReaderDelegate <NSObject>

@optional

/// 视频帧输出，注意及时释放videoSampleBuffer
- (void)videoReaderDidOutputVideoSampleBuffer:(CMSampleBufferRef)videoSampleBuffer;

/// 音频帧输出，注意及时释放audioSampleBuffer
- (void)videoReaderDidOutputAudioSampleBuffer:(CMSampleBufferRef)audioSampleBuffer;

/// 视频解码完成
- (void)videoReaderDidFinishVideoReading;

/// 音频解码完成
- (void)videoReaderDidFinishAudioReading;

/// 解码完成
- (void)videoReaderDidFinishReading;

@end

@interface FUVideoReader : NSObject

/// 是否正在解码
@property (nonatomic, assign, readonly) BOOL isReading;
/// 视频尺寸
@property (nonatomic, assign, readonly) CGSize videoSize;
/// 视频方向
@property (nonatomic, assign, readonly) FUVideoOrientation videoOrientation;
/// 当前视频是否包含音频轨道
@property (nonatomic, assign, readonly) BOOL containAudioTrack;

@property (nonatomic, weak) id<FUVideoReaderDelegate> delegate;

@property (nonatomic, strong) FUVideoReaderSettings *readerSettings;

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithURL:(NSURL *)URL;

- (instancetype)initWithURL:(NSURL *)URL settings:(nullable FUVideoReaderSettings *)settings;

- (instancetype)initWithAsset:(AVAsset *)asset;

- (instancetype)initWithAsset:(AVAsset *)asset settings:(nullable FUVideoReaderSettings *)settings;

/// 开始解码
/// @param automatic 是否自动完整解码，如果为NO，可以调用readNextVideoBuffer和readNextAudioBuffer方法手动逐帧解码
- (void)start:(BOOL)automatic;

- (void)cancel;

- (BOOL)readNextVideoBuffer;

- (BOOL)readNextAudioBuffer;

/// 获取第一个视频帧，需要在解码开始之后调用
- (CMSampleBufferRef)firstVideoSampleBuffer;

/// 获取最后一个视频帧，需要在解码完成之后调用
- (CMSampleBufferRef)lastVideoSampleBuffer;

@end

NS_ASSUME_NONNULL_END
