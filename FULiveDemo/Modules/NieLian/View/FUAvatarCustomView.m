//
//  FUAvatarCustomView.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/3/21.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import "FUAvatarCustomView.h"
#import "FUAvatarSlider.h"
#import "FUAvatarModel.h"
#import "FUManager.h"


#pragma  mark -  FUAvatarCustomCell
@implementation FUAvatarCustomCell
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        _image  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
        _image.center = self.contentView.center;
        [self.contentView addSubview:_image];
    }
    
    return self;
}
@end


#pragma  mark -  FUAvatarCustomView
@interface FUAvatarCustomView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView *collection;

@property (strong, nonatomic) UILabel *explainLabel;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) FUAvatarSlider *slider;

@property (assign, nonatomic) NSInteger selIndex;
@end

static  NSString *cellID = @"avatarCustomCell";

@implementation FUAvatarCustomView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self setupSubView];
    }
    
    return self;
}


-(void)setupSubView{
    _explainLabel = [[UILabel alloc] init];
    _explainLabel.frame = CGRectMake(17,20,80,20);
    _explainLabel.textAlignment = NSTextAlignmentCenter;
    _explainLabel.numberOfLines = 0;
    _explainLabel.text = @"额头宽窄";
    _explainLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    _explainLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_explainLabel];
    
    _slider = [[FUAvatarSlider alloc] initWithFrame:CGRectMake(_explainLabel.frame.origin.x + 5 + _explainLabel.frame.size.width, 20, [UIScreen mainScreen].bounds.size.width - _explainLabel.frame.size.width - 40, 20)];
    [_slider addTarget:self action:@selector(sliderChangeValue:) forControlEvents:UIControlEventValueChanged];
    _slider.hidden = YES;
    _slider.type = FUSliderCellType101;
    [self addSubview:_slider];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 20;
    layout.itemSize = CGSizeMake(45, 45);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 60, [UIScreen mainScreen].bounds.size.width, 85) collectionViewLayout:layout];
    _collection.backgroundColor = [UIColor clearColor];
    _collection.delegate = self;
    _collection.dataSource = self;
    [self addSubview:_collection];
    [_collection registerClass:[FUAvatarCustomCell class] forCellWithReuseIdentifier:cellID];
    _collection.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    
    UIView *sqView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_collection.frame), [UIScreen mainScreen].bounds.size.width, 1/[UIScreen mainScreen].scale)];
    sqView.backgroundColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    [self addSubview:sqView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(sqView.frame),[UIScreen mainScreen].bounds.size.width,49)];
    _titleLabel.text = @"脸型";
    _titleLabel.textColor = [UIColor colorWithRed:44/255.0 green:46/255.0 blue:48/255.0 alpha:1.0];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
}

-(void)setAvatarModel:(FUAvatarModel *)avatarModel{
    _avatarModel = avatarModel;
    _oldAvatarModel = [avatarModel copy];
    _titleLabel.text = NSLocalizedString(avatarModel.title, nil);
    _selIndex = 0;
    _slider.hidden = YES;
    _explainLabel.hidden = YES;
    
//    if (_avatarModel.bundleSelIndex != 0) {
//        int index =  _avatarModel.bundleSelIndex;
//        for (int i = 0; i  < _avatarModel.bundles[0].params.count; i ++) {
//            _avatarModel.bundles[0].params[i].value = 0;
//        }
//        
//    }
    [self.collection reloadData];
    
}

#pragma  mark -  UI事件

-(void)sliderChangeValue:(FUAvatarSlider *)slider{
    NSLog(@"-----%lf",slider.value);
    if(_selIndex < 1){
        NSLog(@"重置不能调节");
        return;
    }
        
    FUAvatarParam *paramModel = _avatarModel.bundles[0].params[_selIndex - 1];
    paramModel.value =  (slider.value - 0.5) * 2;
    if (slider.value > 0.5) {
        [[FUManager shareManager] setAvatarParam:paramModel.paramS value:0];
        [[FUManager shareManager] setAvatarParam:paramModel.paramB value:(slider.value - 0.5) * 2];
    }else{
        [[FUManager shareManager] setAvatarParam:paramModel.paramS value:fabs(0.5 - slider.value) * 2];
        [[FUManager shareManager] setAvatarParam:paramModel.paramB value:0];
    }
}



