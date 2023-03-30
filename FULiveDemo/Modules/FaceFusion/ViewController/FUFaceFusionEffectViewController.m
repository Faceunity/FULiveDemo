//
//  FUFaceFusionEffectViewController.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/9/2.
//

#import "FUFaceFusionEffectViewController.h"
#import "FUFaceFusionTipView.h"

#import "FUFaceFusionManager.h"

@interface FUFaceFusionEffectViewController ()<FUFaceFusionTipViewDelegate, FUItemsViewDelegate, FUPosterProtocol>

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIImageView *effectImageView;
@property (nonatomic, strong) FUItemsView *itemsView;
@property (nonatomic, strong) UIView *tipBackgroundView;
@property (nonatomic, strong) FUFaceFusionTipView *tipView;
@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) FUPoster *faceFusion;
/// 多个人脸信息
@property (nonatomic, strong) NSMutableArray<FUFaceRectInfo *> *faceInformations;
/// 是否不完整人脸
@property (nonatomic, assign) BOOL incompleteFace;

@end

@implementation FUFaceFusionEffectViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureUI];
    
    self.effectImageView.image = [FUFaceFusionManager sharedManager].image;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self startFusion];
}

#pragma mark - UI

- (void)configureUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.effectImageView];
    
    [self.view addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading).mas_offset(15);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).mas_offset(10);
        } else {
            make.top.equalTo(self.view.mas_top).mas_offset(10);
        }
        make.size.mas_offset(CGSizeMake(44, 44));
    }];
    
    [self.view addSubview:self.saveButton];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.view.mas_trailing).mas_offset(-15);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).mas_offset(10);
        } else {
            make.top.equalTo(self.view.mas_top).mas_offset(10);
        }
        make.size.mas_offset(CGSizeMake(44, 44));
    }];
    
    [self.view addSubview:self.itemsView];
    [self.itemsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.height.mas_offset(FUHeightIncludeBottomSafeArea(84));
    }];
    
    [self.view addSubview:self.tipBackgroundView];
}

#pragma mark - Private methods

- (void)startFusion {
    [FURenderKitManager resetTrackedResult];
    NSString *imageName = [FUFaceFusionManager sharedManager].items[[FUFaceFusionManager sharedManager].selectedIndex];
    UIImage *templateImage = [UIImage imageNamed:imageName];
    [self.faceFusion renderWithInputImage:[FUFaceFusionManager sharedManager].image templateImage:templateImage];
}

- (void)replaceFusionWithIndex:(NSInteger)index {
    if (index == [FUFaceFusionManager sharedManager].selectedIndex) {
        return;
    }
    NSString *imageName = [FUFaceFusionManager sharedManager].items[[FUFaceFusionManager sharedManager].selectedIndex];
    UIImage *templateImage = [UIImage imageNamed:imageName];
    [self.faceFusion changeTempImage:templateImage];
}

/// 多人脸时添加选择蒙版
- (void)addMasksWithFaces:(NSArray<FUFaceRectInfo *> *)infos {
    [self.view addSubview:self.maskView];
    
    UIButton *tipButton = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.maskView.frame) - 211)/2, 0, 211, 40)];
    [tipButton setTitle:FULocalizedString(@"检测到多人，请选择一人进行换脸")  forState:UIControlStateNormal];
    [tipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    tipButton.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    tipButton.titleLabel.numberOfLines = 2;
    tipButton.contentEdgeInsets = UIEdgeInsetsMake(6, 0, 0, 0);
    [tipButton setBackgroundImage:[UIImage imageNamed:@"face_fusion_tip"] forState:UIControlStateNormal];
    tipButton.userInteractionEnabled = NO;
    [self.maskView addSubview:tipButton];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.maskView.bounds];
    for (NSInteger i = 0; i < infos.count; i++) {
        FUFaceRectInfo *info = infos[i];
        CGRect rect = [self faceRectWithRect:info.rect];
        UIBezierPath *path1 =  [[UIBezierPath bezierPathWithOvalInRect:rect] bezierPathByReversingPath];
        [path appendPath:path1];
        
        // 描边
        CAShapeLayer *ovalLayer = [CAShapeLayer layer];
        ovalLayer.path = path1.CGPath;
        ovalLayer.lineWidth = 2;
        ovalLayer.lineDashPattern = @[@8, @4];
        ovalLayer.strokeColor = [UIColor whiteColor].CGColor;
        ovalLayer.fillColor = NULL;
        [self.maskView.layer addSublayer:ovalLayer];
        
        if (CGRectGetMaxY(rect) > tipButton.frame.origin.y) {
            tipButton.frame = CGRectMake((self.maskView.frame.size.width - 200)/2, CGRectGetMaxY(rect) + 20, 200, 40);
        }
        info.rect = rect;
        [self.faceInformations addObject:info];
    }
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.lineWidth = 2;
    shapeLayer.lineDashPattern = @[@8, @4];
    shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.maskView.layer.mask = shapeLayer;
}


