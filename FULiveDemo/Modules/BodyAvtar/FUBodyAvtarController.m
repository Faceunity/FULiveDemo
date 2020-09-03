//
//  FUBodyAvtarController.m
//  FULiveDemo
//
//  Created by 孙慕 on 2020/6/17.
//  Copyright © 2020 FaceUnity. All rights reserved.
//

#import "FUBodyAvtarController.h"
#import "FUSwitch.h"
#import "FUBodCollectionView.h"

@interface FUBodyAvtarController ()<FUBodyItemsDelegate>{
    int oldSelIndex;
    dispatch_semaphore_t backSignal;

}

@property(nonatomic,strong)NSArray <NSArray *>*bindItems;//1.女  2.男

@property(nonatomic,strong)NSMutableDictionary *itemsHache;

@property (strong, nonatomic) FUOpenGLView *mPerView;

@property (strong, nonatomic) FUSwitch *mSwitch;

@property(strong, nonatomic) NSArray <NSString *>*mItmsArray;
@property(strong, nonatomic) FUBodCollectionView *bodyItemsView;
@end

@implementation FUBodyAvtarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.headButtonView.inputSegm.hidden = YES;
    
    /* 道具切信号 */
    backSignal = dispatch_semaphore_create(1);
    
    oldSelIndex = -1;
    /* 待绑定的道具 */
    _mItmsArray = @[@"avatar_female",@"avatar_male"];
    
    _bindItems = @[@[@"facemakeup_3",@"female_hair_23",@"headnv" ,@"midBody_female",@"taozhuang_12",@"toushi_5",@"xiezi_danxie"],@[@"headnan",@"kuzi_changku_5",@"male_hair_5",@"midBody_male",@"peishi_erding_2",@"toushi_7",@"waitao_3",@"xiezi_tuoxie_2"]];
    
    
    /* 句柄缓存对象 */
    _itemsHache = [NSMutableDictionary dictionary];
    
    /*
      抗锯齿
    */
    [[FUManager shareManager] loadBundleWithName:@"fxaa" aboutType:FUNamaHandleTypeFxaa];
    
    /*
       全身avtar 初始化加载的道具
       1,加载 controller
     */
    [[FUManager shareManager] loadBundleWithName:@"controller" aboutType:FUNamaHandleTypeBodyAvtar];
     dispatch_async([FUManager shareManager].asyncLoadQueue, ^{
        double position[3] = {0.0, 53.14, -537.94};
        int handle = [[FUManager shareManager] getHandleAboutType:FUNamaHandleTypeBodyAvtar];
         
         int subItem = [self loadItemwWithItemName:@"controller_config"];
         [FURenderer bindItems:handle items:&subItem itemsCount:1];
         
         /* 绑定默认道具
          1. 背景
          2. 回归动作
          3. 手势动作*/
         NSArray <NSString *>*defaultBindItem = @[@"default_bg",@"anim_idle",@"anim_eight",@"anim_fist",@"anim_greet",@"anim_gun",@"anim_heart",@"anim_hold",@"anim_korheart",@"anim_merge",@"anim_ok",@"anim_one", @"anim_palm",@"anim_rock",@"anim_six",@"anim_thumb",@"anim_two"];
         [self bindItems:defaultBindItem];
         
         [FURenderer itemSetParam:handle withName:@"enable_human_processor" value:@(1)];
         
         [FURenderer itemSetParamdv:handle withName:@"target_position" value:position length:3];
         [FURenderer itemSetParam:handle withName:@"target_angle" value:@(0)];
         [FURenderer itemSetParam:handle withName:@"reset_all" value:@(3)];
         [FURenderer itemSetParam:handle withName:@"human_3d_track_set_scene" value:@(1)];
         

    });
    
    [self setupBodySubView];
    
    [self bodyDidSelectedItemsIndex:0];
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.headButtonView.switchBtn.selected = YES;
     [self.mCamera changeCameraInputDeviceisFront:NO];
}

