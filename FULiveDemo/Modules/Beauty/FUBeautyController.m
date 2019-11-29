//
//  FUBeautyController.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/1/28.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import "FUBeautyController.h"
#import "FUAPIDemoBar.h"
#import "FUManager.h"
#import <Masonry.h>
#import "FUSelectedImageController.h"
#import "SVProgressHUD.h"
#import "FUMakeupSupModel.h"

@interface FUBeautyController ()<FUAPIDemoBarDelegate>

@property (strong, nonatomic) FUAPIDemoBar *demoBar;
/* 比对按钮 */
@property (strong, nonatomic) UIButton *compBtn;
@end

@implementation FUBeautyController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* 在基类控制器中，已经加载了美颜 */
   // [[FUManager shareManager] loadFilter];
    [[FUManager shareManager] loadBeautyType:@"new_face_tracker_pose"];
    
    [self setupView];

    
    self.headButtonView.selectedImageBtn.hidden = NO;
    [self.view bringSubviewToFront:self.photoBtn];

//    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(50, 100, 80, 30)];
//    label1.text = @"窄脸:";
//    label1.textColor = [UIColor redColor];
//    [self.view addSubview:label1];
//
//    UISlider *slider1 = [[UISlider alloc] initWithFrame:CGRectMake(150, 100, 200, 20)];
//    [slider1 addTarget:self action:@selector(sliderChange1:) forControlEvents:UIControlEventValueChanged];
//    [self.view addSubview:slider1];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self demoBarSetBeautyDefultParams];
    
    /* 轻美妆 */
    [[FUManager shareManager] loadMakeupBundleWithName:@"light_makeup"];
    [[FUManager shareManager] removeNamaRenderWithType:FUNamaHandleTypeMakeup];
}

-(void)setupView{
    _demoBar = [[FUAPIDemoBar alloc] init];
    [self demoBarSetBeautyDefultParams];
//    [self.view addSubview:_demoBar];
    [self.view insertSubview:_demoBar atIndex:1];
    
    [_demoBar mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view.mas_bottom);
        }
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(231);
    }];
    
    /* 性能优化按钮 */
//    _performanceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_performanceBtn setImage:[UIImage imageNamed:@"Performance"] forState:UIControlStateNormal];
//    [_performanceBtn setImage:[UIImage imageNamed:@"Performance_selected"] forState:UIControlStateSelected];
//    _performanceBtn.tintColor = [UIColor whiteColor];
//    _performanceBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//    [_performanceBtn setTitle:NSLocalizedString(@"Performance_Preferred",nil) forState:UIControlStateNormal];
//    [_performanceBtn addTarget:self action:@selector(performanceAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_performanceBtn];
//    [_performanceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.headButtonView.mas_bottom);
//        make.right.equalTo(self.view).offset(-10);
//        make.width.mas_equalTo(100);
//        make.height.mas_equalTo(44);
//    }];
    
    /* 比对按钮 */
    _compBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_compBtn setImage:[UIImage imageNamed:@"demo_icon_contrast"] forState:UIControlStateNormal];
    [_compBtn addTarget:self action:@selector(TouchDown) forControlEvents:UIControlEventTouchDown];
    [_compBtn addTarget:self action:@selector(TouchUp) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    _compBtn.hidden = YES;
    [self.view addSubview:_compBtn];
    if (iPhoneXStyle) {
        _compBtn.frame = CGRectMake(15 , self.view.frame.size.height - 70 - 182 - 34, 44, 44);
    }else{
        _compBtn.frame = CGRectMake(15 , self.view.frame.size.height - 70 - 182, 44, 44);
    }
}


//-(void)performanceAction:(UIButton *)btn{
//    btn.selected = !btn.selected;
//    /* 全局美颜参数设置 */
//    [[FUManager shareManager] setBeautyDefaultParameters];
//    [self demoBarSetBeautyDefultParams];
//}

