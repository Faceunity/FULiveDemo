//
//  FUPosterController.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/1/31.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import "FUPosterController.h"
#import "FUSaveViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "FUEditImageViewController.h"
#import "UIImage+FU.h"
#import "FULiveDefine.h"

@interface FUPosterController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation FUPosterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupView];
    
    self.headButtonView.selectedImageBtn.hidden = NO;
    
    [self.headButtonView.selectedImageBtn setImage:[UIImage imageNamed:@"相册icon"] forState:UIControlStateNormal];
}

-(void)setupView{
    [self.headButtonView.mHomeBtn setImage:[UIImage imageNamed:@"save_nav_back_n"] forState:UIControlStateNormal];
    
    [self.photoBtn setType:FUPhotoButtonTypeTakePhoto];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"face_contour"]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.frame = self.view.bounds;
    [self.view addSubview:imageView];
    [self.view insertSubview:imageView atIndex:1];
    
    self.tipLabel.text = FUNSLocalizedString(@"对准线框 正脸拍摄", nil);
    self.tipLabel.font = [UIFont systemFontOfSize:13];
    self.tipLabel.hidden = NO;
    [self.tipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.noTrackLabel.mas_bottom).offset(100);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(22);
    }];
}

/* 海报拍照后不急保存，重载父方法 */
-(void)takePhotoToSave:(UIImage *)image{
    FUSaveViewController *vc = [[FUSaveViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.type = self.model.type;
    vc.mImage = image;
    [self.navigationController pushViewController:vc animated:YES];
}

/* 不需要进入分辨率选择 */
-(BOOL)onlyJumpImage{
    return YES;
}

#pragma  mark - 选择照片
-(void)didClickSelPhoto{
    
    [self showImagePickerWithMediaType:(NSString *)kUTTypeImage];
    
}

- (void)showImagePickerWithMediaType:(NSString *)mediaType {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.allowsEditing = NO;
    picker.mediaTypes = @[mediaType] ;
    [self presentViewController:picker animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // 关闭相册
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    CGFloat imagePixel = image.size.width * image.size.height;
    // 超过限制像素需要压缩
    if (imagePixel > FUPicturePixelMaxSize) {
        CGFloat ratio = FUPicturePixelMaxSize / imagePixel * 1.0;
        image = [image fu_compress:ratio];
    }
    // 图片转正
    if (image.imageOrientation != UIImageOrientationUp && image.imageOrientation != UIImageOrientationUpMirrored) {
        image = [image fu_resetImageOrientationToUp];
    }
    FUEditImageViewController *vc = [[FUEditImageViewController alloc] initWithNibName:@"FUEditImageViewController" bundle:nil];
    vc.view.backgroundColor = [UIColor blackColor];
    vc.PushFrom = FUEditImagePushFromAlbum;
    [self.navigationController pushViewController:vc animated:YES];
    vc.mPhotoImage = image;
}

@end
