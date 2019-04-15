//
//  FUGanEditController.h
//  FULiveDemo
//
//  Created by 孙慕 on 2018/12/24.
//  Copyright © 2018年 FaceUnity. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSUInteger, FUGanEditImagePushFrom) {
    FUGanEditImagePushFromPhoto,
    FUGanEditImagePushFromAlbum,
};

@interface FUGanEditController : UIViewController
@property (assign, nonatomic) FUGanEditImagePushFrom pushFrom;
@property(strong ,nonatomic) UIImage *originalImage;

@end

NS_ASSUME_NONNULL_END
