//
//  FUGreenScreenRenderMediaViewController.m
//  FULiveDemo
//
//  Created by 项林平 on 2021/12/9.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUGreenScreenRenderMediaViewController.h"

#import "FULvMuView.h"

#import "FUGreenScreenManager.h"

@interface FUGreenScreenRenderMediaViewController ()<FULvMuViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) FULvMuView *greenScreenView;
@property (nonatomic, strong) FUGreenScreenManager *greenScreenManager;

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;

/// 取色点
@property (nonatomic, assign) CGPoint currentTouchPoint;

@end

@implementation FUGreenScreenRenderMediaViewController


#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.greenScreenView];
    [self.greenScreenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.height.mas_offset(iPhoneXStyle ? 229 : 195);
    }];
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    self.panGesture.delegate = self;
    [self.view addGestureRecognizer:self.panGesture];
    
    self.pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureAction:)];
    self.pinchGesture.delegate = self;
    [self.view addGestureRecognizer:self.pinchGesture];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self lvmuViewShowTopView:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.greenScreenView destoryLvMuView];
    [self.greenScreenManager releaseItem];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

#pragma mark - Private methods

- (CGPoint)currentTakePointWithImageWidth:(CGFloat)width imageHeight:(CGFloat)height {
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat viewWidth = CGRectGetWidth(self.displayView.bounds) * scale;
    CGFloat viewHeight = CGRectGetHeight(self.displayView.bounds) * scale;
    
    // 宽度比例
    CGFloat widthRatio = width/viewWidth;
    // 高度比例
    CGFloat heightRatio = height/viewHeight;
    // 图片实际在glView上的位置
    CGRect imageRect;
    // 展示图片的比例
    CGFloat targetRatio;
    // 对比高度比例和宽度比例决定高度充满还是宽度充满
    if (widthRatio >= heightRatio) {
        // 宽度充满
        targetRatio = widthRatio;
        CGFloat imageHeight = height / targetRatio;
        imageRect = CGRectMake(0, viewHeight/2.f - imageHeight/2.0, viewWidth, imageHeight);
    } else {
        // 高度充满
        targetRatio = heightRatio;
        CGFloat imageWidth = width / targetRatio;
        imageRect = CGRectMake(viewWidth/2.f - imageWidth/2.0, 0, imageWidth, viewHeight);
    }
    
    CGPoint takePoint = CGPointZero;
    if (CGRectContainsPoint(imageRect, CGPointMake(self.currentTouchPoint.x * scale, self.currentTouchPoint.y * scale))) {
        // 点位在图片展示区域内，则获取实际点
        CGPoint resultPoint = CGPointMake(self.currentTouchPoint.x - imageRect.origin.x / scale, self.currentTouchPoint.y - imageRect.origin.y / scale);
        takePoint = CGPointMake(resultPoint.x * targetRatio, resultPoint.y * targetRatio);
    }
    return takePoint;
}

#pragma mark - Event response

- (void)didEnterBackground {
    if (!self.greenScreenManager.greenScreen.pause && self.greenScreenManager.greenScreen.path) {
        self.greenScreenManager.greenScreen.pause = YES;
    }
}

- (void)willEnterForeground {
    if (self.greenScreenManager.greenScreen.pause && self.greenScreenManager.greenScreen.path) {
        self.greenScreenManager.greenScreen.pause = NO;
    }
}

- (void)panGestureAction:(UIPanGestureRecognizer *)pan {
    UIView *view = pan.view;
    if (pan.state == UIGestureRecognizerStateBegan || pan.state == UIGestureRecognizerStateChanged){
        CGPoint translation = [pan translationInView:view.superview];
        FUGLDisplayViewOrientation orientation = self.displayView.origintation;
        CGFloat dx = translation.x/CGRectGetWidth(self.view.bounds);
        CGFloat dy = translation.y/CGRectGetHeight(self.view.bounds);
        switch (orientation) {
            case FUGLDisplayViewOrientationPortrait:
                self.greenScreenManager.greenScreen.center = CGPointMake(self.greenScreenManager.greenScreen.center.x + dx, self.greenScreenManager.greenScreen.center.y + dy);
                break;
            case FUGLDisplayViewOrientationPortraitUpsideDown:
                self.greenScreenManager.greenScreen.center = CGPointMake(self.greenScreenManager.greenScreen.center.x - dx, self.greenScreenManager.greenScreen.center.y - dy);
                break;
            case FUGLDisplayViewOrientationLandscapeRight:
                self.greenScreenManager.greenScreen.center = CGPointMake(self.greenScreenManager.greenScreen.center.x + dy, self.greenScreenManager.greenScreen.center.y - dx);
                break;
            case FUGLDisplayViewOrientationLandscapeLeft:
                self.greenScreenManager.greenScreen.center = CGPointMake(self.greenScreenManager.greenScreen.center.x - dy, self.greenScreenManager.greenScreen.center.y + dx);
                break;
            default:
                self.greenScreenManager.greenScreen.center = CGPointMake(self.greenScreenManager.greenScreen.center.x + dx, self.greenScreenManager.greenScreen.center.y + dy);
                break;
        }
        [pan setTranslation:CGPointZero inView:view.superview];
    }
}

