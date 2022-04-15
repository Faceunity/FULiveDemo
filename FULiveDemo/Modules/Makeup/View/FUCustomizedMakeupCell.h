//
//  FUCustomizedMakeupCell.h
//  FULiveDemo
//
//  Created by 项林平 on 2021/11/19.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FUCustomizedMakeupCategoryCell : UICollectionViewCell

/// 蓝点提示
@property (nonatomic, strong, readonly) UIView *tipView;
@property (nonatomic, strong, readonly) UILabel *categoryNameLabel;

@end

@interface FUCustomizedMakeupItemCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UIImageView *fuImageView;

@end

NS_ASSUME_NONNULL_END
