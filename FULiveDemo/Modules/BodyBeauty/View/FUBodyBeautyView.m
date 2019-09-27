//
//  FUBodyBeautyView.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/8/2.
//  Copyright © 2019 FaceUnity. All rights reserved.
//

#import "FUBodyBeautyView.h"
#import "FUPositionCell.h"
#import "FUSlider.h"
#import "FUSquareButton.h"

@interface FUBodyBeautyView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)NSArray <FUPosition *> *dataArray;

@property(nonatomic,strong) UICollectionView *collection;

@property(nonatomic,strong) FUSlider *slider;

@property(nonatomic,strong) FUPosition * currentPosition;

@property(nonatomic,strong) FUSquareButton *btn;

@end
@implementation FUBodyBeautyView

static NSString *positionCellID = @"positionCell";

-(instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray <FUPosition *> *)dataArray{
    if (self = [super initWithFrame:frame]) {
        _dataArray = dataArray;
        
        for (FUPosition *modle0 in _dataArray) {
            if (modle0.isSel) {
                _currentPosition = modle0;
                 [self setSliderState:_currentPosition];
                break;
            }
        }
        [self setupView];
        
    }
    return self;
}


-(void)setupView{
    self.backgroundColor = [UIColor colorWithRed:5/255.0 green:15/255.0 blue:20/255.0 alpha:0.74];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 16;
    layout.itemSize = CGSizeMake(50, 60);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _slider = [[FUSlider alloc] initWithFrame:CGRectMake(56, 20, [UIScreen mainScreen].bounds.size.width  - 112, 20)];
    [_slider addTarget:self action:@selector(sliderChangeValue:) forControlEvents:UIControlEventValueChanged];
    [_slider addTarget:self action:@selector(sliderChangeEnd:) forControlEvents:UIControlEventTouchUpInside];
    _slider.type = FUFilterSliderTypeFilter;
    [self addSubview:_slider];
    
    _btn = [[FUSquareButton alloc] initWithFrame:CGRectMake(17, CGRectGetMaxY(_slider.frame) + 18, 50, 60) interval:6];
    [_btn setTitle:NSLocalizedString(@"恢复",nil)  forState:UIControlStateNormal];
    [_btn setImage:[UIImage imageNamed:@"恢复-0"] forState:UIControlStateNormal];
    [_btn addTarget:self action:@selector(restAcetion:) forControlEvents:UIControlEventTouchUpInside];
    self.btn.alpha = 0.5;
    [self addSubview:_btn];
    
    UIView *sqView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_btn.frame) + 12, CGRectGetMaxY(_slider.frame) + 8 + 20, 1/[UIScreen mainScreen].scale, 20)];
    sqView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    [self addSubview:sqView];
    
    _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_btn.frame) + 12, CGRectGetMaxY(_slider.frame), [UIScreen mainScreen].bounds.size.width - CGRectGetMaxX(_btn.frame) - 20, 94) collectionViewLayout:layout];
    _collection.backgroundColor = [UIColor clearColor];
    _collection.delegate = self;
    _collection.dataSource = self;
    [self addSubview:_collection];
    
    [_collection registerClass:[FUPositionCell class] forCellWithReuseIdentifier:positionCellID];
}

#pragma  mark -  UI事件

-(void)sliderChangeValue:(FUSlider *)slider{
    _currentPosition.value = slider.value;
    if ([self.delegate respondsToSelector:@selector(bodyBeautyViewDidSelectPosition:)]) {
        [self.delegate bodyBeautyViewDidSelectPosition:_currentPosition];
    }
    
    if (fabs(slider.value - 0.5) < 0.05 || fabs(slider.value - 0) < 0.05) {
        [_collection reloadData];
    }

}

-(void)sliderChangeEnd:(FUSlider *)slider{
    self.btn.alpha = [self isChangeValue]? 1.0:0.5;
}

