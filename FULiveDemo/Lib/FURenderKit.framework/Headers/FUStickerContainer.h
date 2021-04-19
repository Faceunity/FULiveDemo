//
//  FUStickerContainer.h
//  FURenderKit
//
//  Created by Chen on 2021/1/18.
//

#import <Foundation/Foundation.h>
#import "FUSticker.h"

NS_ASSUME_NONNULL_BEGIN
/**
 * 可叠加的道具可以放到这里
 */
@interface FUStickerContainer : NSObject
/**
 * 添加 sticker，移除当前已经加载的所有 sticker
 * flag: YES 移除，NO 叠加(不移除)
 */
//- (void)addSticker:(FUSticker *)item removeCurrent:(BOOL)flag;
/**
 * 单个FUSticker操作接口
 * 内部已经加锁，外部无需处理
 */
- (void)addSticker:(FUSticker *)sticker completion:(nullable void(^)(void))completion;
- (void)removeSticker:(FUSticker *)sticker completion:(nullable void(^)(void))completion;
//- (void)updateSticker:(FUSticker *)item;
//按照路径移除
- (void)removeStickerForPath:(NSString *)stickerPath completion:(nullable void(^)(void))completion;

- (void)replaceSticker:(FUSticker *)oldSticker withSticker:(FUSticker *)newSticker completion:(nullable void(^)(void))completion;

/**
 * 多个FUSticker操作接口
 * 内部已经加锁，外部无需处理
 */
- (void)addStickers:(NSArray <FUSticker *> *)stickers completion:(nullable void(^)(void))completion;
- (void)removeStickers:(NSArray <FUSticker *> *)stickers completion:(nullable void(^)(void))completion;
//- (void)updateStickers:(NSArray <FUSticker *> *)items;
- (void)removeStickersForPaths:(NSArray <NSString *> *)stickerPaths completion:(nullable void(^)(void))completion;
/**
 * 移除所有已经添加的FUSticker
 * 内部已经枷锁，外部无序需处理
 */
- (void)removeAllSticks;
- (NSArray *)allStickers;
@end



NS_ASSUME_NONNULL_END
