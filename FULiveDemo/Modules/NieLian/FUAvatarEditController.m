//
//  FUAvatarEditController.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/3/20.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import "FUAvatarEditController.h"
#import <Masonry.h>
#import "FUAvatarEditView.h"
#import "FUAvatarCustomView.h"
#import "FUAvatarPresenter.h"
#import "FUAvatarPresenter.h"
#import "FUImageHelper.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "MJExtension.h"


@interface FUAvatarEditController ()<FUAvatarEditViewDelegate>
@property(strong,nonatomic) FUAvatarEditView *avatarEditView;

@property (nonatomic, strong) UIGestureRecognizer *panGesture;
@property (nonatomic, strong) UIGestureRecognizer *pinchGesture;
@end

@implementation FUAvatarEditController{
    dispatch_semaphore_t semaphore;
    UIImage *mCaptureImage;
}


- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.headButtonView.hidden = YES;
    self.photoBtn.hidden = YES;
    
    /* 加载背景 */
    [[FUManager shareManager] loadBgAvatar];
    
    /* 进入捏脸状态 */
    [[FUManager shareManager] enterAvatar];
    [[FUManager shareManager] clearAvatar];
    [[FUManager shareManager] lazyAvatar];
    if (_state == FUAvatarEditStateNew) {
        [[FUAvatarPresenter shareManager] showAProp:[FUAvatarPresenter shareManager].wholeAvatarArray.firstObject];
    }else{
        [[FUAvatarPresenter shareManager] showAProp:self.avatarModel];
    }

    [self setupView];
}

-(void)setupView{
    self.tipLabel.hidden = YES;
    self.noTrackLabel.hidden = YES;
    self.headButtonView.hidden = YES;
    self.photoBtn.hidden = YES;
    for (UIGestureRecognizer *g in self.renderView.gestureRecognizers) {
        [self.renderView removeGestureRecognizer:g];
    }
    
    self.renderView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 317);
    
    UIButton *backBtn = [[UIButton alloc] init];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    [backBtn setImage:[UIImage imageNamed:@"demo_icon_back"] forState:UIControlStateNormal];    
    [self.view addSubview:backBtn];
    
    UIButton *savaBtn = [[UIButton alloc] init];
    [savaBtn addTarget:self action:@selector(savaBtnBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:savaBtn];
    [savaBtn setImage:[UIImage imageNamed:@"demo_icon_save"] forState:UIControlStateNormal];
    [self.view addSubview:savaBtn];
    
    
    /* 编辑视图 */
    NSMutableArray *newModel = [NSMutableArray array];
    for ( FUAvatarModel *model in self.avatarModel.avatarModels) {
        [newModel addObject:[model copy]];
    }
    _avatarEditView = [[FUAvatarEditView alloc] initWithFrame:CGRectZero withData:newModel];
    _avatarEditView.delegate = self;
    [self.view addSubview:_avatarEditView];
    
    [_avatarEditView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view.mas_bottom);
        }
        make.right.left.equalTo(self.view);
        make.height.mas_equalTo(317);
    }];
    
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(11);
        } else {
            make.top.equalTo(self.view.mas_top).offset(11);
        }
        make.left.equalTo(self.view).offset(13);
        make.height.width.mas_equalTo(46);
    }];
    
    [savaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(11);
        } else {
            make.top.equalTo(self.view.mas_top).offset(11);
        }
        make.right.equalTo(self.view).offset(-13);
        make.height.width.mas_equalTo(46);
    }];
}


