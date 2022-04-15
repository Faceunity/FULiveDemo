//
//  FUEditImageViewController.m
//  FULiveDemo
//
//  Created by 孙慕 on 2018/10/9.
//  Copyright © 2018年 L. All rights reserved.
//

#import "FUEditImageViewController.h"
#import "FUNoNullItemsView.h"
#import "FUManager.h"
#import "FULiveModel.h"
#import "SVProgressHUD.h"
#import <FLAnimatedImage/FLAnimatedImage.h>
#import <math.h>
#import "FUBaseViewController.h"
#import "FUPosterManager.h"

@interface FUEditImageViewController ()<FUItemsViewDelegate, FUPosterProtocol> {
    float photoLandmarks[239*2];
}
@property (strong, nonatomic) FUNoNullItemsView *mItemView;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *loadingImage;
@property (weak, nonatomic) IBOutlet UIView *mNoFaceView;
@property (weak, nonatomic) IBOutlet UILabel *mTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *OKBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mLayoutConstraintBottom;
/* 多人脸展示蒙版 */
@property (strong, nonatomic)UIView *maskView;
/* 合成海报是否保存 */
@property (assign, nonatomic)  BOOL isSave;
@property (strong, nonatomic)  NSMutableArray <FUFaceRectInfo *> *faceInfoArray; //多人脸信息存放
/* 返回 */
@property (weak, nonatomic) IBOutlet UIButton *mBackBtn;
/* 下载 */
@property (weak, nonatomic) IBOutlet UIButton *mDownLoadBtn;

@property (strong, nonatomic) FUPosterManager *posterManager;
@end

@implementation FUEditImageViewController
- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.posterManager = [[FUPosterManager alloc] init];
    self.posterManager.poster.delegate = self;
    _faceInfoArray = [NSMutableArray array]; //多人脸信息存放
    [self initializationView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self setupPhotoMake];
}

/* 初始化 */
-(void)initializationView{

    [_OKBtn setTitle:FUNSLocalizedString(@"知道了", nil) forState:UIControlStateNormal];

    /* loading gif */
    NSData *loadingData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"loading.gif" ofType:nil]];
    self.loadingImage.animatedImage = [FLAnimatedImage animatedImageWithGIFData:loadingData];
    self.loadingImage.hidden = YES;
    [self prefersStatusBarHidden];
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];

    FULiveModel *model = [FUManager shareManager].currentModel;
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *str in [FUManager shareManager].currentModel.items) {
        [array addObject:[NSString stringWithFormat:@"%@_icon",str]];
    }
    self.mImageView.image = [UIImage imageNamed:model.items[model.selIndex]];
    
    _mItemView = [[FUNoNullItemsView alloc] init];
    _mItemView.delegate = self;
    _mItemView.selectedItem = [NSString stringWithFormat:@"%@_icon",model.items[model.selIndex]];
    [self.view addSubview:_mItemView];
    _mItemView.backgroundColor = [UIColor clearColor];
    [_mItemView updateCollectionArray:array];
    [_mItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.right.equalTo(self.view);
        if (iPhoneXStyle) {
            make.height.mas_equalTo(84 + 34);
        }else{
            make.height.mas_equalTo(84);
        }
    }];
}


#pragma  mark ----  校验 & push处理  -----
/* 人脸校验 */
-(void)setupPhotoMake{
    _mImageView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);

    [self.posterManager setOnCameraChange];
    FULiveModel *model = [FUManager shareManager].currentModel;
    [self.posterManager.poster renderWithInputImage:_mPhotoImage templateImage:[UIImage imageNamed:model.items[model.selIndex]]];
}

// 选择某一张脸
- (void)selectFace:(UITapGestureRecognizer *)tap {
    CGPoint point = [tap locationInView:self.maskView] ;
    for (FUFaceRectInfo *info in _faceInfoArray) {
        CGRect rect = [info rect];
        if (CGRectContainsPoint(rect, point)) {
            [_maskView removeFromSuperview];//chooseFaceIds
            [self.posterManager.poster chooseFaceID: info.faceId];
        }
    }
}


