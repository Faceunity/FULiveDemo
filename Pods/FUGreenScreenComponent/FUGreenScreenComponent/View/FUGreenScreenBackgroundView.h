//
//  FUGreenScreenBackgroundView.h
//  FUGreenScreenComponent
//
//  Created by 项林平 on 2022/8/1.
//

#import <UIKit/UIKit.h>

#import "FUGreenScreenBackgroundViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUGreenScreenBackgroundView : UIView

- (instancetype)initWithFrame:(CGRect)frame viewModel:(FUGreenScreenBackgroundViewModel *)viewModel;

@end

@interface FUGreenScreenBackgroundCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (nonatomic, strong, readonly) UILabel *textLabel;

@end

NS_ASSUME_NONNULL_END
