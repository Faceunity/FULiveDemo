//
//  FUStyleModel.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/11/7.
//

#import "FURenderModel.h"
#import "FUStyleDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUStyleSkinModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) FUStyleCustomizingSkinType type;
/// 默认值
@property (nonatomic, assign) double defaultValue;
/// 当前值
@property (nonatomic, assign) double currentValue;
/// 实际值对应0.0-1.0的倍率
@property (nonatomic, assign) NSUInteger ratio;

@end

@interface FUStyleShapeModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) FUStyleCustomizingShapeType type;
/// 默认值
@property (nonatomic, assign) double defaultValue;
/// 当前值
@property (nonatomic, assign) double currentValue;
/// 默认值是否中位数
@property (nonatomic, assign) BOOL defaultValueInMiddle;
/// 是否区分设备性能
@property (nonatomic, assign) BOOL differentiateDevicePerformance;

@end

@interface FUStyleMakeupModel : NSObject

/// 妆容bundle名称
@property (nonatomic, copy) NSString *bundleName;
/// 妆容程度默认值
@property (nonatomic, assign) double defaultValue;
/// 妆容程度值
@property (nonatomic, assign) double currentValue;
/// 妆容滤镜默认程度值
@property (nonatomic, assign) double filterDefaultValue;
/// 妆容滤镜程度值
@property (nonatomic, assign) double filterCurrentValue;

@end

@interface FUStyleModel : FURenderModel

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) FUStyleMakeupModel *makeupModel;
/// 美肤是否关闭
@property (nonatomic, assign) BOOL isSkinDisabled;
/// 美型是否关闭
@property (nonatomic, assign) BOOL isShapeDisabled;

@property (nonatomic, copy) NSArray<FUStyleSkinModel *> *skins;

@property (nonatomic, copy) NSArray<FUStyleShapeModel *> *shapes;

@end

NS_ASSUME_NONNULL_END
