//
//  FUVideoReader.h
//  AVAssetReader2
//
//  Created by L on 2018/6/13.
//  Copyright © 2018年 千山暮雪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger, FUVideoReaderOrientation) {
        FUVideoReaderOrientationPortrait           = 0,
        FUVideoReaderOrientationLandscapeRight     = 1,
        FUVideoReaderOrientationUpsideDown         = 2,
        FUVideoReaderOrientationLandscapeLeft      = 3,
};

@protocol FUVideoReaderDelegate <NSObject>

@optional

// 每一帧视频数据
- (CVPixelBufferRef)videoReaderDidReadVideoBuffer:(CVPixelBufferRef)pixelBuffer;

// 读写视频完成
- (void)videoReaderDidFinishReadSuccess:(BOOL)success ;
@end

@interface FUVideoReader : NSObject

@property (nonatomic, assign) id<FUVideoReaderDelegate>delegate ;

@property (nonatomic, strong) NSURL *videoURL ;
// 视频朝向
@property (nonatomic, assign, readonly) FUVideoReaderOrientation videoOrientation ;

- (instancetype)initWithVideoURL:(NSURL *)videoRUL;

// 只读 第一帧
- (void)startReadForFirstFrame ;
// 只读 最后一帧
- (void)startReadForLastFrame ;

// 读写整个视频
- (void)startReadWithDestinationPath:(NSString *)destinationPath ;
// 停止
- (void)stopReading ;
/* 继续 */
-(void)continueReading;
// 销毁
- (void)destory ;
@end
