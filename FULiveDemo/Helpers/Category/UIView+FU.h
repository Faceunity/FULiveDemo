//
//  UIView+FU.h
//  FULiveDemo
//
//  Created by 项林平 on 2021/8/4.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (FU)

/// 获取当前View所在控制器
- (UIViewController *)fu_targetViewController;

@end

NS_ASSUME_NONNULL_END
