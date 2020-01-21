//
//  FUBodyBeautyController.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/8/2.
//  Copyright © 2019 FaceUnity. All rights reserved.
//

#import "FUBodyBeautyController.h"
#import "FUBodyBeautyView.h"
#import "FUPosition.h"
#import "MJExtension.h"
#import <CoreMotion/CoreMotion.h>
#import "FUSelectedImageController.h"

@interface FUBodyBeautyController ()<FUBodyBeautyViewDelegate>
@property(nonatomic,strong)FUBodyBeautyView *mBodyBeautyView;

/* 监听屏幕方向 */
@property (nonatomic, strong) CMMotionManager *motionManager;
/* 当前 */
@property (nonatomic, assign) int orientation;
@end

@implementation FUBodyBeautyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupView];
 
    self.photoBtn.transform = CGAffineTransformMakeTranslation(0, -100);
    [[FUManager shareManager] loadBundleWithName:@"BodySlim" aboutType:FUNamaHandleTypeBodySlim];
    [[FUManager shareManager] setParamItemAboutType:FUNamaHandleTypeBodySlim name:@"Debug" value:0];
    
//    self.headButtonView.selectedImageBtn.hidden = NO;
    [self startListeningDirectionOfDevice];
    
}

-(void)setupView{
    NSString *bodyBeautyPath=[[NSBundle mainBundle] pathForResource:@"BodyBeautyDefault" ofType:@"json"];
    NSData *bodyData=[[NSData alloc] initWithContentsOfFile:bodyBeautyPath];
    NSDictionary *bodyDic=[NSJSONSerialization JSONObjectWithData:bodyData options:NSJSONReadingMutableContainers error:nil];
    NSArray *dataArray = [FUPosition mj_objectArrayWithKeyValuesArray:bodyDic];
    
    _mBodyBeautyView = [[FUBodyBeautyView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 134, [UIScreen mainScreen].bounds.size.width, 134) dataArray:dataArray];
    _mBodyBeautyView.delegate = self;
    [self.view addSubview:_mBodyBeautyView];

}


-(void)displayPromptText{
    int handle = [[FUManager shareManager] getHandleAboutType:FUNamaHandleTypeBodySlim];
    int res    = [FURenderer getDoubleParamFromItem:handle withName:@"HasHuman"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
            self.noTrackLabel.text = NSLocalizedString(@"未检测到人体",nil);
           self.noTrackLabel.hidden = res > 0 ? YES : NO;
    }) ;


}

#pragma  mark -  按钮点击
-(void)didClickSelPhoto{
    FUSelectedImageController *vc = [[FUSelectedImageController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma  mark -  FUBodyBeautyViewDelegate
-(void)bodyBeautyViewDidSelectPosition:(FUPosition *)position{
    if (!position.bundleKey) {
        return;
    }
    NSLog(@"------%@------%lf",position.bundleKey,position.value);
    [[FUManager shareManager] setParamItemAboutType:FUNamaHandleTypeBodySlim name:position.bundleKey value:position.value];
}

-(void)dealloc{
     [[FUManager shareManager] destoryItemAboutType:FUNamaHandleTypeBodySlim];
    
    [self stopListeningDirectionOfDevice];
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
    [[FUManager shareManager] setParamItemAboutType:FUNamaHandleTypeBodySlim name:@"Orientation" value:orientation];
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
