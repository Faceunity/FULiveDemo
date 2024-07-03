//
//  UIDevice+FURenderKit.h
//  FURenderKit
//
//  Created by 项林平 on 2021/8/5.
//

#import <UIKit/UIKit.h>

/// 设备性能等级
typedef NS_ENUM(NSInteger, FUDevicePerformanceLevel) {
    FUDevicePerformanceLevelLow_1 = -1,     // iPhone6、iPhone6Plus及以下机型
    FUDevicePerformanceLevelLow = 1,        // iPhone6Plus以上和iPhone8以下机型
    FUDevicePerformanceLevelHigh = 2,       // iPhone8及以上和iPhoneXR以下机型
    FUDevicePerformanceLevelVeryHigh = 3,   // iPhoneXR
    FUDevicePerformanceLevelExcellent = 4   // iPhoneXR以上机型
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
    FUDeviceModelTypeiPhone13Mini,
    FUDeviceModelTypeiPhone13,
    FUDeviceModelTypeiPhone13Pro,
    FUDeviceModelTypeiPhone13ProMax,
    FUDeviceModelTypeiPhoneSENew,
    FUDeviceModelTypeiPhone14,
    FUDeviceModelTypeiPhone14Plus,
    FUDeviceModelTypeiPhone14Pro,
    FUDeviceModelTypeiPhone14ProMax,
    FUDeviceModelTypeiPhone15,
    FUDeviceModelTypeiPhone15Plus,
    FUDeviceModelTypeiPhone15Pro,
    FUDeviceModelTypeiPhone15ProMax,
    FUDeviceModelTypeOthers
};

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (FURenderKit)

- (FUDeviceModelType)fu_deviceModelType;

- (NSString *)fu_deviceModelString;

- (FUDevicePerformanceLevel)fu_devicePerformanceLevel;

@end

NS_ASSUME_NONNULL_END
