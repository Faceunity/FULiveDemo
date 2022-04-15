//
//  FUSingleMakeupModel.h
//  FULiveDemo
//
//  Created by 项林平 on 2021/11/12.
//  Copyright © 2021 FaceUnity. All rights reserved.
//
//  子妆模型

#import <Foundation/Foundation.h>
#import "FUMakeupDefine.h"
#import "FUSingleMakeupProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUSingleMakeupModel : NSObject<FUSingleMakeupProtocol>

/// icon
@property (nonatomic, copy) NSString *icon;
/// 标题
@property (nonatomic, copy) NSString *title;
/// 是否使用眉毛变形
@property (nonatomic, assign) BOOL isBrowWarp;
/// 眉毛类型（0柳叶眉  1上挑眉  2一字眉  3英气眉  4远山眉  5标准眉  6扶形眉  7剑眉  8日常风  9日系风）
@property (nonatomic, assign) NSInteger browWarpType;
/// 子妆可选颜色数组
@property (nonatomic, copy) NSArray<NSArray *> *colors;
/// 默认选择颜色索引
@property (nonatomic, assign) NSInteger defaultColorIndex;

@end

NS_ASSUME_NONNULL_END
