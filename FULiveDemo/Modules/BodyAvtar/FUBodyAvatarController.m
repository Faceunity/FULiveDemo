//
//  FUBodyAvtarController.m
//  FULiveDemo
//
//  Created by 孙慕 on 2020/6/17.
//  Copyright © 2020 FaceUnity. All rights reserved.
//

#import "FUBodyAvatarController.h"
#import "FUSwitch.h"
// #import "FUBodyCollectionView.h"
#import "FUBodyAvatarManager.h"

#import <FUCommonUIComponent/FUItemsView.h>

@interface FUBodyAvatarController ()<FUItemsViewDelegate>

@property(nonatomic,strong)NSMutableDictionary *itemsHache;

@property (strong, nonatomic) FUGLDisplayView *mPerView;

@property (strong, nonatomic) FUSwitch *mSwitch;

@property(strong, nonatomic) NSArray <NSString *>*mItmsArray;
@property(strong, nonatomic) FUItemsView *bodyItemsView;

@property (nonatomic, strong) FUBodyAvatarManager *bodyAvatarManager;
@end

@implementation FUBodyAvatarController

- (BOOL)needsLoadingBeauty {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.bodyAvatarManager = [[FUBodyAvatarManager alloc] init];
    
    self.headButtonView.inputSegm.hidden = YES;
    
    /* 待绑定的道具 */
    _mItmsArray = @[@"avatar_female",@"avatar_male"];
    
    /* 句柄缓存对象 */
    _itemsHache = [NSMutableDictionary dictionary];
    
    
    [self setupBodySubView];
    
    [self itemsView:self.bodyItemsView didSelectItemAtIndex:0];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.headButtonView.switchBtn.selected = YES;
    [self.mCamera changeCameraInputDeviceisFront:NO];
    [FURenderKit shareRenderKit].internalCameraSetting.position = AVCaptureDevicePositionBack;
}

-(void)setupBodySubView{
    self.photoBtn.transform = CGAffineTransformMakeTranslation(0, -36) ;
    self.photoBtn.hidden = YES;
    
    _mPerView = [[FUGLDisplayView alloc] initWithFrame:CGRectMake(FUScreenWidth - 90 - 5, FUScreenHeight - 144 - 5 - 80 - (iPhoneXStyle ? 34:0), 90, 144)];
     UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanAction:)];
     [_mPerView addGestureRecognizer:panGestureRecognizer];
     [self.view addSubview:_mPerView];
    
    _bodyItemsView = [[FUItemsView alloc] init];
    _bodyItemsView.delegate = self;
    _bodyItemsView.items = self.mItmsArray;
    _bodyItemsView.selectedIndex = 0;
    [self.view addSubview:_bodyItemsView];
    [_bodyItemsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.right.equalTo(self.view);
        if (iPhoneXStyle) {
            make.height.mas_equalTo(80 + 34);
        }else{
            make.height.mas_equalTo(80);
        }
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

#pragma mark - Overriding

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

- (FUAIModelType)necessaryAIModelTypes {
    return FUAIModelTypeFace | FUAIModelTypeHuman;
}

#pragma mark - FUItemsViewDelegate

- (void)itemsView:(FUItemsView *)itemsView didSelectItemAtIndex:(NSInteger)index {
    [self switchSex:self.mSwitch];
    [self.bodyAvatarManager loadAvatarWithIndex:(int)index];
}

#pragma  mark -  UI Action

-(void)switchSex:(FUSwitch *)mSwitch{
    if (mSwitch.on) {//全
        [self.bodyAvatarManager switchBodyTrackMode:FUBodyTrackModeFull];
     }else{//半身
        [self.bodyAvatarManager switchBodyTrackMode:FUBodyTrackModeHalf];
     }
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
            if ((sender.view.center.x + point.x - senderHalfViewWidth) <= 5 || sender.view.center.x < FUScreenWidth/2) {
                viewCenter.x = senderHalfViewWidth + 5;
            }
            if ((sender.view.center.x + point.x + senderHalfViewWidth) >= FUScreenWidth - 5 || sender.view.center.x >= FUScreenWidth/2) {
                viewCenter.x = FUScreenWidth - senderHalfViewWidth - 5;
            }
            if ((sender.view.center.y + point.y - senderHalfViewHeight) <= 75) {
                viewCenter.y = senderHalfViewHeight + 75;
            }
            if ((sender.view.center.y + point.y + senderHalfViewHeight) >= (FUScreenHeight -90 -  34)) {
                viewCenter.y = FUScreenHeight - senderHalfViewHeight - 90 - 34;
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
