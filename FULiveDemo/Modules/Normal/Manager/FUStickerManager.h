//
//  FUStickerManager.h
//  FULiveDemo
//
//  Created by Chen on 2021/2/25.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUMetaManager.h"
#import "FUStickerProtocol.h"
#import <FURenderKit/FUGesture.h>

NS_ASSUME_NONNULL_BEGIN

@interface FUStickerManager : FUMetaManager <FUStickerProtocol>

//手势道具专用（手势道具目前未独立，所以和道具贴纸共用一个模块，通过FUStickerType区分）
@property (nonatomic, strong) FUGesture * _Nullable gestureItem;
- (void)loadItemWithCompletion:(void(^)(void))completion;
+ (int)aiHandDistinguishNums;
@end

NS_ASSUME_NONNULL_END
