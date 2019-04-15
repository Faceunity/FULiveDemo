//
//  FUSelectedImageController.m
//  FULiveDemo
//
//  Created by L on 2018/7/2.
//  Copyright © 2018年 L. All rights reserved.
//

#import "FUSelectedImageController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "FURenderImageViewController.h"
#import "FUManager.h"
#import "FULiveModel.h"
#import "FUEditImageViewController.h"
#import <Masonry.h>

@interface FUSelectedImageController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (strong, nonatomic) UIButton *mSelImageBtn;
@property (strong, nonatomic) UIButton *mSelVideoBtn;
@property (strong, nonatomic) UILabel  *mLablel;

@end

@implementation FUSelectedImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self setupView];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)setupView{
    UIButton *backBtn = [[UIButton alloc] init];
    [backBtn setImage:[UIImage imageNamed:@"back_btn_normal"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(20);
        } else {
            make.top.equalTo(self.view.mas_top).offset(30);
        }
        make.left.equalTo(self.view).offset(10);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];
    
    _mSelImageBtn = [[UIButton alloc] init];
    [_mSelImageBtn setImage:[UIImage imageNamed:@"选择相册icon"] forState:UIControlStateNormal];
    [_mSelImageBtn setBackgroundImage:[UIImage imageNamed:@"selectedBg"] forState:UIControlStateNormal];
    [_mSelImageBtn setTitle:NSLocalizedString(@"sel_Photo",nil) forState:UIControlStateNormal];
    [_mSelImageBtn addTarget:self action:@selector(selectedImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_mSelImageBtn];
    [_mSelImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(self.view);
        make.width.mas_equalTo(235);
        make.height.mas_equalTo(48);
    }];
    
    _mSelVideoBtn = [[UIButton alloc] init];
    [_mSelVideoBtn setImage:[UIImage imageNamed:@"视频icon"] forState:UIControlStateNormal];
    [_mSelVideoBtn setBackgroundImage:[UIImage imageNamed:@"selectedBg"] forState:UIControlStateNormal];
    [_mSelVideoBtn setTitle:NSLocalizedString(@"sel_Video",nil) forState:UIControlStateNormal];
    [_mSelVideoBtn addTarget:self action:@selector(selectedVideo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_mSelVideoBtn];
    [_mSelVideoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(_mSelImageBtn.mas_bottom).offset(44);
        make.width.mas_equalTo(235);
        make.height.mas_equalTo(48);
    }];
    
    _mLablel = [[UILabel alloc] init];
    _mLablel.textColor = [UIColor whiteColor];
    _mLablel.font = [UIFont systemFontOfSize:17];
    _mLablel.textAlignment = NSTextAlignmentCenter;
    _mLablel.text = NSLocalizedString(@"Choose_photo_or_video_from_your_album",nil);
    [self.view addSubview:_mLablel];
    [_mLablel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_mSelImageBtn.mas_top).offset(-44);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(22);
    }];
}


- (void)selectedImage:(UIButton *)sender {
    [self showImagePickerWithMediaType:(NSString *)kUTTypeImage];
}

- (void)selectedVideo:(UIButton *)sender {
    
    [self showImagePickerWithMediaType:(NSString *)kUTTypeMovie];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // 关闭相册
    [picker dismissViewControllerAnimated:NO completion:^{
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        
        if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]){  //视频
            NSURL *videoURL = info[UIImagePickerControllerMediaURL];
            FURenderImageViewController *renderView = [[FURenderImageViewController alloc] init];
            renderView.videoURL = videoURL;
            [self.navigationController pushViewController:renderView animated:YES];
            
        }else if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) { //照片
            
            UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
            
            // 图片转正
            if (image.imageOrientation != UIImageOrientationUp && image.imageOrientation != UIImageOrientationUpMirrored) {
                
                UIGraphicsBeginImageContext(CGSizeMake(image.size.width * 0.5, image.size.height * 0.5));
                
                [image drawInRect:CGRectMake(0, 0, image.size.width * 0.5, image.size.height * 0.5)];
                
                image = UIGraphicsGetImageFromCurrentImageContext();
                
                UIGraphicsEndImageContext();
            }
            
            FURenderImageViewController *renderView = [[FURenderImageViewController alloc] init];
            renderView.image = image;
            [self.navigationController pushViewController:renderView animated:YES];
        }
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    // 关闭相册
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)showImagePickerWithMediaType:(NSString *)mediaType {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.allowsEditing = NO;
    picker.mediaTypes = @[mediaType] ;
    [self presentViewController:picker animated:YES completion:nil];
}

// 返回
- (void)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
