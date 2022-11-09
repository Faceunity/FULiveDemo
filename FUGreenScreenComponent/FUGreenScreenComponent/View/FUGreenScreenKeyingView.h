//
//  FUGreenScreenKeyingView.h
//  FUGreenScreenComponent
//
//  Created by 项林平 on 2022/8/1.
//

#import <UIKit/UIKit.h>

#import "FUGreenScreenKeyingViewModel.h"

@class FUGreenScreenKeyingView;

NS_ASSUME_NONNULL_BEGIN

@protocol FUGreenScreenKeyingViewDelegate <NSObject>

/// 安全区域
- (void)keyingViewDidSelectSafeArea;
/// 是否需要锚点取色
- (void)keyingViewRequiresPickColor:(BOOL)required;
/// 所有抠像功能恢复到默认值
- (void)keyingViewDidRecoverToDefault;

@end

@interface FUGreenScreenKeyingView : UIView

@property (nonatomic, weak) id<FUGreenScreenKeyingViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame viewModel:(FUGreenScreenKeyingViewModel *)viewModel;

/// 刷新视图颜色
- (void)refreshPickerColor:(UIColor *)color;
/// 刷新恢复按钮状态
- (void)refreshRecoverButtonState;

- (void)refreshKeyingCollectionView;

@end

@interface FUGreenScreenKeyingCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UIImageView *imageView;

@property (nonatomic, strong, readonly) UILabel *textLabel;

@property (nonatomic, assign) double currentValue;

@property (nonatomic, assign) double defaultValue;

@property (nonatomic, copy) NSString *imageName;

@end

@interface FUGreenScreenColorCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UIImageView *backgroundImageView;

@property (nonatomic, strong, readonly) UIImageView *imageView;

@property (nonatomic, strong, nullable) UIImage *pickerColorImage;

@end

NS_ASSUME_NONNULL_END
