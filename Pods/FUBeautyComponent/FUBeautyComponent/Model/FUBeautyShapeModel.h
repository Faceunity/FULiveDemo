//
//  FUBeautyShapeModel.h
//  FUBeautyComponent
//
//  Created by 项林平 on 2022/7/8.
//

#import <Foundation/Foundation.h>
#import "FUBeautyDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUBeautyShapeModel : NSObject

@property (nonatomic, copy) NSString *name;
/// 美型类型
@property (nonatomic, assign) FUBeautyShape type;
/// 当前值
@property (nonatomic) double currentValue;
/// 默认值
@property (nonatomic) double defaultValue;
/// 默认值是否中位数
@property (nonatomic, assign) BOOL defaultValueInMiddle;
/// 是否区分设备性能
@property (nonatomic, assign) BOOL differentiateDevicePerformance;

@end

NS_ASSUME_NONNULL_END
