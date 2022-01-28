//
//  FUBodyAvtarController.m
//  FULiveDemo
//
//  Created by 孙慕 on 2020/6/17.
//  Copyright © 2020 FaceUnity. All rights reserved.
//

#import "FUBodyAvatarController.h"
#import "FUSwitch.h"
#import "FUBodyCollectionView.h"
#import "FUBodyAvatarManager.h"

@interface FUBodyAvatarController ()<FUBodyItemsDelegate>{
    dispatch_semaphore_t backSignal;

}

@property(nonatomic,strong)NSMutableDictionary *itemsHache;

@property (strong, nonatomic) FUGLDisplayView *mPerView;

@property (strong, nonatomic) FUSwitch *mSwitch;

@property(strong, nonatomic) NSArray <NSString *>*mItmsArray;
@property(strong, nonatomic) FUBodyCollectionView *bodyItemsView;

@property (nonatomic, strong) FUBodyAvatarManager *bodyAvatarManager;
@end

@implementation FUBodyAvatarController
- (BOOL)isNeedLoadBeauty {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.bodyAvatarManager = [[FUBodyAvatarManager alloc] init];
    
    self.headButtonView.inputSegm.hidden = YES;
    
    /* 道具切信号 */
    backSignal = dispatch_semaphore_create(1);
    
    /* 待绑定的道具 */
    _mItmsArray = @[@"avatar_female",@"avatar_male"];
    
    /* 句柄缓存对象 */
    _itemsHache = [NSMutableDictionary dictionary];
    
    
    [self setupBodySubView];
    
    [self bodyDidSelectedItemsIndex:0];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.headButtonView.switchBtn.selected = YES;
    [self.mCamera changeCameraInputDeviceisFront:NO];
}

-(void)setupBodySubView{
    self.photoBtn.transform = CGAffineTransformMakeTranslation(0, -36) ;
    self.photoBtn.hidden = YES;
    
    _mPerView = [[FUGLDisplayView alloc] initWithFrame:CGRectMake(KScreenWidth - 90 - 5, KScreenHeight - 144 - 5 - 80 - (iPhoneXStyle ? 34:0), 90, 144)];
     UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanAction:)];
     [_mPerView addGestureRecognizer:panGestureRecognizer];
     [self.view addSubview:_mPerView];
    
    _bodyItemsView = [[FUBodyCollectionView alloc] init];
    _bodyItemsView.delegate = self;
    [_bodyItemsView updateCollectionAndSel:0];
    [self.view addSubview:_bodyItemsView];
    [_bodyItemsView setItemsArray:self.mItmsArray];
    _bodyItemsView.backgroundColor = [UIColor clearColor];
    [_bodyItemsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.right.equalTo(self.view);
        if (iPhoneXStyle) {
            make.height.mas_equalTo(80 + 34);
        }else{
            make.height.mas_equalTo(80);
        }
    }];
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.alpha = 1.0;
    [_bodyItemsView addSubview:effectview];
    [_bodyItemsView sendSubviewToBack:effectview];
    /* 磨玻璃 */
    [effectview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(_bodyItemsView);
    }];
    
    
    _mSwitch = [[FUSwitch alloc] initWithFrame:CGRectMake(60, 150, 86, 32) onColor:[UIColor colorWithRed:31 / 255.0 green:178 / 255.0 blue:255 / 255.0 alpha:1.0] offColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:12] ballSize:30];
    _mSwitch.onText = FUNSLocalizedString(@"全身驱动", nil);
    _mSwitch.offText = FUNSLocalizedString(@"半身驱动", nil);
    _mSwitch.offLabel.textColor = [UIColor colorWithRed:31 / 255.0 green:178 / 255.0 blue:255 / 255.0 alpha:1.0];
    _mSwitch.on = YES;
    [_mSwitch addTarget:self action:@selector(switchSex:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_mSwitch];
    [_mSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bodyItemsView.mas_top).offset(-17);
        make.left.equalTo(self.view).offset(17);
        make.width.mas_equalTo(86);
        make.height.mas_equalTo(32);
    }];

}

