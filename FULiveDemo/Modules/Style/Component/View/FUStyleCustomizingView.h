//
//  FUStyleCustomizingView.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/11/7.
//

#import <UIKit/UIKit.h>
#import "FUStyleCustomizingViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FUStyleCustomizingViewDelegate <NSObject>

- (void)styleCustomizingViewDidClickBack;

@end

@interface FUStyleCustomizingView : UIView

@property (nonatomic, strong, readonly) FUStyleCustomizingViewModel *viewModel;

@property (nonatomic, weak) id<FUStyleCustomizingViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame viewModel:(FUStyleCustomizingViewModel *)viewModel;

- (void)refreshSubviews;

- (void)show;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
