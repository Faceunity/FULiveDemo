//
//  FUCustomizeSkinView.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/6/21.
//

#import <UIKit/UIKit.h>
#import "FUCustomizeSkinViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUCustomizeSkinView : UIView

@property (nonatomic, copy) void (^backHandler)(void);
/// 效果开关回调
@property (nonatomic, copy) void (^effectStatusChangeHander)(BOOL isDisabled);

- (instancetype)initWithFrame:(CGRect)frame viewModel:(FUCustomizeSkinViewModel *)viewModel;

- (void)refreshSubviews;

@end

@interface FUCustomizeSkinCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UIImageView *imageView;

@property (nonatomic, strong, readonly) UILabel *textLabel;

@property (nonatomic, assign) double currentValue;

@property (nonatomic, assign) double defaultValue;

@property (nonatomic, copy) NSString *imageName;

@property (nonatomic, assign) BOOL disabled;

@end

NS_ASSUME_NONNULL_END