#pragma  mark ----  多人脸是添加选择蒙版  -----
/* 多人脸是添加选择蒙版 */
-(void)addMakeViewWithFaceInfos:(NSArray <FUFaceRectInfo *> *)faces
                     photoWidth:(int)width
                    photoHeight:(int)height {
    //创建一个View
    _maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_maskView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.6]];
    [self.view addSubview:_maskView];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectFace:)];
    [self.maskView addGestureRecognizer:tap];

    UIButton *tipBtn = [[UIButton alloc] initWithFrame:CGRectMake((_maskView.frame.size.width - 200)/2, 0, 200, 40)];
    [tipBtn setTitle:FUNSLocalizedString(@"检测到多人，请选择一人进行换脸", nil)  forState:UIControlStateNormal];
    [tipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    tipBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    tipBtn.contentEdgeInsets = UIEdgeInsetsMake(6, 0, 0, 0);
    [tipBtn setBackgroundImage:[UIImage imageNamed:@"poster_tip"] forState:UIControlStateNormal];
    [tipBtn addTarget:self action:@selector(tipBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.maskView addSubview:tipBtn];

    CGRect imageAspectRect = AVMakeRectWithAspectRatioInsideRect(_mImageView.image.size, _mImageView.bounds);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:_maskView.bounds];
    for (int i = 0; i < faces.count; i ++) {
        FUFaceRectInfo *info = faces[i];
        CGRect rect = [self getFaceRect:info.rect
                             photoWidth:_mPhotoImage.size.width
                            photoHeight:_mPhotoImage.size.height
                        iamgeAspectRect:imageAspectRect];
        UIBezierPath *path1 =  [[UIBezierPath bezierPathWithOvalInRect:rect] bezierPathByReversingPath];// [UIBezierPath bezierPathWithOvalInRect:rect bez];
        [path appendPath:path1];

        if (CGRectGetMaxY(rect) > tipBtn.frame.origin.y) {
            tipBtn.frame = CGRectMake((_maskView.frame.size.width - 200)/2, CGRectGetMaxY(rect) + 20, 200, 40);
        }
        info.rect = rect;
        [_faceInfoArray addObject:info];
    }

    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    //添加图层蒙板
    _maskView.layer.mask = shapeLayer;

}

/* 获取图片人脸区域
 * iamgeAspectRect 图片在父视图的相对位置
 */
- (CGRect)getFaceRect:(CGRect)rect
           photoWidth:(int)photoWidth
          photoHeight:(int)photoHeight
      iamgeAspectRect:(CGRect)iamgeAspectRect {

    //rect 是人脸在图片上的位置 所以人脸中心点x = (rect.origin.x + (rect.originx + rect.size.width))/2 , (originx + size.width) 为人脸x最大坐标，y最大坐标同理可得
    CGFloat centerX = (rect.origin.x + (rect.origin.x + rect.size.width)) * 0.5;
    CGFloat centerY = (rect.origin.y + (rect.origin.y + rect.size.height)) * 0.5;

    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;

    float scaleW = iamgeAspectRect.size.width / photoWidth;
    float scaleH = iamgeAspectRect.size.height / photoHeight;
    
    width  = width * scaleW;
    height = height * scaleH;
    
    /**
     * centerY * scaleH 在图片centerY 相对坐标,
     * centerY * scaleH - height / 2, 即人脸在图片的originY 相对位置
     * centerY * scaleH - height / 2 + iamgeAspectRect.origin.y 即人脸在图片的父视图的originY位置
     * */
    float y = centerY * scaleH - height / 2 + iamgeAspectRect.origin.y;
    float x = centerX * scaleW - width / 2 + iamgeAspectRect.origin.x;
    CGRect retRect = CGRectMake(x, y, width, height);
    return retRect;
}

#pragma  mark ---- FUItemsViewDelegate   -----
-(void)itemsViewDidSelectedItem:(NSString *)item indexPath:(NSIndexPath *)indexPath {
    _isSave = NO;
    NSArray *array = [item componentsSeparatedByString:@"_"];
    [self.mItemView startAnimation];
    [self.posterManager.poster changeTempImage:[UIImage imageNamed:array[0]]];
}

