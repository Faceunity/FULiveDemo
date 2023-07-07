//
//  FUCustomizedMakeupView.h
//  FUMakeupComponent
//
//  Created by 项林平 on 2021/11/19.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUCustomizedMakeupViewModel.h"

@class FUCustomizedMakeupView;

NS_ASSUME_NONNULL_BEGIN

@protocol FUCustomizedMakeupViewDelegate <NSObject>

/// 自定义子妆容变化
- (void)customizedMakeupViewDidChangeSubMakeup:(NSString *)title;
/// 自定义点击返回
- (void)customizedMakeupViewDidClickBack;

@end

@interface FUCustomizedMakeupView : UIView

@property (nonatomic, strong, readonly) FUCustomizedMakeupViewModel *viewModel;

@property (nonatomic, weak) id<FUCustomizedMakeupViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame viewModel:(FUCustomizedMakeupViewModel *)viewModel;

- (void)show;

- (void)dismiss;

@end

@interface FUCustomizedMakeupCategoryCell : UICollectionViewCell

/// 蓝点提示
@property (nonatomic, strong, readonly) UIView *tipView;
@property (nonatomic, strong, readonly) UILabel *categoryNameLabel;

@end

@interface FUCustomizedMakeupItemCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UIImageView *fuImageView;

@end

NS_ASSUME_NONNULL_END
