//
//  FUHomepageModuleCell.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/7/6.
//  Copyright © 2022 FaceUnity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LOTAnimationView.h>

NS_ASSUME_NONNULL_BEGIN

@interface FUHomepageModuleCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UIImageView *backgroundImageView;

@property (nonatomic, strong, readonly) UIImageView *iconImageView;

@property (nonatomic, strong, readonly) UILabel *titleLabel;

@property (nonatomic, strong, readonly) UIImageView *bottomImageView;
/// 动画视图
@property (nonatomic, strong, readonly) LOTAnimationView *animationView;

@end

NS_ASSUME_NONNULL_END
