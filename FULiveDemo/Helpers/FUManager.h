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
#import "FUSaveModelProtocol.h"

@class FULiveModel, FUBeautyModel, FUStyleModel;

/**
 * 暂时作为加载FURenderKit的入口和记录当前模块数据的作用
 */
@interface FUManager : NSObject
+ (FUManager *)shareManager;

@property (nonatomic, strong) FULiveModel *currentModel;
//初始化FURenderKit
- (void)setupRenderKit;

/**
 * 缓存的美颜参数:
 * 按照 美肤、美体、滤镜, 风格 顺序缓存
 */
@property (nonatomic, strong) NSArray *beautyParams;
//缓存的选种滤镜参数
@property (nonatomic, strong) FUBeautyModel *seletedFliter;
//缓存的风格参数
@property (nonatomic, strong) FUStyleModel *currentStyle;
@end
