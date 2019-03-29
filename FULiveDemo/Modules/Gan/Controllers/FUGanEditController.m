//
//  FUGanEditController.m
//  FULiveDemo
//
//  Created by 孙慕 on 2018/12/24.
//  Copyright © 2018年 FaceUnity. All rights reserved.
//

#import "FUGanEditController.h"
#import <Masonry.h>
#import "FUGanEditBarView.h"
#import "FUGifEditView.h"
#import <SVProgressHUD.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import<AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <AFNetworking.h>
#import <SDWebImageManager.h>
#import "FUManager.h"
#import <math.h>
#import "FUGanImageModel.h"
#import "FUTipView.h"
#import "UIImage+GIF.h"

@interface FUGanEditController ()<FUGanEditBarViewDelegate,FUGifEditViewDelegate,UIGestureRecognizerDelegate>
@property(strong ,nonatomic) UIButton *backBtn;
@property(strong ,nonatomic) UILabel *titleLabel;
@property(strong ,nonatomic) UIButton *loadBtn;

@property(strong ,nonatomic) UIImageView *imageView;
/* 下方编辑视图 */
@property(strong ,nonatomic) FUGanEditBarView *editView;
/* gif编辑视图 */
@property(strong ,nonatomic) FUGifEditView *gifView;
@property(strong ,nonatomic) FUGanImageModel *fullModel;
@property(strong ,nonatomic) FUGanImageModel *twoModel;
@property(strong ,nonatomic) FUGanImageModel *fourModel;
@property(strong ,nonatomic) FUTipView *tipView;

@property(strong ,nonatomic) NSString *gifPath;
@property(strong ,nonatomic) NSString *theVideoPath;

@property (nonatomic, strong) UIGestureRecognizer *tapGesture;
@property (strong, nonatomic) CAShapeLayer *imageLineBorder;

@property(strong ,nonatomic) NSTimer *gifAnimatedTimer;
@end

@implementation FUGanEditController

-(FUGifEditView *)gifView{
    if (!_gifView) {
        _gifView = [[FUGifEditView alloc] init];
        _gifView.delegate = self;
        [self.view addSubview:self.gifView];
         [self.gifView addGifImage:self.originalImage];
        [self.gifView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.imageView);
            make.height.mas_equalTo(116);
        }];
    }
    return _gifView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addObserver];
    [self setupView];

    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

-(void)setupView{
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
//    self.imageView.backgroundColor = [UIColor grayColor];
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    self.tapGesture.delegate = self;
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:self.tapGesture];
    [self.view addSubview:self.imageView];
    
    self.backBtn = [[UIButton alloc] init];
    [self.backBtn setImage:[UIImage imageNamed:@"icon_gan_return"] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backBtn];
    
    self.loadBtn = [[UIButton alloc] init];
    [self.loadBtn setImage:[UIImage imageNamed:@"icon_gan_save"] forState:UIControlStateNormal];
    [self.loadBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loadBtn];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.frame = CGRectMake(145.5,13.5,83.5,16.5);
    self.titleLabel.numberOfLines = 0;
    [self.view addSubview:self.titleLabel];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"一键变表情", nil) attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17],NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
    
    self.titleLabel.attributedText = string;
    
    /* 五官编辑 */
    _editView = [[FUGanEditBarView alloc] init];
    _editView.backgroundColor = [UIColor blackColor];
    _editView.delegate = self;
    [self.view addSubview:_editView];
    
    _tipView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([FUTipView class]) owner:self options:nil].lastObject;
    _tipView.frame = CGRectMake(0, 0, 245, 225);
    _tipView.center = self.view.center;
    _tipView.hidden = YES;
    __weak typeof(self)weakSelf = self ;
    [_tipView.OKBtn  setTitle:NSLocalizedString(@"知道了", nil) forState:UIControlStateNormal];
    _tipView.didClick = ^(int index) {
        [weakSelf.navigationController popToViewController:weakSelf.navigationController.viewControllers[1] animated:YES];
    };
    [self.view addSubview:_tipView];
    
    [self addLayoutConstraint];
   
}

-(void)addLayoutConstraint{

    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(42, 42));
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(13);
        } else {
            make.top.equalTo(self.view.mas_top).offset(13);
        }
    }];

    [self.loadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backBtn);
        make.right.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(42, 42));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 42));
        make.centerY.equalTo(self.loadBtn);
        make.centerX.equalTo(self.view);
    }];
    
    [self.editView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(145);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view.mas_bottom);
        }
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(17);
        make.right.equalTo(self.view).offset(-17);
        make.top.equalTo(self.backBtn.mas_bottom);
        make.bottom.equalTo(self.editView.mas_top);
    }];
}

-(void)viewDidLayoutSubviews{
    _tipView.center = self.view.center;
}