- (void)pinchGestureAction:(UIPinchGestureRecognizer *)pinch {
    if (pinch.state == UIGestureRecognizerStateBegan || pinch.state == UIGestureRecognizerStateChanged) {
        self.greenScreenManager.greenScreen.scale *= pinch.scale;
        pinch.scale = 1;
    }
}

#pragma mark - FURenderMediaProtocol

- (BOOL)isNeedTrack {
    return NO;
}

- (void)renderMediaDidOutputImage:(UIImage *)image {
    if (!CGPointEqualToPoint(CGPointZero, self.currentTouchPoint)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIColor *color = [UIColor blackColor];
            CGPoint takePoint = [self currentTakePointWithImageWidth:image.size.width imageHeight:image.size.height];
            if (!CGPointEqualToPoint(CGPointZero, takePoint)) {
                // 获取实际点的颜色
                color = [FUGreenScreen pixelColorWithImage:image point:takePoint];
            }
            if (color) {
                [self.greenScreenView setTakeColor:color];
            }
        });
    }
}

- (void)renderMediaDidOutputPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    if (!CGPointEqualToPoint(CGPointZero, self.currentTouchPoint)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIColor *color = [UIColor blackColor];
            CGPoint takePoint = [self currentTakePointWithImageWidth:CVPixelBufferGetWidth(pixelBuffer) imageHeight:CVPixelBufferGetHeight(pixelBuffer)];
            if (!CGPointEqualToPoint(CGPointZero, takePoint)) {
                // 获取实际点的颜色
                color = [FUGreenScreen pixelColorWithPixelBuffer:pixelBuffer point:takePoint];
            }
            if (color) {
                [self.greenScreenView setTakeColor:color];
            }
        });
    }
}

#pragma mark - FULvMuViewDelegate

-(void)beautyCollectionView:(FULvMuView *)beautyView didSelectedParam:(FUGreenScreenModel *)param{
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

- (void)colorDidSelected:(UIColor *)color {
    [self.greenScreenManager setGreenScreenWithColor:color];
}

- (void)lvmuViewShowTopView:(BOOL)shown {
    [self refreshDownloadButtonTransformWithHeight:shown ? 190 : 49 show:shown];
}

- (void)didSelectedParam:(FUGreenScreenBgModel *)param {
    if(param.videoPath){
        NSString *urlStr = [[NSBundle mainBundle] pathForResource:param.videoPath ofType:@"mp4"];
        self.greenScreenManager.greenScreen.videoPath = urlStr;
    }else{
        self.greenScreenManager.greenScreen.videoPath = nil;
        [self.greenScreenManager.greenScreen stopVideoDecode];
    }
}

- (void)takeColorState:(FUTakeColorState)state {
    self.greenScreenManager.greenScreen.cutouting = state == FUTakeColorStateRunning;
    // 取色的时候取消缩放和移动手势
    self.panGesture.enabled = state == FUTakeColorStateStop;
    self.pinchGesture.enabled = state == FUTakeColorStateStop;
}

- (void)getPoint:(CGPoint)point {
    self.currentTouchPoint = point;
}

- (UIView *)takeColorBgView {
    return self.displayView;
}

#pragma mark - Gesture recognizer delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return ![touch.view isDescendantOfView:self.greenScreenView];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - Getters

- (FULvMuView *)greenScreenView {
    if (!_greenScreenView) {
        _greenScreenView = [[FULvMuView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), iPhoneXStyle ? 229 : 195)];
        _greenScreenView.mDelegate = self;
        [_greenScreenView reloadDataSoure:self.greenScreenManager.dataArray];
        [_greenScreenView reloadBgDataSource:self.greenScreenManager.bgDataArray];
        // 毛玻璃效果
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
        effectView.frame = _greenScreenView.frame;
        [_greenScreenView addSubview:effectView];
        [_greenScreenView sendSubviewToBack:effectView];
    }
    return _greenScreenView;
}

- (FUGreenScreenManager *)greenScreenManager {
    if (!_greenScreenManager) {
        _greenScreenManager = [[FUGreenScreenManager alloc] init];
        _greenScreenManager.greenScreen.keyColor = FUColorMakeWithUIColor([UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0]);
        _greenScreenManager.greenScreen.center = CGPointMake(0.5, 0.5);
        //默认取教室的背景录像
        FUGreenScreenBgModel *param = [_greenScreenManager.bgDataArray objectAtIndex:3];
        NSString *urlStr = [[NSBundle mainBundle] pathForResource:param.videoPath ofType:@"mp4"];
        _greenScreenManager.greenScreen.videoPath = urlStr;
    }
    return _greenScreenManager;
}

@end
