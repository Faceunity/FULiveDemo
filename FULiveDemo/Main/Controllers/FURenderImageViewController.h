//
//  FURenderImageViewController.h
//  FULiveDemo
//
//  Created by L on 2018/6/22.
//  Copyright © 2018年 L. All rights reserved.
//
/* 相片·视频处理控制器 */
#import <UIKit/UIKit.h>
#import "FULiveModel.h"

@interface FURenderImageViewController : UIViewController

/* 相片 */
@property (nonatomic, strong) UIImage *image;
/* 本地视频路径 */
@property (nonatomic, strong) NSURL *videoURL;

@end
