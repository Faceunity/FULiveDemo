//
//  FUVideoWriter.h
//  FUVideoComponent
//
//  Created by 项林平 on 2022/5/9.
//

#import <AVFoundation/AVFoundation.h>

#import "FUVideoComponentDefines.h"
#import "FUVideoSettings.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUVideoWriter : NSObject

@property (nonatomic, assign, readonly) BOOL isWriting;
@property (nonatomic, strong, readonly) NSURL *videoURL;
@property (nonatomic, strong, readonly) AVAssetWriterInput *videoInput;
@property (nonatomic, strong, readonly) AVAssetWriterInput *audioInput;
/// 视频数据允许写入回调，star()方法调用前赋值
@property (nonatomic, copy) BOOL (^videoInputReadyHandler)(void);
/// 音频数据允许写入回调，start()方法调用前赋值
@property (nonatomic, copy) BOOL (^audioInputReadyHandler)(void);

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithVideoURL:(NSURL *)URL
                       videoSize:(CGSize)size;

/// 初始化方法
/// @param URL 文件保存路径（如果已经存在文件，会先删除原文件）
/// @param size 视频尺寸
/// @param settings 编码设置，nil时会使用默认设置
- (instancetype)initWithVideoURL:(NSURL *)URL
                       videoSize:(CGSize)size
                         setting:(nullable FUVideoWriterSettings *)settings;

- (void)start;

- (void)stop;

/// 写入完成后必须调用该方法
- (void)finishWritingWithCompletion:(nullable void (^)(void))completion;

- (void)appendVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer;

- (void)appendPixelBuffer:(CVPixelBufferRef)pixelBuffer time:(CMTime)timeStamp;

- (void)appendAudioSampleBuffer:(CMSampleBufferRef)sampleBuffer;

@end

NS_ASSUME_NONNULL_END
