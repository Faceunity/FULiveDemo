//
//  FUSlider.h
//  FUAPIDemoBar
//
//  Created by L on 2018/6/27.
//  Copyright © 2018年 L. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FUAvatarSliderType) {
    FUSliderCellType01,  /* 正常滑杆 */
    FUSliderCellType101, /* ±50 滑杆 */
};

@interface FUAvatarSlider : UISlider

@property (nonatomic, assign) FUAvatarSliderType type ;
@end
