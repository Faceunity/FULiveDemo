//
//  FUFaceAdjustController.m
//  FULiveDemo
//
//  Created by 孙慕 on 2018/12/17.
//  Copyright © 2018年 FaceUnity. All rights reserved.
//

#import "FUFaceAdjustController.h"
#import "FUFaceAddItemView.h"
#import <Masonry.h>
#import "FUAdjustImageView.h"
#import "FUMiniAdjustViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "FUYItuSaveManager.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface FUFaceAdjustController ()<FUYituItemsDelegate,FUAdjustImageViewDelegate>


@property(strong ,nonatomic) UIButton *backBtn;

@property(strong ,nonatomic) UIButton *loadBtn;
@property(strong ,nonatomic) UIButton *miniAdjustBtn;

@property(strong ,nonatomic) FUFaceAddItemView *addItemsView;
/* 当前选中 */
@property(strong ,nonatomic) FUAdjustImageView *curAdjustView;

@end

@implementation FUFaceAdjustController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    self.view.backgroundColor = [UIColor whiteColor];
    

}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

-(void)setupView{
    self.imageView = [[UIImageView alloc] init];
    NSString *imageFile = [NSString stringWithFormat:@"%@/%@.jpg", [[NSBundle mainBundle] resourcePath], @"target"];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.image = [UIImage imageWithContentsOfFile:imageFile];
    [self.view addSubview:self.imageView];
    
    self.backBtn = [[UIButton alloc] init];
    [self.backBtn setImage:[UIImage imageNamed:@"icon_yitu_back"] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backBtn];
    
    self.loadBtn = [[UIButton alloc] init];
    [self.loadBtn setImage:[UIImage imageNamed:@"icon_yitu_load"] forState:UIControlStateNormal];
    [self.loadBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loadBtn];
    
    _addItemsView = [[FUFaceAddItemView alloc] init];
    _addItemsView.delegate = self;
    [self.view addSubview:_addItemsView];
    
    
    _miniAdjustBtn = [[UIButton alloc] init];
    _miniAdjustBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    _miniAdjustBtn.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6].CGColor;
    _miniAdjustBtn.layer.shadowOffset = CGSizeMake(0,0);
    _miniAdjustBtn.layer.shadowOpacity = 1;
    _miniAdjustBtn.layer.shadowRadius = 2;
    _miniAdjustBtn.layer.cornerRadius = 15;
    _miniAdjustBtn.hidden = YES;
    [_miniAdjustBtn setImage:[UIImage imageNamed:@"icon_yitu_adjustment"] forState:UIControlStateNormal];
    [_miniAdjustBtn setTitle:NSLocalizedString(@"精细调整",nil) forState:UIControlStateNormal];
    [_miniAdjustBtn setTitleColor:[UIColor colorWithWhite:0.05 alpha:1] forState:UIControlStateNormal];
    _miniAdjustBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_miniAdjustBtn addTarget:self action:@selector(miniAdjusetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_miniAdjustBtn];
    
    [self addLayoutConstraint];
}

-(void)addLayoutConstraint{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.equalTo(self.view);
    }];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(13);
        } else {
            make.top.equalTo(self.view.mas_top).offset(13);
        }
        make.left.equalTo(self.view).offset(15);
        make.size.mas_equalTo(CGSizeMake(42, 42));
    }];
    [self.loadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backBtn);
        make.right.equalTo(self.view).offset(-15);
        make.size.mas_equalTo(CGSizeMake(42, 42));
    }];
    
    [self.addItemsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(184);
        make.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view.mas_bottom);
        }
    }];
    
    [self.miniAdjustBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-17);
        make.bottom.equalTo(self.addItemsView.mas_top).offset(-17);
        make.width.mas_equalTo(86);
        make.height.mas_equalTo(30);
    }];
}

-(void)showAlert{
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"你还没有添加五官哦",nil) preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"不添加",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [cancleAction setValue:[UIColor colorWithRed:44/255.f green:46/255.f blue:48/255.f alpha:1] forKey:@"titleTextColor"];
    
    __weak typeof(self)weakSelf = self ;
    UIAlertAction *certainAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"去添加",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [certainAction setValue:[UIColor colorWithRed:134/255.f green:157/255.f blue:255/255.f alpha:1] forKey:@"titleTextColor"];
    
    [alertCon addAction:cancleAction];
    [alertCon addAction:certainAction];
    [self presentViewController:alertCon animated:YES completion:^{
    }];
}


