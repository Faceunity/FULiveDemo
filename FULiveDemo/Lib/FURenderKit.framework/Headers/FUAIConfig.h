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

@property (nonatomic, assign) BOOL followBody;

@property (nonatomic, assign) double followFov;

@property (nonatomic, assign) double fullBodyScale;

@property (nonatomic, assign) double halfBodyScale;

@property (nonatomic, assign) CGPoint bodyOffset;

@property (nonatomic, assign, readonly) FUBodyTrackStatus bodyTrackStatus;

@property (nonatomic, assign, readonly) FUGestureID gestureID;

@end