#pragma  mark ----  图片校验  -----
-(void)setupPhotoMake{
    NSData *imageData = UIImageJPEGRepresentation(_originalImage, 1.0);
    UIImage *image = [UIImage imageWithData:imageData];
    int photoWidth = (int)CGImageGetWidth(image.CGImage);
    int photoHeight = (int)CGImageGetHeight(image.CGImage);
    
    CFDataRef photoDataFromImageDataProvider = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
    GLubyte *photoData = (GLubyte *)CFDataGetBytePtr(photoDataFromImageDataProvider);
    
    fuOnCameraChange();
    int endI = 0;
    for (int i = 0; i<50; i++) {//校验出人脸再trsckFace 10次
        [FURenderer trackFace:FU_FORMAT_BGRA_BUFFER inputData:photoData width:photoWidth height:photoHeight];
        if ([FURenderer isTracking] > 0) {
            if (endI == 0) {
                endI = i;
            }
            if (i > endI + 10) {
                break;
            }
        }
    }

    if ([FURenderer isTracking] > 0) {
        if (![[FUManager shareManager] isGoodFace:0]) {
            if (_pushFrom == FUGanEditImagePushFromPhoto) {
                _tipView.mTextLabel.text = NSLocalizedString(@"人脸偏转角度过大，请重新拍摄",nil);
            }else{
                _tipView.mTextLabel.text = NSLocalizedString(@"人脸偏转角度过大，请重新选择",nil);
            }
            _tipView.hidden = NO;
            CFRelease(photoDataFromImageDataProvider);
            return;
        }
        if ([[FUManager shareManager] isExaggeration:0]) {
            _tipView.mTextLabel.text = NSLocalizedString(@"人脸表情夸张，请正脸拍摄",nil);
            _tipView.hidden = NO;
            CFRelease(photoDataFromImageDataProvider);
            return;
        }
        
    }else{
        if (_pushFrom == FUGanEditImagePushFromPhoto) {
            _tipView.mTextLabel.text = NSLocalizedString(@"未检测出人脸，请重新拍摄",nil);
        }else{
            _tipView.mTextLabel.text = NSLocalizedString(@"未检测出人脸，请重新选择",nil);
        }
        _tipView.hidden = NO;
        CFRelease(photoDataFromImageDataProvider);
        return;
    }
//    if ([self isExaggeration]) {
//        _tipView.mTextLabel.text = @"";
//        _tipView.hidden = NO;
//    }
    
    CFRelease(photoDataFromImageDataProvider);
}


#pragma  mark ----  set  -----
-(void)setOriginalImage:(UIImage *)originalImage{
    if (!originalImage) {
        return;
    }
    _originalImage = originalImage;
    [self setupPhotoMake];//图片校验
    [self initializationDataModel];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.imageView.image = self.originalImage;
    });
}


-(void)initializationDataModel{
    FUGanSubImageModel *subModel = [[FUGanSubImageModel alloc] init];
    subModel.subImage = _originalImage;
    subModel.type = 0;
    _fullModel = [[FUGanImageModel alloc] init];
    _fullModel.currentImage = _originalImage;
    _fullModel.images  = [@[subModel] mutableCopy];
    
    _twoModel = [[FUGanImageModel alloc] init];
    _twoModel.viewSelIndex = 1;
    _twoModel.images  = [@[[subModel copy],[subModel copy]] mutableCopy];
    
    _fourModel = [[FUGanImageModel alloc] init];
    _fourModel.viewSelIndex = 1;
    _fourModel.images  = [@[[subModel copy],[subModel copy],[subModel copy],[subModel copy]] mutableCopy];
}

#pragma  mark ----  UI事件  -----
-(void)backBtnClick:(UIButton *)btn{
    
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"返回后当前操作将不会被保存哦",nil) preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [cancleAction setValue:[UIColor colorWithRed:44/255.f green:46/255.f blue:48/255.f alpha:1] forKey:@"titleTextColor"];
    
    UIAlertAction *certainAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
    }];
    [certainAction setValue:[UIColor colorWithRed:134/255.f green:157/255.f blue:255/255.f alpha:1] forKey:@"titleTextColor"];
    
    [alertCon addAction:cancleAction];
    [alertCon addAction:certainAction];
    
    [self presentViewController:alertCon animated:YES completion:^{
    }];
    
    
}

-(void)saveBtnClick:(UIButton *)btn{
    switch (_editView.currentModeType) {
        case 0:
            [self saveImageToCustomAlbum:_fullModel.currentImage];
            break;
        case 1:
            [self saveImageToCustomAlbum:_twoModel.currentImage];
            break;
        case 2:
            [self saveImageToCustomAlbum:_fourModel.currentImage];
            break;
        case 3:
            [self saveGif];
            break;
            
        default:
            break;
    }
    
}

