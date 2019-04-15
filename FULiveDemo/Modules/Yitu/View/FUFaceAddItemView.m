//
//  FUFaceAddItemView.m
//  FULiveDemo
//
//  Created by 孙慕 on 2018/12/17.
//  Copyright © 2018年 FaceUnity. All rights reserved.
//

#import "FUFaceAddItemView.h"
#import "FUFaceAddItemCell.h"
#import "FUYituItemModel.h"
#import <Masonry.h>

@interface FUFaceAddItemView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView *collection;

@property (strong,nonatomic) NSArray <FUYituItemModel *>*dataArray;

@property (strong, nonatomic) UILabel *titleLabel;
@end
@implementation FUFaceAddItemView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self InitializationData];
        [self setupView];
        [self addLayoutConstraint];
    }
    return self;
}

-(void)setupView{
    self.backgroundColor = [UIColor colorWithRed:5/255.0 green:15/255.0 blue:20/255.0 alpha:0.74];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 16;
    layout.itemSize = CGSizeMake(60, 60);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collection.backgroundColor = [UIColor clearColor];
    _collection.delegate = self;
    _collection.dataSource = self;
    [self addSubview:_collection];
    
    [_collection registerClass:[FUFaceAddItemCell class] forCellWithReuseIdentifier:@"addItemCellId"];
    
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.numberOfLines = 0;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"请选择以下五官至上方调整",nil) attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12],NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
    _titleLabel.attributedText = string;

}

-(void)addLayoutConstraint{
    [self.collection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.left.equalTo(self);
        make.height.mas_equalTo(100);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.centerX.equalTo(self);
        make.height.mas_equalTo(50);
        
    }];
}

-(void)InitializationData{
    FUYituItemModel *model0 = [FUYituItemModel getClassTitle:NSLocalizedString(@"左眼",nil) imageStr:@"icon_left_eye" type:FUFacialFeaturesLeye];
    FUYituItemModel *model1 = [FUYituItemModel getClassTitle:NSLocalizedString(@"右眼",nil) imageStr:@"icon_right_eye" type:FUFacialFeaturesReye];
    FUYituItemModel *model2 = [FUYituItemModel getClassTitle:NSLocalizedString(@"嘴巴",nil) imageStr:@"icon_yitu_mouth" type:FUFacialFeaturesMouth];
    FUYituItemModel *model3 = [FUYituItemModel getClassTitle:NSLocalizedString(@"鼻子",nil) imageStr:@"icon_yitu_nose" type:FUFacialFeaturesNose];
    FUYituItemModel *model4 = [FUYituItemModel getClassTitle:NSLocalizedString(@"左眉毛",nil) imageStr:@"icon_left_eyebrow" type:FUFacialFeatureLbrow];
    FUYituItemModel *model5 = [FUYituItemModel getClassTitle:NSLocalizedString(@"右眉毛",nil) imageStr:@"icon_right_eyebrow" type:FUFacialFeaturesRbrow];
    _dataArray = @[model0,model1,model2,model3,model4,model5];
}

#pragma mark --- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count ;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FUFaceAddItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"addItemCellId" forIndexPath:indexPath];
    
    NSString *imageName = self.dataArray[indexPath.row].imageName ;
    
    cell.topImage.image = [UIImage imageNamed:imageName] ;
    cell.botlabel.text = self.dataArray[indexPath.row].title;

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
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(yituAddItemView:)]) {
            [self.delegate yituAddItemView:self.dataArray[indexPath.row].type];
        }
}

@end
