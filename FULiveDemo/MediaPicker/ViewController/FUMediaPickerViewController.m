//
//  FUMediaPickerViewController.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/8/8.
//

#import "FUMediaPickerViewController.h"
#import "FUBeautyImageRenderViewController.h"
#import "FUBeautyVideoRenderViewController.h"
#import "FUMakeupImageRenderViewController.h"
#import "FUMakeupVideoRenderViewController.h"
#import "FUStyleImageRenderViewController.h"
#import "FUStyleVideoRenderViewController.h"
#import "FUStickerImageRenderViewController.h"
#import "FUStickerVideoRenderViewController.h"
#import "FUGreenScreenImageRenderViewController.h"
#import "FUGreenScreenVideoRenderViewController.h"

#import <Photos/Photos.h>

@interface FUMediaPickerViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) UIButton *imageSelectionButton;
@property (strong, nonatomic) UIButton *videoSelectionButton;
@property (strong, nonatomic) UILabel  *messageLabel;

@property (nonatomic, strong) FUMediaPickerViewModel *viewModel;

@property (nonatomic, copy) void (^mediaCallBack)(NSDictionary<UIImagePickerControllerInfoKey,id> *info);

@end

@implementation FUMediaPickerViewController

- (instancetype)initWithViewModel:(FUMediaPickerViewModel *)viewModel {
    return [self initWithViewModel:viewModel selectedMediaHandler:nil];
}

- (instancetype)initWithViewModel:(FUMediaPickerViewModel *)viewModel selectedMediaHandler:(void (^)(NSDictionary<UIImagePickerControllerInfoKey,id> *))handler {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
        self.mediaCallBack = handler;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureUI];
}

#pragma mark - UI

- (void)configureUI {
    self.view.backgroundColor = [UIColor blackColor];
    
    UIButton *backButton = [[UIButton alloc] init];
    [backButton setImage:[UIImage imageNamed:@"back_item"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(20);
        } else {
            make.top.equalTo(self.view.mas_top).offset(30);
        }
        make.leading.equalTo(self.view).offset(10);
        make.size.mas_offset(CGSizeMake(44, 44));
    }];
    
    [self.view addSubview:self.imageSelectionButton];
    [self.imageSelectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_offset(CGSizeMake(235, 48));
    }];
    
    [self.view addSubview:self.videoSelectionButton];
    [self.videoSelectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.imageSelectionButton.mas_bottom).mas_offset(44);
        make.size.mas_offset(CGSizeMake(235, 48));
    }];
    
    [self.view addSubview:self.messageLabel];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading).mas_offset(20);
        make.trailing.equalTo(self.view.mas_trailing).mas_offset(-20);
        make.bottom.equalTo(self.imageSelectionButton.mas_top).mas_offset(-74);
    }];
}

#pragma mark - Event response

- (void)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)imageSelectionAction:(UIButton *)sender {
    [self selectWithMediaType:(NSString *)kUTTypeImage];
}

- (void)videoSelectionAction:(UIButton *)sender {
    [self selectWithMediaType:(NSString *)kUTTypeMovie];
}

- (void)selectWithMediaType:(NSString *)type {
    if (@available(iOS 14, *)) {
        [PHPhotoLibrary requestAuthorizationForAccessLevel:PHAccessLevelReadWrite handler:^(PHAuthorizationStatus status) {
            [self handleAuthorizationStatus:status mediaType:type];
        }];
    } else {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            [self handleAuthorizationStatus:status mediaType:type];
        }];
    }
}

- (void)handleAuthorizationStatus:(PHAuthorizationStatus)status mediaType:(NSString *)type {
    if (status == PHAuthorizationStatusAuthorized) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            picker.allowsEditing = NO;
            picker.mediaTypes = @[type];
            picker.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:picker animated:YES completion:nil];
        });
    } else {
        // 需要用户主动打开相册权限
        dispatch_async(dispatch_get_main_queue(), ^{
            [FUAlertManager showAlertWithTitle:nil message:FULocalizedString(@"photo_library_authorization_tips") cancel:FULocalizedString(@"取消") confirm:FULocalizedString(FULocalizedString(@"确定")) inController:self confirmHandler:^{
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            } cancelHandler:nil];
        });
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    [picker dismissViewControllerAnimated:NO completion:nil];
    if (self.mediaCallBack) {
        self.mediaCallBack(info);
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        NSString *mediaType = info[UIImagePickerControllerMediaType];
        if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
            UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
            // 图片处理
            image = [image fu_processedImage];
            [self pushToImageRender:image];
        } else {
            // 获取视频地址
            [FUUtility requestVideoURLFromInfo:info resultHandler:^(NSURL * _Nonnull videoURL) {
                if (videoURL) {
                    [self pushToVideoRender:videoURL];
                }
            }];
        }
    }
}

