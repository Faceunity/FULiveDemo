//
//  FULightModel.h
//  FULiveDemo
//
//  Created by 孙慕 on 2019/10/17.
//  Copyright © 2019 FaceUnity. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FUSingleMakeupModel.h"//目的导入FUMakeupModelType枚举，这里简单写了

NS_ASSUME_NONNULL_BEGIN

/* 部位模型，如：口红数据，则对应一个FUSingleLightMakeupModel对象 */
@interface FUSingleLightMakeupModel : NSObject

/* 妆容类型 */
@property (nonatomic, assign) FUMakeupModelType makeType;
/* 妆容键值 sdk参数*/
@property (nonatomic, copy) NSString* namaTypeStr;
/* 加载到部位的图片 */
@property (nonatomic, copy) NSString* namaImgStr;
/* 妆容程度值键值 sdk参数*/
@property (nonatomic, copy) NSString* namaValueStr;
/* 妆容程度值 */
@property (nonatomic, assign) float  value;
/* 妆容颜色键值 sdk参数*/
@property (nonatomic, copy) NSString* colorStr;
/* 妆容颜色 */
@property (nonatomic, strong) NSArray* colorStrV;

/* 口红相关 */
@property (nonatomic, assign) int is_two_color;
@property (nonatomic, assign) int lip_type;

@end

@interface FULightModel : NSObject
/* 妆容名称 */
@property (copy, nonatomic) NSString *name;
/* icon图片 */
@property (copy, nonatomic) NSString *imageStr;
/* 选中的滤镜 */
@property (nonatomic, strong) NSString *selectedFilter;
/* 选中滤镜的 level*/
@property (nonatomic, assign) double selectedFilterLevel;
/* 记录选中状态 */
@property (assign, nonatomic) BOOL isSel;
/* 整体妆容程度值 */
@property (nonatomic, assign) float value;

/* 组合妆对应所有子妆容 */
@property (nonatomic, strong) NSArray <FUSingleLightMakeupModel *>* makeups;

@end


NS_ASSUME_NONNULL_END
