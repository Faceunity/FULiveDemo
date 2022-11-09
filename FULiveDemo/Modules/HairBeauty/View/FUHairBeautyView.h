//
//  FUHairBeautyView.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/8/5.
//

#import <FUCommonUIComponent/FUCommonUIComponent.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FUHairBeautyViewDelegate <NSObject>

@optional
- (void)hairBeautyViewChangedStrength:(double)strength;

@end


@interface FUHairBeautyView : FUItemsView

@property (nonatomic, strong, readonly) FUSlider *slider;

@property (nonatomic, weak) id<FUHairBeautyViewDelegate> hairDelegate;

@end

NS_ASSUME_NONNULL_END
