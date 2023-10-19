//
//  FUGreenScreenKeyingModel.h
//  FUGreenScreenComponent
//
//  Created by 项林平 on 2022/8/1.
//

#import <Foundation/Foundation.h>
#import "FUGreenScreenDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUGreenScreenKeyingModel : NSObject
/// 抠像参数类型
/// @see FUGreenScreenKeyingType
@property (nonatomic, assign) FUGreenScreenKeyingType type;
/// 抠像参数名
@property (nonatomic, copy) NSString *name;
/// icon
@property (nonatomic, copy) NSString *icon;
/// 当前值
@property (nonatomic, assign) double currentValue;
/// 默认值
@property (nonatomic, assign) double defaultValue;

@end

NS_ASSUME_NONNULL_END