#pragma  mark ----  UI事件  -----
-(void)backBtnClick:(UIButton *)btn{
    BOOL isOK = NO;
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[FUAdjustImageView class]]) {
            isOK = YES;
            break;
        }
    }
    if (!isOK && self.editType == FUFaceEditModleTypeNew) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"返回后当前操作将不会保存哦",nil) preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

    }];
    [cancleAction setValue:[UIColor colorWithRed:44/255.f green:46/255.f blue:48/255.f alpha:1] forKey:@"titleTextColor"];
    
    UIAlertAction *certainAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"继续",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       [self.navigationController popViewControllerAnimated:YES];
    }];
    [certainAction setValue:[UIColor colorWithRed:134/255.f green:157/255.f blue:255/255.f alpha:1] forKey:@"titleTextColor"];
    
    [alertCon addAction:cancleAction];
    [alertCon addAction:certainAction];
    [self presentViewController:alertCon animated:YES completion:^{
    }];
    
}

-(void)saveBtnClick:(UIButton *)btn{
    btn.userInteractionEnabled = NO;
    
    BOOL isOK = NO;
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[FUAdjustImageView class]]) {
            isOK = YES;
            break;
        }
    }
    if (!isOK) {
        [self showAlert];
        btn.userInteractionEnabled = YES;
        return;
    }
    
    if(_yituModle.imagePathMid){//跟新图片
        [FUYItuSaveManager removeImagePath:_yituModle.imagePathMid];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMdd HHmmssSSS";
    NSDate *date = [NSDate date];
    NSString *imagePath = [formatter stringFromDate:date];
    [FUYItuSaveManager saveImg:self.imageView.image withVideoMid:imagePath];
    
    FUYituModel *modle = [[FUYituModel alloc] init];
    NSMutableArray *group_points = [NSMutableArray array];
    NSMutableArray *group_type   =  [NSMutableArray array];
    NSMutableArray <FUYituItemModel *> *itemModels = [NSMutableArray array];
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[FUAdjustImageView class]]) {
            FUAdjustImageView *view0 = (FUAdjustImageView *)view;
            [group_type addObject:@(view0.model.type)];
            FUYituItemModel *itemModel = view0.model;
            /* 保存状态 */
            itemModel.Transform = [view0 getTransform];
            itemModel.itemCenter = [view0 getCenter];
            itemModel.points = view0.points;
            [itemModels addObject:itemModel];
            
            NSArray *points =  [view0 getConvertPointsToView:self.view];//相对imageView坐标数组
            NSArray *imagePoint = [self coordinteImageViewToImage:points];
            for (NSNumber *num in imagePoint) {
                [group_points addObject:num];
            }
        }
    }

    modle.group_points = group_points;
    modle.group_type = group_type;
    modle.imagePathMid = imagePath;
    modle.width = self.imageView.image.size.width;
    modle.height = self.imageView.image.size.height;
    modle.itemModels = itemModels;

    if (self.saveSuccessBlock) {//更新UI,选中当前
        self.saveSuccessBlock(modle);
    }
    
    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"道具保存成功",nil)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        /* 更新存储 */
        [FUYItuSaveManager dataWriteToFile];
        [self.navigationController popViewControllerAnimated:YES];
            btn.userInteractionEnabled = YES;
    });
}
/* 调整 */
-(void)miniAdjusetBtnClick:(UIButton *)btn{
    NSLog(@"点击了精细调整");
    FUMiniAdjustViewController *vc  = [[FUMiniAdjustViewController alloc] init];
    vc.image = self.imageView.image;

    NSArray *points =  [_curAdjustView getConvertPointsToView:self.view];//相对imageView坐标数组
    vc.pointsArray = [[self coordinteImageViewToImage:points] mutableCopy];

    CGPoint imageC = [_curAdjustView getConvertCenterImage:self.view];
    CGPoint imageCenter = [self coordinteImageViewToPoint:imageC];
    //归一
    vc.preCenter  = CGPointMake(imageCenter.x/self.imageView.image.size.width, imageCenter.y/self.imageView.image.size.height);
    [self.navigationController pushViewController:vc animated:YES];
    
    __weak typeof(self)weakSelf = self;
    vc.adjustedLandmarksSuccessBlock = ^(NSMutableArray *array) {
        NSArray *points = [weakSelf coordinteImageToImageView:array];
        [weakSelf.curAdjustView setDefaultPoint:points aboutView:weakSelf.view];
        
//        CGPoint newPoint = CGPointMake(0, 0);
//        for (int i = 0; i < points.count; i++) {
//            double xy = [points[i] doubleValue];
//            if (i % 2 && i != 0) {
//                newPoint.y = xy;
//                [self createDot:newPoint];
//            }else{
//                newPoint.x = xy;
//            }
//        }
    };
}


