//
//  FUBeautyShapeView.h
//  FUBeautyComponent
//
//  Created by 项林平 on 2022/7/8.
//

#import <UIKit/UIKit.h>
#import "FUBeautyShapeViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUBeautyShapeView : UIView

- (instancetype)initWithFrame:(CGRect)frame viewModel:(FUBeautyShapeViewModel *)viewModel;

@end

@interface FUBeautyShapeCell : UICollectionViewCell

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
