//
//  FUVideoDecoder.h
//  FULiveDemo
//
//  Created by 孙慕 on 2019/12/20.
//  Copyright © 2019 FaceUnity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreVideo/CoreVideo.h>

NS_ASSUME_NONNULL_BEGIN


typedef void(^videoDecoderCallBack)(CVPixelBufferRef pixelBuffer);


@interface FUVideoDecoder : NSObject

///  初始化
/// @param url 视频URL
/// @param fps 回调的帧率
/// @param repeat 是否重复播放
/// @param callback 回调
-(instancetype)initWithVideoDecodeUrl:(NSURL *)url fps:(int)fps repeat:(BOOL)repeat callback:(videoDecoderCallBack)callback;

/* 开始解码 */
-(void)videoStartReading;

/* 结束解码，注意 解码需要调用该函数，类对象才会销毁 */
-(void)videoStopRending;

-(void)setupVideoDecoder:(NSURL *)url;

/* 继续 */
-(void)continueReading;
@end

NS_ASSUME_NONNULL_END
