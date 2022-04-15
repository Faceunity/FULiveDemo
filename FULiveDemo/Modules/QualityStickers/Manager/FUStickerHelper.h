//
//  FUStickerHelper.h
//  FULiveDemo
//
//  Created by 项林平 on 2021/3/11.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FUStickerModel;

NS_ASSUME_NONNULL_BEGIN

@interface FUStickerHelper : NSObject

#pragma mark - Network request

/// 获取道具Tag数组
/// @param complection 结果回调
+ (void)itemTagsCompletion:(void (^)(BOOL isSuccess, NSArray * _Nullable tags))complection;

/// 获取道具数据数组
/// @param tag 道具Tag
/// @param completion 结果回调
+ (void)itemListWithTag:(NSString *)tag
             completion:(void (^)(NSArray <FUStickerModel *>* _Nullable dataArray, NSError * _Nullable error))completion;

/// 下载单个道具
/// @param sticker 道具
/// @param completion 结果回调
+ (void)downloadItem:(FUStickerModel *)sticker completion:(void (^)(NSError * _Nullable error))completion;

/// 取消所有精品贴纸相关网络任务
+ (void)cancelStickerHTTPTasks;

#pragma mark - Local stickers

/// 获取本地贴纸数组（无网络情况）
/// @param stickerTag 贴纸标签
+ (NSArray<FUStickerModel *> *)localStickersWithTag:(NSString *)stickerTag;

/// 根据网络贴纸更新本地贴纸
/// @param stickers 网络贴纸数组
/// @param stickerTag 贴纸标签
+ (void)updateLocalStickersWithStickers:(NSArray<FUStickerModel *> *)stickers tag:(NSString *)stickerTag;

/// 判断贴纸是否已经下载
/// @param sticker 贴纸
+ (BOOL)downloadStatusOfSticker:(FUStickerModel *)sticker;

@end

NS_ASSUME_NONNULL_END
