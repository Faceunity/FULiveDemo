//
//  FUHairController.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/1/31.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import "FUHairController.h"
#import "FUHairView.h"
#import "FUSwitch.h"
#import "SVProgressHUD.h"

typedef NS_ENUM(NSUInteger, FUHairModel) {
    FUHairModelModelNormal,
    FUHairModelModelGradient
};
@interface FUHairController ()<FUHairViewDelegate>
@property (nonatomic, strong) FUHairView *hairView ;

@property (nonatomic, assign) FUHairModel currentModle;

@end

@implementation FUHairController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    
    
}

-(void)setupView{
     _hairView = [[FUHairView alloc] init];
    _hairView.delegate = self;
    _hairView.itemsArray = self.model.items;
    [self.view addSubview:_hairView];
    [_hairView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.right.equalTo(self.view);
        if (iPhoneXStyle) {
            make.height.mas_equalTo(134 + 34);
        }else{
            make.height.mas_equalTo(134);
        }
        
    }];
    _hairView.backgroundColor = [UIColor clearColor];
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    [_hairView insertSubview:effectview atIndex:0];
    /* 磨玻璃 */
    [effectview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(_hairView);
    }];

    
    /* 初始状态 */
    [[FUManager shareManager] loadItem:@"hair_gradient" completion:nil];
    
    [[FUManager shareManager] setParamItemAboutType:FUNamaHandleTypeItem name:@"Index" value:0];
    [[FUManager shareManager] setParamItemAboutType:FUNamaHandleTypeItem name:@"Strength" value:0.5];
    _currentModle = FUHairModelModelGradient;

    
   /* 美发模式切换 */
//    FUSwitch *swit = [[FUSwitch alloc] initWithFrame:CGRectMake(60, 150, 86, 32) onColor:[UIColor colorWithRed:31 / 255.0 green:178 / 255.0 blue:255 / 255.0 alpha:1.0] offColor:[UIColor colorWithRed:31 / 255.0 green:178 / 255.0 blue:255 / 255.0 alpha:1.0] font:[UIFont systemFontOfSize:13] ballSize:30];
//    swit.onText = FUNSLocalizedString(@"高精版", nil);
//    swit.offText = FUNSLocalizedString(@"极速版", nil);
//    swit.on = YES;
//    [swit addTarget:self action:@selector(switchSex:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:swit];
//    [swit mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(_hairView.mas_top).offset(-17);
//        make.left.equalTo(self.view).offset(17);
//        make.width.mas_equalTo(86);
//        make.height.mas_equalTo(32);
//    }];
    
    self.photoBtn.transform = CGAffineTransformMakeTranslation(0, -100) ;
}

#pragma mark - FUHairViewDelegate
-(void)hairViewDidSelectedhairIndex:(NSInteger)index{
    if (index == -1) {
        [[FUManager shareManager] setParamItemAboutType:FUNamaHandleTypeItem name:@"Index" value:0];
        [[FUManager shareManager] setParamItemAboutType:FUNamaHandleTypeItem name:@"Strength" value:0];
    }else{
        if(index < 5) {//渐变色
            if (_currentModle != FUHairModelModelGradient) {
                [[FUManager shareManager] loadItem:@"hair_gradient" completion:nil];
                _currentModle = FUHairModelModelGradient;
            }
            [[FUManager shareManager] setParamItemAboutType:FUNamaHandleTypeItem name:@"Index" value:(int)index];
            [[FUManager shareManager] setParamItemAboutType:FUNamaHandleTypeItem name:@"Strength" value:self.hairView.slider.value];
        }else{
            if (_currentModle != FUHairModelModelNormal) {
                [[FUManager shareManager] loadItem:@"hair_normal" completion:nil];
                _currentModle = FUHairModelModelNormal;
            }
            [[FUManager shareManager] setParamItemAboutType:FUNamaHandleTypeItem name:@"Index" value:(int)index - 5];
            [[FUManager shareManager] setParamItemAboutType:FUNamaHandleTypeItem name:@"Strength" value:self.hairView.slider.value];
        }
    }
}

-(void)hairViewChanageStrength:(float)strength{
    [[FUManager shareManager] setParamItemAboutType:FUNamaHandleTypeItem name:@"Strength" value:strength];
}


#pragma  mark -  action

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

-(void)dealloc{
        [[FUManager shareManager] destoryItemAboutType:FUNamaHandleTypeItem];
}



@end
