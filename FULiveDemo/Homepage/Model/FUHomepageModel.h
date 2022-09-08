//
//  FUHomepageModel.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/7/4.
//  Copyright © 2022 FaceUnity. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FUHomepageModule : NSObject

@property (nonatomic, assign) FUModuleType type;

@property (nonatomic, copy) NSString *title;
/// 是否有使用权限
@property (nonatomic, assign) BOOL enable;
/// 权限码
@property (nonatomic, assign) NSInteger permissionCode;
/// 模块编码（0或者1）
@property (nonatomic, assign) NSInteger moduleCode;

@end

@interface FUHomepageGroup : NSObject

@property (nonatomic, assign) FUGroupType type;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSArray<FUHomepageModule *> *modules;

@end

NS_ASSUME_NONNULL_END
