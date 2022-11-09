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
    _mHomeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_mHomeBtn setImage:[UIImage imageNamed:@"render_back_home"] forState:UIControlStateNormal];
    [_mHomeBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_mHomeBtn];
    
    _selectedImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_selectedImageBtn setImage:[UIImage imageNamed:@"render_more"] forState:UIControlStateNormal];
    [_selectedImageBtn addTarget:self action:@selector(selImageAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_selectedImageBtn];
    
    _bulyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bulyBtn setImage:[UIImage imageNamed:@"render_bugly"] forState:UIControlStateNormal];
    [_bulyBtn addTarget:self action:@selector(buglyAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_bulyBtn];
    
    _switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_switchBtn setImage:[UIImage imageNamed:@"render_camera_switch"] forState:UIControlStateNormal];
    [_switchBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_switchBtn];
    
    //先创建一个数组用于设置标题
    NSArray *arr = [[NSArray alloc]initWithObjects:@"BGRA",@"YUV", nil];
    _inputSegm = [[UISegmentedControl alloc] initWithItems:arr];
    _inputSegm.tintColor = [UIColor whiteColor];
    _inputSegm.selectedSegmentIndex = 0;
    [_inputSegm addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_inputSegm];
}

-(void)addLayoutConstraint{
    [_mHomeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.leading.equalTo(self).offset(10);
        make.height.width.mas_equalTo(44);
    
    }];
    
    [_inputSegm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mHomeBtn);
        make.leading.equalTo(self.mHomeBtn.mas_trailing).offset(12);
        make.width.mas_equalTo(96);
        make.height.mas_equalTo(27);
    }];
    
    [_switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-10);
        make.centerY.equalTo(self.mHomeBtn);
        make.height.width.mas_equalTo(44);
        
    }];
    
    [_bulyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.switchBtn.mas_leading).offset(-10);
        make.centerY.equalTo(self.mHomeBtn);
        make.height.width.mas_equalTo(44);
        
    }];
    
    [_selectedImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.bulyBtn.mas_leading).offset(-10);
        make.centerY.equalTo(self.mHomeBtn);
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


-(void)change:(UISegmentedControl *)sender{
    if ([_delegate respondsToSelector:@selector(headButtonViewSegmentedChange:)]) {
        [_delegate headButtonViewSegmentedChange:sender];
    }
}




@end
