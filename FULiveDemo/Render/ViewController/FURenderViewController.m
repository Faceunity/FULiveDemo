//
//  FURenderViewController.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/7/19.
//  Copyright © 2022 FaceUnity. All rights reserved.
//

#import "FURenderViewController.h"
#import "FUMediaPickerViewController.h"
#import "FUHeadButtonView.h"
#import "FUCaptureButton.h"
#import "FULightingView.h"
#import "FUPopupMenu.h"
#import "FULandmarkManager.h"

@interface FURenderViewController ()<FUPopupMenuDelegate, FULightingViewDelegate>

/// 渲染视图
@property (nonatomic, strong) FUGLDisplayView *renderView;
/// 顶部功能视图
@property (nonatomic, strong) FUHeadButtonView *headButtonView;
/// 拍照和录制视频按钮
@property (nonatomic, strong) FUCaptureButton *captureButton;
/// 曝光度调节器
@property (nonatomic, strong) FULightingView *lightingView;
/// 手动对焦指示器
@property (nonatomic, strong) UIImageView *adjustImageView;
/// debug信息标签
@property (nonatomic, strong) FUInsetsLabel *buglyLabel;

@property (nonatomic, strong) UILabel *noTrackLabel;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) FURenderViewModel *viewModel;

@end

@implementation FURenderViewController {
    // 对焦点击操作记录时间
    CFAbsoluteTime operatedTime;
}

#pragma mark - Initializer

- (instancetype)initWithViewModel:(FURenderViewModel *)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
        self.viewModel.delegate = self;
    }
    return self;
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 加载美颜
    if (self.viewModel.needsLoadingBeauty) {
        [[FUBeautyComponentManager sharedManager] loadBeauty];
    }
    
    [self configureUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 每次进入页面或者返回页面都需要重新设置人脸和人体检测模式
    if (self.viewModel.necessaryAIModelTypes & FUAIModelTypeFace) {
        [FURenderKitManager setFaceProcessorDetectMode:FUFaceProcessorDetectModeVideo];
    }
    if (self.viewModel.necessaryAIModelTypes & FUAIModelTypeHuman) {
        [FURenderKitManager setHumanProcessorDetectMode:FUHumanProcessorDetectModeVideo];
    }
    
    [self.viewModel startCameraWithRenderView:self.renderView];
    
    // 添加点位测试开关
    if ([FURenderKitManager sharedManager].showsLandmarks) {
        [FULandmarkManager show];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.viewModel stopCamera];
    [self.viewModel resetCameraFocusAndExposureMode];
    
    // 移除点位测试开关
    if ([FURenderKitManager sharedManager].showsLandmarks) {
        [FULandmarkManager dismiss];
    }
}

- (void)dealloc {
    if (self.viewModel.needsLoadingBeauty) {
        [FUBeautyComponentManager destory];
    }
}


#pragma mark - UI

- (void)configureUI {
    self.view.backgroundColor = [UIColor colorWithRed:17/255.0 green:18/255.0 blue:38/255.0 alpha:1.0];
    
    [self.view addSubview:self.renderView];
    [self.renderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            if(FUDeviceIsiPhoneXStyle()) {
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).mas_offset(-50);
            } else {
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            }
        } else {
            make.top.equalTo(self.view.mas_top);
            make.bottom.equalTo(self.view.mas_bottom);
        }
        make.leading.trailing.equalTo(self.view);
    }];
    
    [self.view addSubview:self.headButtonView];
    [self.headButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(15);
        } else {
            make.top.equalTo(self.view.mas_top).offset(30);
        }
        make.leading.trailing.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
    [self.view addSubview:self.buglyLabel];
    [self.buglyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headButtonView.mas_bottom).offset(15);
        make.leading.equalTo(self.view).offset(10);
    }];
    
    [self.view addSubview:self.lightingView];
    [self.view addSubview:self.adjustImageView];
    
    [self.view addSubview:self.noTrackLabel];
    [self.noTrackLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
    [self.view addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY).mas_offset(24);
        make.centerX.equalTo(self.view);
    }];
    
    [self.view addSubview:self.captureButton];
    [self.captureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).mas_offset(-FUHeightIncludeBottomSafeArea(10));
        make.size.mas_offset(CGSizeMake(81, 81));
    }];
}

#pragma mark - Instance methods

