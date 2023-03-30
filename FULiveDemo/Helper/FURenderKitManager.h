//
//  FURenderKitManager.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/7/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FURenderKitManager : NSObject

/// 当前设备性能等级
@property (nonatomic, assign, readonly) FUDevicePerformanceLevel devicePerformanceLevel;
/// 测试配置
@property (nonatomic, copy, readonly) NSDictionary *configurations;
/// 是否需要点位开关
@property (nonatomic, assign, readonly) BOOL showsLandmarks;

+ (instancetype)sharedManager;

/// 初始化FURenderKit
- (void)setupRenderKit;

/// 销毁FURenderKit
- (void)destoryRenderKit;

/// 设置设备性能相关细项
- (void)setDevicePerformanceDetails;

/// 加载人脸AI模型
+ (void)loadFaceAIModel;

/// 加载人体AI模型
+ (void)loadHumanAIModel:(FUHumanSegmentationMode)mode;

/// 加载手势AI模型
+ (void)loadHandAIModel;

/// 检测是否有人脸
+ (BOOL)faceTracked;

/// 检测是否有人体
+ (BOOL)humanTracked;

/// 检测是否有手势
+ (BOOL)handTracked;

/// 设置最大人脸数量
+ (void)setMaxFaceNumber:(NSInteger)number;

/// 设置最大人体数量
+ (void)setMaxHumanNumber:(NSInteger)number;

/// 更新美颜磨皮效果（根据人脸检测置信度设置不同磨皮效果）
+ (void)updateBeautyBlurEffect;

/// 重置面部跟踪结果
+ (void)resetTrackedResult;

/// 设置人脸检测模式
+ (void)setFaceProcessorDetectMode:(FUFaceProcessorDetectMode)mode;

/// 设置人体检测模式
+ (void)setHumanProcessorDetectMode:(FUHumanProcessorDetectMode)mode;

/// 清除所有资源
+ (void)clearItems;

@end

NS_ASSUME_NONNULL_END