-(void)createDot:(CGPoint)ponint{
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:ponint radius:1 startAngle:0 endAngle:2*M_PI clockwise:YES];
    layer.path = path.CGPath;
    layer.strokeColor = [UIColor redColor].CGColor;
    layer.fillColor = [UIColor redColor].CGColor;
    [self.imageView.layer addSublayer:layer];
}


/* imageView坐标系转图片坐标系 */
-(NSArray *)coordinteImageViewToImage:(NSArray *)points{
    CGRect iamgeAspectRect = AVMakeRectWithAspectRatioInsideRect(_imageView.image.size,_imageView.bounds);
    double magrinX =  iamgeAspectRect.origin.x;//图片在ImageView中的X空隙
    double magrinY =  iamgeAspectRect.origin.y;//图片在ImageView中的Y空隙
    double screenW = [UIScreen mainScreen].bounds.size.width;
    double screenH = [UIScreen mainScreen].bounds.size.height;
    double scaleX = self.imageView.image.size.width / (screenW - 2 * magrinX);//横向图片可能有问题
    double scaleY = self.imageView.image.size.height / (screenH - 2 * magrinY);
    double scale  = MAX(scaleX, scaleY);
    NSMutableArray *newPoints = [NSMutableArray array];//相对图片的点位数组
    for (int i = 0; i < points.count; i++) {
        double xy = [points[i] doubleValue];
        if (i % 2 && i != 0) {
            [newPoints addObject:@((xy - magrinY) * scale)];
        }else{
            [newPoints addObject:@((xy - magrinX) * scale)];
            
        }
    }
    return newPoints;
}


-(CGPoint )coordinteImageViewToPoint:(CGPoint )point{
    CGRect iamgeAspectRect = AVMakeRectWithAspectRatioInsideRect(_imageView.image.size,_imageView.bounds);
    double magrinX =  iamgeAspectRect.origin.x;//图片在ImageView中的X空隙
    double magrinY =  iamgeAspectRect.origin.y;//图片在ImageView中的Y空隙
    double screenW = [UIScreen mainScreen].bounds.size.width;
    double screenH = [UIScreen mainScreen].bounds.size.height;
    double scaleX = self.imageView.image.size.width / (screenW - 2 * magrinX);//横向图片可能有问题
    double scaleY = self.imageView.image.size.height / (screenH - 2 * magrinY);
    double scale  = MAX(scaleX, scaleY);
    CGPoint newPoint = CGPointMake((point.x - magrinX) * scale, (point.y - magrinY) * scale);

    return newPoint;
}

/* 相片点位坐标点转控件坐标点位 */
-(NSArray *)coordinteImageToImageView:(NSArray *)points{
    CGRect iamgeAspectRect = AVMakeRectWithAspectRatioInsideRect(_imageView.image.size,_imageView.bounds);
    double magrinX =  iamgeAspectRect.origin.x;//图片在ImageView中的X空隙
    double magrinY =  iamgeAspectRect.origin.y;//图片在ImageView中的Y空隙
    double screenW = [UIScreen mainScreen].bounds.size.width;
    double screenH = [UIScreen mainScreen].bounds.size.height;
    double scaleX = self.imageView.image.size.width / (screenW - 2 * magrinX);//横向图片可能有问题
    double scaleY = self.imageView.image.size.height / (screenH - 2 * magrinY);
    double scale  = MAX(scaleX, scaleY);
    NSMutableArray *newPoints = [NSMutableArray array];//相对图片的点位数组
    for (int i = 0; i < points.count; i++) {
        double xy = [points[i] doubleValue];
        if (i % 2 && i != 0) {
                  [newPoints addObject:@(xy/scale + magrinY)];
        }else{
             [newPoints addObject:@(xy/scale + magrinX)];
            
        }
    }
    return newPoints;
}



