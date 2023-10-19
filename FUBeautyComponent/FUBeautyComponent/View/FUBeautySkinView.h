//
//  FUBeautySkinView.h
//  FUBeautyComponent
//
//  Created by 项林平 on 2022/6/21.
//
//  美肤&美型视图

#import <UIKit/UIKit.h>
#import "FUBeautySkinViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUBeautySkinView : UIView

- (instancetype)initWithFrame:(CGRect)frame viewModel:(FUBeautySkinViewModel *)viewModel;

@end

@interface FUBeautySkinCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UIImageView *imageView;

@property (nonatomic, strong, readonly) UILabel *textLabel;
/// 是否允许选择
@property (nonatomic, assign) BOOL disabled;

@property (nonatomic, assign) BOOL defaultInMiddle;

@property (nonatomic, assign) double currentValue;

@property (nonatomic, assign) double defaultValue;

@property (nonatomic, copy) NSString *imageName;

@end

NS_ASSUME_NONNULL_END