/// 获取人脸框在手机屏幕上的位置
- (CGRect)faceRectWithRect:(CGRect)rect {
    //rect 是人脸在图片上的位置 所以人脸中心点x = (rect.origin.x + (rect.originx + rect.size.width))/2 , (originx + size.width) 为人脸x最大坐标，y最大坐标同理可得
    CGFloat centerX = (rect.origin.x + (rect.origin.x + rect.size.width)) * 0.5;
    CGFloat centerY = (rect.origin.y + (rect.origin.y + rect.size.height)) * 0.5;

    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    UIImage *image = [FUFaceFusionManager sharedManager].image;
    
    CGRect imageAspectRect = AVMakeRectWithAspectRatioInsideRect(image.size, self.effectImageView.bounds);
    
    CGFloat scaleW = imageAspectRect.size.width / image.size.width;
    CGFloat scaleH = imageAspectRect.size.height / image.size.height;
    
    width  = width * scaleW;
    height = height * scaleH;
    
    /**
     * centerY * scaleH 在图片centerY 相对坐标,
     * centerY * scaleH - height / 2, 即人脸在图片的originY 相对位置
     * centerY * scaleH - height / 2 + iamgeAspectRect.origin.y 即人脸在图片的父视图的originY位置
     * */
    float y = centerY * scaleH - height / 2 + imageAspectRect.origin.y;
    float x = centerX * scaleW - width / 2 + imageAspectRect.origin.x;
    CGRect result = CGRectMake(x, y, width, height);
    return result;
}

#pragma mark - Event response

- (void)backAction {
    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
}

- (void)saveAction {
    if (self.effectImageView.image) {
        UIImageWriteToSavedPhotosAlbum(self.effectImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [FUTipHUD showTips:FULocalizedString(@"保存图片失败") dismissWithDelay:1.5];
    } else {
        [FUTipHUD showTips:FULocalizedString(@"图片已保存到相册") dismissWithDelay:1.5];
    }
}

/// 多人脸时选择某一个人脸
- (void)selectFaceAction:(UITapGestureRecognizer *)tap {
    CGPoint point = [tap locationInView:self.maskView];
    for (FUFaceRectInfo *info in self.faceInformations) {
        CGRect rect = info.rect;
        if (CGRectContainsPoint(rect, point)) {
            [self.maskView removeFromSuperview];
            _maskView = nil;
            [self.faceFusion chooseFaceID:info.faceId];
            break;
        }
    }
}

#pragma mark - FUItemsViewDelegate

- (void)itemsView:(FUItemsView *)itemsView didSelectItemAtIndex:(NSInteger)index {
    if ([FUFaceFusionManager sharedManager].selectedIndex == index) {
        return;
    }
    [self.itemsView startAnimation];
    [FUFaceFusionManager sharedManager].selectedIndex = index;
    // 切换融合海报图片
    NSString *imageName = [FUFaceFusionManager sharedManager].items[index];
    UIImage *templateImage = [UIImage imageNamed:imageName];
    [self.faceFusion changeTempImage:templateImage];
}

#pragma mark - FUPosterProtocol

- (void)poster:(FUPoster *)poster trackedFaceInfo:(FUFaceRectInfo *)faceInfo {
    CGRect faceRect = faceInfo.rect;
    UIImage *image = [FUFaceFusionManager sharedManager].image;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (faceRect.origin.x < 0 || faceRect.origin.y < 0 || (faceRect.origin.x + faceRect.size.width > image.size.width) || (faceRect.origin.y + faceRect.size.height > image.size.height)) {
            self.incompleteFace = YES;
            // 处理人脸不完整情况
            self.tipBackgroundView.hidden = NO;
            self.tipView.tipLabel.text = [FUFaceFusionManager sharedManager].imageSource == FUFaceFusionImageSourceCamera ? FULocalizedString(@"人脸不全，请重新拍摄") : FULocalizedString(@"人脸不全，请重新上传");
        } else {
            self.incompleteFace = NO;
            self.tipBackgroundView.hidden = YES;
        }
    });
}

