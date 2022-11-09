//
//  FUCombinationMakeupModel.h
//  FUMakeupComponent
//
//  Created by 项林平 on 2021/11/11.
//  Copyright © 2021 FaceUnity. All rights reserved.
//
//  组合妆模型

#import <Foundation/Foundation.h>
#import "FUSubMakeupModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUCombinationMakeupModel : NSObject

/// 名称
@property (nonatomic, copy) NSString *name;
/// icon
@property (nonatomic, copy) NSString *icon;
/// 当前程度值
@property (nonatomic, assign) double value;
/// 滤镜名称（v8.0.0之后不需要）
@property (nonatomic, copy, nullable) NSString *selectedFilter;
/// 滤镜程度
@property (nonatomic, assign) double selectedFilterLevel;
/// bundle名称
@property (nonatomic, copy) NSString *bundleName;
/// 是否允许自定义
@property (nonatomic, assign) BOOL isAllowedEdit;
/// 是否v8.0.0之后新组合妆（只用一个bundle）
@property (nonatomic, assign) BOOL isCombined;
/// 粉底
@property (nonatomic, strong) FUSubMakeupModel *foundationModel;
/// 口红
@property (nonatomic, strong) FULipstickModel *lipstickModel;
/// 腮红
@property (nonatomic, strong) FUSubMakeupModel *blusherModel;
/// 眉毛
@property (nonatomic, strong) FUEyebrowModel *eyebrowModel;
/// 眼影
@property (nonatomic, strong) FUSubMakeupModel *eyeShadowModel;
/// 眼线
@property (nonatomic, strong) FUSubMakeupModel *eyelinerModel;
/// 睫毛
@property (nonatomic, strong) FUSubMakeupModel *eyelashModel;
/// 高光
@property (nonatomic, strong) FUSubMakeupModel *highlightModel;
/// 阴影
@property (nonatomic, strong) FUSubMakeupModel *shadowModel;
/// 美瞳
@property (nonatomic, strong) FUSubMakeupModel *pupilModel;

@end

NS_ASSUME_NONNULL_END
