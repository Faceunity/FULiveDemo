//
//  FULightMakeupModel.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/8/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FUSingleLightMakeupModel : NSObject
/// 子妆容类型
@property (nonatomic, assign) FUSingleMakeupType type;
/// 加载到子妆的图片或者bundle
@property (nonatomic, copy) NSString *bundleName;
/// 妆容程度值
@property (nonatomic, assign) double value;
/// 实际妆容程度值（子妆value * 组合妆value）
@property (nonatomic, assign) double realValue;
/// 妆容颜色
@property (nonatomic, copy) NSArray *colorsArray;
/// 是否双色口红
@property (nonatomic, assign) BOOL isTwoColorLipstick;
/// 口红类型
@property (nonatomic, assign) NSInteger lipType;

@end

@interface FULightMakeupModel : NSObject

/// 妆容名称
@property (nonatomic, copy) NSString *name;
/// icon图片
@property (nonatomic, copy) NSString *imageStr;
/// 选中的滤镜
@property (nonatomic, copy) NSString *selectedFilter;
/// 选中滤镜的程度值
@property (nonatomic, assign) double selectedFilterLevel;
/// 整体妆容程度值
@property (nonatomic, assign) double value;
/// 子妆容数组
@property (nonatomic, copy) NSArray<FUSingleLightMakeupModel *> *makeups;

@end

NS_ASSUME_NONNULL_END
