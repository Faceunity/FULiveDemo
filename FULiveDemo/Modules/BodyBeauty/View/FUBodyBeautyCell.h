//
//  FUBodyBeautyCell.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/8/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FUBodyBeautyCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UIImageView *imageView;

@property (nonatomic, strong, readonly) UILabel *textLabel;

@property (nonatomic, assign) BOOL defaultInMiddle;

@property (nonatomic, assign) double currentValue;

@property (nonatomic, copy) NSString *imageName;

@end

NS_ASSUME_NONNULL_END
