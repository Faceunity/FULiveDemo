//
//  FUAnimojiViewModel.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/8/4.
//

#import "FURenderViewModel.h"

@class FUComicFilterModel;

NS_ASSUME_NONNULL_BEGIN

@interface FUAnimojiViewModel : FURenderViewModel

@property (nonatomic, copy, readonly) NSArray<NSString *> *animojiItems;

@property (nonatomic, copy, readonly) NSArray<FUComicFilterModel *> *comicFilterItems;

@property (nonatomic, copy, readonly) NSArray<NSString *> *comicFilterIcons;

@property (nonatomic, assign, readonly) NSInteger selectedAnimojiIndex;

@property (nonatomic, assign, readonly) NSInteger selectedComicFilterIndex;
/// 当前特效视图索引
@property (nonatomic, assign) NSInteger currentIndex;

- (void)loadAnimojiAtIndex:(NSInteger)index completion:(nullable void (^)(void))complection;

- (void)loadComicFilterAtIndex:(NSInteger)index completion:(nullable void (^)(void))complection;

@end

NS_ASSUME_NONNULL_END