- (void)demoBarSetBeautyDefultParams {
    _demoBar.delegate = nil ;
    _demoBar.blurLevel_0 = [FUManager shareManager].blurLevel_0;
//    _demoBar.sharpenLevel = [FUManager shareManager].sharpenLevel ;
    _demoBar.colorLevel = [FUManager shareManager].whiteLevel ;
    _demoBar.redLevel = [FUManager shareManager].redLevel;
    _demoBar.eyeBrightLevel = [FUManager shareManager].eyelightingLevel ;
    _demoBar.toothWhitenLevel = [FUManager shareManager].beautyToothLevel ;
    
    _demoBar.vLevel =  [FUManager shareManager].vLevel;
    _demoBar.eggLevel = [FUManager shareManager].eggLevel;
    _demoBar.narrowLevel = [FUManager shareManager].narrowLevel;
    _demoBar.smallLevel = [FUManager shareManager].smallLevel;
    //    _demoBar.faceShape = [FUManager shareManager].faceShape ;
    _demoBar.enlargingLevel = [FUManager shareManager].enlargingLevel ;
    _demoBar.thinningLevel = [FUManager shareManager].thinningLevel ;
    //    _demoBar.enlargingLevel_new = [FUManager shareManager].enlargingLevel_new ;
    //    _demoBar.thinningLevel_new = [FUManager shareManager].thinningLevel_new ;
    _demoBar.chinLevel = [FUManager shareManager].jewLevel ;
    _demoBar.foreheadLevel = [FUManager shareManager].foreheadLevel ;
    _demoBar.noseLevel = [FUManager shareManager].noseLevel ;
    _demoBar.mouthLevel = [FUManager shareManager].mouthLevel ;
    
    _demoBar.filtersDataSource = [FUManager shareManager].filtersDataSource ;
    _demoBar.beautyFiltersDataSource = [FUManager shareManager].beautyFiltersDataSource ;
    _demoBar.filtersCHName = [FUManager shareManager].filtersCHName ;
    _demoBar.selectedFilter = [FUManager shareManager].selectedFilter ;
    _demoBar.selectedFilterLevel = [FUManager shareManager].selectedFilterLevel;
    _demoBar.delegate = self;
}


-(void)setOrientation:(int)orientation{
    [super setOrientation:orientation];
    [[FUManager shareManager] setParamItemAboutType:FUNamaHandleTypeBeautyType name:@"orientation" value:orientation];
}

#pragma  mark -  按钮点击
-(void)didClickSelPhoto{
    FUSelectedImageController *vc = [[FUSelectedImageController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)TouchDown{
    self.openComp = YES;
}

- (void)TouchUp{
    self.openComp = NO;
}

#pragma mark -  FUAPIDemoBarDelegate
/**设置美颜参数*/
- (void)demoBarBeautyParamChanged{
    [self syncBeautyParams];
}

-(void)restDefaultValue:(int)type{
    if (type == 1) {//美肤
       [[FUManager shareManager] setBeautyDefaultParameters:FUBeautyModuleTypeSkin];
    }
    
    if (type == 2) {
       [[FUManager shareManager] setBeautyDefaultParameters:FUBeautyModuleTypeShape];
    }
    
    [self demoBarSetBeautyDefultParams];
}

- (void)syncBeautyParams{
    [FUManager shareManager].blurLevel_0 = _demoBar.blurLevel_0;
//    [FUManager shareManager].sharpenLevel = _demoBar.sharpenLevel;
    [FUManager shareManager].whiteLevel = _demoBar.colorLevel;
    [FUManager shareManager].redLevel = _demoBar.redLevel;
    [FUManager shareManager].eyelightingLevel = _demoBar.eyeBrightLevel;
    [FUManager shareManager].beautyToothLevel = _demoBar.toothWhitenLevel;
    [FUManager shareManager].vLevel = _demoBar.vLevel;
    [FUManager shareManager].eggLevel = _demoBar.eggLevel;
    [FUManager shareManager].narrowLevel = _demoBar.narrowLevel;
    [FUManager shareManager].smallLevel = _demoBar.smallLevel;
    [FUManager shareManager].enlargingLevel = _demoBar.enlargingLevel;
    [FUManager shareManager].thinningLevel = _demoBar.thinningLevel;
    //    [FUManager shareManager].enlargingLevel_new = _demoBar.enlargingLevel_new;
    //    [FUManager shareManager].thinningLevel_new = _demoBar.thinningLevel_new;
    
    [FUManager shareManager].jewLevel = _demoBar.chinLevel;
    [FUManager shareManager].foreheadLevel = _demoBar.foreheadLevel;
    [FUManager shareManager].noseLevel = _demoBar.noseLevel;
    [FUManager shareManager].mouthLevel = _demoBar.mouthLevel;
    
    /* 暂时解决展示表中，没有显示滤镜，引起bug */
    if (![[FUManager shareManager].beautyFiltersDataSource containsObject:_demoBar.selectedFilter]) {
        return;
    }
    if (![[FUManager shareManager].selectedFilter isEqualToString:_demoBar.selectedFilter]) {
        [FUManager shareManager].selectedFilter = _demoBar.selectedFilter ;
        NSString *tipName = [FUManager shareManager].filtersCHName[_demoBar.selectedFilter];
        [self showMessage:NSLocalizedString(tipName,nil)];
    }

    [FUManager shareManager].selectedFilterLevel = _demoBar.selectedFilterLevel;
    
}


#pragma  mark -  提示UI
- (void)showMessage:(NSString *)string{
    //[SVProgressHUD showWithStatus:string]; //设置需要显示的文字
    [SVProgressHUD showImage:[UIImage imageNamed:@"wrt424erte2342rx"] status:string];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom]; //设置HUD背景图层的样式
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.74]];
    [SVProgressHUD setBackgroundLayerColor:[UIColor clearColor]];
    [SVProgressHUD setCornerRadius:5];
    [SVProgressHUD dismissWithDelay:1.5];
}