-(void)setupBodySubView{
    self.photoBtn.transform = CGAffineTransformMakeTranslation(0, -36) ;
    self.photoBtn.hidden = YES;
    
     _mPerView = [[FUOpenGLView alloc] initWithFrame:CGRectMake(KScreenWidth - 90 - 5, KScreenHeight - 146 - 5 - 90 - 34, 90, 146)];
     UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanAction:)];
     [_mPerView addGestureRecognizer:panGestureRecognizer];
     [self.view addSubview:_mPerView];
    
    _bodyItemsView = [[FUBodCollectionView alloc] init];
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
    _mSwitch.onText = NSLocalizedString(@"全身驱动", nil);
    _mSwitch.offText = NSLocalizedString(@"半身驱动", nil);
    _mSwitch.offLabel.textColor = [UIColor colorWithRed:31 / 255.0 green:178 / 255.0 blue:255 / 255.0 alpha:1.0];
    _mSwitch.on = YES;
    [_mSwitch addTarget:self action:@selector(switchSex:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_mSwitch];
    [_mSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bodyItemsView.mas_top).offset(-17);
        make.left.equalTo(self.view).offset(17);
        make.width.mas_equalTo(86);
        make.height.mas_equalTo(32);
    }];
    
    [_mPerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bodyItemsView.mas_top).offset(-17);
        make.right.equalTo(self.view).offset(-5);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(144);
    }];
}


/* 告诉父类，render时候走的接口

   这个接口特殊暂时不共用
 */
-(FUNamaHandleType)getNamaRenderType{
    return FUNamaHandleTypeBodyAvtar;
}


-(void)didOutputVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer{
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) ;
    CVPixelBufferLockBaseAddress(pixelBuffer,0);
    [self.mPerView displayPixelBuffer:pixelBuffer];
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    [super didOutputVideoSampleBuffer:sampleBuffer];
}

-(void)displayPromptText{
    int res  = fuHumanProcessorGetNumResults();
    dispatch_async(dispatch_get_main_queue(), ^{
            self.noTrackLabel.text = NSLocalizedString(@"未检测到人体",nil);
           self.noTrackLabel.hidden = res > 0 ? YES : NO;
    }) ;
}

#pragma  mark -  UI Action

/* UI 点击 */
-(void)bodyDidSelectedItemsIndex:(int)index{
    if (oldSelIndex >= 0) {//如果存在，解绑
        int temp = oldSelIndex;
        _mSwitch.hidden = NO;
         dispatch_async([FUManager shareManager].asyncLoadQueue, ^{
             [self unBindItems:self.bindItems[temp]];
        });
    }
    /* 绑定选中的新 模型数组 */
    dispatch_async([FUManager shareManager].asyncLoadQueue, ^{
         [self bindItems:self.bindItems[index]];
    });
    oldSelIndex = index;
}

-(void)switchSex:(FUSwitch *)mSwitch{
    int handle = [[FUManager shareManager] getHandleAboutType:FUNamaHandleTypeBodyAvtar];
    if (handle == 0) {
        NSLog(@"未加载道具---error");
        return;
    }
    if (!mSwitch.on) {//全
        static double position[3] = {0.0, 53.14, -537.94};
        if (iPhoneXStyle) {
            position[0] = 0.0;
            position[1] = 53.14;
            position[2] = -600;
        }
        
        [FURenderer itemSetParamdv:handle withName:@"target_position" value:position length:3];
        [FURenderer itemSetParam:handle withName:@"target_angle" value:@(0)];
        [FURenderer itemSetParam:handle withName:@"reset_all" value:@(3)];
        [FURenderer itemSetParam:handle withName:@"human_3d_track_set_scene" value:@(1)];
     }else{//半身
         [FURenderer itemSetParam:handle withName:@"human_3d_track_set_scene" value:@(0)];
         double position[3] = {0.0, 0, -183.89};
         if (iPhoneXStyle) {
             position[0] = 0.0;
             position[1] = 0;
             position[2] = -200;
         }
         
         [FURenderer itemSetParamdv:handle withName:@"target_position" value:position length:3];
         [FURenderer itemSetParam:handle withName:@"target_angle" value:@(0)];
         [FURenderer itemSetParam:handle withName:@"reset_all" value:@(3)];
     }
}