#pragma  mark ----  FUGanEditBarViewDelegate     -----

-(void)ganEditExpressionIndex:(int)index{
    NSLog(@"--------%d",index);

   
    if (_editView.currentModeType == 3) {//防止gif还在放
        self.imageView.image = _gifView.selImageView.image;
    }
    
    if(index == 0){
        [self updateOneImageViewTypeIndex:(int)_editView.currentModeType image:self.originalImage typeModel:0];
    }else{
        [self syntheticExpressionPhoto:self.originalImage expressionIndex:index];
    }
}

-(void)ganEditFunctionalModeIndex:(int)index{
     [_gifAnimatedTimer invalidate];
    if (index == 3) {
        if(self.gifView.quickenBtn.selected){
            [self ganGifDidQuickenPlay];
        }
        if(self.gifView.playBtn.selected){
            [self ganGifDidPlay];
        }
    }
    
    [self changeImageViewImageTypeInde:index];
    
}

#pragma  mark ----  更新图片  -----
-(void)changeImageViewImageTypeInde:(int)index{
    self.gifView.hidden = YES;
     [_imageLineBorder removeFromSuperlayer];
    switch (index) {
        case 0:{//全屏幕
            self.imageView.contentMode = UIViewContentModeScaleAspectFill;
            self.imageView.image = _fullModel.currentImage;
            /* 对应表情 */
            FUGanSubImageModel *model = _fullModel.images[_fullModel.viewSelIndex];
            [_editView updataCurrentSel:model.type];
       }
            break;
            
        case 1:{//2
            if (!_twoModel.currentImage) {
                UIImage *image =  [self combineWith2ImageArr:_twoModel withMargin:3];
                self.imageView.image = image;
                _twoModel.currentImage = image;
            }else{
                self.imageView.image = _twoModel.currentImage;
            }
            self.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [self changeLineBorder:_twoModel.viewSelIndex];
            /* 对应表情 */
            FUGanSubImageModel *model = _twoModel.images[_twoModel.viewSelIndex];
            [_editView updataCurrentSel:model.type];
            
        }
            break;
        case 2:{//4
            if (!_fourModel.currentImage) {
                 UIImage *image =  [self combineWith4ImageArr:_fourModel withMargin:3];
                self.imageView.image = image;
                _fourModel.currentImage = image;
            }else{
                self.imageView.image = _fourModel.currentImage;
            }
           
            self.imageView.image = _fourModel.currentImage;
            self.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [self changeLineBorder:_fourModel.viewSelIndex];
            
            /* 对应表情 */
            FUGanSubImageModel *model = _fourModel.images[_fourModel.viewSelIndex];
            [_editView updataCurrentSel:model.type];
            
        }
            break;
        case 3:{//gif
            self.imageView.contentMode = UIViewContentModeScaleAspectFill;
            if (_gifView.selImageView.image) {
                self.imageView.image = _gifView.selImageView.image;
            }else{
                self.imageView.image = _originalImage;
            }
            self.gifView.hidden = NO;
            
        }
            break;
        default:
            break;
    }
}

-(void)updateOneImageViewTypeIndex:(int)index image:(UIImage *)image typeModel:(int)type{
    switch (index) {
        case 0:{//全屏幕
            int index = _fullModel.viewSelIndex;
            FUGanSubImageModel *model = _fullModel.images[index];
            model.type = type;
            model.subImage = image;
            
            _fullModel.currentImage = image;
            self.imageView.image = image;
            self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        }
            break;
            
        case 1:{//2
            int index = _twoModel.viewSelIndex;
            FUGanSubImageModel *model = _twoModel.images[index];
            model.type = type;
            model.subImage = image;

            UIImage *image =  [self combineWith2ImageArr:_twoModel withMargin:3];
            self.imageView.image = image;
            _twoModel.currentImage = image;
            self.imageView.contentMode = UIViewContentModeScaleAspectFit;        
        }
            break;
        case 2:{//4
            int index = _fourModel.viewSelIndex;
            FUGanSubImageModel *model = _fourModel.images[index];
            model.type = type;
            model.subImage = image;
            
            UIImage *image =  [self combineWith4ImageArr:_fourModel withMargin:3];
            self.imageView.image = image;
            _fourModel.currentImage = image;
            self.imageView.contentMode = UIViewContentModeScaleAspectFit;
            
        }
            break;
        case 3:{//gif
            self.imageView.contentMode = UIViewContentModeScaleAspectFill;
            self.imageView.image = image;
            self.gifView.hidden = NO;
            [_gifView updataSelImage:image];
        }
            break;
        default:
            break;
    }
}


#pragma  mark ----  FUGifEditViewDelegate  -----

