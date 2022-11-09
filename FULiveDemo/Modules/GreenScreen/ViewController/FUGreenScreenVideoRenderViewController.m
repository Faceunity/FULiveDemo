//
//  FUGreenScreenVideoRenderViewController.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/8/15.
//

#import "FUGreenScreenVideoRenderViewController.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <FUGreenScreenComponent/FUGreenScreenComponentManager.h>

#import "UIImage+FU.h"

@interface FUGreenScreenVideoRenderViewController ()<FUGreenScreenComponentDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation FUGreenScreenVideoRenderViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 添加绿幕视图
    [[FUGreenScreenComponentManager sharedManager] addComponentViewToView:self.view];
    [FUGreenScreenComponentManager sharedManager].displayView = self.renderView;
    [FUGreenScreenComponentManager sharedManager].delegate = self;
    // 更新保存按钮位置
    [self updateBottomConstraintsOfDownloadButton:[FUGreenScreenComponentManager sharedManager].componentViewHeight + 10 hidden:[FUGreenScreenComponentManager sharedManager].selectedIndex == -1 animated:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // 移除绿幕视图
    [[FUGreenScreenComponentManager sharedManager] removeComponentView];
    [FUGreenScreenComponentManager sharedManager].displayView = nil;
    [FUGreenScreenComponentManager sharedManager].delegate = nil;
}

#pragma mark - FUGreenScreenComponentDelegate

- (void)greenScreenComponentDidCustomizeSafeArea {
    // 相册选择安全区域图片
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.allowsEditing = NO;
    picker.mediaTypes = @[(NSString *)kUTTypeImage];
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)greenScreenComponentViewHeightDidChange:(CGFloat)height {
    // 绿幕视图高度变化时需要更新拍照/录制按钮的位置
    [self updateBottomConstraintsOfDownloadButton:height + 10 hidden:[FUGreenScreenComponentManager sharedManager].selectedIndex == -1 animated:YES];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (!image) {
            return;
        }
        image = [image fu_processedImage];
        // 保存自定义安全区域图片
        [[FUGreenScreenComponentManager sharedManager] saveCustomSafeArea:image];
    }];
}


@end