-(void)restAcetion:(FUSquareButton *)btn{
    self.btn.alpha = 0.5;
    if(![self isChangeValue]){
        return;
    }
    
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"是否将所有参数恢复到默认值",nil) preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [cancleAction setValue:[UIColor colorWithRed:44/255.0 green:46/255.0 blue:48/255.0 alpha:1.0] forKey:@"titleTextColor"];
    
    __weak typeof(self)weakSelf = self ;
    UIAlertAction *certainAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        for (FUPosition *position in _dataArray) {
            if (position.type == FUPositionTypeshoulder) {//不同的样式
                position.value = 0.5;
            }else{
                position.value = 0;
            }
            if ([weakSelf.delegate respondsToSelector:@selector(bodyBeautyViewDidSelectPosition:)]) {
                [weakSelf.delegate bodyBeautyViewDidSelectPosition:position];
            }
        }
        weakSelf.slider.value = _currentPosition.value;
        [weakSelf.collection reloadData];
    }];
    [certainAction setValue:[UIColor colorWithRed:31/255.0 green:178/255.0 blue:255/255.0 alpha:1.0] forKey:@"titleTextColor"];
    
    [alertCon addAction:cancleAction];
    [alertCon addAction:certainAction];
    
    [[self viewControllerFromView:self] presentViewController:alertCon animated:YES completion:^{
    }];
    return;
}

- (UIViewController *)viewControllerFromView:(UIView *)view {
    for (UIView *next = [view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}


#pragma mark --- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FUPositionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:positionCellID forIndexPath:indexPath];
    FUPosition *modle = _dataArray[indexPath.row];
    cell.topImage.image = [self getIconImage:modle];
    cell.botlabel.text = NSLocalizedString(modle.name,nil);

    return cell;
}

#pragma mark --- UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 12, 0, 17);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FUPosition *modle = _dataArray[indexPath.row];
    if(_currentPosition == modle){
        return;
    }
    for (FUPosition *modle0 in _dataArray) {
        modle0.isSel = NO;
    }
    modle.isSel = YES;
    _currentPosition = modle;
    [self setSliderState:_currentPosition];
    
    [self.collection reloadData];
//    if ([self.delegate respondsToSelector:@selector(bodyBeautyViewDidSelectPosition:)]) {
//        [self.delegate bodyBeautyViewDidSelectPosition:modle];
//    }
}

#pragma  mark -  private

-(void)setSliderState:(FUPosition *)position{
    _slider.hidden = NO;
    if (position.type == FUPositionTypeshoulder) {//不同的样式
        _slider.type = FUFilterSliderTypeMouth;
    }else{
        _slider.type = FUFilterSliderTypeFilter;
    }
    
    _slider.value = position.value;
}

/* 根据数据不同icon */
-(UIImage *)getIconImage:(FUPosition *)position{
    NSString *behindStr = nil;
    if (position.isSel) {
        if (position.type == FUPositionTypeshoulder) {
            if (fabs(position.value - 0.5) < 0.01) {
                behindStr = @"_sel";
            }else{
                behindStr = @"_sel_open";
            }
        }else{
            if (position.value < 0.01) {
                behindStr = @"_sel";
            }else{
                behindStr = @"_sel_open";
            }
        }
    }else{
        if (position.type == FUPositionTypeshoulder) {
            if (fabs(position.value - 0.5) < 0.01) {
                behindStr = @"_nor";
            }else{
                behindStr = @"_nor_open";
            }
        }else{
            if (position.value < 0.01) {
                behindStr = @"_nor";
            }else{
                behindStr = @"_nor_open";
            }
        }
    }
    return  [UIImage imageNamed:[position.iconName stringByAppendingString:behindStr]];
}


/**
 value 是否有改动
 */
-(BOOL)isChangeValue{
    for (FUPosition *position in _dataArray) {
        if (position.type == FUPositionTypeshoulder) {//不同的样式
            
            if (position.value != 0.5) {
                return YES;
            }
        }else{
            if (position.value != 0) {
                return YES;
            }
        }
    }
    return NO;
}

@end
