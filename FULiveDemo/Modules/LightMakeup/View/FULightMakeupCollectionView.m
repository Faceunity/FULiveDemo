//
//  FULightMakeupCollectionView.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/10/17.
//  Copyright © 2019 FaceUnity. All rights reserved.
//

#import "FULightMakeupCollectionView.h"
#import "FULightMakeupCell.h"
#import "FUSlider.h"

static NSString * const kFULightMakeupCellIdentifierKey = @"FULightMakeupCell";

@interface FULightMakeupCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)NSArray <FULightModel *> *dataArray;

@property(nonatomic,strong) UICollectionView *collection;

@property (assign,nonatomic) id<FULightMakeupCollectionViewDelegate> delegate;

@property(nonatomic,strong) FUSlider *slider;

@end
@implementation FULightMakeupCollectionView

static NSString *makeupCellID = @"FUMakeupTopCell";

-(instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray <FULightModel *> *)dataArray  delegate:(id<FULightMakeupCollectionViewDelegate>)delegate{
    if (self = [super initWithFrame:frame]) {
        _dataArray = dataArray;
        _delegate = delegate;
        
        [self setupView];
        
        for (FULightModel *modle0 in _dataArray) {
            if (modle0.isSel) {
                _currentLightModel = modle0;
                [self.slider setValue:modle0.value];
                break;
            }
        }
        
        // 默认选中卸妆
        [self.collection selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        
    }
    return self;
}


-(void)setupView{
//    self.backgroundColor = [UIColor colorWithRed:5/255.0 green:15/255.0 blue:20/255.0 alpha:0.74];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 16;
    layout.itemSize = CGSizeMake(50, 60);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _slider = [[FUSlider alloc] initWithFrame:CGRectMake(56, 20, [UIScreen mainScreen].bounds.size.width  - 112, 20)];
    [_slider addTarget:self action:@selector(sliderChangeValue:) forControlEvents:UIControlEventValueChanged];
    _slider.bidirection = NO;
    _slider.hidden = YES;
    [self addSubview:_slider];
    
    _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_slider.frame), self.frame.size.width, 100) collectionViewLayout:layout];
    _collection.backgroundColor = [UIColor clearColor];
    _collection.delegate = self;
    _collection.dataSource = self;
    [self addSubview:_collection];
    
    /* 初始化collection */
    [_collection registerClass:[FULightMakeupCell class] forCellWithReuseIdentifier:kFULightMakeupCellIdentifierKey];
}


#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FULightMakeupCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFULightMakeupCellIdentifierKey forIndexPath:indexPath];
    cell.fuImageView.image = [UIImage imageNamed:_dataArray[indexPath.row].imageStr];
    cell.fuTitleLabel.text = FUNSLocalizedString(_dataArray[indexPath.row].name, nil);;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FULightModel *modle = _dataArray[indexPath.row];
    if(_currentLightModel == modle){
        return;
    }
    for (FULightModel *modle0 in _dataArray) {
        modle0.isSel = NO;
    }
    modle.isSel = YES;
    _currentLightModel = modle;
    [self.slider setValue:modle.value];
    _slider.hidden = indexPath.row ? NO:YES;

    if (self.delegate && [self.delegate respondsToSelector:@selector(lightMakeupCollectionView:)]) {
        [self.delegate lightMakeupCollectionView:_dataArray[indexPath.row]];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    return CGSizeMake(54.0, 70.0) ;
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 12, 0, 17);
}

#pragma  mark -  UI事件

-(void)sliderChangeValue:(FUSlider *)slider{
    _currentLightModel.value = slider.value;
    _currentLightModel.selectedFilterLevel = slider.value;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(lightMakeupModleValue:)]) {
        [self.delegate lightMakeupModleValue:_currentLightModel];
    }
}


@end
