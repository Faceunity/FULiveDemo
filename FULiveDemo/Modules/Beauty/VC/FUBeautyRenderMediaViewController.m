//
//  FUBeautyRenderMediaViewController.m
//  FULiveDemo
//
//  Created by 项林平 on 2021/12/9.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUBeautyRenderMediaViewController.h"
#import "FUAPIDemoBar.h"

@interface FUBeautyRenderMediaViewController ()<FUAPIDemoBarDelegate>

@property (nonatomic, strong) FUAPIDemoBar *beautyDemoBar;
/// 效果比对按钮
@property (nonatomic, strong) UIButton *compareButton;

@end

@implementation FUBeautyRenderMediaViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.beautyDemoBar];
    [self.beautyDemoBar mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view.mas_bottom);
        }
        make.leading.trailing.equalTo(self.view);
        make.height.mas_equalTo(190);
    }];
    
    [self.view addSubview:self.compareButton];
    [self.compareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading).mas_offset(15);
        make.bottom.equalTo(self.beautyDemoBar.mas_top).mas_offset(-10);
        make.size.mas_offset(CGSizeMake(44, 44));
    }];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self showTopView:NO];
    
    [self bringFunctionButtonToFront];
}

#pragma mark - Event response

- (void)compareTouchDownAction {
    self.stopRendering = YES;
}

- (void)compareTouchUpAction {
    self.stopRendering = NO;
}

#pragma mark - FURenderMediaProtocol

- (BOOL)isNeedTrack {
    return YES;
}

- (FUTrackType)trackType {
    return FUTrackTypeFace;
}

#pragma mark - FUAPIDemoBarDelegate

- (void)resetDefaultValue:(NSUInteger)type {
    [self.baseManager resetDefaultParams:type];
}

/// 美型是否全部是默认参数
- (BOOL)isDefaultShapeValue {
    return [self.baseManager isDefaultShapeValue];
}

/// 美肤是否全部是默认参数
- (BOOL)isDefaultSkinValue {
    return [self.baseManager isDefaultSkinValue];
}

- (void)showTopView:(BOOL)shown{
    self.compareButton.hidden = !shown;
    [self refreshDownloadButtonTransformWithHeight:shown ? 190 : 49 show:shown];
}

- (void)filterValueChange:(FUBeautyModel *)param{
    [self.baseManager setFilterkey:[param.strValue lowercaseString]];
    self.baseManager.beauty.filterLevel = param.mValue;
    self.baseManager.seletedFliter = param;
}

- (void)beautyParamValueChange:(FUBeautyModel *)param{
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

#pragma mark - Getters

- (FUAPIDemoBar *)beautyDemoBar {
    if (!_beautyDemoBar) {
        _beautyDemoBar = [[FUAPIDemoBar alloc] init];
        _beautyDemoBar.mDelegate = self;
        [_beautyDemoBar reloadShapView:self.baseManager.shapeParams];
        [_beautyDemoBar reloadSkinView:self.baseManager.skinParams];
        [_beautyDemoBar reloadFilterView:self.baseManager.filters];
        [_beautyDemoBar reloadStyleView:self.baseManager.styleParams defaultStyle:self.baseManager.currentStyle];
    }
    return _beautyDemoBar;
}

- (UIButton *)compareButton {
    if (!_compareButton) {
        _compareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_compareButton setImage:[UIImage imageNamed:@"demo_icon_contrast"] forState:UIControlStateNormal];
        [_compareButton addTarget:self action:@selector(compareTouchDownAction) forControlEvents:UIControlEventTouchDown];
        [_compareButton addTarget:self action:@selector(compareTouchUpAction) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        _compareButton.hidden = YES;
    }
    return _compareButton;
}

@end