- (void)updateBottomConstraintsOfCaptureButton:(CGFloat)constant animated:(BOOL)animated {
    [self.captureButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).mas_offset(-constant);
    }];
    if (animated) {
        [UIView animateWithDuration:0.15 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

#pragma mark - Private methods

/// 延迟隐藏视图
- (void)hideFocusAndLightingViewAfterDelay:(NSTimeInterval)deley {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(deley * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CFAbsoluteTime currentTime = CFAbsoluteTimeGetCurrent();
        if (currentTime - self->operatedTime > 1.29) {
            self.lightingView.hidden = YES;
            self.adjustImageView.hidden = YES;
        }
    });
}

#pragma mark - Event response

- (void)renderViewTapAction:(UITapGestureRecognizer *)tap {
    operatedTime = CFAbsoluteTimeGetCurrent();
    self.lightingView.hidden = NO;
    self.adjustImageView.hidden = NO;
    [self.viewModel switchCameraFocusMode:FUCaptureCameraFocusModeChangeless];
    CGPoint center = [tap locationInView:self.renderView];
    self.adjustImageView.center = center;
    // 缩放动画
    self.adjustImageView.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.3 animations:^{
        self.adjustImageView.transform = CGAffineTransformMakeScale(0.67, 0.67);
    } completion:^(BOOL finished) {
        [self hideFocusAndLightingViewAfterDelay:1.1];
    }];
    // 根据renderView的填充模式计算图像中心点
    CGPoint pictureCenter;
    CGFloat scale = self.viewModel.inputBufferHeight / self.viewModel.inputBufferWidth;
    CGFloat renderViewWidth = CGRectGetWidth(self.renderView.bounds);
    CGFloat renderViewHeight = CGRectGetHeight(self.renderView.bounds);
    if (self.renderView.contentMode == FUGLDisplayViewContentModeScaleAspectFill) {
        // 短边填满(宽度按比例截取中间部分)
        CGFloat leading = (renderViewHeight / scale - renderViewWidth) / 2.0;
        CGFloat pictureWidth = renderViewWidth + leading * 2;
        center.x += leading;
        if (center.y <= 0) {
            return;
        }
        pictureCenter = CGPointMake(center.y / renderViewHeight, self.viewModel.captureDevicePostion == AVCaptureDevicePositionFront ? center.x / pictureWidth : 1 - center.x / pictureWidth);
    } else if (self.renderView.contentMode == FUGLDisplayViewContentModeScaleAspectFit) {
        // 长边填满(高度上下会留空白)
        CGFloat top = (renderViewHeight - renderViewWidth * scale) / 2.0;
        CGFloat pictureHeight = renderViewHeight - top * 2;
        center.y -= top;
        if (center.y <= 0) {
            return;
        }
        pictureCenter = CGPointMake(center.y / pictureHeight, self.viewModel.captureDevicePostion == AVCaptureDevicePositionFront ? center.x / renderViewWidth : 1 - center.x / renderViewWidth);
    } else {
        // 拉伸填满
        pictureCenter = CGPointMake(center.y / renderViewHeight, self.viewModel.captureDevicePostion == AVCaptureDevicePositionFront ? center.x / renderViewWidth : 1 - center.x / renderViewWidth);
    }
    [self.viewModel setCameraFocusPoint:pictureCenter];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *) contextInfo {
    if (error) {
        [SVProgressHUD showError:FULocalizedString(@"保存图片失败")];
    } else {
        [SVProgressHUD showSuccess:FULocalizedString(@"图片已保存到相册")];
    }
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [SVProgressHUD showError:FULocalizedString(@"保存视频失败")];
    } else {
        [SVProgressHUD showSuccess:FULocalizedString(@"视频已保存到相册")];
    }
}

#pragma mark - FURenderViewModelDelegate

- (void)renderDidOutputDebugInformations:(NSString *)informations {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.buglyLabel.hidden) {
            self.buglyLabel.text = informations;
        }
    });
}

- (void)renderShouldCheckDetectingStatus:(FUDetectingParts)parts {
    @autoreleasepool {
        BOOL detectingResult = YES;
        switch (parts) {
            case FUDetectingPartsFace:
                detectingResult = [FURenderKitManager faceTracked];
                break;
            case FUDetectingPartsHuman:
                detectingResult = [FURenderKitManager humanTracked];
                break;
            case FUDetectingPartsHand:
                detectingResult = [FURenderKitManager handTracked];
                break;
            default:
                break;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.noTrackLabel.hidden = detectingResult;
            if (!detectingResult) {
                self.noTrackLabel.text = parts == FUDetectingPartsFace ? FULocalizedString(@"未检测到人脸") : (parts == FUDetectingPartsHuman ? FULocalizedString(@"未检测到人体") : FULocalizedString(@"未检测到手势"));
            }
        });
    }
}

