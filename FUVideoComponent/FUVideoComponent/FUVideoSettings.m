//
//  FUVideoSettings.m
//  FUVideoComponent
//
//  Created by 项林平 on 2022/5/27.
//

#import "FUVideoSettings.h"

@implementation FUVideoReaderSettings

- (instancetype)init {
    self = [super init];
    if (self) {
        [self resetToDefault];
    }
    return self;
}

- (void)resetToDefault {
    self.needsAudioTrack = YES;
    self.readAtVideoRate = YES;
    self.needsRepeat = NO;
    self.videoOutputFormat = kCVPixelFormatType_420YpCbCr8BiPlanarFullRange;
    self.audioOutputFormat = kAudioFormatLinearPCM;
}

@end


@implementation FUVideoWriterSettings

- (instancetype)init {
    self = [super init];
    if (self) {
        [self resetToDefault];
    }
    return self;
}

- (void)resetToDefault {
    self.needsAudioTrack = YES;
    self.fileType = AVFileTypeQuickTimeMovie;
    self.isRealTimeData = NO;
    self.videoOrientation = FUVideoOrientationPortrait;
    self.videoInputFormat = AVVideoCodecH264;
    self.audioInputFormat = kAudioFormatMPEG4AAC;
    self.audioChannels = 2;
    self.audioRate = [AVAudioSession sharedInstance].sampleRate;
}

@end
