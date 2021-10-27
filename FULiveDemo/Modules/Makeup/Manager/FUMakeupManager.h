//
//  FUMakeUpManager.h
//  FULiveDemo
//
//  Created by Chen on 2021/3/2.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUMetaManager.h"
#import <FURenderKit/FUMakeup.h>
#import "FUMakeUpDefine.h"

@class FUMakeupModel, FUMakeupSupModel, FUSingleMakeupModel;
NS_ASSUME_NONNULL_BEGIN

@interface FUMakeupManager : FUMetaManager

@property (nonatomic, strong, readonly) NSArray <FUMakeupModel *>* dataArray;

@property (nonatomic, strong, readonly) NSArray <FUMakeupSupModel *>*supArray;

/// 设置子妆容数据
- (void)setMakeupSupModel:(FUSingleMakeupModel *)model type:(UIMAKEUITYPE)type;

/// 设置整体妆容数据
- (void)setMakeupWholeModel:(FUMakeupSupModel *)model;

/// 设置新组合妆滤镜程度
- (void)updateMakeupFilterLevel:(FUMakeupSupModel *)model;

- (void)loadMakeupPackageWithPathName:(NSString *)pathName;

- (void)setSupModel:(FUMakeupSupModel *)model;

@end

NS_ASSUME_NONNULL_END