- (void)showMessage:(NSString *)string{
    //[SVProgressHUD showWithStatus:string]; //设置需要显示的文字
    [SVProgressHUD showImage:[UIImage imageNamed:@"wrt424erte2342rx"] status:string];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom]; //设置HUD背景图层的样式
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
    [SVProgressHUD setBackgroundLayerColor:[UIColor clearColor]];
    [SVProgressHUD setCornerRadius:5];
    [SVProgressHUD dismissWithDelay:2];

}
#pragma  mark ----  获取某个五官的数量  -----
-(int)currentNumType:(FUFacialFeaturesType)type{
    int count = 0;
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[FUAdjustImageView class]]) {
            FUAdjustImageView *view0 = (FUAdjustImageView *)view;
            if (view0.model.type == type) {
                count ++;
            }
        }
    }
    return count;
}
#pragma  mark ----  五官选择点击FUYituItemsDelegate  -----

-(void)yituAddItemView:(FUYituItemModel *)model{
    if ([self currentNumType:model.type] == 3) {
        [self showMessage:NSLocalizedString(@"不能添加更多了哦~",nil)];
        return;
    }
    _curAdjustView.editing = NO;
    
    FUYituItemModel *modleNew = [[FUYituItemModel alloc] init];
    modleNew.title = [model.title copy];
    modleNew.imageName = [model.imageName copy];
    modleNew.type =  model.type;
    modleNew.faceType = model.faceType;
    modleNew.Transform = model.Transform;
    modleNew.itemCenter = model.itemCenter;
    modleNew.points = model.points;
    
    float x = arc4random() % 200 + ([UIScreen mainScreen].bounds.size.width - 300)/2;
    float y = arc4random() % 200 + ([UIScreen mainScreen].bounds.size.height - 300)/2;
    FUAdjustImageView *view = [[FUAdjustImageView alloc] initWithFrame:CGRectMake(x, y, 100, 100)];
    view.delegate = self;
    view.model = modleNew;
    _curAdjustView = view;
    [self.view addSubview:view];
    self.miniAdjustBtn.hidden = NO;
}

-(void)addAllFaceItems:(NSArray <FUYituItemModel *> *)itemModels{
    for (FUYituItemModel *model in itemModels) {
        [self yituAddItemView:model];
    }
}

#pragma  mark ----  五官编辑代理FUAdjustImageViewDelegate  -----

-(void)adjustImageViewFocus:(FUAdjustImageView *)view{
    for (UIView *subView in self.view.subviews) {//单个成为编辑
        if ([subView isKindOfClass:[FUAdjustImageView class]]) {
            if (subView == view) {
                continue;
            }
            FUAdjustImageView *view0 = (FUAdjustImageView *)subView;
            view0.editing = NO;
        }
    }
    _curAdjustView = view;
    self.miniAdjustBtn.hidden = NO;
}

-(void)adjustImageViewRemove:(FUAdjustImageView *)view{
    [view removeFromSuperview];
    self.miniAdjustBtn.hidden = YES;
    for (UIView *subView in self.view.subviews) {//任意一个成为编辑
        if ([subView isKindOfClass:[FUAdjustImageView class]]) {
            FUAdjustImageView *view0 = (FUAdjustImageView *)subView;
            _curAdjustView = view0;
            view0.editing = YES;
            self.miniAdjustBtn.hidden = NO;
            break;
        }
    }
}

-(void)adjustImageViewAddOne:(FUAdjustImageView *)view{
    [self yituAddItemView:view.model];
}


#pragma  mark ----  点击空白  -----

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[FUAdjustImageView class]]) {
            FUAdjustImageView *view0 = (FUAdjustImageView *)view;
            view0.editing = NO;
            self.miniAdjustBtn.hidden = YES;
        }
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
