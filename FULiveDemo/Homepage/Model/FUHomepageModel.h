//
//  FUHomepageModel.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/7/4.
//  Copyright © 2022 FaceUnity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface FUHomepageModule : NSObject

@property (nonatomic, assign) FUModule module;

@property (nonatomic, copy) NSString *title;
/// 是否有使用权限
@property (nonatomic, assign) BOOL enable;
/// 权限码
@property (nonatomic, copy) NSString *authCode;
/// 最低支持设备性能等级
@property (nonatomic, assign) FUDevicePerformanceLevel performanceLevel;

@end

@interface FUHomepageGroup : NSObject<YYModel>

@property (nonatomic, assign) FUGroup group;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSArray<FUHomepageModule *> *modules;

@end

NS_ASSUME_NONNULL_END
