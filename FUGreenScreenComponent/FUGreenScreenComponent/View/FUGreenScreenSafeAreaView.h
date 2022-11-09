//
//  FUGreenScreenSafeAreaView.h
//  FUGreenScreenComponent
//
//  Created by 项林平 on 2021/8/10.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUGreenScreenSafeAreaViewModel.h"

@class FUGreenScreenSafeAreaView;

NS_ASSUME_NONNULL_BEGIN

@protocol FUGreenScreenSafeAreaViewDelegate <NSObject>

@optional
/// 返回
- (void)safeAreaCollectionViewDidClickBack;
/// 取消选择
- (void)safeAreaCollectionViewDidClickCancel;
/// 自定义
- (void)safeAreaCollectionViewDidClickAdd;
/// 选择
- (void)safeAreaCollectionViewDidSelectItemAtIndex:(NSInteger)index;

@end

@interface FUGreenScreenSafeAreaView : UIView

@property (nonatomic, weak) id<FUGreenScreenSafeAreaViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame viewModel:(FUGreenScreenSafeAreaViewModel *)viewModel;

- (void)refreshSafeAreas;

@end

@interface FUGreenScreenSafeAreaCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UIImageView *imageView;

@end

NS_ASSUME_NONNULL_END