#pragma mark - FULightingViewDelegate

- (void)lightingViewValueDidChange:(float)value {
    operatedTime = CFAbsoluteTimeGetCurrent();
    [self hideFocusAndLightingViewAfterDelay:1.3];
    [self.viewModel setCameraExposureValue:value];
}

#pragma mark - FUHeadButtonViewDelegate

- (void)headButtonViewBackAction:(UIButton *)btn {
    // 恢复相机曝光度
    [self.viewModel setCameraExposureValue:0];
    [self.viewModel stopCamera];
    [self.viewModel resetCameraSettings];
    [FURenderKitManager clearItems];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)headButtonViewSegmentedChange:(UISegmentedControl *)sender {
    [self.viewModel switchCameraOutputFormat];
}

- (void)headButtonViewSelImageAction:(UIButton *)btn {
    if (!self.viewModel.supportPresetSelection) {
        // 直接进入图片和视频选择页面
        FUMediaPickerViewController *picker = [[FUMediaPickerViewController alloc] initWithViewModel:[[FUMediaPickerViewModel alloc] initWithModule:self.viewModel.module]];
        [self.navigationController pushViewController:picker animated:YES];
    } else {
        // 弹出视图
        CGFloat height;
        BOOL hideMediaSelection;
        if (self.viewModel.supportMediaRendering) {
            // 支持分辨率、图片或视频视图
            height = 132;
            hideMediaSelection = NO;
        } else {
            // 只支持分辨率视图
            height = 80;
            hideMediaSelection = YES;
        }
        int selectedPresetIndex = (int)[self.viewModel.presets indexOfObject:self.viewModel.capturePreset];
        [FUPopupMenu showRelyOnView:btn frame:CGRectMake(17, CGRectGetMaxY(self.headButtonView.frame) + 1, 340, height) defaultSelectedAtIndex:selectedPresetIndex onlyTop:hideMediaSelection dataSource:self.viewModel.presetTitles delegate:self];
    }
}

- (void)headButtonViewBuglyAction:(UIButton *)btn {
    self.buglyLabel.hidden = !self.buglyLabel.hidden;
}

- (void)headButtonViewSwitchAction:(UIButton *)btn {
    btn.userInteractionEnabled = NO;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
        btn.userInteractionEnabled = YES;
    });
    [self.viewModel switchCameraBetweenFrontAndRear:self.viewModel.captureDevicePostion != AVCaptureDevicePositionFront unsupportedPresetHandler:^{
        // 硬件不支持当前分辨率，则降低一个分辨率
        NSInteger currentIndex = [self.viewModel.presets indexOfObject:self.viewModel.capturePreset];
        if (currentIndex < 1) {
            return;
        }
        [self fuPopupMenuDidSelectedAtIndex:currentIndex - 1];
    }];
}

#pragma mark - FUPopupMenuDelegate

/// 选择图片或视频
- (void)fuPopupMenuDidSelectedImage {
    // 直接进入图片和视频选择页面
    FUMediaPickerViewController *picker = [[FUMediaPickerViewController alloc] initWithViewModel:[[FUMediaPickerViewModel alloc] initWithModule:self.viewModel.module]];
    [self.navigationController pushViewController:picker animated:YES];
}

/// 分辨率切换
- (void)fuPopupMenuDidSelectedAtIndex:(NSInteger)index {
    AVCaptureSessionPreset selectedPreset = self.viewModel.presets[index];
    [self.viewModel switchCapturePreset:selectedPreset unsupportedPresetHandler:^{
        [SVProgressHUD showInfo:FULocalizedString(@"设备不支持该分辨率")];
    }];
}

#pragma mark - FUCaptureButtonDelegate

- (void)captureButtonDidTakePhoto {
    UIImage *image = [FURenderKit captureImage];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
}

- (void)captureButtonDidStartRecording {
    NSString *videoPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", FUCurrentDateString()]];
    if (!videoPath) {
        return;
    }
    [FURenderKit startRecordVideoWithFilePath:videoPath];
}

