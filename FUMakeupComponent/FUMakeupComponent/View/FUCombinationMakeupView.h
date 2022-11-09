//
//  FUCombinationMakeupView.h
//  FUMakeupComponent
//
//  Created by 项林平 on 2021/11/12.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUCombinationMakeupViewModel.h"

@class FUCombinationMakeupModel, FUCombinationMakeupView;

NS_ASSUME_NONNULL_BEGIN

@protocol FUCombinationMakeupViewDelegate <NSObject>

/// 自定义妆容
- (void)combinationMakeupViewDidClickCustomize;

@end

@interface FUCombinationMakeupView : UIView

@property (nonatomic, strong, readonly) FUCombinationMakeupViewModel *viewModel;

@property (nonatomic, weak) id<FUCombinationMakeupViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame viewModel:(FUCombinationMakeupViewModel *)viewModel;

/// 取消选中当前组合妆
- (void)deselectCurrentCombinationMakeup;

- (void)show;

- (void)dismiss;

@end

@interface FUCombinationMakeupCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UIImageView *fuImageView;

@property (nonatomic, strong, readonly) UILabel *fuTitleLabel;

@property (nonatomic, strong, readonly) UIActivityIndicatorView *indicatorView;

@end

NS_ASSUME_NONNULL_END
