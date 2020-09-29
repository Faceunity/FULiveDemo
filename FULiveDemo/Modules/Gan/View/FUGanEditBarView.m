//
//  FUGanEditBarView.m
//  FULiveDemo
//
//  Created by 孙慕 on 2018/12/24.
//  Copyright © 2018年 FaceUnity. All rights reserved.
//

#import "FUGanEditBarView.h"
#import "FUExpressionCell.h"
#import <Masonry.h>
#import "FUExpressionMode.h"

@interface FUGanEditBarView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView *collection;
@property (strong, nonatomic) UIView *bottomBtnView;

@property (assign, nonatomic) NSInteger selIndex;

@property (strong, nonatomic) NSArray <FUExpressionMode *>*dataArray;
@end

@implementation FUGanEditBarView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupView];
        
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setupView];
}

-(void)setupView{
    [self initializationData];//初始化数据
    
    self.backgroundColor = [UIColor colorWithRed:5/255.0 green:15/255.0 blue:20/255.0 alpha:0.74];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 16;
    layout.itemSize = CGSizeMake(60, 60);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collection.backgroundColor = [UIColor clearColor];
    _collection.showsHorizontalScrollIndicator = NO;
    _collection.delegate = self;
    _collection.dataSource = self;
    [self addSubview:_collection];
    
    [_collection registerClass:[FUExpressionCell class] forCellWithReuseIdentifier:@"ExpressionCell"];
    
    
    _bottomBtnView = [[UIView alloc] init];
    _bottomBtnView.backgroundColor = [UIColor clearColor];
    [self addSubview:_bottomBtnView];
    
    NSArray *norImageArr = @[@"icon_gan_full_nor",@"icon_gan_twor_nor",@"icon_gan_four_nor",@"icon_gan_gif_nor"];
    NSArray *selImageArr = @[@"icon_gan_full_sel",@"icon_gan_twor_sel",@"icon_gan_four_sel",@"icon_gan_gif_sel"];
    
    float margin1 = 13;
    float margin2 = ([UIScreen mainScreen].bounds.size.width - 44 * 4 - 2 * margin1) / 3;
    
    for (int i = 0; i < 4; i ++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(margin1 + (margin2 + 44) * i, 0, 44, 44)];
        btn.tag = 100 + i;
        [btn setImage:[UIImage imageNamed:norImageArr[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:selImageArr[i]] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomBtnView addSubview:btn];
        if (i == 0) {
            btn.selected = YES;
        }
    }
    
    [self addLayoutConstraint];

}

-(void)initializationData{
    FUExpressionMode *model9 = [FUExpressionMode getClassTitle:FUNSLocalizedString(@"原图", nil)  imageStr:@"icon_gan_original"];
    FUExpressionMode *model0 = [FUExpressionMode getClassTitle:FUNSLocalizedString(@"微笑", nil) imageStr:@"icon_gan_smile"];
    FUExpressionMode *model1 = [FUExpressionMode getClassTitle:FUNSLocalizedString(@"露齿笑", nil) imageStr:@"icon_gan_laugh"];
    FUExpressionMode *model2 = [FUExpressionMode getClassTitle:FUNSLocalizedString(@"大笑", nil) imageStr:@"icon_gan_grin"];
    FUExpressionMode *model3 = [FUExpressionMode getClassTitle:FUNSLocalizedString(@"左闭眼", nil) imageStr:@"icon_gan_left_close_eyes"];
    FUExpressionMode *model4 = [FUExpressionMode getClassTitle:FUNSLocalizedString(@"右闭眼", nil) imageStr:@"icon_gan_right_close_eyes"];
    FUExpressionMode *model5 = [FUExpressionMode getClassTitle:FUNSLocalizedString(@"生气", nil) imageStr:@"icon_gan_angry"];
    FUExpressionMode *model6 = [FUExpressionMode getClassTitle:FUNSLocalizedString(@"伤感", nil) imageStr:@"icon_gan_sad"];
    FUExpressionMode *model7 = [FUExpressionMode getClassTitle:FUNSLocalizedString(@"左邪魅", nil) imageStr:@"icon_gan_left_demon"];
    FUExpressionMode *model8 = [FUExpressionMode getClassTitle:FUNSLocalizedString(@"右邪魅", nil) imageStr:@"icon_gan_right_demon"];
    
    _dataArray = @[model9,model0,model1,model2,model3,model4,model5,model6,model7,model8];
    
}
     



-(void)addLayoutConstraint{
    [_collection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self);
        make.height.mas_equalTo(90);
    }];
    [_bottomBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self);
        make.height.mas_equalTo(44);
    }];
}


#pragma  mark ----  UI事件  -----
-(void)btnClick:(UIButton *)btn{
    for (UIView *view in _bottomBtnView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn0 = (UIButton *)view;
            btn0.selected = NO;
        }
    }
    btn.selected = YES;
    _currentModeType = btn.tag - 100;
    if ([self.delegate respondsToSelector:@selector(ganEditFunctionalModeIndex:)]) {
        [self.delegate ganEditFunctionalModeIndex:(int)btn.tag - 100];
    }
}

#pragma mark --- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FUExpressionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ExpressionCell" forIndexPath:indexPath];
    
    cell.isSel = _selIndex == indexPath.row ? YES : NO;
    cell.topImage.image = [UIImage imageNamed:_dataArray[indexPath.row].imageName];
    cell.botlabel.text = _dataArray[indexPath.row].title;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

#pragma mark --- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(60, 60) ;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(12, 16, 12, 16);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _selIndex = indexPath.row;
    [_collection reloadData];
    if ([self.delegate respondsToSelector:@selector(ganEditExpressionIndex:)]) {
        [self.delegate ganEditExpressionIndex:(int)indexPath.row];
    }
}


-(void)updataCurrentSel:(int)index{
    _selIndex = index;
    [_collection reloadData];
    [_collection scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}


@end