-(void)ganGifDidClickAddImage{
    [self.imageView stopAnimating];
     [self.gifView addGifImage:_originalImage];
    self.imageView.image = _originalImage;
}

- (void)ganGifDidPlay{

//    _gifPath = [self composeGIF:_gifView.imageArr DelayTime:1.0];
//    NSData  *imageData = [NSData dataWithContentsOfFile:_gifPath];
//    self.imageView.image = [UIImage sd_animatedGIFWithData:imageData];
    
    if (_gifView.playBtn.selected) {
        [_gifAnimatedTimer invalidate];
        gifId = 0;
        _gifAnimatedTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(setNextImage) userInfo:nil repeats:YES];
        
    }else{
        [_gifAnimatedTimer invalidate];
    }

}

-(void)ganGifDidQuickenPlay{
    if (_gifView.quickenBtn.selected) {
        [_gifAnimatedTimer invalidate];
        gifId = 0;
        _gifAnimatedTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(setNextImage) userInfo:nil repeats:YES];
    }else{
         [_gifAnimatedTimer invalidate];
    }

}

- (void)ganGifDidSelOneImage{
    self.imageView.image = _gifView.selImageView.image;
}

#pragma  mark ----  手势事件  -----
-(void)handleTapGesture:(UITapGestureRecognizer *) panGesture{
    CGPoint locationPoint = [panGesture locationInView:panGesture.view];
    NSLog(@"当前点击%@",NSStringFromCGPoint(locationPoint));
    CGRect iamgeAspectRect = AVMakeRectWithAspectRatioInsideRect(_imageView.image.size,_imageView.bounds);
    
    if (_editView.currentModeType == 1) {
        CGRect rect5 = CGRectMake(iamgeAspectRect.origin.x, iamgeAspectRect.origin.y, iamgeAspectRect.size.width / 2, iamgeAspectRect.size.height);
        CGRect rect6 = CGRectMake(iamgeAspectRect.size.width / 2, iamgeAspectRect.origin.y, iamgeAspectRect.size.width / 2, iamgeAspectRect.size.height);
        if(CGRectContainsPoint(rect5,locationPoint)){
            _twoModel.viewSelIndex = 0;
            self.imageLineBorder.frame = rect5;
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.imageLineBorder.bounds cornerRadius:3];
            _imageLineBorder.path = path.CGPath;
            
        }else{
            _twoModel.viewSelIndex = 1;
            self.imageLineBorder.frame = rect6;
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.imageLineBorder.bounds cornerRadius:3];
            _imageLineBorder.path = path.CGPath;
        }
        FUGanSubImageModel *model = _twoModel.images[_twoModel.viewSelIndex];
        [_editView updataCurrentSel:model.type];
    }else if (_editView.currentModeType == 2){
            
        CGRect rect1 = CGRectMake(iamgeAspectRect.origin.x, iamgeAspectRect.origin.y, iamgeAspectRect.size.width / 2, iamgeAspectRect.size.height/2);
        CGRect rect2 = CGRectMake(iamgeAspectRect.size.width / 2 + iamgeAspectRect.origin.x, iamgeAspectRect.origin.y, iamgeAspectRect.size.width / 2, iamgeAspectRect.size.height/2);
        CGRect rect3 = CGRectMake(iamgeAspectRect.origin.x, iamgeAspectRect.size.height/2 + iamgeAspectRect.origin.y, iamgeAspectRect.size.width / 2, iamgeAspectRect.size.height/2);
        CGRect rect4 = CGRectMake(iamgeAspectRect.size.width / 2 + iamgeAspectRect.origin.x, iamgeAspectRect.size.height/2 + iamgeAspectRect.origin.y, iamgeAspectRect.size.width / 2, iamgeAspectRect.size.height/2);
        
        if (CGRectContainsPoint(rect1,locationPoint)) {
            _fourModel.viewSelIndex = 0;
            self.imageLineBorder.frame = rect1;
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.imageLineBorder.bounds cornerRadius:3];
            _imageLineBorder.path = path.CGPath;
        }
        if (CGRectContainsPoint(rect2,locationPoint)) {
            _fourModel.viewSelIndex = 1;
            self.imageLineBorder.frame = rect2;
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.imageLineBorder.bounds cornerRadius:3];
            _imageLineBorder.path = path.CGPath;
        }
        if (CGRectContainsPoint(rect3,locationPoint)) {
            _fourModel.viewSelIndex = 2;
            self.imageLineBorder.frame = rect3;
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.imageLineBorder.bounds cornerRadius:3];
            _imageLineBorder.path = path.CGPath;
        }
        if (CGRectContainsPoint(rect4,locationPoint)) {
            _fourModel.viewSelIndex = 3;
            self.imageLineBorder.frame = rect4;
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.imageLineBorder.bounds cornerRadius:3];
            _imageLineBorder.path = path.CGPath;
        }
        
        FUGanSubImageModel *model = _fourModel.images[_fourModel.viewSelIndex];
        [_editView updataCurrentSel:model.type];
    }
    
}


