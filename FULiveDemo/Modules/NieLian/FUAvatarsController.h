//
//  FUMyItemsViewController.h
//  FULiveDemo
//
//  Created by L on 2018/3/1.
//  Copyright © 2018年 刘洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FUAvatarsControllerDelegate <NSObject>

@optional
- (void)myItemViewDidDelete;

@end

@interface FUAvatarsController : UIViewController

@property (nonatomic, assign) id<FUAvatarsControllerDelegate>mDelegate ;
@end