/*
 返回按钮
 */
-(void)headButtonViewBackAction:(UIButton *)btn{
    if (oldSelIndex >= 0) {//如果存在，解绑
         dispatch_async([FUManager shareManager].asyncLoadQueue, ^{
             [self unBindItems:self.bindItems[oldSelIndex]];
             /* 销毁所有绑定道具 */
             [self destoryItems];
        });
    }
    
    dispatch_semaphore_wait(backSignal, DISPATCH_TIME_FOREVER);
    [self.mCamera stopCapture];

    [[FUManager shareManager] destoryItems];
    [self.navigationController popViewControllerAnimated:YES];
    dispatch_semaphore_signal(backSignal);
    
}

-(void)headButtonViewSwitchAction:(UIButton *)sender{
    sender.userInteractionEnabled = NO ;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
        sender.userInteractionEnabled = YES ;
    });
     [self.mCamera changeCameraInputDeviceisFront:sender.selected];
    /**切换摄像头要调用此函数*/
    [[FUManager shareManager] onCameraChange];
    sender.selected = !sender.selected ;
}

#pragma  mark - 操作items

-(void)unBindItems:(NSArray <NSString *>*)items{
    NSInteger count  = items.count;
    int *oldItems = (int *)malloc(count * sizeof(int));
    for (int i  = 0; i < count; i ++) {
        oldItems[i] = [self loadItemwWithItemName:items[i]];
    }
    
    int controlHandle = [[FUManager shareManager] getHandleAboutType:FUNamaHandleTypeBodyAvtar];
    int res = [FURenderer unBindItems:controlHandle items:oldItems itemsCount:(int)count];
    NSLog(@"解绑道具---ret--%d",res);
    free(oldItems);
}

-(void)bindItems:(NSArray <NSString *>*)items{
    NSInteger count  = items.count;
    int *newitems = (int *)malloc(count * sizeof(int));
    for (int i  = 0; i < count; i ++) {
        newitems[i] = [self loadItemwWithItemName:items[i]];
    }
    
    int controlHandle = [[FUManager shareManager] getHandleAboutType:FUNamaHandleTypeBodyAvtar];
    int ret =[FURenderer bindItems:controlHandle items:newitems itemsCount:(int)count];
    
    NSLog(@"绑定--res--%d",ret);
    free(newitems);
}

-(void)destoryItems{
    for (NSString *key in _itemsHache) {
        int subHandle = [_itemsHache[key] intValue];
        [FURenderer destroyItem:subHandle];
    }
    [_itemsHache removeAllObjects];
}



#pragma  mark -  道具加载缓存
-(int)loadItemwWithItemName:(NSString *)bundleName{
    
    int handel = [self getHandleWithName:bundleName];
    if (handel == 0) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"];
        if (!filePath) {
             NSLog(@"error---%@ = nil",bundleName);
            return 0;
        }
        handel =  [FURenderer itemWithContentsOfFile:filePath];
        [self setCacheBundleName:bundleName value:handel];
    }
    return handel;
}

/* 缓存 */
-(void)setCacheBundleName:(NSString *)bundleName value:(int)handle{
    if ([bundleName isEqualToString:@""] || !bundleName) {
        return;
    }
    [_itemsHache setObject:@(handle) forKey:bundleName];

}

-(int)getHandleWithName:(NSString *)bundleName{
    if ([bundleName isEqualToString:@""] || !bundleName) {
        return 0;
    }
    return [_itemsHache[bundleName] intValue];
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