#pragma mark --- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _avatarModel.bundles[0].params.count + 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FUAvatarCustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        cell.image.image =   [UIImage imageNamed:@"demo_avatar_reset"];
    }else{
        FUAvatarParam *modle = _avatarModel.bundles[0].params[indexPath.row - 1];
        
        cell.image.image = _selIndex == indexPath.row ?[UIImage imageNamed:modle.icon_sel] : [UIImage imageNamed:modle.icon];
    }

    return cell;
}

#pragma mark --- UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(20, 10, 20, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FUBundelModel *modle = _avatarModel.bundles[0];
    if (indexPath.row == 0) {//重置
        [self restBundleParm:modle];
    }else{
        _selIndex = indexPath.row;
        _slider.value =  (modle.params[_selIndex - 1].value + 1)/2;
        _explainLabel.hidden = NO;
        _slider.hidden = NO;
        _explainLabel.hidden = NO;
        _explainLabel.text = NSLocalizedString(_avatarModel.bundles[0].params[_selIndex - 1].title, nil);
        _slider.value = (1 + _avatarModel.bundles[0].params[_selIndex - 1].value) / 2;
          [_collection reloadData];
    }
}

-(void)restBundleParm:(FUBundelModel *)modle{
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"是否将所有参数恢复到默认值",nil) preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [cancleAction setValue:[UIColor colorWithRed:44/255.0 green:46/255.0 blue:48/255.0 alpha:1.0] forKey:@"titleTextColor"];

    UIAlertAction *certainAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self setAvatarValueZero];
    }];
    [certainAction setValue:[UIColor colorWithRed:31/255.0 green:178/255.0 blue:255/255.0 alpha:1.0] forKey:@"titleTextColor"];
    
    [alertCon addAction:cancleAction];
    [alertCon addAction:certainAction];
    
    [[self viewControllerFromView:self]  presentViewController:alertCon animated:YES completion:^{
    }];
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


-(void)resetDefaultValue{
    FUBundelModel *modle = _avatarModel.bundles[0];
    FUBundelModel *oldModle = _oldAvatarModel.bundles[0];
    
    for (int i = 0; i  < modle.params.count; i ++) {
        FUAvatarParam *param = modle.params[i];
        FUAvatarParam *oldParam = oldModle.params[i];
        param.value = oldParam.value;
        
        if (param.value < 0) {
            [[FUManager shareManager] setAvatarParam:param.paramB value:0];
            [[FUManager shareManager] setAvatarParam:param.paramS value:fabsf(param.value)];
        }else{
            [[FUManager shareManager] setAvatarParam:param.paramS value:0];
            [[FUManager shareManager] setAvatarParam:param.paramB value:fabsf(param.value)];
        }
    }
    _slider.hidden = YES;
    [_collection reloadData];
}

-(void)setAvatarValueZero{
    for (FUAvatarParam *param in _avatarModel.bundles[0].params) {
        param.value = 0;
        [[FUManager shareManager] setAvatarParam:param.paramB value:0];
        [[FUManager shareManager] setAvatarParam:param.paramS value:0];
    }
    _selIndex = 0;
    _slider.hidden = YES;
    _explainLabel.hidden = YES;
    [_collection reloadData];
}



-(BOOL)isParamValueChange{
    /* 自定义数据 */
    FUBundelModel *modle = _avatarModel.bundles[0];
    FUBundelModel *oldModle = _oldAvatarModel.bundles[0];
    
    for (int i = 0; i  < modle.params.count; i ++) {
        if (modle.params[i].value != oldModle.params[i].value) return YES;
    }
    
    return NO;
}

@end