-(void)backBtnClick{
    if (_avatarEditView.isCustomState) {
        if(![self.avatarEditView.avatarCustomView isParamValueChange]){
            self.avatarEditView.isCustomState = NO;
            return;
        }
        UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"返回后当前操作将不会保存？",nil) preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [cancleAction setValue:[UIColor colorWithRed:44/255.0 green:46/255.0 blue:48/255.0 alpha:1.0] forKey:@"titleTextColor"];
        
        __weak typeof(self)weakSelf = self ;
        UIAlertAction *certainAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            weakSelf.avatarEditView.isCustomState = NO;
            [weakSelf.avatarEditView.avatarCustomView resetDefaultValue];
        }];
        [certainAction setValue:[UIColor colorWithRed:31/255.0 green:178/255.0 blue:255/255.0 alpha:1.0] forKey:@"titleTextColor"];
        
        [alertCon addAction:cancleAction];
        [alertCon addAction:certainAction];
        
        [self presentViewController:alertCon animated:YES completion:^{
        }];
        return;
    }
    
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"返回后当前操作将不会保存哦",nil) preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [cancleAction setValue:[UIColor colorWithRed:44/255.0 green:46/255.0 blue:48/255.0 alpha:1.0] forKey:@"titleTextColor"];
    
    __weak typeof(self)weakSelf = self ;
    UIAlertAction *certainAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[FUManager shareManager] quitAvatar];
        
        if (weakSelf.returnBlock) {
            weakSelf.returnBlock(NO);
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    [certainAction setValue:[UIColor colorWithRed:31/255.0 green:178/255.0 blue:255/255.0 alpha:1.0] forKey:@"titleTextColor"];
    
    [alertCon addAction:cancleAction];
    [alertCon addAction:certainAction];
    
    [self presentViewController:alertCon animated:YES completion:^{
    }];
    
}
-(void)savaBtnBtnClick{
    if (_avatarEditView.isCustomState) {
        _avatarEditView.isCustomState = NO;
        return;
    }
    if (self.state == FUAvatarEditStateNew) {
        UIImage *image = [self captureImage];
        [[FUAvatarPresenter shareManager] addWholeAvatar:self.avatarEditView.dataArray icon:image];
        
        if (self.returnBlock) {
            self.returnBlock(YES);
        }
    }else{
        UIImage *image = [self captureImage];
        _avatarModel.image = image;
        /* 修改缓存数据 */
        self.avatarModel.avatarModels = self.avatarEditView.dataArray;
        
        if (self.returnBlock) {
            self.returnBlock(NO);
        }
    }
    /* 跟新本地存储 */
    [[FUAvatarPresenter shareManager] dataWriteToFile];

    /* 保存捏脸 */
    [[FUManager shareManager] recomputeAvatar];
    /* 提示 */
    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"道具保存成功",nil)];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        /* 更新存储 */
        [self.navigationController popViewControllerAnimated:YES];
//    });
}

-(void)didOutputVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer{
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) ;
    [[FUManager shareManager] renderAvatarPixelBuffer:pixelBuffer];
    [self.renderView displayPixelBuffer:pixelBuffer];
    
    /* 获取当前图片，作为icon */
    if (!mCaptureImage && semaphore) {
        mCaptureImage = [self imageFromPixelBuffer:pixelBuffer];
        dispatch_semaphore_signal(semaphore);
    }
}
#pragma  mark -  FUAvatarEditViewDelegate
-(void)avatarEditViewDidCustom:(BOOL)isCustomStata{
    if (isCustomStata) {
        [UIView animateWithDuration:0.25 animations:^{
            float h = self.avatarEditView.avatarCustomView.frame.size.height + 49;
            self.renderView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - h);
        }];
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            float h = self.avatarEditView.frame.size.height;
            self.renderView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - h);
        }];
    }
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
//        _renderView.frame = CGRectMake(0,-10, [UIScreen mainScreen].bounds.size.width, 160);
    
    NSLog(@"_________%@",NSStringFromCGRect(self.renderView.frame));
    
}




    
-(UIImage *)captureImage{
    mCaptureImage = nil;
    semaphore = dispatch_semaphore_create(0);
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return mCaptureImage;
    
}

#pragma  mark -  s图片处理
-(UIImage *)imageFromPixelBuffer:(CVPixelBufferRef)pixelBufferRef {
    
    CVPixelBufferLockBaseAddress(pixelBufferRef, 0);

    int w = (int)CVPixelBufferGetWidth(pixelBufferRef);
    int h = (int)CVPixelBufferGetHeight(pixelBufferRef);
    
    int defaultW = w;
//    int defaultH = h / 2 ;
    
    int x = (w - defaultW) /2;
    int y = (h - defaultW) /2;
    
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBufferRef];
    
    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
    CGImageRef videoImage = [temporaryContext
                             createCGImage:ciImage
                             fromRect:CGRectMake(x, y,
                                                 defaultW,
                                                 defaultW)];
    
    UIImage *image = [UIImage imageWithCGImage:videoImage];
    CGImageRelease(videoImage);
    CVPixelBufferUnlockBaseAddress(pixelBufferRef, 0);
    
    return image;
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    /* 去除背景 */
    [[FUManager shareManager] destoryItemAboutType:FUNamaHandleTypeAvtarbg];
}


@end
