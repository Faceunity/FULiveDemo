//
//  FULocalDataManager.h
//  FULiveDemo
//
//  Created by Chen on 2021/2/25.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FULocalDataManager : NSObject
+ (instancetype)shareManager;

//道具贴纸
+ (NSDictionary *)stickerTipsJsonData;

//美妆 - 子妆容
+ (NSDictionary *)makeupJsonData;

//美妆 - 整体妆容
+ (NSDictionary *)makeupWholeJsonData;

//轻美妆数据
+ (NSDictionary *)lightMakeupJsonData;

//美体数据
+ (NSArray *)bodyBeautyJsonData;
@end

NS_ASSUME_NONNULL_END
