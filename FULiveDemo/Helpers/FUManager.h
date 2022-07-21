//
//  FUManager.h
//  FULiveDemo
//
//  Created by 刘洋 on 2017/8/18.
//  Copyright © 2017年 刘洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class FULiveModel;

/**
 * 暂时作为加载FURenderKit的入口和记录当前模块数据的作用
 */
@interface FUManager : NSObject

+ (FUManager *)shareManager;

@property (nonatomic, assign, readonly) FUDevicePerformanceLevel devicePerformanceLevel;

@property (nonatomic, strong) FULiveModel *currentModel;

/// 初始化FURenderKit
- (void)setupRenderKit;

/// 加载AI模型
/// @param moduleType 模块
+ (void)loadAIModelWithModuleType:(FULiveModelType)moduleType;

@end
