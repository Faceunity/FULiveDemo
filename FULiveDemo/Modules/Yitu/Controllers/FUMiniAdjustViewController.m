//
//  FUMakeUpAdjustViewController.m
//  FULive
//
//  Created by L on 2018/8/31.
//  Copyright © 2018年 faceUnity. All rights reserved.
//

#import "FUMiniAdjustViewController.h"
//#import "FUButton.h"
#import <FLAnimatedImage.h>
#import "FUOpenGLView.h"
#import "FUManager.h"
#import <Masonry.h>
//#import "FULiveTool.h"

typedef enum : NSUInteger {
    FUPreViewOriginLeft,
    FUPreViewOriginRight,
    FUPreViewOriginAnimation,
} FUPreViewOrigin;


@interface FUMiniAdjustViewController ()<UIScrollViewDelegate>
{
    BOOL rendering ;
    // lanmarks 在屏幕上的点坐标
    NSMutableArray *screenPoints ;
    
    FUPreViewOrigin preViewOrigin ;
    CGPoint preViewPoint ;
}
//@property (weak, nonatomic) IBOutlet UIView *maskView;
//@property (weak, nonatomic) IBOutlet FLAnimatedImageView *gifView;
@property (strong, nonatomic) FUOpenGLView *renderView;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *renderViewHeight;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) FUOpenGLView *preView;
@property (strong, nonatomic) UIButton *backBtn;

@property (strong, nonatomic) UIImageView *centerImageView;
@property (strong, nonatomic) UIImageView *gestureImageView;

@property (assign, nonatomic) float zoomScale;
// 调整记录
//@property (nonatomic, strong) NSMutableArray *adjustedArray ;
//@property (nonatomic, assign) NSInteger adjustedIndex ;
//@property (weak, nonatomic) IBOutlet FUButton *leftBtn;
//@property (weak, nonatomic) IBOutlet FUButton *rightBtn;


@end

@implementation FUMiniAdjustViewController

- (BOOL)prefersStatusBarHidden {
    return YES ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.zoomScale = 1;
    
    [self addObserver];
    self.automaticallyAdjustsScrollViewInsets = NO;

    NSData *imageData = UIImageJPEGRepresentation(self.image, 1.0);
    self.image = [UIImage imageWithData:imageData];

    rendering = YES ;
    [self renderImage];
    
//    if ([self isFirstPreview]) {
//        [self showGifAction:nil];
//    }
    [self setupView];
    [self viewAddGestureRecognizer];
}

-(void)setupView{
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    self.renderView = [[FUOpenGLView alloc] init];
    self.renderView.contentMode = FUOpenGLViewContentModeScaleAspectFit;
    self.renderView.userInteractionEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(500, 500);
    self.scrollView.maximumZoomScale=2.0;
    self.scrollView.minimumZoomScale=1.0;
    [self.scrollView addSubview:self.renderView];
    
    self.preView = [[FUOpenGLView alloc] init];
    self.preView.hidden = YES;
    [self.view addSubview:self.preView];
    
    self.backBtn = [[UIButton alloc] init];
    self.backBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.backBtn.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6].CGColor;
    self.backBtn.layer.shadowOffset = CGSizeMake(0,0);
    self.backBtn.layer.shadowOpacity = 1;
    self.backBtn.layer.shadowRadius = 2;
    self.backBtn.layer.cornerRadius = 15;
    [self.backBtn setImage:[UIImage imageNamed:@"icon_yitu_adjusting_back"] forState:UIControlStateNormal];
    [self.backBtn setTitle:NSLocalizedString(@"保存点位",nil) forState:UIControlStateNormal];
    [self.backBtn setTitleColor:[UIColor colorWithWhite:0.05 alpha:1] forState:UIControlStateNormal];
    self.backBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backBtn];
    
    self.centerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_yitu_adjusting"]];
    [self.preView addSubview:self.centerImageView];
    
    self.gestureImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_yitu_adjusting_w"]];
    self.gestureImageView.hidden = YES;
    [self.renderView addSubview:self.gestureImageView];

    [self addLayoutConstraint];
}




