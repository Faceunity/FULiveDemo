//
//  FUSafeAreaCollectionView.h
//  FULiveDemo
//
//  Created by 项林平 on 2021/8/10.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FUGreenScreenManager.h"

@class FUSafeAreaCollectionView, FUGreenScreenSafeAreaModel;

NS_ASSUME_NONNULL_BEGIN

@protocol FUSafeAreaCollectionViewDelegate <NSObject>

/// 返回
- (void)safeAreaCollectionViewDidClickBack:(FUSafeAreaCollectionView *)safeAreaView;
/// 取消选择
- (void)safeAreaCollectionViewDidClickCancel:(FUSafeAreaCollectionView *)safeAreaView;
/// 自定义
- (void)safeAreaCollectionViewDidClickAdd:(FUSafeAreaCollectionView *)safeAreaView;
/// 选择
- (void)safeAreaCollectionView:(FUSafeAreaCollectionView *)safeAreaView didSelectItemAtIndex:(NSInteger)index;

@end

@interface FUSafeAreaCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

@end

@interface FUSafeAreaCollectionView : UICollectionView

@property (nonatomic, copy, readonly) NSArray<FUGreenScreenSafeAreaModel *> *safeAreas;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, weak) id<FUSafeAreaCollectionViewDelegate> safeAreaDelegate;

- (void)reloadSafeAreas;

@end

NS_ASSUME_NONNULL_END
