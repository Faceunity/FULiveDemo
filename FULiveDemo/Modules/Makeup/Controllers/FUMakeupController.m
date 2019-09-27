//
//  FUMakeupController.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/1/30.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import "FUMakeupController.h"
#import "FUMakeUpView.h"
#import "FUManager.h"
#import "FUMakeupSupModel.h"
#import "MJExtension.h"
#import "FUColourView.h"
#import <CoreMotion/CoreMotion.h>

@interface FUMakeupController ()<FUMakeUpViewDelegate,FUColourViewDelegate>
/* 化妆视图 */
@property (nonatomic, strong) FUMakeUpView *makeupView ;
/* 颜色选择视图 */
@property (nonatomic, strong) FUColourView *colourView;
/* 监听屏幕方向 */
@property (nonatomic, strong) CMMotionManager *motionManager;
/* 当前 */
@property (nonatomic, assign) int orientation;

@end

@implementation FUMakeupController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[FUManager shareManager] loadMakeupType:@"new_face_tracker"];
    [[FUManager shareManager] loadMakeupBundleWithName:@"face_makeup"];
    
    [self setupView];
    [self setupColourView];
    
    /* 美妆道具 */
    [_makeupView setSelSupItem:1];
    
    [self startListeningDirectionOfDevice];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self stopListeningDirectionOfDevice];
}


-(void)setupColourView{
    if (iPhoneXStyle) {
        _colourView = [[FUColourView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 15 - 60, self.view.frame.size.height - 250 - 182 - 10 - 34, 60, 250)];
    }else{
        _colourView = [[FUColourView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 15 - 60, self.view.frame.size.height - 250 - 182 - 10, 60, 250)];
    }
    _colourView.delegate = self;
    _colourView.hidden = YES;
    [self.view addSubview:_colourView];
    
}

-(void)setupView{
    NSString *wholePath=[[NSBundle mainBundle] pathForResource:@"makeup_whole" ofType:@"json"];
    NSData *wholeData=[[NSData alloc] initWithContentsOfFile:wholePath];
    NSDictionary *wholeDic=[NSJSONSerialization JSONObjectWithData:wholeData options:NSJSONReadingMutableContainers error:nil];
    NSArray *supArray = [FUMakeupSupModel mj_objectArrayWithKeyValuesArray:wholeDic[@"data"]];

    _makeupView = [[FUMakeUpView alloc] init];
    _makeupView.delegate = self;
    [_makeupView setWholeArray:supArray];
    _makeupView.backgroundColor = [UIColor clearColor];
    _makeupView.topView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    _makeupView.bottomCollection.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [self.view addSubview:_makeupView];
    
    [_makeupView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view.mas_bottom);
        }
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(182);
    }];
    
    self.photoBtn.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(0, -100), CGAffineTransformMakeScale(0.8, 0.8));
}


#pragma mark -  FUMakeUpViewDelegate
-(void)makeupCustomShow:(BOOL)isShow{
    if (isShow) {
        [UIView animateWithDuration:0.2 animations:^{
            self.photoBtn.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(0, -150), CGAffineTransformMakeScale(0.8, 0.8)) ;
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.photoBtn.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(0, -100), CGAffineTransformMakeScale(0.8, 0.8));
        }];
    }
}

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

-(void)makeupViewSelectiveColorArray:(NSArray<NSArray *> *)colors selColorIndex:(int)index{
    [_colourView setDataColors:colors];
    [_colourView setSelCell:index];
}

-(void)makeupFilter:(NSString *)filterStr value:(float)filterValue{
    if (!filterStr) {
        return;
    }
    [FUManager shareManager].selectedFilter = filterStr ;
    [FUManager shareManager].selectedFilterLevel = filterValue;
}

-(void)makeupSelColorStata:(BOOL)stata{
    _colourView.hidden = stata ? NO :YES;
}


-(void)makeupViewDidSelTitle:(NSString *)nama{
    self.tipLabel.hidden = NO;
    self.tipLabel.text = NSLocalizedString(nama, nil);
    [FUMakeupController cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissTipLabel) object:nil];
    [self performSelector:@selector(dismissTipLabel) withObject:nil afterDelay:1 ];
}

- (void)dismissTipLabel{
    self.tipLabel.hidden = YES;
}

#pragma  mark -  FUColourViewDelegate
-(void)colourViewDidSelIndex:(int)index{
    [_makeupView changeSubItemColorIndex:index];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (!_makeupView.topHidden) {
        [_makeupView hiddenTopCollectionView:YES];
        _colourView.hidden = YES;
    }
}


#pragma  mark -  方向监听

/// 开启屏幕旋转的检测
- (void)startListeningDirectionOfDevice {
    if (self.motionManager == nil) {
        self.motionManager = [[CMMotionManager alloc] init];
    }
    self.motionManager.deviceMotionUpdateInterval = 0.3;
    
    // 判断设备传感器是否可用
    if (self.motionManager.deviceMotionAvailable) {
        // 启动设备的运动更新，通过给定的队列向给定的处理程序提供数据。
        [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
            [self performSelectorOnMainThread:@selector(handleDeviceMotion:) withObject:motion waitUntilDone:YES];
        }];
    } else {
        [self setMotionManager:nil];
    }
}

- (void)stopListeningDirectionOfDevice {
    if (_motionManager) {
        [_motionManager stopDeviceMotionUpdates];
        _motionManager = nil;
    }
}

- (void)handleDeviceMotion:(CMDeviceMotion *)deviceMotion {

    double x = deviceMotion.gravity.x;
    double y = deviceMotion.gravity.y;
    int orientation = 0;
    
    if (fabs(y) >= fabs(x)) {// 竖屏
        if (y < 0) {
            orientation = 0;
        }
        else {
            orientation = 2;
        }
    }
    else { // 横屏
        if (x < 0) {
           orientation = 1;
        }
        else {
           orientation = 3;
        }
    }
    
    if (orientation != _orientation) {
        self.orientation = orientation;
    }
    
}

-(void)setOrientation:(int)orientation{
    _orientation = orientation;
     [[FUManager shareManager] setParamItemAboutType:FUNamaHandleTypeMakeupType name:@"orientation" value:orientation];
}


-(void)dealloc{
//    [[FUManager shareManager] setDefaultFilter];
    [self stopListeningDirectionOfDevice];

}

@end