-(void)addLayoutConstraint{
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.equalTo(self.view);
    }];
    
    [self.renderView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.right.bottom.left.equalTo(self.scrollView);
        make.edges.equalTo(self.scrollView);
        make.width.height.equalTo(self.scrollView);

    }];
    
    [self.preView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(5);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(5);
        } else {
            make.top.equalTo(self.view.mas_top).offset(5);
        }
        make.width.height.mas_equalTo(117);
    }];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-17);
        
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-17);
        } else {
            make.bottom.equalTo(self.view.mas_bottom).offset(-17);
        }
        make.width.mas_equalTo(86);
        make.height.mas_equalTo(30);
    }];
    
    [self.centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(_preView);

    }];

}

-(void)viewAddGestureRecognizer{
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    longPress.minimumPressDuration = 0.2;
    [self.renderView addGestureRecognizer:longPress];
    self.renderView.userInteractionEnabled = YES ;
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    preViewOrigin = FUPreViewOriginLeft ;
    preViewPoint = CGPointMake(self.preView.frame.origin.x + self.preView.frame.size.width , self.preView.frame.origin.y + self.preView.frame.size.height) ;
    
    // 图像宽高
    float width = self.image.size.width ;
    float height = self.image.size.height ;
    // frame 宽高
    float frameWidth = self.renderView.frame.size.width;
    float frameHeight = self.renderView.frame.size.height;
    
    float dH      = frameHeight / height;
    float dW      = frameWidth / width;
    float dd      = MIN(dH, dW);
    
    float h       = height * dd;
    float w       = width  * dd;
    
    screenPoints = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0 ; i < _pointsArray.count/2; i ++) {
        CGFloat x = [self.pointsArray[2 * i] floatValue] / width * w + (frameWidth - w) / 2.0;
        CGFloat y = [self.pointsArray[2 * i + 1] floatValue] / height * h + (frameHeight - h)/ 2.0;
        [screenPoints addObject:@(x)];
        [screenPoints addObject:@(y)];
    }
    
//    self.adjustedArray = [NSMutableArray arrayWithCapacity:1];
//    FULandmarksAdjustMode *model = [[FULandmarksAdjustMode alloc] init];
//    model.screenPoints = [screenPoints copy] ;
//    model.landmarks = [self.pointsArray copy];
//    [self.adjustedArray addObject:model] ;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    rendering = NO ;
}

#pragma  mark ----  是否第一进入  -----

-(BOOL)isFirstPreview{

    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *passWord = [user objectForKey:@"isFirstPreview"];
    if (passWord == nil) {
         [user setObject:@"1" forKey:@"isFirstPreview"];
        return YES;
    }else{
        return NO;
    }
}


- (void)renderImage {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
         int count = (int)_pointsArray.count;
        float *landmarks = (float *)malloc(count * sizeof(float));
        float *landmarks2 = (float *)malloc(count * sizeof(float));
        while (self->rendering) {

            
            [NSThread sleepForTimeInterval:0.07] ;
            if (!self.image) {
                continue ;
            }
            
            CFDataRef dataFromImageDataProvider = CGDataProviderCopyData(CGImageGetDataProvider(self.image.CGImage));
            GLubyte *imageData = (GLubyte *)CFDataGetBytePtr(dataFromImageDataProvider);
            CGSize size = self.image.size;
//            [[FUManager shareManager] renderItemsToImage:self.image];
            
//            float landmarks[count] = {0};
//            float landmarks2[count] = {0};
            for (int i = 0 ; i < count ; i ++) {
                landmarks[i] = [self.pointsArray[i] floatValue] ;
                landmarks2[i] = [self.pointsArray[i] floatValue] ;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.zoomScale = self.scrollView.zoomScale;
            });
            
            [self.renderView displayImageData:imageData Size:size Landmarks:landmarks count:count zoomScale:self.zoomScale];
            
            [self.preView displayImageData:imageData withSize:size Center:_preCenter Landmarks:landmarks2 count:count];
        
            CFRelease(dataFromImageDataProvider);
        }
        free(landmarks);
        free(landmarks2);
    });
}

