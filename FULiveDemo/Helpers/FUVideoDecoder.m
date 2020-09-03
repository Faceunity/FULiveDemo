//
//  FUVideoDecoder.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/12/20.
//  Copyright © 2019 FaceUnity. All rights reserved.
//

#import "FUVideoDecoder.h"
#import <AVFoundation/AVFoundation.h>

@interface FUVideoDecoder(){
    BOOL _isRun;
    BOOL _isRepeat;
    int  _fps;
}

@property (nonatomic, strong) AVAssetReader *assetReader;
@property (nonatomic, strong) AVAssetTrack *videoTrack;
@property (nonatomic, strong) AVAssetReaderTrackOutput* videoReaderOutput;
@property (nonatomic, strong) NSURL *mUrl;
@property (nonatomic, copy) videoDecoderCallBack videoCallBack;

@end

@implementation FUVideoDecoder

-(instancetype)initWithVideoDecodeUrl:(NSURL *)url fps:(int)fps repeat:(BOOL)repeat callback:(videoDecoderCallBack)callback{
    if (self = [super init]) {
        if (!url) {
            NSLog(@"url is nil");
        }
        _videoCallBack = callback;
        _isRepeat = repeat;
        _mUrl  = url;
        _fps = fps;
    }
    return self;
}



-(void)setupVideoDecoder:(NSURL *)url{
    AVAsset *asset = [AVAsset assetWithURL:url];
    NSError *error;
    _assetReader = [[AVAssetReader alloc] initWithAsset:asset error:&error];
    NSLog(@"error = %@", error);
    
    NSArray *videoTracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    _videoTrack = videoTracks[0];
    
    // 视频播放时，m_pixelFormatType = kCVPixelFormatType_32BGRA
    NSDictionary* options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:
                                                                (int)kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    _videoReaderOutput = [[AVAssetReaderTrackOutput alloc]
                          initWithTrack:_videoTrack outputSettings:options];
    
    
    [_assetReader addOutput:_videoReaderOutput];
    [_assetReader startReading];
}



-(void)runVideoDecoder{
    while (_videoTrack.nominalFrameRate > 0 && _isRun) {
        @autoreleasepool {
            if (_assetReader.status == AVAssetReaderStatusReading) {
                
                // 读取video sample
                CMSampleBufferRef videoBuffer = [_videoReaderOutput copyNextSampleBuffer];
                
                CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(videoBuffer);
                if (_videoCallBack) {
                    _videoCallBack(pixelBuffer);
                }
                
                if (videoBuffer) {
                    CMSampleBufferInvalidate(videoBuffer);
                    CFRelease(videoBuffer);
                }
                // 根据需要休眠一段时间；比如上层播放视频时每帧之间是有间隔的
                [NSThread sleepForTimeInterval: 1.0 / _fps];
            }else if ([_assetReader status] == AVAssetReaderStatusCompleted) {
                if (_isRepeat) {
                    [self setupVideoDecoder:_mUrl];
                }else{
                    _isRun = NO;
                }
                
            }
            
        }
        
    }
}


-(void)videoStartReading{
    if (_isRun) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        _isRun = YES;
        [self setupVideoDecoder:_mUrl];
        [self runVideoDecoder];
    });
}

-(void)videoStopRending{
    _isRun = NO;
    [_assetReader cancelReading];
    _assetReader = nil;

}


- (void)dealloc
{
    NSLog(@"video  dealloc");
}


@end
