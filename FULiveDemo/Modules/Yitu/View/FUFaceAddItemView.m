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

@property (strong,nonatomic) NSArray <NSArray <FUYituItemModel *>*>* allArray;
@property (strong,nonatomic) NSArray <FUYituItemModel *>*dataArray;

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UIView *typeTitlesView;
@property (strong, nonatomic) UIButton *selectedTitleButton;
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
    _collection.showsHorizontalScrollIndicator = NO;
    [self addSubview:_collection];
    [_collection registerClass:[FUFaceAddItemCell class] forCellWithReuseIdentifier:@"addItemCellId"];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.numberOfLines = 0;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:FUNSLocalizedString(@"请选择以下五官至上方调整",nil) attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12],NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
    _titleLabel.attributedText = string;
    
    _typeTitlesView = [[UIView alloc] init];
    [self addSubview:_typeTitlesView];

    UIView *spView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1/[UIScreen mainScreen].scale)];
    spView.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0];
    [_typeTitlesView addSubview:spView];
    // 添加标题
    NSArray *titles = @[FUNSLocalizedString(@"写实", nil),FUNSLocalizedString(@"漫画男", nil),FUNSLocalizedString(@"漫画女", nil),FUNSLocalizedString(@"萌版", nil)];
    NSUInteger count = titles.count;
    CGFloat titleButtonW = ([UIScreen mainScreen].bounds.size.width -34) / count;
    CGFloat titleButtonH = 49;
    for (NSUInteger i = 0; i < count; i++) {
        // 创建
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        titleButton.tag = i;
        [titleButton addTarget:self action:@selector(typeTitleClick:) forControlEvents:UIControlEventTouchUpInside];
        [_typeTitlesView addSubview:titleButton];
        // 设置数据
        [titleButton setTitle:titles[i] forState:UIControlStateNormal];
        // 设置frame
        titleButton.frame = CGRectMake(i * titleButtonW + 17, 1, titleButtonW, titleButtonH);
        titleButton.titleLabel.font = [UIFont systemFontOfSize:13];
        
        [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [titleButton setTitleColor:[UIColor colorWithRed:31/255.0 green:178/255.0 blue:255/255.0 alpha:1] forState:UIControlStateSelected];
        if (i == 0) {
            _selectedTitleButton = titleButton;
            titleButton.selected = YES;
        }
        
    }

}

-(void)addLayoutConstraint{
    [self.collection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self);
        make.bottom.equalTo(self).offset(-55);
        make.height.mas_equalTo(100);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.centerX.equalTo(self);
        make.height.mas_equalTo(50);
    }];
    
    [self.typeTitlesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.left.equalTo(self);
        make.height.mas_equalTo(50);
    }];
}

