//
//  FULightingView.h
//  FULiveDemo
//
//  Created by L on 2018/9/20.
//  Copyright © 2018年 L. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@protocol FULightingViewDelegate <NSObject>

@optional
- (void)lightingViewValueDidChange:(float)value ;
@end

@class FULightingSlider ;
@interface FULightingView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *sunImage;
@property (weak, nonatomic) IBOutlet UIImageView *monImage;
@property (weak, nonatomic) IBOutlet FULightingSlider *slider;

@property (nonatomic, assign) id<FULightingViewDelegate>delegate ;
@end

NS_ASSUME_NONNULL_END
