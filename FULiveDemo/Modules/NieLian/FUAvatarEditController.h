//
//  FUAvatarEditController.h
//  FULiveDemo
//
//  Created by 孙慕 on 2019/3/20.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import "FUBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN


typedef void(^FUAvatarEditSuccess)(BOOL isAdd);

@interface FUAvatarEditController : FUBaseViewController
@property(copy ,nonatomic) FUAvatarEditSuccess returnBlock;
@end

NS_ASSUME_NONNULL_END
