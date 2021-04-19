//
//  FUScene.h
//  FUAvatarSDK
//
//  Created by ly-Mac on 2020/11/16.
//

#import <Foundation/Foundation.h>
#import "FUBackground.h"
#import "FULight.h"
#import "FUSceneCamera.h"
#import "FUAvatar.h"
#import "FUCameraAnimation.h"
#import "FUAIConfig.h"
#import "FURenderableObject.h"

@class FUScene;

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    FUProjectionModePerspective,
    FUProjectionModeParallel,
} FUProjectionMode;

@protocol FUSceneDelegate <NSObject>

- (void)scene:(FUScene *)scene AIConfigDidUpdate:(FUAIConfig *)AIConfig;

@end


@interface FUScene : FURenderableObject

@property (nonatomic, weak) id<FUSceneDelegate> delegate;

/// controller_config.bundle 文件路径，默认为 FURenderKit 初始化时设置的 controller_config 路径，用户可以通过修改该参数修改该路径。
@property (nonatomic, copy) NSString *controllerConfigPath;

/// 背景道具
@property (nonatomic, strong) FUBackground *background;

/// 背景颜色，如果设置了背景颜色，背景道具自动失效
@property (nonatomic, strong) UIColor *backgroundColor;

/// 机位道具
@property (nonatomic, strong) FUSceneCamera *sceneCamera;

/// 投影模式，支持两种模式：1、透视投影（FUProjectionModePerspective）；2、平行投影（FUProjectionModeParallel）
@property (nonatomic, assign) FUProjectionMode projectMode;

@property (nonatomic, assign) double renderFov;

@property (nonatomic, assign) double renderOrthSize;

@property (nonatomic, assign) double znear;

@property (nonatomic, assign) double zfar;

/// 光照道具
@property (nonatomic, strong) FULight *light;

/// 阴影开关
@property (nonatomic, assign) BOOL enableShadow;

@property (nonatomic, assign) double shadowMapSize;

@property (nonatomic, assign) double shadowPcfLevel;

@property (nonatomic, assign) FUShadowBias shadowBias;

@property (nonatomic, assign) BOOL enableExpressionBlend;

@property (nonatomic, copy, readonly) NSArray<FUAvatar *> *avatars;

- (void)unload;

- (void)addAvatar:(FUAvatar *)avatar;

- (BOOL)replaceAvatar:(FUAvatar *)avatar withNewAvatar:(FUAvatar*)newAvatar;

- (void)removeAvatar:(FUAvatar *)avatar;

@end

@interface FUScene (AIConfig)

@property (nonatomic, strong, readonly) FUAIConfig *AIConfig;

@end

@interface FUScene (Animation)

@property (nonatomic, assign) BOOL enableCustomAnimationTime;

@property (nonatomic, assign) double customAnimationTime;

@property (nonatomic, assign) BOOL enableCameraAnimation;

///// 相机动画列表
@property (nonatomic, copy, readonly) NSArray<FUCameraAnimation *> *cameraAnimations;
/// 当前正在播放的相机动画
@property (nonatomic, strong, readonly) FUCameraAnimation *currentCameraAnimation;

/// 添加动画，如果相机动画的 name 不为空，可以通过 name 查找或移除相机动画
/// @param cameraAnimation 动画
- (void)addCameraAnimation:(FUCameraAnimation *)cameraAnimation;

/// 通过动画名称查找相机动画
/// @param cameraAnimationName 相机动画名称
- (FUCameraAnimation *)cameraAnimationForName:(NSString *)cameraAnimationName;

/// 移除相机动画
/// @param cameraAnimation 相机动画
- (void)removeCameraAnimation:(FUCameraAnimation *)cameraAnimation;

/// 通过名称移除相机动画
/// @param cameraAnimationName 相机动画名称
- (void)removeCameraAnimationWithName:(NSString *)cameraAnimationName;

/// 播放相机动画
/// @param cameraAnimation 相机动画
/// @param playOnce YES 只播放一次，NO 循环播放
/// @param transitionDuration 相机动画过度时间
- (void)playCameraAnimation:(nullable FUCameraAnimation *)cameraAnimation playOnce:(BOOL)playOnce transitionDuration:(float)transitionDuration;

/// 通过名称播放相机动画
/// @param cameraAnimationName 相机动画名称
/// @param playOnce YES 只播放一次，NO 循环播放
/// @param transitionDuration 相机动画过度时间
- (void)playCameraAnimationWithName:(NSString *)cameraAnimationName playOnce:(BOOL)playOnce transitionDuration:(float)transitionDuration;

- (void)setCurrentCameraAnimationUseProgress:(BOOL)useProgress;

- (void)setCurrentCameraAnimationProgress:(double)progress;

- (void)letCurrentCameraAnimationUseTransitionProgress:(BOOL)useTransitionProgress;

- (void)setCurrentCameraAnimationTransitionProgress:(double)transitionProgress;

- (void)logCurrentCameraAnimationStatus;

- (void)pauseCurrentCameraAnimation;

- (void)resumeCurrentCameraAnimation;

- (void)stopCurrentCameraAnimation;

- (void)resetCurrentCameraAnimation;

- (double)getProgressForCameraAnimation:(FUCameraAnimation *)cameraAnimation;

- (double)getTransitionProgressForCameraAnimation:(FUCameraAnimation *)cameraAnimation;

- (int)getFrameNumberForCameraAnimation:(FUCameraAnimation *)cameraAnimation;

@end

NS_ASSUME_NONNULL_END