-(void)InitializationData{
    /* 写实 */
    FUYituItemModel *model0 = [FUYituItemModel getClassTitle:FUNSLocalizedString(@"左眼",nil) imageStr:@"icon_left_eye" faceType:FUFaceTypeRealism subType:FUFacialFeaturesLeye];
    FUYituItemModel *model1 = [FUYituItemModel getClassTitle:FUNSLocalizedString(@"右眼",nil) imageStr:@"icon_right_eye" faceType:FUFaceTypeRealism subType:FUFacialFeaturesReye];
    FUYituItemModel *model2 = [FUYituItemModel getClassTitle:FUNSLocalizedString(@"嘴巴",nil) imageStr:@"icon_yitu_mouth"  faceType:FUFaceTypeRealism subType:FUFacialFeaturesMouth];
    FUYituItemModel *model3 = [FUYituItemModel getClassTitle:FUNSLocalizedString(@"鼻子",nil) imageStr:@"icon_yitu_nose" faceType:FUFaceTypeRealism subType:FUFacialFeaturesNose];
    FUYituItemModel *model4 = [FUYituItemModel getClassTitle:FUNSLocalizedString(@"左眉毛",nil) imageStr:@"demo_icon_leyebrow"  faceType:FUFaceTypeRealism subType:FUFacialFeatureLbrow];
    FUYituItemModel *model5 = [FUYituItemModel getClassTitle:FUNSLocalizedString(@"右眉毛",nil) imageStr:@"icon_right_eyebrow"  faceType:FUFaceTypeRealism subType:FUFacialFeaturesRbrow];
    NSArray *array0 = @[model0,model1,model2,model3,model4,model5];
    
    /* 萌版 */
    FUYituItemModel *mModel0 = [FUYituItemModel getClassTitle:FUNSLocalizedString(@"左眼",nil) imageStr:@"demo_icon_q_leyes" faceType:FUFaceTypeMengBan subType:FUFacialFeaturesLeye];
    FUYituItemModel *mModel1 = [FUYituItemModel getClassTitle:FUNSLocalizedString(@"右眼",nil) imageStr:@"demo_icon_q_reyes" faceType:FUFaceTypeMengBan subType:FUFacialFeaturesReye];
    FUYituItemModel *mModel2 = [FUYituItemModel getClassTitle:FUNSLocalizedString(@"嘴巴",nil) imageStr:@"demo_icon_mouth"  faceType:FUFaceTypeMengBan subType:FUFacialFeaturesMouth];
    FUYituItemModel *mModel3 = [FUYituItemModel getClassTitle:FUNSLocalizedString(@"鼻子",nil) imageStr:@"demo_icon_nose" faceType:FUFaceTypeMengBan subType:FUFacialFeaturesNose];
    FUYituItemModel *mModel4 = [FUYituItemModel getClassTitle:FUNSLocalizedString(@"左眉毛",nil) imageStr:@"demo_icon_leyebrow"  faceType:FUFaceTypeMengBan subType:FUFacialFeatureLbrow];
    FUYituItemModel *mModel5 = [FUYituItemModel getClassTitle:FUNSLocalizedString(@"右眉毛",nil) imageStr:@"icon_right_eyebrow"  faceType:FUFaceTypeMengBan subType:FUFacialFeaturesRbrow];
    NSArray *array1 = @[mModel0,mModel1,mModel2,mModel3,mModel4,mModel5];
    
    /* 动漫男 */
    FUYituItemModel *bModel0 = [FUYituItemModel getClassTitle:FUNSLocalizedString(@"左眼",nil) imageStr:@"demo_icon_comic_boy_leyes" faceType:FUFaceTypeComicBoy subType:FUFacialFeaturesLeye];
    FUYituItemModel *bModel1 = [FUYituItemModel getClassTitle:FUNSLocalizedString(@"右眼",nil) imageStr:@"demo_icon_comic_boy_reyes" faceType:FUFaceTypeComicBoy subType:FUFacialFeaturesReye];
    FUYituItemModel *bModel2 = [FUYituItemModel getClassTitle:FUNSLocalizedString(@"嘴巴",nil) imageStr:@"demo_icon_mouth"  faceType:FUFaceTypeComicBoy subType:FUFacialFeaturesMouth];
    FUYituItemModel *bModel3 = [FUYituItemModel getClassTitle:FUNSLocalizedString(@"鼻子",nil) imageStr:@"demo_icon_nose" faceType:FUFaceTypeComicBoy subType:FUFacialFeaturesNose];
    FUYituItemModel *bModel4 = [FUYituItemModel getClassTitle:FUNSLocalizedString(@"左眉毛",nil) imageStr:@"demo_icon_leyebrow"  faceType:FUFaceTypeComicBoy subType:FUFacialFeatureLbrow];
    FUYituItemModel *bModel5 = [FUYituItemModel getClassTitle:FUNSLocalizedString(@"右眉毛",nil) imageStr:@"icon_right_eyebrow"  faceType:FUFaceTypeComicBoy subType:FUFacialFeaturesRbrow];
    NSArray *array2 = @[bModel0,bModel1,bModel2,bModel3,bModel4,bModel5];
    
    /* 动漫女 */
    FUYituItemModel *gModel0 = [FUYituItemModel getClassTitle:FUNSLocalizedString(@"左眼",nil) imageStr:@"demo_icon_comic_girl_leyes" faceType:FUFaceTypeComicGirl subType:FUFacialFeaturesLeye];
    FUYituItemModel *gModel1 = [FUYituItemModel getClassTitle:FUNSLocalizedString(@"右眼",nil) imageStr:@"demo_icon_comic_girl_reyes" faceType:FUFaceTypeComicGirl subType:FUFacialFeaturesReye];
    FUYituItemModel *gModel2 = [FUYituItemModel getClassTitle:FUNSLocalizedString(@"嘴巴",nil) imageStr:@"demo_icon_mouth"  faceType:FUFaceTypeComicGirl subType:FUFacialFeaturesMouth];
    FUYituItemModel *gModel3 = [FUYituItemModel getClassTitle:FUNSLocalizedString(@"鼻子",nil) imageStr:@"demo_icon_nose" faceType:FUFaceTypeComicGirl subType:FUFacialFeaturesNose];
    FUYituItemModel *gModel4 = [FUYituItemModel getClassTitle:FUNSLocalizedString(@"左眉毛",nil) imageStr:@"demo_icon_leyebrow"  faceType:FUFaceTypeComicGirl subType:FUFacialFeatureLbrow];
    FUYituItemModel *gModel5 = [FUYituItemModel getClassTitle:FUNSLocalizedString(@"右眉毛",nil) imageStr:@"icon_right_eyebrow"  faceType:FUFaceTypeComicGirl subType:FUFacialFeaturesRbrow];
    NSArray *array3 = @[gModel0,gModel1,gModel2,gModel3,gModel4,gModel5];
    
    _allArray = @[array0,array2,array3,array1];
    _dataArray = array0;
}


#pragma  mark -  UI 事件

-(void)typeTitleClick:(UIButton *)btn{
    // 控制按钮状态
    self.selectedTitleButton.selected = NO;
    btn.selected = YES;
    self.selectedTitleButton = btn;
    
    int index = (int)btn.tag;
    _dataArray = _allArray[index];
    [_collection reloadData];
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
            [self.delegate yituAddItemView:self.dataArray[indexPath.row]];
        }
}

@end
