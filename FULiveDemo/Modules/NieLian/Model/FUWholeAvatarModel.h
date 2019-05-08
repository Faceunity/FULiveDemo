//
//  FUWholeAvatarModel.h
//  FULiveDemo
//
//  Created by 孙慕 on 2019/3/22.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FUAvatarModel.h"
#import <UIKit/UIKit.h>

/* 整体模型 */

NS_ASSUME_NONNULL_BEGIN

@interface FUWholeAvatarModel : NSObject


@property (nonatomic, strong) UIImage* image;

@property (nonatomic, strong) NSArray <FUAvatarModel *> *avatarModel;

@end

NS_ASSUME_NONNULL_END