- (void)captureButtonDidFinishRecording {
    @FUWeakify(self)
    [FURenderKit stopRecordVideoComplention:^(NSString * _Nonnull filePath) {
        @FUStrongify(self)
        if (!filePath) {
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            UISaveVideoAtPathToSavedPhotosAlbum(filePath, self, @selector(video:didFinishSavingWithError:contextInfo:), NULL);
        });
    }];
}

#pragma mark - Getters

- (FUGLDisplayView *)renderView {
    if (!_renderView) {
        _renderView = [[FUGLDisplayView alloc] initWithFrame:self.view.bounds];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(renderViewTapAction:)];
        [_renderView addGestureRecognizer:tap];
    }
    return _renderView;
}

- (FUHeadButtonView *)headButtonView {
    if (!_headButtonView) {
        _headButtonView = [[FUHeadButtonView alloc] init];
        _headButtonView.delegate = self;
        _headButtonView.selectedImageBtn.hidden = (!self.viewModel.supportMediaRendering && !self.viewModel.supportPresetSelection);
        _headButtonView.inputSegm.hidden = !self.viewModel.supportSwitchingOutputFormat;
        if (!_headButtonView.hidden) {
            [_headButtonView.selectedImageBtn setImage:self.viewModel.supportPresetSelection ? [UIImage imageNamed:@"render_more"] : [UIImage imageNamed:@"render_picture"] forState:UIControlStateNormal];
        }
    }
    return _headButtonView;
}

- (FUInsetsLabel *)buglyLabel {
    if (!_buglyLabel) {
        _buglyLabel = [[FUInsetsLabel alloc] initWithFrame:CGRectZero insets:UIEdgeInsetsMake(5, 5, 5, 5)];
        _buglyLabel.layer.masksToBounds = YES;
        _buglyLabel.layer.cornerRadius = 5;
        _buglyLabel.numberOfLines = 0;
        _buglyLabel.backgroundColor = [UIColor darkGrayColor];
        _buglyLabel.text = @"resolution:\n720x1280\nfps:30\nrender time:\n0ms";
        _buglyLabel.textColor = [UIColor whiteColor];
        _buglyLabel.alpha = 0.74;
        _buglyLabel.font = [UIFont systemFontOfSize:13];
        _buglyLabel.hidden = YES;
    }
    return _buglyLabel;
}

- (FULightingView *)lightingView {
    if (!_lightingView) {
        _lightingView = [[FULightingView alloc] initWithFrame:CGRectMake(0, 0, 280, 40)];
        _lightingView.center = CGPointMake(CGRectGetWidth(self.view.bounds) - 20, CGRectGetHeight(self.view.bounds) / 2.0 - 60);
        _lightingView.transform = CGAffineTransformMakeRotation(-M_PI_2);
        _lightingView.slider.minimumValue = -2;
        _lightingView.slider.maximumValue = 2;
        _lightingView.slider.value = 0;
        _lightingView.delegate = self;
        _lightingView.hidden = YES;
    }
    return _lightingView;
}

- (UIImageView *)adjustImageView {
    if (!_adjustImageView) {
        _adjustImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"render_adjust"]];
        _adjustImageView.center = self.view.center;
        _adjustImageView.hidden = YES;
    }
    return _adjustImageView;
}

- (UILabel *)noTrackLabel {
    if (!_noTrackLabel) {
        _noTrackLabel = [[UILabel alloc] init];
        _noTrackLabel.textColor = [UIColor whiteColor];
        _noTrackLabel.font = [UIFont systemFontOfSize:17];
        _noTrackLabel.textAlignment = NSTextAlignmentCenter;
        _noTrackLabel.text = FULocalizedString(@"No_Face_Tracking");
        _noTrackLabel.hidden = YES;
    }
    return _noTrackLabel;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textColor = [UIColor whiteColor];
        _tipLabel.font = [UIFont systemFontOfSize:32];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.hidden = YES;
    }
    return _tipLabel;
}

- (FUCaptureButton *)captureButton {
    if (!_captureButton) {
        _captureButton = [[FUCaptureButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds) / 2.0 - 40.5, CGRectGetHeight(self.view.bounds) - 91, 81, 81)];
        _captureButton.recordVideo = self.viewModel.supportVideoRecording;
        _captureButton.hidden = !self.viewModel.supportCaptureAndRecording;
        _captureButton.delegate = self;
    }
    return _captureButton;
}

#pragma mark - Overriding

- (BOOL)prefersStatusBarHidden {
    return !FUDeviceIsiPhoneXStyle();
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
