//
//  FUManager.h
//  FULiveDemo
//
//  Created by 刘洋 on 2017/8/18.
//  Copyright © 2017年 刘洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface FUManager : NSObject

+ (FUManager *)shareManager;

/// 保存的设备性能等级
@property (nonatomic, assign, readonly) FUDevicePerformanceLevel devicePerformanceLevel;

/// 初始化FURenderKit
- (void)setupRenderKit;

/// 设置设备性能相关细项
- (void)setDevicePerformanceDetails;

/// 加载人脸AI模型
+ (void)loadFaceAIModel;

/// 加载人体AI模型
+ (void)loadHumanAIModel;

/// 加载手势AI模型
+ (void)loadHandAIModel;

/// 检测是否有人脸
+ (BOOL)faceTracked;

/// 检测是否有人体
+ (BOOL)humanTracked;

/// 检测是否有手势
+ (BOOL)handTracked;

/// 更新美颜磨皮效果（根据人脸检测置信度设置不同磨皮效果）
+ (void)updateBeautyBlurEffect;

/// 重置面部跟踪结果
+ (void)resetTrackedResult;

/// 清除所有资源
+ (void)clearItems;

@end
