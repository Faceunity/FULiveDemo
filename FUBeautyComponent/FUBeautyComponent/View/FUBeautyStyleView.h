//
//  FUBeautyStyleView.h
//  FUBeautyComponent
//
//  Created by 项林平 on 2022/6/21.
//

#import <UIKit/UIKit.h>
#import "FUBeautyStyleViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FUBeautyStyleViewDelegate <NSObject>

@optional
/// 取消选择风格
- (void)beautyStyleViewDidCancelStyle;
/// 选择某一风格
- (void)beautyStyleViewDidSelectStyle;

@end

@interface FUBeautyStyleView : UIView

@property (nonatomic, weak) id<FUBeautyStyleViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame viewModel:(FUBeautyStyleViewModel *)viewModel;

@end

@interface FUBeautyStyleCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UIImageView *imageView;

@property (nonatomic, strong, readonly) UILabel *textLabel;

@property (nonatomic, copy) NSString *imageName;

@end

NS_ASSUME_NONNULL_END