#pragma  mark ----  点击的选中框  -----
-(void)changeLineBorder:(int)index{
    [_imageLineBorder removeFromSuperlayer];
    _imageLineBorder  = [[CAShapeLayer alloc] init];
    [_imageLineBorder setLineWidth:2];
    [_imageLineBorder setFillColor:[UIColor clearColor].CGColor];
    [_imageLineBorder setStrokeColor:[UIColor colorWithRed:94/255.0 green:199/255.0 blue:254/255.0 alpha:1.0].CGColor];
    [self.imageView.layer addSublayer:_imageLineBorder];
    if (_editView.currentModeType == 1) {//二分
        
        if(index == 0){
            CGRect iamgeAspectRect = AVMakeRectWithAspectRatioInsideRect(_imageView.image.size,_imageView.bounds);
            self.imageLineBorder.frame =  CGRectMake(iamgeAspectRect.origin.x, iamgeAspectRect.origin.y, iamgeAspectRect.size.width / 2, iamgeAspectRect.size.height);
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:_imageLineBorder.bounds cornerRadius:3];
            _imageLineBorder.path = path.CGPath;

        }else{
            CGRect iamgeAspectRect = AVMakeRectWithAspectRatioInsideRect(_imageView.image.size,_imageView.bounds);
            self.imageLineBorder.frame = CGRectMake(iamgeAspectRect.size.width / 2, iamgeAspectRect.origin.y, iamgeAspectRect.size.width / 2, iamgeAspectRect.size.height);
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:_imageLineBorder.bounds cornerRadius:3];
            _imageLineBorder.path = path.CGPath;
        }
        
    }else if (_editView.currentModeType == 2){//四分
        CGRect iamgeAspectRect = AVMakeRectWithAspectRatioInsideRect(_imageView.image.size,_imageView.bounds);
  
        switch (index) {
            case 0:{
                CGRect rect = CGRectMake(iamgeAspectRect.origin.x, iamgeAspectRect.origin.y, iamgeAspectRect.size.width / 2, iamgeAspectRect.size.height/2);
                self.imageLineBorder.frame = rect;
                UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.imageLineBorder.bounds cornerRadius:3];
                _imageLineBorder.path = path.CGPath;
            }
                break;
            case 1:{
                CGRect rect = CGRectMake(iamgeAspectRect.size.width / 2 + iamgeAspectRect.origin.x, iamgeAspectRect.origin.y, iamgeAspectRect.size.width / 2, iamgeAspectRect.size.height/2);
                self.imageLineBorder.frame = rect;
                UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.imageLineBorder.bounds cornerRadius:3];
                _imageLineBorder.path = path.CGPath;
            }
                break;
            case 2:{
                CGRect rect = CGRectMake(iamgeAspectRect.origin.x, iamgeAspectRect.size.height/2 + iamgeAspectRect.origin.y, iamgeAspectRect.size.width / 2, iamgeAspectRect.size.height/2);
                self.imageLineBorder.frame = rect;
                UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.imageLineBorder.bounds cornerRadius:3];
                _imageLineBorder.path = path.CGPath;
            }
                break;
            case 3:{
                CGRect rect = CGRectMake(iamgeAspectRect.size.width / 2 + iamgeAspectRect.origin.x, iamgeAspectRect.size.height/2 + iamgeAspectRect.origin.y, iamgeAspectRect.size.width / 2, iamgeAspectRect.size.height/2);
                self.imageLineBorder.frame = rect;
                UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.imageLineBorder.bounds cornerRadius:3];
                _imageLineBorder.path = path.CGPath;
            }
                break;
            default:
                break;
        }
        
    }

}

#pragma  mark ----  保存图片 gif -----

-(void)saveGif{
    
    if (_gifView.imageArr.count < 2) {
        [SVProgressHUD showInfoWithStatus:@"图片数量太少"];
        return;
    }
    _gifPath = [self composeGIF:_gifView.imageArr DelayTime:1.0];
    
    NSError *error1 = nil;
    __block PHObjectPlaceholder *createdAsset = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        if (@available(iOS 9.0, *)) {
            createdAsset = [PHAssetCreationRequest creationRequestForAssetFromImageAtFileURL:[NSURL URLWithString:_gifPath]].placeholderForCreatedAsset;
        } else {
            // Fallback on earlier versions
        }
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    } error:&error1];
}

-(void)saveImageToCustomAlbum:(UIImage *)image{
  UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}



- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    }
}


/**
 合成gif
 
 @param imageArray 图片数组
 */
