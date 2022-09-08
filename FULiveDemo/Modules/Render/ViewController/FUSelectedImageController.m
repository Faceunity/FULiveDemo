//
//  FUSelectedImageController.m
//  FULiveDemo
//
//  Created by L on 2018/7/2.
//  Copyright © 2018年 L. All rights reserved.
//

#import "FUSelectedImageController.h"
#import "FUBeautyRenderMediaViewController.h"
#import "FUMakeupRenderMediaViewController.h"
#import "FUStickerRenderMediaViewController.h"
#import "FUGreenScreenRenderMediaViewController.h"
#import "FUBodyBeautyRenderMediaViewController.h"

#import "UIImage+FU.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <Photos/Photos.h>

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
    [_mSelImageBtn setTitle:FUNSLocalizedString(@"sel_Photo",nil) forState:UIControlStateNormal];
    [_mSelImageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_mSelImageBtn setTitleColor:[UIColor colorWithWhite:1 alpha:0.6] forState:UIControlStateHighlighted];
    [_mSelImageBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -5)];
    [_mSelImageBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
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
    [_mSelVideoBtn setTitle:FUNSLocalizedString(@"sel_Video",nil) forState:UIControlStateNormal];
    [_mSelVideoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_mSelVideoBtn setTitleColor:[UIColor colorWithWhite:1 alpha:0.6] forState:UIControlStateHighlighted];
    [_mSelVideoBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -5)];
    [_mSelVideoBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
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
    _mLablel.text = FUNSLocalizedString(@"Choose_photo_or_video_from_your_album",nil);
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(imagePicker:didFinishWithInfo:)]) {
        [self.delegate imagePicker:picker didFinishWithInfo:info];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    // 关闭相册
    [picker dismissViewControllerAnimated:NO completion:^{
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        
        if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]){  //视频
            __block NSURL *videoURL = info[UIImagePickerControllerMediaURL];
            if (!videoURL) {
                if (info[UIImagePickerControllerReferenceURL]) {
                    NSURL *refrenceURL = info[UIImagePickerControllerReferenceURL];
                    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsWithALAssetURLs:@[refrenceURL] options:nil];
                    [[PHImageManager defaultManager] requestAVAssetForVideo:assets.firstObject options:nil resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                        AVURLAsset *urlAsset = (AVURLAsset *)asset;
                        videoURL = urlAsset.URL;
                        [self selectVideo:videoURL];
                    }];
                } else {
                    if (@available(iOS 11.0, *)) {
                        PHAsset *asset = info[UIImagePickerControllerPHAsset];
                        [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:nil resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                            AVURLAsset *urlAsset = (AVURLAsset *)asset;
                            videoURL = urlAsset.URL;
                            [self selectVideo:videoURL];
                        }];
                    }
                }
            } else {
                [self selectVideo:videoURL];
            }
        } else if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) { //照片
            
            UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
            
            if (!image) {
                return;
            }
            
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
            switch (self.type) {
                case FUModuleTypeBeauty:{
                    FUBeautyRenderMediaViewController *renderController = [[FUBeautyRenderMediaViewController alloc] initWithImage:image];
                    [self.navigationController pushViewController:renderController animated:YES];
                }
                    break;
                case FUModuleTypeMakeup:{
                    FUMakeupRenderMediaViewController *renderController = [[FUMakeupRenderMediaViewController alloc] initWithImage:image];
                    [self.navigationController pushViewController:renderController animated:YES];
                }
                    break;
                case FUModuleTypeSticker:{
                    FUStickerRenderMediaViewController *renderController = [[FUStickerRenderMediaViewController alloc] initWithImage:image];
                    [self.navigationController pushViewController:renderController animated:YES];
                }
                    break;
                case FUModuleTypeGreenScreen: {
                    FUGreenScreenRenderMediaViewController *renderController = [[FUGreenScreenRenderMediaViewController alloc] initWithImage:image];
                    [self.navigationController pushViewController:renderController animated:YES];
                }
                    break;
                case FUModuleTypeBody: {
                    FUBodyBeautyRenderMediaViewController *renderController = [[FUBodyBeautyRenderMediaViewController alloc] initWithImage:image];
                    [self.navigationController pushViewController:renderController animated:YES];
                }
                    break;
                default:
                    break;
            }
        }
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    // 关闭相册
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)selectVideo:(NSURL *)videoURL {
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (self.type) {
            case FUModuleTypeBeauty:{
                FUBeautyRenderMediaViewController *renderController = [[FUBeautyRenderMediaViewController alloc] initWithVideoURL:videoURL];
                [self.navigationController pushViewController:renderController animated:YES];
            }
                break;
            case FUModuleTypeMakeup:{
                FUMakeupRenderMediaViewController *renderController = [[FUMakeupRenderMediaViewController alloc] initWithVideoURL:videoURL];
                [self.navigationController pushViewController:renderController animated:YES];
            }
                break;
            case FUModuleTypeSticker:{
                FUStickerRenderMediaViewController *renderController = [[FUStickerRenderMediaViewController alloc] initWithVideoURL:videoURL];
                [self.navigationController pushViewController:renderController animated:YES];
            }
                break;
            case FUModuleTypeGreenScreen: {
                FUGreenScreenRenderMediaViewController *renderController = [[FUGreenScreenRenderMediaViewController alloc] initWithVideoURL:videoURL];
                [self.navigationController pushViewController:renderController animated:YES];
            }
                break;
            case FUModuleTypeBody: {
                FUBodyBeautyRenderMediaViewController *renderController = [[FUBodyBeautyRenderMediaViewController alloc] initWithVideoURL:videoURL];
                [self.navigationController pushViewController:renderController animated:YES];
            }
                break;
            default:
                break;
        }
    });
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
    if (self.didCancel) {
        self.didCancel();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
