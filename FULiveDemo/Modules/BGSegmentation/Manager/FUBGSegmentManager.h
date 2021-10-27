//
//  FUBGSegmentManager.h
//  FULiveDemo
//
//  Created by Chen on 2021/2/25.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUStickerManager.h"
#import <FURenderKit/FUAISegment.h>
#import "FUManager.h"

#define CUSTOMBG @"bg_segment"
#define HUMANOUTLINE @"human_outline"

NS_ASSUME_NONNULL_BEGIN
@class FUBGSaveModel, FUBGSaveModel;
@interface FUBGSegmentManager : FUStickerManager
@property (nonatomic, strong) FUAISegment * _Nullable segment;

- (BOOL)saveModel:(FUBGSaveModel *)model;

- (BOOL)isHaveCustItem;

- (FUBGSaveModel *)getSaveModel;

//是否有自定的数据要添加
- (NSArray *)additionalItems;
@end

NS_ASSUME_NONNULL_END
