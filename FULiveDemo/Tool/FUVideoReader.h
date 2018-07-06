//
//  FUVideoReader.h
//  AVAssetReader2
//
//  Created by L on 2018/6/13.
//  Copyright © 2018年 千山暮雪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol FUVideoReaderDelegate <NSObject>

@optional

//- (void)videoReaderDidReadAudioBuffer:(CMSampleBufferRef)sampleBuffer ;

- (void)videoReaderDidReadVideoBuffer:(CVPixelBufferRef)pixelBuffer;

- (void)videoReaderDidFinishReadSuccess:(BOOL)success ;
@end

@interface FUVideoReader : NSObject

@property (nonatomic, assign) id<FUVideoReaderDelegate>delegate ;

@property (nonatomic, strong) NSURL *videoURL ;

// 只读 第一帧
- (void)startReadForFirstFrame ;
// 只读 最后一帧
- (void)startReadForLastFrame ;

// 读写
- (void)startReadWithDestinationPath:(NSString *)destinationPath ;

// 停止
- (void)stopReading ;
@end