- (void)poster:(FUPoster *)poster trackedMultiFaceInfos:(NSArray<FUFaceRectInfo *> *)faceInfos {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self addMasksWithFaces:faceInfos];
    });
}

- (void)poster:(FUPoster *)poster inputImageTrackErrorCode:(int)code {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tipBackgroundView.hidden = NO;
        self.backButton.hidden = YES;
        self.saveButton.hidden = YES;
        if (code == -1) {
            self.tipView.tipLabel.text = [FUFaceFusionManager sharedManager].imageSource == FUFaceFusionImageSourceCamera ? FULocalizedString(@"人脸偏转角度过大，请重新拍摄") : FULocalizedString(@"人脸偏转角度过大，请重新上传");
        } else {
            self.tipView.tipLabel.text = [FUFaceFusionManager sharedManager].imageSource == FUFaceFusionImageSourceCamera ? FULocalizedString(@"未检测到人脸，请重新拍摄") : FULocalizedString(@"未检测到人脸，请重新上传");
        }
    });
}

- (void)poster:(FUPoster *)poster tempImageTrackErrorCode:(int)code {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tipBackgroundView.hidden = NO;
        self.backButton.hidden = YES;
        self.saveButton.hidden = YES;
        if (code == -1) {
            self.tipView.tipLabel.text = [FUFaceFusionManager sharedManager].imageSource == FUFaceFusionImageSourceCamera ? FULocalizedString(@"人脸偏转角度过大，请重新拍摄") : FULocalizedString(@"人脸偏转角度过大，请重新上传");
        } else {
            self.tipView.tipLabel.text = [FUFaceFusionManager sharedManager].imageSource == FUFaceFusionImageSourceCamera ? FULocalizedString(@"未检测到人脸，请重新拍摄") : FULocalizedString(@"未检测到人脸，请重新上传");
        }
    });
}

- (void)poster:(FUPoster *)poster didRenderToImage:(UIImage *)image {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.backButton.hidden = self.incompleteFace;
        self.saveButton.hidden = self.incompleteFace;
        self.effectImageView.image = self.incompleteFace ? [FUFaceFusionManager sharedManager].image : image;
        [self.itemsView stopAnimation];
    });
}

- (NSNumber *)renderOfWarp {
    NSNumber *warpValue = [FUFaceFusionManager sharedManager].selectedIndex == 5 ? @0.2 : @0;
    return warpValue;
}

#pragma mark - FUFaceFusionTipViewDelegate

- (void)faceFusionTipViewDidClickComfirm {
    [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
}

#pragma mark - Getters

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"face_fusion_back"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        _backButton.hidden = YES;
    }
    return _backButton;
}

- (UIButton *)saveButton {
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveButton setImage:[UIImage imageNamed:@"face_fusion_save"] forState:UIControlStateNormal];
        [_saveButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
        _saveButton.hidden = YES;
    }
    return _saveButton;
}

- (UIImageView *)effectImageView {
    if (!_effectImageView) {
        _effectImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _effectImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _effectImageView;
}

- (FUItemsView *)itemsView {
    if (!_itemsView) {
        _itemsView = [[FUItemsView alloc] init];
        _itemsView.delegate = self;
        _itemsView.items = [FUFaceFusionManager sharedManager].iconItems;
        _itemsView.selectedIndex = [FUFaceFusionManager sharedManager].selectedIndex;
    }
    return _itemsView;
}

- (UIView *)tipBackgroundView {
    if (!_tipBackgroundView) {
        _tipBackgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
        _tipBackgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        [_tipBackgroundView addSubview:self.tipView];
        [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_tipBackgroundView);
            make.size.mas_offset(CGSizeMake(245, 225));
        }];
        _tipBackgroundView.hidden = YES;
    }
    return _tipBackgroundView;
}

- (FUFaceFusionTipView *)tipView {
    if (!_tipView) {
        _tipView = [[FUFaceFusionTipView alloc] init];
        _tipView.delegate = self;
    }
    return _tipView;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:self.view.bounds];
        _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectFaceAction:)];
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}

- (FUPoster *)faceFusion {
    if (!_faceFusion) {
        _faceFusion = [FUPoster itemWithPath:[[NSBundle mainBundle] pathForResource:@"change_face" ofType:@"bundle"] name:@"face_fusion"];
        _faceFusion.delegate = self;
    }
    return _faceFusion;
}

- (NSMutableArray<FUFaceRectInfo *> *)faceInformations {
    if (!_faceInformations) {
        _faceInformations = [[NSMutableArray alloc] init];
    }
    return _faceInformations;
}

@end