// 关闭
- (void)backAction:(UIButton *)sender {
//    FULandmarksAdjustMode *model = [self.adjustedArray objectAtIndex:0] ;
//    self.faceLandArray[self.selectedFaceIndex] = model.landmarks ;
//    [[FUManager shareManager] setLandmarksWithArray:self.faceLandArray];
    
    if (self.adjustedLandmarksSuccessBlock) {
        self.adjustedLandmarksSuccessBlock(self.pointsArray) ;
    }
    [self.navigationController popViewControllerAnimated:YES];
}


//// 知道啦
//- (IBAction)hiddenGifView:(FUButton *)sender {
//    self.gifView.animatedImage = nil ;
//    self.maskView.hidden = YES ;
//}
//
//- (IBAction)recoverAction:(FUButton *)sender {
//
//    if (!sender.selected) {
//        return ;
//    }
//
//    if (sender == self.leftBtn) {
//        if (self.adjustedIndex < 1 ) {
//            return ;
//        }
//        self.adjustedIndex -= 1 ;
//
//        FULandmarksAdjustMode *model = [self.adjustedArray objectAtIndex:self.adjustedIndex] ;
//        screenPoints = [model.screenPoints mutableCopy] ;
//        self.faceLandArray[self.selectedFaceIndex] = model.landmarks ;
//        [[FUManager shareManager] setLandmarksWithArray:self.faceLandArray];
//        self.landmarksArray = [model.landmarks mutableCopy] ;
//    }else {
//        if (self.adjustedIndex > self.adjustedArray.count - 2) {
//            return ;
//        }
//        self.adjustedIndex += 1 ;
//
//        FULandmarksAdjustMode *model = [self.adjustedArray objectAtIndex:self.adjustedIndex] ;
//        screenPoints = [model.screenPoints mutableCopy] ;
//        self.faceLandArray[self.selectedFaceIndex] = model.landmarks ;
//        [[FUManager shareManager] setLandmarksWithArray:self.faceLandArray];
//        self.landmarksArray = [model.landmarks mutableCopy] ;
//    }
//    self.leftBtn.selected = self.adjustedIndex > 0 ;
//    self.rightBtn.selected = self.adjustedIndex < self.adjustedArray.count - 1 ;
//}

// Zoom
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.renderView ;
}

// 长按显示左上角
static int pointIndex = -1 ;

