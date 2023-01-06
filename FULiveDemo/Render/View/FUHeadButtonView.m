//
//  FUHeadButtonView.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/1/29.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import "FUHeadButtonView.h"

@implementation FUHeadButtonView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupSubView];
        [self addLayoutConstraint];
    }
    
    return self;
}

-(void)setupSubView{
    _homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_homeButton setImage:[UIImage imageNamed:@"render_back_home"] forState:UIControlStateNormal];
    [_homeButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_homeButton];
    
    _selectedImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_selectedImageButton setImage:[UIImage imageNamed:@"render_more"] forState:UIControlStateNormal];
    [_selectedImageButton addTarget:self action:@selector(selImageAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_selectedImageButton];
    
    _bulyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bulyButton setImage:[UIImage imageNamed:@"render_bugly"] forState:UIControlStateNormal];
    [_bulyButton addTarget:self action:@selector(buglyAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_bulyButton];
    
    _switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_switchButton setImage:[UIImage imageNamed:@"render_camera_switch"] forState:UIControlStateNormal];
    [_switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_switchButton];
    
    //先创建一个数组用于设置标题
    NSArray *arr = [[NSArray alloc]initWithObjects:@"BGRA",@"YUV", nil];
    _segmentedControl = [[FUSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, 77, 27) items:arr];
    _segmentedControl.selectedTitleColor = FUColorFromHex(0x2C2E30);
    _segmentedControl.layer.masksToBounds = YES;
    _segmentedControl.layer.cornerRadius = 4;
    _segmentedControl.layer.borderWidth = 1.5;
    _segmentedControl.layer.borderColor = [UIColor whiteColor].CGColor;
    _segmentedControl.selectedIndex = 0;
    @FUWeakify(self);
    _segmentedControl.selectHandler = ^(NSUInteger index) {
        @FUStrongify(self);
        if ([self.delegate respondsToSelector:@selector(headButtonViewSegmentedChange:)]) {
            [self.delegate headButtonViewSegmentedChange:index];
        }
    };
    [self addSubview:_segmentedControl];
}

-(void)addLayoutConstraint{
    [_homeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.leading.equalTo(self).offset(10);
        make.height.width.mas_equalTo(44);
    
    }];
    
    [_segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.homeButton);
        make.leading.equalTo(self.homeButton.mas_trailing).offset(12);
        make.width.mas_equalTo(77);
        make.height.mas_equalTo(27);
    }];
    
    [_switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-10);
        make.centerY.equalTo(self.homeButton);
        make.height.width.mas_equalTo(44);
        
    }];
    
    [_bulyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.switchButton.mas_leading).offset(-10);
        make.centerY.equalTo(self.homeButton);
        make.height.width.mas_equalTo(44);
        
    }];
    
    [_selectedImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.bulyButton.mas_leading).offset(-10);
        make.centerY.equalTo(self.homeButton);
        make.height.width.mas_equalTo(44);
        
    }];
}


#pragma  mark -  UI 交互
-(void)backAction:(UIButton *)btn{
    if ([_delegate respondsToSelector:@selector(headButtonViewBackAction:)]) {
        [_delegate headButtonViewBackAction:btn];
    }
}

-(void)selImageAction:(UIButton *)btn{
    if ([_delegate respondsToSelector:@selector(headButtonViewSelImageAction:)]) {
        [_delegate headButtonViewSelImageAction:btn];
    }
}

-(void)buglyAction:(UIButton *)btn{
    if ([_delegate respondsToSelector:@selector(headButtonViewBuglyAction:)]) {
        [_delegate headButtonViewBuglyAction:btn];
    }
}

-(void)switchAction:(UIButton *)btn{
    if ([_delegate respondsToSelector:@selector(headButtonViewSwitchAction:)]) {
        [_delegate headButtonViewSwitchAction:btn];
    }
}

@end
