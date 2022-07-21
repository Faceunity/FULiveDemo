//
//  FULvMuViewController.m
//  FULiveDemo
//
//  Created by 孙慕 on 2020/8/13.
//  Copyright © 2020 FaceUnity. All rights reserved.
//

#import "FULvMuViewController.h"
#import "FULvMuView.h"
#import "FUManager.h"
#import "FUGreenScreenManager.h"

#import <FURenderKit/FUImageHelper.h>

@interface FULvMuViewController ()<FULvMuViewDelegate,UIGestureRecognizerDelegate>{
    BOOL isRender;
    CGPoint _currPoint;
}
@property(strong,nonatomic) FULvMuView *lvmuEditeView;
@property (nonatomic, strong) UIGestureRecognizer *panGesture;
@property (nonatomic, strong) UIGestureRecognizer *pinchGesture;

@property (nonatomic, strong) FUGreenScreenManager *greenScreenManager;

@end

@implementation FULvMuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isRender = YES;
    // Do any additional setup after loading the view.
    _lvmuEditeView = [[FULvMuView alloc] initWithFrame:CGRectZero];
    _lvmuEditeView.mDelegate = self;
    [self.view addSubview:_lvmuEditeView];
    [_lvmuEditeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        if (iPhoneXStyle) {
            make.height.mas_equalTo(195 + 34);
        }else{
            make.height.mas_equalTo(195);
        }
    }];
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    [_lvmuEditeView addSubview:effectview];
    [_lvmuEditeView sendSubviewToBack:effectview];
    /* 磨玻璃 */
    [effectview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(_lvmuEditeView);
    }];
    
    self.headButtonView.selectedImageBtn.hidden = NO;
    
    /* 添加手势改变input size */
    [self initMovementGestures];
    
    /* 提示 */
    [self showToast];
    
    self.greenScreenManager = [[FUGreenScreenManager alloc] init];
    
    self.greenScreenManager.greenScreen.center = CGPointMake(0.5, 0.5);
    //默认取教室的背景录像
    FUGreenScreenBgModel *param = [self.greenScreenManager.bgDataArray objectAtIndex:3];
    NSString *urlStr = [[NSBundle mainBundle] pathForResource:param.videoPath ofType:@"mp4"];
    self.greenScreenManager.greenScreen.videoPath = urlStr;
    
    [self colorDidSelected:[UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0]];
    
    [_lvmuEditeView reloadDataSoure:self.greenScreenManager.dataArray];
    [_lvmuEditeView reloadBgDataSource:self.greenScreenManager.bgDataArray];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForeground) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.greenScreenManager loadItem];
    if (self.greenScreenManager.greenScreen.pause && self.greenScreenManager.greenScreen.path) {
        [self.greenScreenManager.greenScreen startVideoDecode];
    }
    [self lvmuViewShowTopView:!self.lvmuEditeView.isHidenTop];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.greenScreenManager releaseItem];
    [self.lvmuEditeView destoryLvMuView];
    if (!self.greenScreenManager.greenScreen.pause && self.greenScreenManager.greenScreen.path) {
        self.greenScreenManager.greenScreen.pause = YES;
    }
}

-(void)initMovementGestures {
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    self.panGesture.delegate = self;
    [self.view addGestureRecognizer:self.panGesture];
    //
    self.pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    self.pinchGesture.delegate = self;
    [self.view addGestureRecognizer:self.pinchGesture];
}


-(void)showToast {
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:nil message:FUNSLocalizedString(@"请使用纯色背景拍摄，推荐绿色幕布效果最佳",nil) preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *certainAction = [UIAlertAction actionWithTitle:FUNSLocalizedString(@"我知道了",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [FURenderKit shareRenderKit].pause = NO;
    }];
    [certainAction setValue:[UIColor colorWithRed:31/255.0 green:178/255.0 blue:255/255.0 alpha:1.0] forKey:@"titleTextColor"];

    [alertCon addAction:certainAction];

    [self.navigationController  presentViewController:alertCon animated:YES completion:^{
    }];
}

#pragma  mark -  supAction
-(void)displayPromptText{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.noTrackLabel.hidden = YES;
    });
}

-(void)headButtonViewBackAction:(UIButton *)btn{
    [self.lvmuEditeView destoryLvMuView];
    [super headButtonViewBackAction:btn];
}

- (void)didEnterBackground {
    if (!self.greenScreenManager.greenScreen.pause && self.greenScreenManager.greenScreen.path) {
        self.greenScreenManager.greenScreen.pause = YES;
    }
}

- (void)willEnterForeground{
    if (self.greenScreenManager.greenScreen.pause && self.greenScreenManager.greenScreen.path) {
        [self.greenScreenManager.greenScreen startVideoDecode];
    }
}

- (BOOL)needsPresetSelections {
    return YES;
}

#pragma  mark -  FULvMuViewDelegate

