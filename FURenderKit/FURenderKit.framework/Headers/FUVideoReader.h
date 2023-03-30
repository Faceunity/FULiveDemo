//
//  FUVideoReader.h
//  FUVideoComponent
//
//  Created by 项林平 on 2022/5/9.
//

#import <AVFoundation/AVFoundation.h>

#import "FUVideoComponentDefines.h"
#import "FUVideoSettings.h"

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
/// 视频时长，单位秒
@property (nonatomic, assign, readonly) CGFloat duration;

@property (nonatomic, weak) id<FUVideoReaderDelegate> delegate;

@property (nonatomic, strong) FUVideoReaderSettings *readerSettings;

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithURL:(NSURL *)URL;

- (instancetype)initWithURL:(NSURL *)URL settings:(nullable FUVideoReaderSettings *)settings;

- (instancetype)initWithAsset:(AVAsset *)asset;

- (instancetype)initWithAsset:(AVAsset *)asset settings:(nullable FUVideoReaderSettings *)settings;

/// 开始解码
/// @note 内部自动解码为异步
- (void)start;

/// 停止解码
- (void)stop;

- (BOOL)readNextVideoBuffer;

- (BOOL)readNextAudioBuffer;

@end

NS_ASSUME_NONNULL_END
