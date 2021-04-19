//
//  FULightMakeupManager.h
//  FULiveDemo
//
//  Created by Chen on 2021/3/4.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUMetaManager.h"
#import <FURenderKit/FULightMakeup.h>

@class FULightModel, FUSingleLightMakeupModel;

NS_ASSUME_NONNULL_BEGIN

@interface FULightMakeupManager : FUMetaManager
@property (nonatomic, strong, nullable) FULightMakeup *lightMakeup;
@property (nonatomic, strong, readonly) NSArray <FULightModel *> *dataArray;

//业务层设置所有子妆需要配合整体妆容程度值，所以需要带上lightModel.value
- (void)setAllSubLghtMakeupModelWithLightModel:(FULightModel *)lightModel;

//单独设置子妆设置强度值
- (void)setIntensityWithModel:(FUSingleLightMakeupModel *)model;
@end

NS_ASSUME_NONNULL_END