-(void)beautyCollectionView:(FULvMuView *)beautyView didSelectedParam:(FUGreenScreenModel *)param {
    [self.greenScreenManager setGreenScreenModel:param];
}

- (void)lvmuViewDidSelectSafeArea:(FUGreenScreenSafeAreaModel *)model {
    if (model.effectImage) {
        [self.greenScreenManager updateSafeAreaImage:model.effectImage];
    }
}

- (void)lvmuViewDidCancelSafeArea {
    [self.greenScreenManager updateSafeAreaImage:nil];
}

-(void)colorDidSelected:(UIColor *)color {
    [self.greenScreenManager setGreenScreenWithColor:color];
    NSLog(@"取色值 %@",color);
    // 设置关键颜色后FURenderKit层的相似度、平滑度、祛色度可能自动发生变化，所以需要更新程度值
    [self.greenScreenManager updateCurrentGreenScreen];
    // 刷新UI
    [self.lvmuEditeView reloadDataSoure:self.greenScreenManager.dataArray];
}

-(void)lvmuViewShowTopView:(BOOL)shown{
    float h = shown?190:49;
    [self setPhotoScaleWithHeight:h show:shown];
}


- (void)getPoint:(CGPoint)point {
    _currPoint = point;
}

//从外面获取全局的取点背景view，为了修复取点view加载Window上的系统兼容性问题
- (UIView *)takeColorBgView {
    return self.renderView;
}

- (void)renderKitDidRenderToOutput:(FURenderOutput *)renderOutput {
    if (!CGPointEqualToPoint(CGPointZero, _currPoint)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIColor *color = [self.renderView colorInPoint:_currPoint];
            [self.lvmuEditeView setTakeColor:color];
        });
    }
    [super renderKitDidRenderToOutput:renderOutput];
}

- (void)setPhotoScaleWithHeight:(CGFloat)height show:(BOOL)shown {
    if (shown) {
        
        CGAffineTransform photoTransform0 = CGAffineTransformMakeTranslation(0, height * -0.8) ;
        CGAffineTransform photoTransform1 = CGAffineTransformMakeScale(0.9, 0.9);
        
        [UIView animateWithDuration:0.35 animations:^{
            
            self.photoBtn.transform = CGAffineTransformConcat(photoTransform0, photoTransform1) ;
        }];
    } else {
        [UIView animateWithDuration:0.35 animations:^{
            
            self.photoBtn.transform = CGAffineTransformIdentity ;
        }];
    }
}

-(void)didSelectedParam:(FUGreenScreenBgModel *)param {
    if(param.videoPath){
        NSString *urlStr = [[NSBundle mainBundle] pathForResource:param.videoPath ofType:@"mp4"];
        self.greenScreenManager.greenScreen.videoPath = urlStr;
    }else{
        self.greenScreenManager.greenScreen.videoPath = nil;
        [self.greenScreenManager.greenScreen stopVideoDecode];
    }
}

/* 取色的时候，不rendder */
-(void)takeColorState:(FUTakeColorState)state{
    self.greenScreenManager.greenScreen.cutouting = state == FUTakeColorStateRunning;
    // 取色的时候取消缩放和移动手势
    self.panGesture.enabled = state == FUTakeColorStateStop;
    self.pinchGesture.enabled = state == FUTakeColorStateStop;
}

#pragma  mark ----  手势事件  -----
-(void)handlePanGesture:(UIPanGestureRecognizer *) panGesture{
    UIView *view = panGesture.view;
    if (panGesture.state == UIGestureRecognizerStateBegan || panGesture.state == UIGestureRecognizerStateChanged){
        
        CGPoint translation = [panGesture translationInView:view.superview];
        float dx ,dy;
        dx = translation.x/CGRectGetWidth(self.view.bounds);
        dy = translation.y/CGRectGetHeight(self.view.bounds);
        self.greenScreenManager.greenScreen.center = CGPointMake(self.greenScreenManager.greenScreen.center.x + dx, self.greenScreenManager.greenScreen.center.y + dy);
        [panGesture setTranslation:CGPointZero inView:view.superview];
    }
}

-(void)handlePinchGesture:(UIPinchGestureRecognizer *)pinchGesture{
    if (pinchGesture.state == UIGestureRecognizerStateBegan || pinchGesture.state == UIGestureRecognizerStateChanged) {
        self.greenScreenManager.greenScreen.scale *= pinchGesture.scale;
        pinchGesture.scale = 1;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return ![touch.view isDescendantOfView:self.lvmuEditeView];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma  mark -  supAction
-(void)touchScreenAction:(UITapGestureRecognizer *)tap {
    if (_lvmuEditeView.mTakeColorView.isHidden) {
        [super touchScreenAction:tap];
        [_lvmuEditeView hidenTop:YES];
        self.lightingView.hidden = YES;
    }else{
        CGPoint point = [tap locationInView:self.renderView];
        [_lvmuEditeView.mTakeColorView toucheSetPoint:point];
    }
}

@end
