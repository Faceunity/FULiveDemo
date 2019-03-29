//
//  FUFaceAdjustController.h
//  FULiveDemo
//
//  Created by 孙慕 on 2018/12/17.
//  Copyright © 2018年 FaceUnity. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^FUFaceAdjustEditSuccess)(int index);
@interface FUFaceAdjustController : UIViewController
@property(strong ,nonatomic) UIImageView *imageView;

@property(copy ,nonatomic) FUFaceAdjustEditSuccess returnBlock;
@end

NS_ASSUME_NONNULL_END
