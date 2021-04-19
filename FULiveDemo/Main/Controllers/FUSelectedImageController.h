//
//  FUSelectedImageController.h
//  FULiveDemo
//
//  Created by L on 2018/7/2.
//  Copyright © 2018年 L. All rights reserved.
//
/* 本地图片·视频选择控制器 */

#import <UIKit/UIKit.h>

typedef void(^FUImagePickerselCancel)(void);

@protocol FUImagePickerDataDelegate <NSObject>

- (void)imagePicker:(UIImagePickerController *)picker didFinishWithInfo:(NSDictionary<NSString *,id> *)info;
@end

@interface FUSelectedImageController : UIViewController

@property (nonatomic, assign) id<FUImagePickerDataDelegate> delegate;

@property(nonatomic,copy) FUImagePickerselCancel didCancel;

@end