- (NSString *)composeGIF:(NSArray *)imageArray DelayTime:(float)time {
    
    //创建gif路径
    NSString *imagepPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString * gifPath = [imagepPath stringByAppendingString:@"/my.gif"];
    
    NSLog(@"gifPath   %@",gifPath);
    
    //图像目标
    CGImageDestinationRef destination;
    
    CFURLRef url=CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)gifPath, kCFURLPOSIXPathStyle, false);
    
    //通过一个url返回图像目标
    destination = CGImageDestinationCreateWithURL(url, kUTTypeGIF, imageArray.count, NULL);
    
    //设置gif的信息,播放间隔时间,基本数据,和delay时间,可以自己设置
    NSDictionary *frameProperties = [NSDictionary
                                     dictionaryWithObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:time], (NSString *)kCGImagePropertyGIFDelayTime, nil]
                                     forKey:(NSString *)kCGImagePropertyGIFDictionary];
    
    //设置gif信息
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
    //颜色
    [dict setObject:[NSNumber numberWithBool:YES] forKey:(NSString*)kCGImagePropertyGIFHasGlobalColorMap];
    //颜色类型
    [dict setObject:(NSString *)kCGImagePropertyColorModelRGB forKey:(NSString *)kCGImagePropertyColorModel];
    //颜色深度
    [dict setObject:[NSNumber numberWithInt:8] forKey:(NSString*)kCGImagePropertyDepth];
    //是否重复
    [dict setObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount];
    NSDictionary * gifproperty = [NSDictionary dictionaryWithObject:dict forKey:(NSString *)kCGImagePropertyGIFDictionary];
    //合成gif
    for (UIImage *image in imageArray)
    {
        CGImageDestinationAddImage(destination, image.CGImage, (__bridge CFDictionaryRef)frameProperties);
    }
    
    CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)gifproperty);
    CGImageDestinationFinalize(destination);
    CFRelease(destination);
    
    return gifPath;
}


//视频合成按钮点击操作
- (void)movCompressionSession {
    //设置mov路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString *moviePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mov",@"demoVideo"]];
    
    self.theVideoPath=moviePath;
    
    //定义视频的大小320 480 倍数
    CGSize size = CGSizeMake(320,480);
    
    NSError *error = nil;
    
    //    转成UTF-8编码
    unlink([moviePath UTF8String]);
    
    NSLog(@"path->%@",moviePath);
    
    //     iphone提供了AVFoundation库来方便的操作多媒体设备，AVAssetWriter这个类可以方便的将图像和音频写成一个完整的视频文件
    
    AVAssetWriter *videoWriter = [[AVAssetWriter alloc]initWithURL:[NSURL fileURLWithPath:moviePath]fileType:AVFileTypeQuickTimeMovie error:&error];
    
    NSParameterAssert(videoWriter);
    
    if(error) {
        NSLog(@"error =%@",[error localizedDescription]);
        return;
    }
    
    //mov的格式设置 编码格式 宽度 高度
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:AVVideoCodecH264,AVVideoCodecKey,
                                   
                                   [NSNumber numberWithInt:size.width],AVVideoWidthKey,
                                   
                                   [NSNumber numberWithInt:size.height],AVVideoHeightKey,nil];
    
    AVAssetWriterInput *writerInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];
    
    NSDictionary *sourcePixelBufferAttributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kCVPixelFormatType_32ARGB],kCVPixelBufferPixelFormatTypeKey,nil];
    
    //    AVAssetWriterInputPixelBufferAdaptor提供CVPixelBufferPool实例,
    //    可以使用分配像素缓冲区写入输出文件。使用提供的像素为缓冲池分配通常
    //    是更有效的比添加像素缓冲区分配使用一个单独的池
    AVAssetWriterInputPixelBufferAdaptor *adaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput sourcePixelBufferAttributes:sourcePixelBufferAttributesDictionary];
    
    NSParameterAssert(writerInput);
    
    NSParameterAssert([videoWriter canAddInput:writerInput]);
    
    if([videoWriter canAddInput:writerInput]){
        
        NSLog(@"11111");
        
    }else{
        
        NSLog(@"22222");
        
    }
    
    [videoWriter addInput:writerInput];
    
    [videoWriter startWriting];
    
    [videoWriter startSessionAtSourceTime:kCMTimeZero];
    
    //合成多张图片为一个视频文件
    
    dispatch_queue_t dispatchQueue = dispatch_queue_create("mediaInputQueue",NULL);
    
    int __block frame = 0;
    
    [writerInput requestMediaDataWhenReadyOnQueue:dispatchQueue usingBlock:^{
        
        while([writerInput isReadyForMoreMediaData]) {
            
            if(++frame >= [_gifView.imageArr count] * 10) {
                [writerInput markAsFinished];
                
                [videoWriter finishWritingWithCompletionHandler:^{
                    NSLog(@"视频合成完毕");
                    
                    
                }];
                break;
            }
            
            CVPixelBufferRef buffer = NULL;
            
            int idx = frame / 10;
       
            buffer = (CVPixelBufferRef)[self pixelBufferFromCGImage:[[_gifView.imageArr objectAtIndex:idx]CGImage]size:size];
            
            if(buffer){
                
                //设置每秒钟播放图片的个数
                if(![adaptor appendPixelBuffer:buffer withPresentationTime:CMTimeMake(frame,10)]) {
                    
                    NSLog(@"FAIL");
                    
                } else {
                    
                    NSLog(@"OK");
                }
                
                CFRelease(buffer);
            }
        }
    }];
    
    
}
- (CVPixelBufferRef)pixelBufferFromCGImage:(CGImageRef)image size:(CGSize)size {
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             
                             [NSNumber numberWithBool:YES],kCVPixelBufferCGImageCompatibilityKey,
                             
                             [NSNumber numberWithBool:YES],kCVPixelBufferCGBitmapContextCompatibilityKey,nil];
    
    CVPixelBufferRef pxbuffer = NULL;
    
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault,size.width,size.height,kCVPixelFormatType_32ARGB,(__bridge CFDictionaryRef) options,&pxbuffer);
    
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer,0);
    
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    
    NSParameterAssert(pxdata !=NULL);
    
    CGColorSpaceRef rgbColorSpace=CGColorSpaceCreateDeviceRGB();
    
    //    当你调用这个函数的时候，Quartz创建一个位图绘制环境，也就是位图上下文。当你向上下文中绘制信息时，Quartz把你要绘制的信息作为位图数据绘制到指定的内存块。一个新的位图上下文的像素格式由三个参数决定：每个组件的位数，颜色空间，alpha选项
    
    CGContextRef context = CGBitmapContextCreate(pxdata,size.width,size.height,8,4*size.width,rgbColorSpace,kCGImageAlphaPremultipliedFirst);
    
    NSParameterAssert(context);
    
    //使用CGContextDrawImage绘制图片  这里设置不正确的话 会导致视频颠倒
    
    //    当通过CGContextDrawImage绘制图片到一个context中时，如果传入的是UIImage的CGImageRef，因为UIKit和CG坐标系y轴相反，所以图片绘制将会上下颠倒
    
    CGContextDrawImage(context,CGRectMake(0,0,CGImageGetWidth(image),CGImageGetHeight(image)), image);
    
    // 释放色彩空间
    
    CGColorSpaceRelease(rgbColorSpace);
    
    // 释放context
    
    CGContextRelease(context);
    
    // 解锁pixel buffer
    
    CVPixelBufferUnlockBaseAddress(pxbuffer,0);
    
    return pxbuffer;
    
}



