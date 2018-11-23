//
//  FUSegmentBarView.m
//  FULiveDemo
//
//  Created by 孙慕 on 2018/11/12.
//  Copyright © 2018年 L. All rights reserved.
//

#import "FUSegmentBarView.h"

typedef void(^FUSegmentDidSelBtnIndex)(int index);

@interface FUSegmentBarView()
@property (nonatomic, copy)  FUSegmentDidSelBtnIndex selBtnBlock;
@property (nonatomic, strong) NSArray <NSString *>*titlArray;

@end
@implementation FUSegmentBarView

-(instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray <NSString *>*)titlArray selBlock:(void (^)(int index))didSelBtnIndex{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:5/255.0 green:15/255.0 blue:20/255.0 alpha:0.6];
        _currentBtnIndex = 0;
         _titlArray = titlArray;
        _selBtnBlock = didSelBtnIndex;
        [self setupView];
    }
    
    return self;
}

-(void)setupView{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
    topView.backgroundColor = [UIColor colorWithRed:229/255.0f green:229/255.0f blue:229/255.0f alpha:1];
    [self addSubview:topView];
    
    float btnW = (self.frame.size.width - _titlArray.count + 1)/_titlArray.count;
    for (int i = 0; i < _titlArray.count; i++) {
        UIButton *titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(btnW * i + i, 1, btnW, 44)];
        [titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [titleBtn setTitleColor:[UIColor colorWithRed:94/255.0f green:199/255.0f blue:254/255.0f alpha:1.0] forState:UIControlStateSelected];
        [titleBtn setTitle:_titlArray[i] forState:UIControlStateNormal];
        titleBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        titleBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [titleBtn addTarget:self action:@selector(titleBtnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        titleBtn.tag = 100 + i;
        [self addSubview:titleBtn];
        
        if (i > 0) {
            UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(btnW * i, 13, 1, 20)];
            sepView.backgroundColor = [UIColor colorWithRed:229/255.0f green:229/255.0f blue:229/255.0f alpha:1];
            [self addSubview:sepView];
        }else{
            titleBtn.selected = YES;
        }

    }
    
}


-(void)titleBtnBtnClick:(UIButton *)btn{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton * btn = (UIButton *)view;
            btn.selected = NO;
        }
    }
    btn.selected = YES;
    _selBtnBlock((int)btn.tag - 100);
    _currentBtnIndex = (int)btn.tag - 100;
    
}




@end
