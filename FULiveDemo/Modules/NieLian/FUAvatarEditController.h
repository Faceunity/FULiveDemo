//
//  FUAvatarEditController.h
//  FULiveDemo
//
//  Created by 孙慕 on 2019/3/20.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import "FUBaseViewController.h"
#import "FUWholeAvatarModel.h"


NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FUAvatarEditState) {
    FUAvatarEditStateNew,
    FUAvatarEditStateUpdate
};

typedef void(^FUAvatarEditSuccess)(BOOL isAdd);

@interface FUAvatarEditController : FUBaseViewController

/* 单个完整扭脸模型*/
@property (nonatomic, strong) FUWholeAvatarModel *avatarModel;

@property(copy ,nonatomic) FUAvatarEditSuccess returnBlock;

@property(assign ,nonatomic) FUAvatarEditState  state;
@end

NS_ASSUME_NONNULL_END