- (void)pushToImageRender:(UIImage *)image {
    dispatch_async(dispatch_get_main_queue(), ^{
        FUImageRenderViewController *controller;
        switch (self.viewModel.module) {
            case FUModuleBeauty:{
                controller = [[FUBeautyImageRenderViewController alloc] initWithViewModel:[[FUBeautyImageRenderViewModel alloc] initWithImage:image]];
            }
                break;
            case FUModuleMakeup:{
                controller = [[FUMakeupImageRenderViewController alloc] initWithViewModel:[[FUMakeupImageRenderViewModel alloc] initWithImage:image]];
            }
                break;
            case FUModuleStyle:{
                controller = [[FUStyleImageRenderViewController alloc] initWithViewModel:[[FUStyleImageRenderViewModel alloc] initWithImage:image]];
            }
                break;
            case FUModuleSticker:{
                controller = [[FUStickerImageRenderViewController alloc] initWithViewModel:[[FUStickerImageRenderViewModel alloc] initWithImage:image]];
            }
                break;
            case FUModuleGreenScreen:{
                controller = [[FUGreenScreenImageRenderViewController alloc] initWithViewModel:[[FUGreenScreenImageRenderViewModel alloc] initWithImage:image]];
            }
                break;
            default:
                break;
        }
        [self.navigationController pushViewController:controller animated:YES];
    });
}

- (void)pushToVideoRender:(NSURL *)videoURL {
    dispatch_async(dispatch_get_main_queue(), ^{
        FUVideoRenderViewController *controller;
        switch (self.viewModel.module) {
            case FUModuleBeauty:{
                controller = [[FUBeautyVideoRenderViewController alloc] initWithViewModel:[[FUBeautyVideoRenderViewModel alloc] initWithVideoURL:videoURL]];
            }
                break;
            case FUModuleMakeup:{
                controller = [[FUMakeupVideoRenderViewController alloc] initWithViewModel:[[FUMakeupVideoRenderViewModel alloc] initWithVideoURL:videoURL]];
            }
                break;
            case FUModuleStyle:{
                controller = [[FUStyleVideoRenderViewController alloc] initWithViewModel:[[FUStyleVideoRenderViewModel alloc] initWithVideoURL:videoURL]];
            }
                break;
            case FUModuleSticker:{
                controller = [[FUStickerVideoRenderViewController alloc] initWithViewModel:[[FUStickerVideoRenderViewModel alloc] initWithVideoURL:videoURL]];
            }
                break;
            case FUModuleGreenScreen:{
                controller = [[FUGreenScreenVideoRenderViewController alloc] initWithViewModel:[[FUGreenScreenVideoRenderViewModel alloc] initWithVideoURL:videoURL]];
            }
                break;
            default:
                break;
        }
        [self.navigationController pushViewController:controller animated:YES];
    });
}

#pragma mark - Getters

- (UIButton *)imageSelectionButton {
    if (!_imageSelectionButton) {
        _imageSelectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_imageSelectionButton setImage:[UIImage imageNamed:@"media_picker_image_selection"] forState:UIControlStateNormal];
        [_imageSelectionButton setBackgroundImage:[UIImage imageNamed:@"media_picker_button_background"] forState:UIControlStateNormal];
        [_imageSelectionButton setTitle:FULocalizedString(@"选择图片") forState:UIControlStateNormal];
        [_imageSelectionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_imageSelectionButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.6] forState:UIControlStateHighlighted];
        [_imageSelectionButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -5)];
        [_imageSelectionButton setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
        [_imageSelectionButton addTarget:self action:@selector(imageSelectionAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _imageSelectionButton;
}

- (UIButton *)videoSelectionButton {
    if (!_videoSelectionButton) {
        _videoSelectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_videoSelectionButton setImage:[UIImage imageNamed:@"media_picker_video_selection"] forState:UIControlStateNormal];
        [_videoSelectionButton setBackgroundImage:[UIImage imageNamed:@"media_picker_button_background"] forState:UIControlStateNormal];
        [_videoSelectionButton setTitle:FULocalizedString(@"选择视频") forState:UIControlStateNormal];
        [_videoSelectionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_videoSelectionButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.6] forState:UIControlStateHighlighted];
        [_videoSelectionButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -5)];
        [_videoSelectionButton setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
        [_videoSelectionButton addTarget:self action:@selector(videoSelectionAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _videoSelectionButton;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.textColor = [UIColor whiteColor];
        _messageLabel.font = [UIFont systemFontOfSize:17];
        _messageLabel.text = FULocalizedString(@"请从相册中选择图片或视频");
        _messageLabel.numberOfLines = 0;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _messageLabel;
}

#pragma mark - Overriding

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
