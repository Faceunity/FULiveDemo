//
//  FUMediaPickerViewController.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/8/8.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "FUMediaPickerViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUMediaPickerViewController : UIViewController

- (instancetype)initWithViewModel:(FUMediaPickerViewModel *)viewModel;

/// 初始化
/// @param viewModel FUMediaPickerViewModel
/// @param handler 选择图片/视频回调
- (instancetype)initWithViewModel:(FUMediaPickerViewModel *)viewModel
             selectedMediaHandler:(nullable void (^)(NSDictionary<UIImagePickerControllerInfoKey,id> *info))handler;

@end

NS_ASSUME_NONNULL_END
