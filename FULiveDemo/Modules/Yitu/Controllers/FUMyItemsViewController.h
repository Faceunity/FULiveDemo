//
//  FUMyItemsViewController.h
//  FULiveDemo
//
//  Created by L on 2018/3/1.
//  Copyright © 2018年 刘洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FUMyItemsViewDelegate <NSObject>

@optional
- (void)myItemViewDidDelete;

@end

@interface FUMyItemsViewController : UIViewController

@property (nonatomic, assign) id<FUMyItemsViewDelegate>mDelegate ;
@end
