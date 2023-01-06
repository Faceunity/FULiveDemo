//
//  FUFaceFusionCaptureViewController.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/9/2.
//

#import "FUFaceFusionCaptureViewController.h"
#import "FUFaceFusionCaptureResultViewController.h"
#import "FUFaceFusionEffectViewController.h"

#import "FUFaceFusionManager.h"

#import <MobileCoreServices/MobileCoreServices.h>

@interface FUFaceFusionCaptureViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation FUFaceFusionCaptureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.headButtonView.homeButton setImage:[UIImage imageNamed:@"back_item"] forState:UIControlStateNormal];
    
    // 人脸区域视图
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"face_fusion_contour"]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.frame = self.view.bounds;
    [self.view insertSubview:imageView atIndex:1];
    
    UILabel *tips = [[UILabel alloc] init];
    tips.text = FULocalizedString(@"对准线框 正脸拍摄");
    tips.textColor = [UIColor whiteColor];
    tips.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:tips];
    [tips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view.mas_centerY).mas_offset(160);
    }];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    // 图片处理
    image = [image fu_processedImage];
    [FUFaceFusionManager sharedManager].image = image;
    [FUFaceFusionManager sharedManager].imageSource = FUFaceFusionImageSourceAlbum;
    // 相册选择直接进入人脸融合效果页面
    FUFaceFusionEffectViewController *effectController = [[FUFaceFusionEffectViewController alloc] init];
    [self.navigationController pushViewController:effectController animated:YES];
}

#pragma mark - Overriding

- (void)renderShouldCheckDetectingStatus:(FUDetectingParts)parts {
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL result = [FURenderKitManager faceTracked];
        if (!result) {
            self.noTrackLabel.text = FULocalizedString(@"未检测到人脸");
        } else {
            if (self.viewModel.trackedCompleteFace) {
                self.noTrackLabel.hidden = YES;
            } else {
                self.noTrackLabel.text = FULocalizedString(@"Incomplete_face");
                self.noTrackLabel.hidden = NO;
            }
        }
    });
}

- (void)captureButtonDidTakePhoto {
    UIImage *image = [FURenderKit captureImage];
    [FUFaceFusionManager sharedManager].image = image;
    // 拍照需要先进入拍照结果页面
    FUFaceFusionCaptureResultViewController *controller = [[FUFaceFusionCaptureResultViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)headButtonViewSelImageAction:(UIButton *)btn {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.allowsEditing = NO;
    picker.mediaTypes = @[(NSString *)kUTTypeImage];
    [self presentViewController:picker animated:YES completion:nil];
}

@end
