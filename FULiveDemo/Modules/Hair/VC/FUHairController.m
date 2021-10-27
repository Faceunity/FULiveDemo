//
//  FUHairController.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/1/31.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import "FUHairController.h"
#import "FUHairView.h"
#import "SVProgressHUD.h"
#import "FUHairManager.h"

@interface FUHairController ()<FUHairViewDelegate>
@property (nonatomic, strong) FUHairView *hairView ;

@property (nonatomic, assign) FUHairModel currentModle;

@property (nonatomic, strong) FUHairManager *hairManager;
@end

@implementation FUHairController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hairManager = [[FUHairManager alloc] init];
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
    self.photoBtn.transform = CGAffineTransformMakeTranslation(0, -100) ;
}

- (void)headButtonViewBackAction:(UIButton *)btn {
    [super headButtonViewBackAction:btn];
    [self.hairManager releaseItem];
}

#pragma mark - FUHairViewDelegate
-(void)hairViewDidSelectedhairIndex:(NSInteger)index{
    if (index == -1) {
        self.hairManager.hair.index = 0;
        self.hairManager.hair.strength = 0;
    }else{
        if(index < 5) {//渐变色
            if (self.hairManager.curMode != FUHairModelModelGradient) {
                NSString *path = [[NSBundle mainBundle] pathForResource:@"hair_gradient" ofType:@"bundle"];
                [self.hairManager loadItemWithPath:path];
                self.hairManager.curMode = FUHairModelModelGradient;
            }
            
            self.hairManager.hair.index = (int)index;
            self.hairManager.hair.strength = self.hairView.slider.value;
        }else {
            if (self.hairManager.curMode != FUHairModelModelNormal) {
                NSString *path = [[NSBundle mainBundle] pathForResource:@"hair_normal" ofType:@"bundle"];
                [self.hairManager loadItemWithPath:path];
                self.hairManager.curMode = FUHairModelModelNormal;
            }
           
            self.hairManager.hair.index = (int)index - 5;
            self.hairManager.hair.strength = self.hairView.slider.value;
        }
    }
}

-(void)hairViewChanageStrength:(float)strength {
    self.hairManager.hair.strength = strength;
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
@end
