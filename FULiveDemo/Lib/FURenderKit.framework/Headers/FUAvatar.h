//
//  FUAvatar.h
//  FUAvatarSDK
//
//  Created by ly-Mac on 2020/11/16.
//

#import "FUItem.h"
#import "FUAnimation.h"
#import "FUStruct.h"
#import "FUFacepupKeys.h"
#import "FUDeformationKeys.h"
#import "FUAvatarColorKeys.h"
#import "FUAvatarMakeup.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUAvatar : FURenderableObject

@property (nonatomic, assign) FUPosition position;

@property (nonatomic, assign) BOOL visible;

@property (nonatomic, assign) double rotate;

/// 身体组件列表
@property (nonatomic, copy, readonly) NSArray<FUItem *> *components;

/// 当前正在播放的动画
@property (nonatomic, strong, readonly) FUAnimation *currentAnimation;

/// 动画列表
@property (nonatomic, copy, readonly) NSArray<FUAnimation *> *animations;

@property (nonatomic, assign) int faceTrackID;

// 阴影
@property (nonatomic, assign) double shadowPCFLevel;

@property (nonatomic, assign) int shadowSampleOffset;

- (void)updateTransformWithTranslateDelta:(float)translateDelta rotateDelta:(float)rotateDelta scaleDelta:(float)scaleDelta;

@end

@interface FUAvatar (Component)

/// 添加身体组件，如果组件的 name 不为空，可以通过 name 查找或移除组件；如果 avatar 已有组件存在与新组件名称一致的组件，已存在的组件将被替换。
/// @param component 身体组件
- (void)addComponent:(FUItem *)component;

- (BOOL)replaceComponent:(FUItem *)component withNewComponent:(FUItem *)newComponent;

- (BOOL)replaceComponentWithName:(NSString *)name newComponent:(FUItem *)newComponent;


/// 批量添加和移除接口，如果 avatar 已有组件与新组件数组中存在名称一致的组件，已存在的组件将被替换。
/// @param newComponents 新的组件数组
/// @param removeComponentNames 老组件名字数组
- (void)addNewComponents:(NSArray<FUItem *> *)newComponents withRemoveComponentNames:(NSArray<NSString *> *)removeComponentNames ;

/// 通过组件名称查找组件
/// @param componentName 组件名称
- (FUItem *)componentForName:(NSString *)componentName;

/// 移除身体组件
/// @param component 身体组件
- (void)removeComponent:(FUItem *)component;

/// 通过身体组件名称移除组件
/// @param componentName 组件名称
- (FUItem*)removeComponentWithName:(NSString *)componentName;

- (void)updateComponentsVisiableWithARMode:(BOOL)ARMode;

@end

@interface FUAvatar (Animation)

@property (nonatomic, assign) BOOL enableAnimationLerp;

/// 添加动画，如果动画的 name 不为空，可以通过 name 查找或移除动画
/// @param animation 动画
- (void)addAnimation:(FUAnimation *)animation;

/// 通过动画名称查找动画
/// @param animationName 动画名称
- (FUAnimation *)animationForName:(NSString *)animationName;

/// 移除动画
/// @param animation 动画
- (void)removeAnimation:(FUAnimation *)animation;

/// 通过名称移除动画
/// @param animationName 动画名称
- (void)removeAnimationWithName:(NSString *)animationName;

/// 移除所有动画
- (void)removeAllAnimations;

/// 播放动画
/// @param animation 动画
/// @param playOnce YES 只播放一次，NO 循环播放
/// @param transitionDuration 动画过度时间
- (void)playAnimation:(nullable FUAnimation *)animation playOnce:(BOOL)playOnce transitionDuration:(float)transitionDuration;

/// 通过名称播放动画
/// @param animationName 动画名称
/// @param playOnce YES 只播放一次，NO 循环播放
/// @param transitionDuration 动画过度时间
- (void)playAnimationWithName:(NSString *)animationName playOnce:(BOOL)playOnce transitionDuration:(float)transitionDuration;

- (void)pauseCurrentAnimation;

- (void)resumeCurrentAnimation;

- (void)stopCurrentAnimation;

- (void)resetCurrentAnimation;

- (double)getProgressForAnimation:(FUAnimation *)animation;

- (double)getTransitionProgressForAnimation:(FUAnimation *)animation;

- (int)getFrameNumberForAnimation:(FUAnimation *)animation;

@end

@interface FUAvatar (DynamicBone)

@property (nonatomic, assign) BOOL modelmatToBone;
@property (nonatomic, assign) BOOL dynamicBoneTeleportMode;
@property (nonatomic, assign) BOOL dynamicBoneRootTranslateSpeedLimitMode;
@property (nonatomic, assign) BOOL dynamicBoneRootRotateSpeedLimitMode;
- (void)refreshDynamicBone;
- (void)resetDynamicBone;

@end

@interface FUAvatar (Blendshape)

@property (nonatomic, assign) BOOL enableExpressionBlend;

@property (nonatomic) FUBlendshapeWeight inputBlendshapeWeight;

@property (nonatomic) FUBlendshapeWeight systemBlendshapeWeight;

- (void)updateInputBlendshape:(FUBlendshape)blendshape;

@end

@interface FUAvatar (EyesFocusToCamera)

@property (nonatomic, assign) BOOL eyesFocusToCamera;

@property (nonatomic, assign) double eyesFocusHeightAdjust;

@property (nonatomic, assign) double eyesFocusDistanceAdjust;

@property (nonatomic, assign) double eyesFocusWeight;

@end

@interface FUAvatar (Color)

- (NSDictionary <NSString *, NSData *> *)allColorKeyValues;

- (NSDictionary<NSString *,NSNumber *> *)allColorIntensityKeyValues;

- (void)setColor:(FURGBColor)color forComponentName:(NSString *)componentName;

- (void)setColor:(FURGBColor)color forKey:(NSString *)colorKey;

- (void)setColorIntensity:(float)colorIntensity forKey:(NSString *)colorIntensityKey;

- (int)getSkinColorIndex;

@end

@interface FUAvatar (Facepup)

@property (nonatomic, copy, readonly) NSArray<NSNumber *> *allFacepupValues;

@property (nonatomic, copy, readonly) NSDictionary<NSString *, NSNumber *> *allFacepupKeyValues;

+ (void)setFacepupKeysWithJsonPath:(NSString *)josnPath;

- (void)enterFacepupMode;

- (void)quitFacepupMode;

- (void)setFacepupValue:(double)facepupValue forKey:(NSString *)facepupKey;

- (CGPoint)getFaceVertexScreenCoordinateForVertexIndex:(int)index;

- (float)getFacepupOriginalValueForKey:(NSString *)facepupKey;

@end

@interface FUAvatar (Deformation)

@property (nonatomic, copy, readonly) NSDictionary<NSString *, NSNumber *> *allDeformationKeyValues;

- (void)setDeformationValue:(double)deformationValue forKey:(NSString *)deformationKey;

@end

NS_ASSUME_NONNULL_END
