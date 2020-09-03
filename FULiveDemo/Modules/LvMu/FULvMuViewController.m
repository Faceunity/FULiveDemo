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
#import "FUVideoDecoder.h"

@interface FULvMuViewController ()<FULvMuViewDelegate,UIGestureRecognizerDelegate>
@property(strong,nonatomic) FULvMuView *lvmuEditeView;

@property (strong, nonatomic) FUVideoDecoder *videoDecoder;

@property (nonatomic, assign) CGRect lvRect;
@property (nonatomic, strong) UIGestureRecognizer *panGesture;
@property (nonatomic, strong) UIGestureRecognizer *pinchGesture;

@end

@implementation FULvMuViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[FUManager shareManager] loadBundleWithName:@"green_screen" aboutType:FUNamaHandleTypeItem];
    dispatch_async([FUManager shareManager].asyncLoadQueue, ^{
        int lvmuHandle = [[FUManager shareManager] getHandleAboutType:FUNamaHandleTypeItem];
        [FURenderer itemSetParam:lvmuHandle withName:@"start_x" value:@(0.0)];
        [FURenderer itemSetParam:lvmuHandle withName:@"start_y" value:@(0.0)];
        [FURenderer itemSetParam:lvmuHandle withName:@"end_x" value:@(1.0)];
        [FURenderer itemSetParam:lvmuHandle withName:@"end_y" value:@(1.0)];
    });
    
    [_lvmuEditeView restUI];
    [self lvmuViewShowTopView:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    _lvmuEditeView = [[FULvMuView alloc] initWithFrame:CGRectZero];
    _lvmuEditeView.mDelegate = self;
    [self.view addSubview:_lvmuEditeView];
    [_lvmuEditeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        if (iPhoneXStyle) {
            make.height.mas_equalTo(49 + 34);
        }else{
            make.height.mas_equalTo(49);
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
    
    /* 提示 */
    [self showToast];
    
    CGAffineTransform photoTransform0 = CGAffineTransformMakeTranslation(0, 180 * -0.8) ;
    CGAffineTransform photoTransform1 = CGAffineTransformMakeScale(0.9, 0.9);
    self.photoBtn.transform = CGAffineTransformConcat(photoTransform0, photoTransform1) ;
    self.headButtonView.selectedImageBtn.hidden = NO;
    
    /* 添加手势改变input size */
    [self initMovementGestures];
}

-(void)initMovementGestures
{
    _lvRect = CGRectMake(0, 0, 1.0, 1.0);
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    self.panGesture.delegate = self;
    [self.view addGestureRecognizer:self.panGesture];
    //
    self.pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    self.pinchGesture.delegate = self;
    [self.view addGestureRecognizer:self.pinchGesture];
}


-(void)showToast{
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"请使用纯色背景拍摄，推荐绿色幕布效果最佳",nil) preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *certainAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [certainAction setValue:[UIColor colorWithRed:31/255.0 green:178/255.0 blue:255/255.0 alpha:1.0] forKey:@"titleTextColor"];
    
    [alertCon addAction:certainAction];
    
    [self  presentViewController:alertCon animated:YES completion:^{
    }];
}

#pragma  mark -  supAction
-(void)displayPromptText{
    self.noTrackLabel.hidden = YES;
}

-(void)headButtonViewBackAction:(UIButton *)btn{
    [self.lvmuEditeView destoryLvMuView];
    [super headButtonViewBackAction:btn];
}


#pragma  mark -  FULvMuViewDelegate

-(void)beautyCollectionView:(FULvMuView *)beautyView didSelectedParam:(FUBeautyParam *)param{
    dispatch_async([FUManager shareManager].asyncLoadQueue, ^{
        int lvmuHandle = [[FUManager shareManager] getHandleAboutType:FUNamaHandleTypeItem];
        [FURenderer itemSetParam:lvmuHandle withName:param.mParam value:@(param.mValue)];
        
        NSLog(@"----%d---%@",lvmuHandle,param.mParam);
    });
}

-(void)colorDidSelectedR:(float)r G:(float)g B:(float)b A:(float)a{
    int lvmuHandle = [[FUManager shareManager] getHandleAboutType:FUNamaHandleTypeItem];
    dispatch_async([FUManager shareManager].asyncLoadQueue, ^{
        static double color[4];
        color[0] = round(r * 255);
        color[1] = round(g * 255);
        color[2] = round(b * 255);
        color[3] = round(a * 255);
        
        [FURenderer itemSetParamdv:lvmuHandle withName:@"key_color" value:color length:4];
        NSLog(@"取色点位------rgba %f %f %f %f",r,g,b,a);
    });
}


-(void)lvmuViewShowTopView:(BOOL)shown{
    float h = shown?180:49;
    [self setPhotoScaleWithHeight:h show:shown];
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

-(void)didSelectedParam:(FUBeautyParam *)param{
    NSString *urlStr = [[NSBundle mainBundle] pathForResource:param.mParam ofType:@"mp4"];
    
    NSURL *url = [NSURL fileURLWithPath:urlStr];
    [self setupVideoDecoder:url];
    
}

-(void)setupVideoDecoder:(NSURL *)url{
    [_videoDecoder videoStopRending];
    _videoDecoder = [[FUVideoDecoder alloc] initWithVideoDecodeUrl:url fps:30 repeat:YES callback:^(CVPixelBufferRef  _Nonnull pixelBuffer) {
        if(pixelBuffer){
            
           int lvmuHandle = [[FUManager shareManager] getHandleAboutType:FUNamaHandleTypeItem];
            CVPixelBufferLockBaseAddress(pixelBuffer, 0);
            char *buffer = CVPixelBufferGetBaseAddress(pixelBuffer);
            int w = (int)CVPixelBufferGetBytesPerRow(pixelBuffer) / 4;
            int h = (int)CVPixelBufferGetHeight(pixelBuffer);
            [FURenderer itemSetParam:lvmuHandle withName:@"is_bgra" value:@(1)];
            /* 数据写入nama */
            fuDeleteTexForItem(lvmuHandle, (char *)[@"tex_bg" UTF8String]);
            fuCreateTexForItem(lvmuHandle, (char *)[@"tex_bg" UTF8String], buffer, w, h);
            CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
            NSLog(@"解码-----");
        }

    }];
    [_videoDecoder videoStartReading];
}

#pragma  mark ----  手势事件  -----
-(void)handlePanGesture:(UIPanGestureRecognizer *) panGesture{
    
    UIView *view = panGesture.view;
    if (panGesture.state == UIGestureRecognizerStateBegan || panGesture.state == UIGestureRecognizerStateChanged){
        
        CGPoint translation = [panGesture translationInView:view.superview];
        
        float x ,y;
        x = _lvRect.origin.x + translation.x/[UIScreen mainScreen].bounds.size.width;
        y = _lvRect.origin.y + translation.y/[UIScreen mainScreen].bounds.size.height;
        _lvRect.origin = CGPointMake(x,y);
        [self setLvFrameRect:_lvRect];
        
        [panGesture setTranslation:CGPointZero inView:view.superview];
        
    }
}

-(void)handlePinchGesture:(UIPinchGestureRecognizer *)pinchGesture{
    if (pinchGesture.state == UIGestureRecognizerStateBegan || pinchGesture.state == UIGestureRecognizerStateChanged) {
        float w ,h,x,y;
        
        w = _lvRect.size.width * pinchGesture.scale;
        h = _lvRect.size.height * pinchGesture.scale;
        y = _lvRect.origin.y - (h - _lvRect.size.width)/2;
        x = _lvRect.origin.x - (w - _lvRect.size.width)/2;
        
        
        if (w <= 0.2) {
            w = 0.2;
            h = 0.2;
        }
        if (w >= 1.0) {
            x = 0;
            y = 0;
            w = 1.0;
            h = 1.0;
        }
        
        
        
        _lvRect = CGRectMake(x, y, w, h);
        [self setLvFrameRect:_lvRect];
        
        pinchGesture.scale = 1;
    }
}


-(void)setLvFrameRect:(CGRect)rect{
    dispatch_async([FUManager shareManager].asyncLoadQueue, ^{
        int lvmuHandle = [[FUManager shareManager] getHandleAboutType:FUNamaHandleTypeItem];
        [FURenderer itemSetParam:lvmuHandle withName:@"start_x" value:@(rect.origin.x)];
        [FURenderer itemSetParam:lvmuHandle withName:@"start_y" value:@(rect.origin.y)];
        [FURenderer itemSetParam:lvmuHandle withName:@"end_x" value:@(rect.origin.x + rect.size.width)];
        [FURenderer itemSetParam:lvmuHandle withName:@"end_y" value:@(rect.origin.y + rect.size.height)];
        
        NSLog(@"---%f---%f---%f---%f",rect.origin.x,rect.origin.y,rect.origin.x + rect.size.width,rect.origin.y + rect.size.height);
    });
}




-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_videoDecoder videoStopRending];
    [_lvmuEditeView destoryLvMuView];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_lvmuEditeView hidenTop:YES];
}

@end
