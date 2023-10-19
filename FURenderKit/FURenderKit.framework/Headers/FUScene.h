//
//  FUScene.h
//  FUAvatarSDK
//
//  Created by ly-Mac on 2020/11/16.
//

#import <Foundation/Foundation.h>
#import "FUBackground.h"
#import "FUCustomBackground.h"
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
@property (nonatomic, copy, readonly) NSString *controllerConfigPath;

/// 背景道具
@property (nonatomic, strong) FUBackground *background;

/// 背景颜色，如果设置了背景颜色，背景道具自动失效
@property (nonatomic, strong) UIColor *backgroundColor;

/// 机位道具
@property (nonatomic, strong) FUSceneCamera *sceneCamera;

/// 是否使用 orthogonal projection, 默认为 perspective projection
@property (nonatomic, assign) BOOL enableOrthogonalProjection;

@property (nonatomic, assign) float renderFov;

@property (nonatomic, assign) float renderOrthSize;

@property (nonatomic, assign) double znear;

@property (nonatomic, assign) double zfar;

/// 光照道具
@property (nonatomic, strong) FULight *light;

@property (nonatomic, assign) BOOL enableLowQualityLighting;

@property (nonatomic, assign) BOOL enableBloom;

/// 阴影开关
@property (nonatomic, assign) BOOL enableShadow;

@property (nonatomic, assign) BOOL enableRenderCameraImage;

@property (nonatomic, copy, readonly) NSArray<FUAvatar *> *avatars;

- (FUScene *)initWithControllerConfigPath:(NSString *)controllerConfigPath;

- (FUScene *)initWithControllerConfigPath:(NSString *)controllerConfigPath litemListJson:(NSString *)litemListJson;

#pragma mark - Avatar

- (BOOL)addAvatar:(FUAvatar *)avatar;

- (void)addAvatar:(FUAvatar *)avatar completion:(void(^)(BOOL result))completion;

- (void)removeAvatar:(FUAvatar *)avatar;

- (void)removeAvatar:(FUAvatar *)avatar completion:(void(^)(void))completion;

- (BOOL)replaceAvatar:(FUAvatar *)avatar withNewAvatar:(FUAvatar *)newAvatar;

- (void)replaceAvatar:(FUAvatar *)avatar withNewAvatar:(FUAvatar *)newAvatar compoletion:(void(^)(BOOL result))completion;

@end

@interface FUScene (AIConfig)

@property (nonatomic, strong, readonly) FUAIConfig *AIConfig;

@end

@interface FUScene (Animation)

@property (nonatomic, assign) BOOL enableCustomAnimationTime;

@property (nonatomic, assign) float customAnimationTime;

@property (nonatomic, assign) BOOL pauseSystemTimeUpdate;

@property (nonatomic, assign) BOOL enableCameraAnimation;

@property (nonatomic, assign) BOOL enableCameraAnimationLerp;

/// 相机动画列表
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

- (void)pauseCurrentCameraAnimation;

- (void)resumeCurrentCameraAnimation;

- (void)resetCurrentCameraAnimation;

- (float)getProgressForCameraAnimation:(FUCameraAnimation *)cameraAnimation;

- (float)getCurrentCameraAnimationTransitionProgress;

- (int)getFrameNumberForCameraAnimation:(FUCameraAnimation *)cameraAnimation;

@end

@interface FUScene (DynamicBone)

@property (nonatomic, assign) BOOL enableDynamicbone;

@end

@interface FUScene (Reflection)

/// 是否开启倒影（默认为 YES）
@property (nonatomic, assign) BOOL enableReflection;

/// 设置倒影参数
/// @param transparency 倒影透明度 （0～1）
/// @param distance 倒影显示距离
/// （说明：倒影显示距离与倒影透明度的设置要合理搭配才能出来比较好的效果，两者呈正相关的关系）
- (BOOL)reflectionWithTransparency:(float)transparency distance:(float)distance;

@end

NS_ASSUME_NONNULL_END
