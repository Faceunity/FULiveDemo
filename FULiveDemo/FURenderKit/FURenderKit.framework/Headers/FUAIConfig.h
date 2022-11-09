//
//  FUAIConfig.h
//  FUAvatarSDK
//
//  Created by ly-Mac on 2020/11/20.
//

#import <Foundation/Foundation.h>
#import "FUConfig.h"
#import "FUStruct.h"

typedef enum : NSUInteger {
    FUBodyTrackModeHalf,
    FUBodyTrackModeFull,
} FUBodyTrackMode;

typedef enum : NSUInteger {
    FUBodyTrackStatusNoBody,
    FUBodyTrackStatusHalfLessBody,
    FUBodyTrackStatusHalfBody,
    FUBodyTrackStatusHalfMoreBody,
    FUBodyTrackStatusFullBody
} FUBodyTrackStatus;

@interface FUAIConfig : FUConfig

@end

@interface FUAIConfig (AR)

@property (nonatomic, assign) BOOL ARModeEnable;

@end

@interface FUAIConfig (FaceTrack)

@property (nonatomic, assign) BOOL faceTrackEnable;

@end

@interface FUAIConfig (BodyTrack)

@property (nonatomic, assign) BOOL bodyTrackEnable;

@property (nonatomic, assign) FUBodyTrackMode bodyTrackMode;

@property (nonatomic, assign) BOOL handDetector;

@end

@interface FUAIConfig (Avatar)

@property (nonatomic, assign) FUPosition avatarTranslationScale;

/// 抖动参数设置
- (void)setAvatarAnimFilter:(int)bufferFrames pos:(float)pos angle:(float)angle;

@end
