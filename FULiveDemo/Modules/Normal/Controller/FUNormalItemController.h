//
//  FUNormalItemController.h
//  FULiveDemo
//
//  Created by 孙慕 on 2019/1/31.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//
/* 加道具切换 */

#import "FUBaseViewController.h"
#import "FUItemsView.h"
NS_ASSUME_NONNULL_BEGIN

@interface FUNormalItemController : FUBaseViewController<FUItemsViewDelegate>
@property (strong, nonatomic) FUItemsView *itemsView;
@end

NS_ASSUME_NONNULL_END
