//
//  FUVideoProcessor.h
//  FUVideoComponent
//
//  Created by 项林平 on 2022/5/27.
//

#import <AVFoundation/AVFoundation.h>
#import "FUVideoSettings.h"
#import "FUVideoReader.h"
#import "FUVideoWriter.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUVideoProcessor : NSObject

/// 视频帧编码前处理，不设置则直接编码
@property (nonatomic, copy) CVPixelBufferRef (^processingVideoBufferHandler)(CVPixelBufferRef videoPixelBuffer, CGFloat time);

/// 音频帧编码前处理，不设置则直接编码
@property (nonatomic, copy) CMSampleBufferRef (^processingAudioBufferHandler)(CMSampleBufferRef audioSampleBuffer);

/// 处理流程完成
@property (nonatomic, copy) void (^processingFinishedHandler)(void);

@property (nonatomic, strong, readonly) FUVideoReader *reader;

@property (nonatomic, strong, readonly) FUVideoWriter *writer;

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)init NS_UNAVAILABLE;


- (instancetype)initWithReadingURL:(NSURL *)readingURL
                        writingURL:(NSURL *)writingURL;

/// 初始化方法
/// @param readingURL 解码视频URL
/// @param readerSettings 解码设置，nil时使用默认设置
/// @param writingURL 编码视频URL
/// @param writerSettings 编码设置，nil时使用默认设置
- (instancetype)initWithReadingURL:(NSURL *)readingURL
                    readerSettings:(nullable FUVideoReaderSettings *)readerSettings
                        writingURL:(NSURL *)writingURL
                    writerSettings:(nullable FUVideoWriterSettings *)writerSettings;

- (void)startProcessing;

/// 内部会销毁解码器和编码器
- (void)cancelProcessing;

@end

NS_ASSUME_NONNULL_END
