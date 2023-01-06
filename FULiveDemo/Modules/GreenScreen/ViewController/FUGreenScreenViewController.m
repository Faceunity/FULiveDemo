//
//  FUGreenScreenViewController.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/8/1.
//

#import "FUGreenScreenViewController.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <FUGreenScreenComponent/FUGreenScreenComponentManager.h>


@interface FUGreenScreenViewController ()<FUGreenScreenComponentDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong, readonly) FUGreenScreenViewModel *viewModel;

@end

@implementation FUGreenScreenViewController

@dynamic viewModel;

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 加载绿幕
    [[FUGreenScreenComponentManager sharedManager] loadGreenScreen];
    
    [FUTipHUD showTips:FULocalizedString(@"green_screen_effect_tips")];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 添加绿幕视图
    [[FUGreenScreenComponentManager sharedManager] addComponentViewToView:self.view];
    [FUGreenScreenComponentManager sharedManager].displayView = self.renderView;
    [FUGreenScreenComponentManager sharedManager].delegate = self;
    // 更新拍照/录制按钮位置
    [self updateBottomConstraintsOfCaptureButton:[FUGreenScreenComponentManager sharedManager].componentViewHeight];
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
    [self updateBottomConstraintsOfCaptureButton:height];
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

#pragma mark - FUHeadButtonViewDelegate

- (void)headButtonViewBackAction:(UIButton *)btn {
    [FUGreenScreenComponentManager destory];
    [super headButtonViewBackAction:btn];
}

@end