#pragma  mark ----  合成表情  -----

-(void)syntheticExpressionPhoto:(UIImage *)image expressionIndex:(int)index{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"正在处理图片", nil)];
    //AFN3.0+基于封住HTPPSession的句柄
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer]; // 响应
    manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 请求
    manager.requestSerializer.timeoutInterval = 60.0;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    // 图片转正
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width , image.size.height));
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *data = UIImageJPEGRepresentation(image,1.0);
    NSDictionary *dict = @{@"index":@(index)};
    //formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
    [manager POST:@"http://192.168.0.86:5001/index_upload" parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];

        [formData appendPartWithFileData:data name:@"img_t0" fileName:fileName mimeType:@"image/jpg"];

    } progress:^(NSProgress * _Nonnull uploadProgress) {

        NSLog(@"%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic =  (NSDictionary *)responseObject;
        NSString *urlStr = [NSString stringWithFormat:@"http://192.168.0.86:5001/%d_image_ti.jpg",[dic[@"task_id"] intValue]];
        SDWebImageManager *manager = [SDWebImageManager sharedManager] ;
        [manager loadImageWithURL:[NSURL URLWithString:urlStr] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            [self updateOneImageViewTypeIndex:(int)_editView.currentModeType image:image typeModel:index];
        }];
 
        
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showInfoWithStatus:@"处理失败"];
        NSLog(@"上传失败 %@", error);
    }];
}

#pragma  mark ----  二拼图  -----

