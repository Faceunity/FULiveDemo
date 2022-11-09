//
//  FUFaceFusionTipView.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/9/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FUFaceFusionTipViewDelegate <NSObject>

- (void)faceFusionTipViewDidClickComfirm;

@end

@interface FUFaceFusionTipView : UIView

@property (nonatomic, strong, readonly) UILabel *tipLabel;

@property (nonatomic, weak) id<FUFaceFusionTipViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