-(void)demoBarShouldShowMessage:(NSString *)message {
    
    self.tipLabel.hidden = NO;
    self.tipLabel.text = message;
    [FUBeautyController cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissTipLabel) object:nil];
    [self performSelector:@selector(dismissTipLabel) withObject:nil afterDelay:1 ];
}

-(void)demoBarDidShowTopView:(BOOL)shown {
    [self setPhotoScaleWithHeight:self.demoBar.frame.size.height show:shown];
}

- (void)setPhotoScaleWithHeight:(CGFloat)height show:(BOOL)shown {
    
    if (shown) {
        _compBtn.hidden = NO;
        CGAffineTransform photoTransform0 = CGAffineTransformMakeTranslation(0, height * -0.7) ;
        CGAffineTransform photoTransform1 = CGAffineTransformMakeScale(0.9, 0.9);
        
        [UIView animateWithDuration:0.35 animations:^{
            
            self.photoBtn.transform = CGAffineTransformConcat(photoTransform0, photoTransform1) ;
        }];
    } else {
        _compBtn.hidden = YES;
        [UIView animateWithDuration:0.35 animations:^{
            
            self.photoBtn.transform = CGAffineTransformIdentity ;
        }];
    }
}

- (void)dismissTipLabel{
    self.tipLabel.hidden = YES;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.demoBar hiddeTopView];
}

#pragma mark -  FUMakeUpViewDelegate
-(void)makeupViewDidSelectedNamaStr:(NSString *)namaStr valueArr:(NSArray *)valueArr{
    [[FUManager shareManager] setMakeupItemStr:namaStr valueArr:valueArr];
}

-(void)makeupViewDidSelectedNamaStr:(NSString *)namaStr imageName:(NSString *)imageName{
    if (!namaStr || !imageName) {
        return;
    }
    [[FUManager shareManager] setMakeupItemParamImageName:imageName  param:namaStr];
}

-(void)makeupViewDidChangeValue:(float)value namaValueStr:(NSString *)namaStr{
    
    [[FUManager shareManager] setMakeupItemIntensity:value param:namaStr];
}

-(void)makeupFilter:(NSString *)filterStr value:(float)filterValue{
    if(!filterStr || [filterStr isEqualToString:@""]){
        return;
    }
    self.demoBar.selectedFilter = filterStr;
    self.demoBar.selectedFilterLevel = filterValue;
    [FUManager shareManager].selectedFilter = filterStr ;
    [FUManager shareManager].selectedFilterLevel = filterValue;
}

-(NSArray *)jsonToLipRgbaArrayResName:(NSString *)resName{
    NSString *path=[[NSBundle mainBundle] pathForResource:resName ofType:@"json"];
    NSData *data=[[NSData alloc] initWithContentsOfFile:path];
    //解析成字典
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *rgba = [dic objectForKey:@"rgba"];
    
    if (rgba.count != 4) {
        NSLog(@"颜色json不合法");
    }
    return rgba;
}

-(void)makeupViewDidSelectedSupModle:(FUMakeupSupModel *)model{
    dispatch_async([FUManager shareManager].makeupQueue, ^{
        if ([model.makeupBundle isEqualToString:@""] || !model.makeupBundle) {
             [[FUManager shareManager] removeNamaRenderWithType:FUNamaHandleTypeMakeup];
        }else{
            [[FUManager shareManager] rejoinNamaRenderWithType:FUNamaHandleTypeMakeup];
        }
    });
}


-(void)dealloc{
    if (![[FUManager shareManager].beautyFiltersDataSource containsObject:_demoBar.selectedFilter]) {
        [[FUManager shareManager] setDefaultFilter];
    }
}

@end
