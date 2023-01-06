//
//  FUStyleListView.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/11/7.
//

#import <UIKit/UIKit.h>

#import "FUStyleListViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FUStyleListViewDelegate <NSObject>

/// 选择风格
- (void)styleListViewDisSelectStyleAtIndex:(NSUInteger)index;

/// 自定义
- (void)styleListViewDidClickCustomizingAtIndex:(NSUInteger)index;

@optional
/// 效果程度值变化
- (void)styleListViewFunctionValueDidChanged;

@end

@interface FUStyleListView : UIView

@property (nonatomic, strong, readonly) FUStyleListViewModel *viewModel;

@property (nonatomic, weak) id<FUStyleListViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame viewModel:(FUStyleListViewModel *)viewModel;

- (void)show;

- (void)dismiss;

- (void)refreshSubviews;

@end

@interface FUStyleListCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (nonatomic, strong, readonly) UILabel *textLabel;
@property (nonatomic, strong, readonly) UIActivityIndicatorView *indicatorView;

@property (nonatomic, assign) BOOL cancelStyle;

@property (nonatomic, copy) void (^customizeHandler)(void);

@end

@interface FUStyleFunctionButton : UIButton

@end


NS_ASSUME_NONNULL_END
