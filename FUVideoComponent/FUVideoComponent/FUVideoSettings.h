//
//  FUVideoSettings.h
//  FUVideoComponent
//
//  Created by 项林平 on 2022/5/27.
//

#import <AVFoundation/AVFoundation.h>
#import "FUVideoComponentDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUVideoReaderSettings : NSObject

/// 是否自动解码，默认为NO
/// @note 如果为NO，可以调用FUVideoReader实例的readNextVideoBuffer和readNextAudioBuffer方法逐帧读取
@property (nonatomic, assign) BOOL readingAutomatically;

/// 是否需要音频轨道，默认为YES
@property (nonatomic, assign) BOOL needsAudioTrack;

/// 以视频真实码率或者以默认速度解码，默认为YES（视频真实码率）
@property (nonatomic, assign) BOOL readAtVideoRate;

/// 是否需要循环解码，默认为NO
@property (nonatomic, assign) BOOL needsRepeat;

/// 视频解码格式，默认为kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
@property (nonatomic) OSType videoOutputFormat;

/// 音频解码格式，默认为kAudioFormatLinearPCM (最高保真度)
@property (nonatomic) AudioFormatID audioOutputFormat;

/// 恢复默认设置
- (void)resetToDefault;

@end

@interface FUVideoWriterSettings : NSObject

/// 是否需要音频轨道，默认为YES
@property (nonatomic, assign) BOOL needsAudioTrack;

/// 文件格式，默认为AVFileTypeQuickTimeMovie
@property (nonatomic, copy) AVFileType fileType;

/// 是否实时数据源，默认为NO
@property (nonatomic, assign) BOOL isRealTimeData;

/// 视频方向，默认为FUVideoOrientationPortrait
@property (nonatomic, assign) FUVideoOrientation videoOrientation;

/// 视频编码格式，默认为AVVideoCodecH264
@property (nonatomic, copy) AVVideoCodecType videoInputFormat;

/// 音频编码格式，默认为kAudioFormatMPEG4AAC
@property (nonatomic) AudioFormatID audioInputFormat;

/// 音频声道数量，默认为2
@property (nonatomic, assign) NSInteger audioChannels;

/// 音频码率，默认为当前硬件码率
@property (nonatomic) double audioRate;

/// 恢复默认设置
- (void)resetToDefault;

@end

NS_ASSUME_NONNULL_END
