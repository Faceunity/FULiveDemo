//
//  FUNormalItemController.h
//  FULiveDemo
//
//  Created by 孙慕 on 2019/1/31.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//
/* 加道具切换 */

#import "FUBaseViewController.h"
#import "FUStickerDefine.h"
NS_ASSUME_NONNULL_BEGIN

@interface FUNormalItemController : FUBaseViewController

/**
 * 默认是贴纸道具类
 * 需要根据业务来自行对应类型
 */
@property (assign, nonatomic) FUStickerType type;

@end

NS_ASSUME_NONNULL_END