- (void)longPressAction:(UILongPressGestureRecognizer *)gester  {
    switch (gester.state) {
        case UIGestureRecognizerStateBegan:{
            _preView.hidden = NO;
            CGPoint point = [gester locationInView:self.renderView];
            float scale = self.scrollView.zoomScale;
            CGPoint center = CGPointMake(point.x / self.renderView.frame.size.width * scale,point.y / self.renderView.frame.size.height * scale) ;
            
            if (center.x <= 0.05 || center.x >= 0.95
                || center.y <= 0.05 || center.y >= 0.95) {
                return ;
            }
            
            CGFloat minSpace = 64 ;
            for (int i = 0 ; i < screenPoints.count/2 ; i ++) {
                
                CGFloat x = [screenPoints[2 * i] floatValue];
                CGFloat y = [screenPoints[2 * i + 1] floatValue];
                
                CGFloat space = fabs(point.x - x) * fabs(point.x - x) + fabs(point.y - y) * fabs(point.y - y) ;
                if (space < 64 && space < minSpace) {
                    minSpace = space ;
                    pointIndex = i ;
//                    self.preView.hidden = NO ;
                    _preCenter = center ;
                    self.renderView.disapplePointIndex = i ;
                    self.gestureImageView.hidden = NO;
                    self.gestureImageView.center  = point;
                }
            }            
            // 修正
            if (self.image.size.width / self.image.size.height > self.renderView.frame.size.width / self.renderView.frame.size.height) {
                
                CGFloat imageS = self.image.size.height / self.image.size.width ;
                CGFloat screeS = self.renderView.frame.size.height / self.renderView.frame.size.width ;
                
                CGFloat space = (screeS - imageS ) * self.renderView.frame.size.width / 2.0 / self.renderView.frame.size.height ;
                
                CGFloat x = (center.y - space ) / (1- 2 * space) ;
                center.y = x ;
                
            }else {
                
                CGFloat imageS = self.image.size.width / self.image.size.height ;
                CGFloat screeS = self.renderView.frame.size.width / self.renderView.frame.size.height ;
                
                CGFloat space = (screeS - imageS ) * self.renderView.frame.size.height / 2.0 / self.renderView.frame.size.width ;
                CGFloat x = (center.x - space ) / (1- 2 * space) ;
                center.x = x ;
            }
            
            if (center.x < 0.05 || center.x > 0.95
                || center.y < 0.05 || center.y > 0.95) {
                return ;
            }
            
            _preCenter = center ;
            
        }
            break ;
        case UIGestureRecognizerStateChanged:{
            
            if (pointIndex != -1) {
                CGPoint point = [gester locationInView:self.renderView];
                float scale = self.scrollView.zoomScale;
                self.gestureImageView.hidden = NO;
                self.gestureImageView.center  = point;
                
                CGPoint center = CGPointMake(point.x / self.renderView.frame.size.width * scale,point.y / self.renderView.frame.size.height * scale) ;
                
                // 修正
                if (self.image.size.width / self.image.size.height > self.renderView.frame.size.width / self.renderView.frame.size.height) {
                    
                    CGFloat imageS = self.image.size.height / self.image.size.width ;
                    CGFloat screeS = self.renderView.frame.size.height / self.renderView.frame.size.width ;
                    
                    CGFloat space = (screeS - imageS ) * self.renderView.frame.size.width / 2.0 / self.renderView.frame.size.height ;
                    
                    CGFloat x = (center.y - space ) / (1- 2 * space) ;
                    center.y = x ;
                    
                }else {
                    
                    CGFloat imageS = self.image.size.width / self.image.size.height ;
                    CGFloat screeS = self.renderView.frame.size.width / self.renderView.frame.size.height ;
                    
                    CGFloat space = (screeS - imageS ) * self.renderView.frame.size.height / 2.0 / self.renderView.frame.size.width ;
                    CGFloat x = (center.x - space ) / (1- 2 * space) ;
                    center.x = x ;
                }
                
                if (center.x < 0.05 || center.x > 0.95
                    || center.y < 0.05 || center.y > 0.95) {
                    return ;
                }
                
                _preCenter = center ;
                
                CGPoint p = [gester locationInView:self.view];
                switch (preViewOrigin) {
                    case FUPreViewOriginLeft:{
                        if (p.x < preViewPoint.x && p.y < preViewPoint.y) {
                            preViewOrigin = FUPreViewOriginAnimation ;
                            
                            [UIView animateWithDuration:0.8 animations:^{
                                self.preView.transform = CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width - self.preView.frame.size.width, 0) ;
                            }completion:^(BOOL finished) {
                                self->preViewOrigin = FUPreViewOriginRight ;
                                self->preViewPoint = CGPointMake([UIScreen mainScreen].bounds.size.width - self.preView.frame.size.width, self->preViewPoint.y) ;
                            }];
                        }
                    }
                        break;
                    case FUPreViewOriginRight:{
                        if (p.x > preViewPoint.x && p.y < preViewPoint.y) {
                            preViewOrigin = FUPreViewOriginAnimation ;
                            
                            [UIView animateWithDuration:0.8 animations:^{
                                self.preView.transform = CGAffineTransformIdentity ;
                            }completion:^(BOOL finished) {
                                self->preViewOrigin = FUPreViewOriginLeft ;
                                self->preViewPoint = CGPointMake(self.preView.frame.size.width, self->preViewPoint.y) ;
                            }];
                        }
                    }
                        break;
                    case FUPreViewOriginAnimation:{
                    }
                        break ;
                }
                
                if (!rendering) {
                    rendering = YES ;
                    [self renderImage];
                    break ;
                }
            }
        }
            break;
        default:{
            
            if (pointIndex != -1) {
 

                // 图像宽高
                float width = self.image.size.width ;
                float height = self.image.size.height ;
                // frame 宽高
                float frameWidth = self.renderView.frame.size.width;
                float frameHeight = self.renderView.frame.size.height;
                float dH      = frameHeight / height;
                float dW      = frameWidth / width;
                float dd      = MIN(dH, dW);
                float h       = height * dd;
                float w       = width  * dd;
                
                // 修正
                if (self.image.size.width / self.image.size.height > self.renderView.frame.size.width / self.renderView.frame.size.height) {

                    CGFloat imageS = self.image.size.height / self.image.size.width ;
                    CGFloat screeS = self.renderView.frame.size.height / self.renderView.frame.size.width ;

                    CGFloat space = (screeS - imageS ) * self.renderView.frame.size.width / 2.0 / self.renderView.frame.size.height ;

                    CGFloat x = _preCenter.y * (1- 2 * space) + space;
                    _preCenter.y = x ;

                }else {
//
                    CGFloat imageS = self.image.size.width / self.image.size.height ;
                    CGFloat screeS = self.renderView.frame.size.width / self.renderView.frame.size.height ;

                    CGFloat space = (screeS - imageS ) * self.renderView.frame.size.height / 2.0 / self.renderView.frame.size.width ;
                    CGFloat x = _preCenter.x * (1- 2 * space) + space ;
                    _preCenter.x = x ;
                }
                
                float landX = (_preCenter.x * frameWidth - (frameWidth - w) / 2.0) * width / w ;
                float landY = (_preCenter.y * frameHeight - (frameHeight -h)/2.0) * height / h ;
                
                float scale = self.scrollView.zoomScale;
                CGFloat x = _preCenter.x / scale * self.renderView.frame.size.width ;
                CGFloat y = _preCenter.y / scale * self.renderView.frame.size.height ;
                
                self.pointsArray[2 * pointIndex] = @(landX) ;
                self.pointsArray[2 * pointIndex + 1] = @(landY) ;
                
                screenPoints[2 * pointIndex] = @(x) ;
                screenPoints[2 * pointIndex + 1] = @(y) ;
                
                FULandmarksAdjustMode *model = [[FULandmarksAdjustMode alloc] init];
                model.landmarks = [self.pointsArray copy] ;
                model.screenPoints = [screenPoints copy];
                
//                if (self.adjustedIndex != self.adjustedArray.count - 1) {
//
//                    NSRange removeRange = NSMakeRange(self.adjustedIndex + 1, self.adjustedArray.count - self.adjustedIndex -1) ;
//                    [self.adjustedArray removeObjectsInRange:removeRange];
//                }
//                [self.adjustedArray addObject:model];
//                self.adjustedIndex = self.adjustedArray.count - 1 ;
            }
            
//            self.leftBtn.selected = YES ;
//            self.rightBtn.selected = NO ;
            
//            self.preView.hidden = YES ;
            pointIndex = -1 ;
            self.gestureImageView.hidden = YES;
             _preView.hidden = YES;
//            self.renderView.disapplePointIndex = -1 ;
        }
            break;
    }
}

#pragma mark --- Observer
- (void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)willResignActive {
    if (self.navigationController.visibleViewController == self) {
        rendering = NO ;
    }
}

- (void)willEnterForeground {
    if (self.navigationController.visibleViewController == self) {
        rendering = YES ;
        [self renderImage];
    }
}

- (void)didBecomeActive {
    if (self.navigationController.visibleViewController == self) {
        rendering = YES ;
        [self renderImage];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

@implementation FULandmarksAdjustMode

@end
