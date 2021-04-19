//
//  FUBeautyController.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/1/28.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import "FUBeautyController.h"
#import "FUAPIDemoBar.h"
//#import "FUManager.h"
#import <Masonry.h>
#import "FUSelectedImageController.h"
#import "SVProgressHUD.h"
#import "FUMakeupSupModel.h"
@interface FUBeautyController ()<FUAPIDemoBarDelegate> {
    BOOL _isFromOther;//其他页面过来的
}

@property (strong, nonatomic) FUAPIDemoBar *demoBar;
/* 比对按钮 */
@property (strong, nonatomic) UIButton *compBtn;
@end

@implementation FUBeautyController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* 在基类控制器中，已经加载了美颜 */
   // [[FUManager shareManager] loadFilter];

    [self setupView];

    self.headButtonView.selectedImageBtn.hidden = NO;
    [self.view bringSubviewToFront:self.photoBtn];
    
}

- (void)headButtonViewBackAction:(UIButton *)btn {
    [super headButtonViewBackAction:btn];
    [self.baseManager releaseItem];
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_isFromOther) {
        [self.baseManager reloadBeautyParams];
    }
    [_demoBar reloadShapView:self.baseManager.shapeParams];
    [_demoBar reloadSkinView:self.baseManager.skinParams];
    [_demoBar reloadFilterView:self.baseManager.filters];
    [_demoBar reloadStyleView:self.baseManager.styleParams defaultStyle:self.baseManager.currentStyle];
    [_demoBar setDefaultFilter:self.baseManager.seletedFliter];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _isFromOther = YES;
}

-(void)setupView{
    _demoBar = [[FUAPIDemoBar alloc] init];
    _demoBar.mDelegate = self;
    [self.view insertSubview:_demoBar atIndex:1];
    
    [_demoBar mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view.mas_bottom);
        }
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
    /* 比对按钮 */
    _compBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_compBtn setImage:[UIImage imageNamed:@"demo_icon_contrast"] forState:UIControlStateNormal];
    [_compBtn addTarget:self action:@selector(TouchDown) forControlEvents:UIControlEventTouchDown];
    [_compBtn addTarget:self action:@selector(TouchUp) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    _compBtn.hidden = YES;
    [self.view addSubview:_compBtn];
    if (iPhoneXStyle) {
        _compBtn.frame = CGRectMake(15 , self.view.frame.size.height - 60 - 182 - 34, 44, 44);
    }else{
        _compBtn.frame = CGRectMake(15 , self.view.frame.size.height - 60 - 182, 44, 44);
    }
    
    _demoBar.backgroundColor = [UIColor clearColor];
    _demoBar.bottomView.backgroundColor = [UIColor clearColor];
    _demoBar.topView.backgroundColor = [UIColor clearColor];
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    [_demoBar addSubview:effectview];
    [_demoBar sendSubviewToBack:effectview];
    /* 磨玻璃 */
    [effectview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(_demoBar);
    }];
    
//    UIBlurEffect *blur1 = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//    UIVisualEffectView *effectview1 = [[UIVisualEffectView alloc] initWithEffect:blur1];
//    [_demoBar.bottomView addSubview:effectview1];
//    [_demoBar.bottomView sendSubviewToBack:effectview1];
//
//    /* 磨玻璃 */
//    [effectview1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.equalTo(_demoBar);
//        make.height.mas_equalTo(_demoBar.bottomView.bounds.size.height);
//    }];
    
    if(iPhoneXStyle){
        UIBlurEffect *blur2 = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectview2 = [[UIVisualEffectView alloc] initWithEffect:blur2];
        [self.view addSubview:effectview2];
        [self.view sendSubviewToBack:effectview2];
        [effectview2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom);
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(34);
        }];
    }
    
}

//-(void)setOrientation:(int)orientation{
//    [super setOrientation:orientation];
////    [self.baseManager setDefaultRotationMode:orientation];
//}

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

-(void)restDefaultValue:(NSUInteger)type {
    [self.baseManager resetDefaultParams:type];
}

//美型是否全部是默认参数
- (BOOL)isDefaultShapeValue {
    return [self.baseManager isDefaultShapeValue];
}

//美肤是否全部是默认参数
- (BOOL)isDefaultSkinValue {
    return [self.baseManager isDefaultSkinValue];
}

-(void)showTopView:(BOOL)shown{
    float h = shown?190:49;
     [_demoBar mas_updateConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view.mas_bottom);
        }
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(h);
    }];

    [self setPhotoScaleWithHeight:h show:shown];
}

-(void)filterShowMessage:(NSString *)message{
    self.tipLabel.hidden = NO;
    self.tipLabel.text = message;
    [FUBeautyController cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissTipLabel) object:nil];
    [self performSelector:@selector(dismissTipLabel) withObject:nil afterDelay:1 ];
}

-(void)filterValueChange:(FUBeautyModel *)param {
    [self.baseManager setFilterkey:[param.strValue lowercaseString]];
    self.baseManager.beauty.filterLevel = param.mValue;
    self.baseManager.seletedFliter = param;
}

-(void)beautyParamValueChange:(FUBeautyModel *)param {
    switch (param.type) {
        case FUBeautyDefineShape: {
            [self.baseManager setShap:param.mValue forKey:param.mParam];
        }
            break;
        case FUBeautyDefineSkin: {
            [self.baseManager setSkin:param.mValue forKey:param.mParam];
        }
            break;
        case FUBeautyDefineStyle: {
            [self.baseManager setStyleBeautyParams:(FUStyleModel *)param];
        }
            break;
        default:
            break;
    }
}


- (void)setPhotoScaleWithHeight:(CGFloat)height show:(BOOL)shown {
    if (shown) {
        _compBtn.hidden = NO;
        CGAffineTransform photoTransform0 = CGAffineTransformMakeTranslation(0, height * -0.8) ;
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


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
     [self.demoBar hiddenTopViewWithAnimation:YES];
}


@end
