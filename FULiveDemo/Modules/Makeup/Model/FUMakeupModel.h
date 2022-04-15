//
//  FUMakeupModel.h
//  FULiveDemo
//
//  Created by 项林平 on 2021/11/22.
//  Copyright © 2021 FaceUnity. All rights reserved.
//
//  单个妆容类型模型，对应自定义妆容任一一项

#import <Foundation/Foundation.h>

@class FUSingleMakeupModel;

NS_ASSUME_NONNULL_BEGIN

@interface FUMakeupModel : NSObject

@property (nonatomic, copy) NSString *name;
/// 妆容可选类型数组（如口红包括：雾面、润泽、珠光等）
@property (nonatomic, copy) NSArray<FUSingleMakeupModel *> *singleMakeups;
/// 当前类型选中的索引
@property (nonatomic, assign) NSInteger selectedIndex;

@end

NS_ASSUME_NONNULL_END
