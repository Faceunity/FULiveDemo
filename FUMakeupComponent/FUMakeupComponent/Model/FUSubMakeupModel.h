//
//  FUSubMakeupModel.h
//  FUMakeupComponent
//
//  Created by 项林平 on 2022/9/8.
//
//  子妆模型

#import <Foundation/Foundation.h>
#import "FUMakeupDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUSubMakeupModel : NSObject

/// 类型
@property (nonatomic, assign) FUSubMakeupType type;
/// icon
@property (nonatomic, copy) NSString *icon;
/// 标题
@property (nonatomic, copy) NSString *title;
/// 子妆bundle名
@property (nonatomic, copy) NSString *bundleName;
/// 妆容程度值
@property (nonatomic, assign) double value;
/// 子妆当前颜色
@property (nonatomic, copy, nullable) NSArray<NSNumber *> *color;
/// 可选颜色数组
@property (nonatomic, copy, nullable) NSArray<NSArray<NSNumber *> *> *colors;
/// 默认选择颜色索引
@property (nonatomic, assign) NSInteger defaultColorIndex;
/// 子妆在自定义子妆可选列表中的索引
@property (nonatomic, assign) NSInteger index;

@end

@interface FULipstickModel : FUSubMakeupModel

/// 是否双色口红
@property (nonatomic, assign) BOOL isTwoColorLipstick;
/// 口红类型
@property (nonatomic, assign) NSInteger lipstickType;

@end

@interface FUEyebrowModel : FUSubMakeupModel

/// 是否使用眉毛变形
@property (nonatomic, assign) BOOL isBrowWarp;

/// 眉毛类型（0柳叶眉  1上挑眉  2一字眉  3英气眉  4远山眉  5标准眉  6扶形眉  7剑眉  8日常风  9日系风）
/// @note 当isBrowWarp为NO时，设置眉毛类型无效果
@property (nonatomic, assign) NSInteger browWarpType;

@end

NS_ASSUME_NONNULL_END
