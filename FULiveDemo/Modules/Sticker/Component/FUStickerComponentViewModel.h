//
//  FUStickerComponentViewModel.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/9/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FUStickerComponentViewModel : NSObject

@property (nonatomic, copy, readonly) NSArray<NSString *> *stickerItems;

@property (nonatomic, assign, readonly) NSUInteger selectedIndex;

/// 加载贴纸
/// @param index 贴纸索引，0表示卸载贴纸
/// @param completion 加载完成回调
- (void)loadStickerAtIndex:(NSUInteger)index completion:(void (^)(void))completion;

@end

NS_ASSUME_NONNULL_END