- (void)renderKitWillRenderFromRenderInput:(FURenderInput *)renderInput {
    [super renderKitWillRenderFromRenderInput:renderInput];
    CVPixelBufferRef pixelBuffer = renderInput.pixelBuffer;
    [self.mPerView displayPixelBuffer:pixelBuffer];
}

- (void)renderKitDidRenderToOutput:(FURenderOutput *)renderOutput {
    [super renderKitDidRenderToOutput:renderOutput];
}

-(void)displayPromptText{
    BOOL result  = [self.baseManager bodyTrace];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.noTrackLabel.text = FUNSLocalizedString(@"未检测到人体",nil);
        self.noTrackLabel.hidden = result;
    }) ;
}

#pragma  mark -  UI Action

/* UI 点击 */
-(void)bodyDidSelectedItemsIndex:(int)index{
    [self switchSex:self.mSwitch];
    [self.bodyAvatarManager loadAvatarWithIndex:index];
}

-(void)switchSex:(FUSwitch *)mSwitch{
    if (mSwitch.on) {//全
        [self.bodyAvatarManager switchBodyTrackMode:FUBodyTrackModeFull];
     }else{//半身
        [self.bodyAvatarManager switchBodyTrackMode:FUBodyTrackModeHalf];
     }
}

/*
 返回按钮
 */
-(void)headButtonViewBackAction:(UIButton *)btn{
    dispatch_semaphore_wait(backSignal, DISPATCH_TIME_FOREVER);
    [self.bodyAvatarManager releaseItem];
    [self.navigationController popViewControllerAnimated:YES];
    dispatch_semaphore_signal(backSignal);
    [super headButtonViewBackAction:btn];
}

-(void)headButtonViewSwitchAction:(UIButton *)sender{
    sender.userInteractionEnabled = NO ;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
        sender.userInteractionEnabled = YES ;
    });
    //TODO: todo 替换内部相机的时需要设置一下
     [self.mCamera changeCameraInputDeviceisFront:sender.selected];
    /**切换摄像头要调用此函数*/
    [self.baseManager setOnCameraChange];
    sender.selected = !sender.selected ;
}

#pragma  mark -  手势
- (void)handlePanAction:(UIPanGestureRecognizer *)sender {
    CGPoint point = [sender translationInView:[sender.view superview]];
    
    CGFloat senderHalfViewWidth = sender.view.frame.size.width / 2;
    CGFloat senderHalfViewHeight = sender.view.frame.size.height / 2;
    
    __block CGPoint viewCenter = CGPointMake(sender.view.center.x + point.x, sender.view.center.y + point.y);
    // 拖拽状态结束
    if (sender.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.4 animations:^{
            if ((sender.view.center.x + point.x - senderHalfViewWidth) <= 5 || sender.view.center.x < KScreenWidth/2) {
                viewCenter.x = senderHalfViewWidth + 5;
            }
            if ((sender.view.center.x + point.x + senderHalfViewWidth) >= KScreenWidth - 5 || sender.view.center.x >= KScreenWidth/2) {
                viewCenter.x = KScreenWidth - senderHalfViewWidth - 5;
            }
            if ((sender.view.center.y + point.y - senderHalfViewHeight) <= 75) {
                viewCenter.y = senderHalfViewHeight + 75;
            }
            if ((sender.view.center.y + point.y + senderHalfViewHeight) >= (KScreenHeight -90 -  34)) {
                viewCenter.y = KScreenHeight - senderHalfViewHeight - 90 - 34;
            }
            sender.view.center = viewCenter;
        } completion:^(BOOL finished) {

        }];
        [sender setTranslation:CGPointMake(0, 0) inView:[sender.view superview]];
    } else {
        // UIGestureRecognizerStateBegan || UIGestureRecognizerStateChanged
        viewCenter.x = sender.view.center.x + point.x;
        viewCenter.y = sender.view.center.y + point.y;
        sender.view.center = viewCenter;
        [sender setTranslation:CGPointMake(0, 0) inView:[sender.view superview]];
    }
}

@end