#pragma  mark ----  SET  -----
-(void)setMPhotoImage:(UIImage *)mPhotoImage{
    NSData *imageData = UIImageJPEGRepresentation(mPhotoImage, 1.0);
    mPhotoImage = [UIImage imageWithData:imageData];
    _mPhotoImage = mPhotoImage;
    self.mImageView.image = mPhotoImage;

    if (_PushFrom == FUEditImagePushFromAlbum) {
        _mTextLabel.text = FUNSLocalizedString(@"未检测出人脸，请重新上传",nil);
    }else{
        _mTextLabel.text = FUNSLocalizedString(@"未检测出人脸，请重新拍摄",nil);
    }

}


#pragma  mark ----  UI Action  -----

- (IBAction)backAction:(id)sender {
    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
}

/* 保存图片 */
- (IBAction)loadAction:(id)sender {

    if (_mImageView.image) {
        if (_isSave) {
             [SVProgressHUD showSuccessWithStatus:FUNSLocalizedString(@"图片已保存到相册", nil)];
            return;
        }
        UIImageWriteToSavedPhotosAlbum(_mImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }

}

-(void)tipBtnClick:(UIButton *)btn{
  //  [_maskView removeFromSuperview];
}

- (IBAction)knownAction:(id)sender {

    [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    if(error != NULL){
        [SVProgressHUD showErrorWithStatus:FUNSLocalizedString(@"保存图片失败", nil)];
    }else{
        _isSave = YES;
        [SVProgressHUD showSuccessWithStatus:FUNSLocalizedString(@"图片已保存到相册", nil)];
    }
}

#pragma mark - PosterDelegate
/**
 * 检测输入照片人脸结果异常调用， 用于处理异常提示 UI逻辑.
 * code: -1, 人脸异常（检测到人脸但是角度不对返回-1），0: 未检测到人脸
 */
- (void)poster:(FUPoster *)poster inputImageTrackErrorCode:(int)code {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.mNoFaceView.hidden = NO;
        if (code == -1) {
            if (_PushFrom == FUEditImagePushFromPhoto) {
                self.mTextLabel.text = FUNSLocalizedString(@"人脸偏转角度过大，请重新拍摄",nil);
            }else{
                self.mTextLabel.text = FUNSLocalizedString(@"人脸偏转角度过大，请重新选择",nil);
            }
        } else if (code == 0) {
        }
    });
}

/**
 * 输入照片检测到多张人脸回调此方法,用于UI层绘制多人脸 UI
 */
- (void)poster:(FUPoster *)poster trackedMultiFaceInfos:(NSArray <FUFaceRectInfo *> *)faceInfos {
    /* 添加遮罩选择逻辑 */
    dispatch_async(dispatch_get_main_queue(), ^{
        [self addMakeViewWithFaceInfos:faceInfos photoWidth:_mPhotoImage.size.width photoHeight:_mPhotoImage.size.height];
    });
}

/**
 * 检测海报模版背景图片人脸结果（异常调用）
 * code: -1, 人脸异常（检测到人脸但是角度不对返回-1） 0: 未检测到人脸
 */
- (void)poster:(FUPoster *)poster tempImageTrackErrorCode:(int)code {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.mNoFaceView.hidden = NO;
        if (code == -1) {
            if (_PushFrom == FUEditImagePushFromPhoto) {
                self.mTextLabel.text = FUNSLocalizedString(@"人脸偏转角度过大，请重新拍摄",nil);
            }else{
                self.mTextLabel.text = FUNSLocalizedString(@"人脸偏转角度过大，请重新选择",nil);
            }
        } else if (code == 0) {

        }
    });
}

/**
 *  inputImage 和 蒙板image 合成的结果回调
 *  data : 海报蒙板和照片合成之后的图片数据
 */

- (void)poster:(FUPoster *)poster didRenderToImage:(UIImage *)image {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.mImageView.image = image;
        self.loadingImage.hidden = YES;
        self.view.userInteractionEnabled = YES;
        //
        [self.mItemView stopAnimation];
    });
}

- (NSNumber *)renderOfWarp {
    FULiveModel *model = [FUManager shareManager].currentModel;
    id warpValue = model.selIndex == 5 ? @0.2 : nil;
    return warpValue;
}

#pragma  mark ----  重载系统方法  -----
- (BOOL)prefersStatusBarHidden
{
    return YES;//隐藏为YES，显示为NO
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
