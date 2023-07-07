//
//  FUBeautyFilterView.h
//  FUBeautyComponent
//
//  Created by 项林平 on 2022/6/21.
//

#import <UIKit/UIKit.h>
#import "FUBeautyFilterViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FUBeautyFilterViewDelegate <NSObject>

/// 滤镜变化
- (void)beautyFilterViewDidChangeFilter:(NSString *)name;

@end

@interface FUBeautyFilterView : UIView

@property (nonatomic, weak) id<FUBeautyFilterViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame viewModel:(FUBeautyFilterViewModel *)viewModel;

@end

@interface FUBeautyFilterCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (nonatomic, strong, readonly) UILabel *textLabel;

@end

NS_ASSUME_NONNULL_END