//leftImage:左侧图片 rightImage:右侧图片 margin:两者间隔
- (UIImage *)combineWith2ImageArr:(FUGanImageModel *)model withMargin:(NSInteger)margin{
    NSMutableArray *images = [NSMutableArray array];
    NSArray <FUGanSubImageModel *>*arr = model.images;
    for (FUGanSubImageModel *model in arr) {
        [images addObject:model.subImage];
    }
    
    UIImage *image = _originalImage;
    CGFloat width = image.size.width + image.size.width + 3 * margin;
    CGFloat height = image.size.height + 2 * margin;
    CGSize offScreenSize = CGSizeMake(width, height);
    
    // UIGraphicsBeginImageContext(offScreenSize);用这个重绘图片会模糊
    UIGraphicsBeginImageContextWithOptions(offScreenSize, NO, [UIScreen mainScreen].scale);
    CGRect bagRect = CGRectMake(0, 0, width, height);
    UIImage *bagImage = [self bagImage:images[0] rect:bagRect withColor:[UIColor whiteColor]];
    [bagImage drawInRect:bagRect];
    
    CGRect rect1 = CGRectMake(margin, margin, image.size.width , image.size.height);
    [images[0] drawInRect:rect1];
    
    CGRect rect2 = CGRectMake(2 * margin + image.size.width, margin, image.size.width , image.size.height);
    [images[1] drawInRect:rect2];
    
    
    UIImage* imagez = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return imagez;
}

#pragma  mark ----  四拼图  -----
- (UIImage *)combineWith4ImageArr:(FUGanImageModel *)model withMargin:(NSInteger)margin{
    NSMutableArray *imageArr = [NSMutableArray array];
    NSArray <FUGanSubImageModel *>*arr = model.images;
    for (FUGanSubImageModel *model in arr) {
        [imageArr addObject:model.subImage];
    }
    
    UIImage *image = _originalImage;
    CGFloat width = image.size.width + image.size.width + 3 * margin;
    CGFloat height = image.size.height + image.size.height + 3 * margin ;
    CGSize offScreenSize = CGSizeMake(width, height);
    
    // UIGraphicsBeginImageContext(offScreenSize);用这个重绘图片会模糊
    UIGraphicsBeginImageContextWithOptions(offScreenSize, NO, [UIScreen mainScreen].scale);
    CGRect bagRect = CGRectMake(0, 0, width, height);
    UIImage *bagImage = [self bagImage:image rect:bagRect withColor:[UIColor whiteColor]];
    [bagImage drawInRect:bagRect];
    
    CGRect rect1 = CGRectMake(margin, margin, image.size.width , image.size.height);
    [imageArr[0] drawInRect:rect1];
    
    CGRect rect2 = CGRectMake(2 * margin + image.size.width, margin, image.size.width , image.size.height);
    [imageArr[1] drawInRect:rect2];
    
    CGRect rect3 = CGRectMake(margin, 2 * margin + image.size.height, image.size.width , image.size.height);
    [imageArr[2] drawInRect:rect3];
    
    CGRect rect4 = CGRectMake(2 * margin + image.size.width, 2 * margin + image.size.height, image.size.width , image.size.height);
    [imageArr[3] drawInRect:rect4];
    
    UIImage* imagez = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return imagez;
}

// 画背景
- (UIImage *)bagImage:(UIImage *)image rect:(CGRect)rect withColor:(UIColor *)color{
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [image drawInRect:rect];
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextFillRect(context, rect);
    
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


// 裁剪二拼图
-(UIImage *)cropSquareImage:(UIImage *)image{
    
    float defaultScale = self.imageView.bounds.size.width * 2 /  self.imageView.bounds.size.height;
    
    CGImageRef sourceImageRef = [image CGImage];//将UIImage转换成CGImageRef
    CGFloat _imageWidth = image.size.width * image.scale;
    CGFloat _imageHeight = image.size.height * image.scale;
    CGFloat newWidth = 0;
    CGFloat newHeight = 0;
    if (_imageWidth > _imageHeight) {
        newHeight = _imageHeight;
        newWidth = _imageHeight * defaultScale;
    }else{
        newWidth = _imageWidth;
        newHeight = _imageWidth / defaultScale;
    }
    
    CGFloat _offsetX = (_imageWidth - newWidth) / 2;
    CGFloat _offsetY = (_imageHeight - newHeight) / 2;
    
    CGRect rect = CGRectMake(_offsetX, _offsetY, newWidth, newHeight);
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);//按照给定的矩形区域进行剪裁
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    return newImage;
}

#pragma  mark ----  后台  -----
- (void)addObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)willResignActive{
    if (self.navigationController.visibleViewController == self) {

    }
}

- (void)willEnterForeground{
    if (self.navigationController.visibleViewController == self) {

    }
}

- (void)didBecomeActive{
    if (self.navigationController.visibleViewController == self) {

    }
}

#pragma  mark ----  图片定时切换  -----
static int gifId = 0;
-(void)setNextImage{
    int playIndex = gifId % _gifView.imageArr.count;
    [_gifView setSelIndex:playIndex];
    gifId ++;
}

-(void)dealloc{
    [self.imageView removeGestureRecognizer:self.tapGesture];
}


@end
