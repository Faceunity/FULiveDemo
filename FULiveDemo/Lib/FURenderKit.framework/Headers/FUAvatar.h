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

@property (nonatomic, assign) double rotateDelta;

@property (nonatomic, assign) double scaleDelta;

@property (nonatomic, assign) double translateDelta;

/// 身体组件列表
@property (nonatomic, copy, readonly) NSArray<FUItem *> *components;

/// 当前正在播放的动画
@property (nonatomic, strong, readonly) FUAnimation *currentAnimation;

/// 动画列表
@property (nonatomic, copy, readonly) NSArray<FUAnimation *> *animations;

@property (nonatomic, assign) int faceTrackID;

- (void)updateTransformWithPosition:(FUPosition)position rotate:(double)rotate lastsFrames:(int)frames;

@end

@interface FUAvatar (Component)

/// 添加身体组件，如果组件的 name 不为空，可以通过 name 查找或移除组件
/// @param component 身体组件
- (void)addComponent:(FUItem *)component;

- (BOOL)replaceComponent:(FUItem *)component withNewComponent:(FUItem *)newComponent;

- (BOOL)replaceComponentWithName:(NSString *)name newComponent:(FUItem *)newComponent;

/// 通过组件名称查找组件
/// @param componentName 组件名称
- (FUItem *)componentForName:(NSString *)componentName;

/// 移除身体组件
/// @param component 身体组件
- (void)removeComponent:(FUItem *)component;

/// 通过身体组件名称移除组件
/// @param componentName 组件名称
- (void)removeComponentWithName:(NSString *)componentName;

- (void)updateComponentsVisiableWithARMode:(BOOL)ARMode;

@end

@interface FUAvatar (Animation)

/// 个别设备支持的骨骼数量有限，无法在默认情况下运行骨骼动画，这时候开启这个选项
@property (nonatomic, assign) BOOL enableVTF;

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

- (int)getLayerIDForAnimation:(FUAnimation *)animation;

@end

@interface FUAvatar (DynamicBone)

@property (nonatomic, assign) BOOL modelmatToBone;
@property (nonatomic, assign) BOOL enableDynamicbone;
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

- (void)setColor:(FURGBColor)color forKey:(FUAvatarColor)colorKey;

- (void)setColorIntensity:(double)colorIntensity forKey:(FUAvatarColorIntensity)colorIntensityKey;

- (int)colorIndexForKey:(FUAvatarColorIndex)colorIndexKey;

@end

@interface FUAvatar (Facepup)

@property (nonatomic, copy, readonly) NSArray<NSNumber *> *allFacepupValues;

- (void)enterFacepupMode;

- (void)quitFacepupMode;

- (void)setFacepupValue:(double)facepupValue forKey:(FUFacepup)facepupKey;

- (double)facepupValueForKey:(NSString *)facepupKey;

- (NSArray *)allFacepupKeys;

- (NSDictionary<NSString*, NSNumber *> *)allFacepupKeyValues;

@end

@interface FUAvatar (Deformation)

@property (nonatomic, copy, readonly) NSArray<NSNumber *> *allDeformationValues;

- (void)setDeformationValue:(double)deformationValue forKey:(FUDeformation)deformationKey;

- (double)deformationValueForKey:(NSString *)deformationKey;

- (NSArray *)allDeformationKeys;

- (NSDictionary<NSString*, NSNumber *> *)allDeformationKeyValues;
@end

NS_ASSUME_NONNULL_END
