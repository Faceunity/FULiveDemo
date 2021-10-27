//
//  UIDevice+FURenderKit.h
//  FURenderKit
//
//  Created by 项林平 on 2021/8/5.
//

#import <UIKit/UIKit.h>

/// 设备性能等级
typedef NS_ENUM(NSInteger, FUDevicePerformanceLevel) {
    FUDevicePerformanceLevelLow = 0,
    FUDevicePerformanceLevelMedium,
    FUDevicePerformanceLevelHigh
};

/// 设备具体机型
typedef NS_ENUM(NSInteger, FUDeviceModelType) {
    FUDeviceModelTypeSimulator = 0,
    FUDeviceModelTypeiPhone3G,
    FUDeviceModelTypeiPhone3GS,
    FUDeviceModelTypeiPhone4,
    FUDeviceModelTypeiPhone4s,
    FUDeviceModelTypeiPhone5,
    FUDeviceModelTypeiPhone5c,
    FUDeviceModelTypeiPhone5s,
    FUDeviceModelTypeiPhone6,
    FUDeviceModelTypeiPhone6Plus,
    FUDeviceModelTypeiPhone6s,
    FUDeviceModelTypeiPhone6sPlus,
    FUDeviceModelTypeiPhoneSE,
    FUDeviceModelTypeiPhone7,
    FUDeviceModelTypeiPhone7Plus,
    FUDeviceModelTypeiPhone8,
    FUDeviceModelTypeiPhone8Plus,
    FUDeviceModelTypeiPhoneX,
    FUDeviceModelTypeiPhoneXS,
    FUDeviceModelTypeiPhoneXSMax,
    FUDeviceModelTypeiPhoneXR,
    FUDeviceModelTypeiPhone11,
    FUDeviceModelTypeiPhone11Pro,
    FUDeviceModelTypeiPhone11ProMax,
    FUDeviceModelTypeiPhoneSE2,
    FUDeviceModelTypeiPhone12Mini,
    FUDeviceModelTypeiPhone12,
    FUDeviceModelTypeiPhone12Pro,
    FUDeviceModelTypeiPhone12ProMax,
    FUDeviceModelTypeOthers
};

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (FURenderKit)

- (FUDeviceModelType)fu_deviceModelType;

- (FUDevicePerformanceLevel)fu_devicePerformanceLevel;

@end

NS_ASSUME_NONNULL_END
