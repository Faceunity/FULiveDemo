//
//  FUItemCell.h
//  FUCommonUIComponent
//
//  Created by 项林平 on 2022/6/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FUItemCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UIImageView *imageView;

@property (nonatomic, strong, readonly) UIActivityIndicatorView *indicatorView;

@end

NS_ASSUME_NONNULL_END
