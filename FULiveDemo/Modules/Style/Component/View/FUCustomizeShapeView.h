//
//  FUCustomizeShapeView.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/7/8.
//

#import <UIKit/UIKit.h>
#import "FUCustomizeShapeViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUCustomizeShapeView : UIView

@property (nonatomic, copy) void (^backHandler)(void);
/// 效果开关回调
@property (nonatomic, copy) void (^effectStatusChangeHander)(BOOL isDisabled);

- (instancetype)initWithFrame:(CGRect)frame viewModel:(FUCustomizeShapeViewModel *)viewModel;

- (void)refreshSubviews;

@end

@interface FUCustomizeShapeCell : UICollectionViewCell

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
