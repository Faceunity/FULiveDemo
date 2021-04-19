//
//  FUBodyBeautyManager.h
//  FULiveDemo
//
//  Created by Chen on 2021/3/5.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUMetaManager.h"
#import <FURenderKit/FUBodyBeauty.h>
#import "FUBodyBeautyDefine.h"

@class FUPositionInfo;
NS_ASSUME_NONNULL_BEGIN

@interface FUBodyBeautyManager : FUMetaManager
@property (nonatomic, strong, nullable) FUBodyBeauty *bodyBeauty;

@property (nonatomic, strong, readonly) NSArray <FUPositionInfo *> *dataArray;

- (int)aiHumanProcessNums;

//调整人体数据
- (void)setBodyBeautyModel:(FUPositionInfo *)model;
@end

NS_ASSUME_NONNULL_END
