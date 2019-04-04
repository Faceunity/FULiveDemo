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

@interface FUBeautyController ()<FUAPIDemoBarDelegate,FUMakeUpViewDelegate>

@property (strong, nonatomic) FUAPIDemoBar *demoBar;
@property (strong, nonatomic) UIButton *performanceBtn;
@end

@implementation FUBeautyController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* 在基类控制器中，已经加载了美颜 */
   // [[FUManager shareManager] loadFilter];
    
    [self setupView];
    self.performanceBtn.hidden = NO;
    self.performanceBtn.selected = [FUManager shareManager].performance;
    
    self.headButtonView.selectedImageBtn.hidden = NO;
    [self.view bringSubviewToFront:self.photoBtn];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self demoBarSetBeautyDefultParams];
}

-(void)setupView{
    _demoBar = [[FUAPIDemoBar alloc] init];
    _demoBar.performance = [FUManager shareManager].performance;
    [self demoBarSetBeautyDefultParams];
    [self.view addSubview:_demoBar];
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
    _performanceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_performanceBtn setImage:[UIImage imageNamed:@"Performance"] forState:UIControlStateNormal];
    [_performanceBtn setImage:[UIImage imageNamed:@"Performance_selected"] forState:UIControlStateSelected];
    _performanceBtn.tintColor = [UIColor whiteColor];
    _performanceBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_performanceBtn setTitle:NSLocalizedString(@"Performance_Preferred",nil) forState:UIControlStateNormal];
    [_performanceBtn addTarget:self action:@selector(performanceAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_performanceBtn];
    [_performanceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headButtonView.mas_bottom);
        make.right.equalTo(self.view).offset(-10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(44);
    }];
}


-(void)performanceAction:(UIButton *)btn{
    btn.selected = !btn.selected;
    self.demoBar.performance = btn.selected;
    /* 全局美颜参数设置 */
    [FUManager shareManager].performance = btn.selected;
    [[FUManager shareManager] setBeautyDefaultParameters];
    [self demoBarSetBeautyDefultParams];
}

- (void)demoBarSetBeautyDefultParams {
    _demoBar.delegate = nil ;
    _demoBar.skinDetect = [FUManager shareManager].skinDetectEnable;
    _demoBar.heavyBlur = [FUManager shareManager].blurShape ;
    _demoBar.blurLevel = [FUManager shareManager].blurLevel ;
    _demoBar.colorLevel = [FUManager shareManager].whiteLevel ;
    _demoBar.redLevel = [FUManager shareManager].redLevel;
    _demoBar.eyeBrightLevel = [FUManager shareManager].eyelightingLevel ;
    _demoBar.toothWhitenLevel = [FUManager shareManager].beautyToothLevel ;
    _demoBar.faceShape = [FUManager shareManager].faceShape ;
    _demoBar.enlargingLevel = [FUManager shareManager].enlargingLevel ;
    _demoBar.thinningLevel = [FUManager shareManager].thinningLevel ;
    _demoBar.enlargingLevel_new = [FUManager shareManager].enlargingLevel_new ;
    _demoBar.thinningLevel_new = [FUManager shareManager].thinningLevel_new ;
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
    _demoBar.demoBar.makeupView.delegate = self;
    _demoBar.demoBar.selMakeupIndex = _demoBar.demoBar.makeupView.supIndex;
}

#pragma  mark -  按钮点击
-(void)didClickSelPhoto{
    FUSelectedImageController *vc = [[FUSelectedImageController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark -  FUAPIDemoBarDelegate
/**设置美颜参数*/
- (void)demoBarBeautyParamChanged{
    [self syncBeautyParams];
}

- (void)syncBeautyParams{
    [FUManager shareManager].skinDetectEnable = _demoBar.skinDetect;
    [FUManager shareManager].blurShape = _demoBar.heavyBlur;
    [FUManager shareManager].blurLevel = _demoBar.blurLevel ;
    [FUManager shareManager].whiteLevel = _demoBar.colorLevel;
    [FUManager shareManager].redLevel = _demoBar.redLevel;
    [FUManager shareManager].eyelightingLevel = _demoBar.eyeBrightLevel;
    [FUManager shareManager].beautyToothLevel = _demoBar.toothWhitenLevel;
    [FUManager shareManager].faceShape = _demoBar.faceShape;
    [FUManager shareManager].enlargingLevel = _demoBar.enlargingLevel;
    [FUManager shareManager].thinningLevel = _demoBar.thinningLevel;
    [FUManager shareManager].enlargingLevel_new = _demoBar.enlargingLevel_new;
    [FUManager shareManager].thinningLevel_new = _demoBar.thinningLevel_new;
    [FUManager shareManager].jewLevel = _demoBar.chinLevel;
    [FUManager shareManager].foreheadLevel = _demoBar.foreheadLevel;
    [FUManager shareManager].noseLevel = _demoBar.noseLevel;
    [FUManager shareManager].mouthLevel = _demoBar.mouthLevel;
    
    /* 暂时解决展示表中，没有显示滤镜，引起bug */
    if (![[FUManager shareManager].beautyFiltersDataSource containsObject:_demoBar.selectedFilter]) {
        return;
    }
    [FUManager shareManager].selectedFilter = _demoBar.selectedFilter ;
    [FUManager shareManager].selectedFilterLevel = _demoBar.selectedFilterLevel;
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
        
        CGAffineTransform photoTransform0 = CGAffineTransformMakeTranslation(0, height * -0.7) ;
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

- (void)dismissTipLabel{
    self.tipLabel.hidden = YES;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.demoBar hiddeTopView];
}

#pragma mark -  FUMakeUpViewDelegate
- (void)makeupViewDidSelectedItemName:(NSString *)itemName namaStr:(NSString *)namaStr isLip:(BOOL)isLip{
    if (isLip) {
        NSArray *rgba = [self jsonToLipRgbaArrayResName:itemName];
        double lip[4] = {[rgba[0] doubleValue],[rgba[1] doubleValue],[rgba[2] doubleValue],[rgba[3] doubleValue]};
        [[FUManager shareManager] setMakeupItemLipstick:lip];
    }else{
        UIImage *namaImage = [UIImage imageNamed:itemName];
        if (!namaImage) {
            return;
        }
        [[FUManager shareManager] setMakeupItemParamImage:[UIImage imageNamed:itemName]  param:namaStr];
    }
}

-(void)makeupViewDidChangeValue:(float)value namaValueStr:(NSString *)namaStr{

    [[FUManager shareManager] setMakeupItemIntensity:value param:namaStr];
    
    NSLog(@"当前设置的值-------%lf",value);
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


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
