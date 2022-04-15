//
//  FUCombinationMakeupModel.h
//  FULiveDemo
//
//  Created by 项林平 on 2021/11/11.
//  Copyright © 2021 FaceUnity. All rights reserved.
//
//  组合妆模型

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FUCombinationMakeupModel : NSObject

/// 名称
@property (nonatomic, copy) NSString *name;
/// icon
@property (nonatomic, copy) NSString *icon;
/// 当前程度值
@property (nonatomic, assign) double value;
/// 滤镜名称（v8.0.0之后不需要）
@property (nonatomic, copy) NSString *selectedFilter;
/// 滤镜程度
@property (nonatomic, assign) double selectedFilterLevel;
/// bundle名称
@property (nonatomic, copy) NSString *bundleName;
/// 是否允许自定义
@property (nonatomic, assign) BOOL isAllowedEdit;
/// 是否v8.0.0之后新组合妆（只用一个bundle）
@property (nonatomic, assign) BOOL isCombined;
/// 子妆容数组
@property (nonatomic, copy) NSArray *singleMakeupArray;

@end

NS_ASSUME_NONNULL_END
