//
//  FUMakeUpView.m
//  FULiveDemo
//
//  Created by L on 2018/8/2.
//  Copyright © 2018年 L. All rights reserved.
//

#import "FUMakeUpView.h"
#import "FUMakeupSlider.h"


@implementation FUMakeupSupModel
+(FUMakeupSupModel *)getClassName:(NSString *)name image:(NSString *)imageStr isSel:(BOOL)sel{
    FUMakeupSupModel *model = [FUMakeupSupModel new];
    model.name = name;
    model.imageStr = imageStr;
    model.isSel = sel;
    return model;
}
@end

@interface FUMakeUpView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    NSInteger bottomIndex ;
    NSMutableDictionary *selectedDict ;
    
    NSMutableDictionary *makeupLevels ;
}
@property (nonatomic, strong) NSArray *bottomList;
@property (weak, nonatomic) IBOutlet UICollectionView *bottomCollection;

@property (nonatomic, strong) NSArray *topDataList ;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UICollectionView *topCollection;
@property (weak, nonatomic) IBOutlet UIButton *noitemBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mNoitemH;

@property (weak, nonatomic) IBOutlet FUMakeupSlider *slider;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mTopBottom;
@property (weak, nonatomic) IBOutlet UIView *mSepLine;


@property (nonatomic, strong) NSArray <FUMakeupSupModel *>*supArray;
@property (nonatomic, assign) BOOL isOpen;
@end

//static NSString *registerID = @"Cell";
@implementation FUMakeUpView

-(void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    [_noitemBtn setTitle:NSLocalizedString(@"自定义",nil)  forState:UIControlStateNormal];
    
   // [_topCollection registerNib:[UINib nibWithNibName:@"FUMakeupSupCell" bundle:nil] forCellWithReuseIdentifier:registerID];
    FUMakeupSupModel *model0 = [FUMakeupSupModel getClassName:NSLocalizedString(@"卸妆", nil)  image:@"makeup_noitem" isSel:YES];
    FUMakeupSupModel *model1 = [FUMakeupSupModel getClassName:NSLocalizedString(@"桃花妆", nil) image:@"icon_peachblossom_make-up" isSel:NO];
    FUMakeupSupModel *model2 = [FUMakeupSupModel getClassName:NSLocalizedString(@"雀斑妆", nil) image:@"icon_freckles_make-up" isSel:NO];
    FUMakeupSupModel *model3 = [FUMakeupSupModel getClassName:NSLocalizedString(@"朋克妆", nil) image:@"icon_punk_make-up" isSel:NO];
    _supArray = @[model0,model1,model2,model3];
    self.isOpen = NO;
    
    NSArray *dataArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"makeupSource.plist" ofType:nil]];
    
    NSMutableArray *bottomArray = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *topArray = [NSMutableArray arrayWithCapacity:1];
    
    makeupLevels = [NSMutableDictionary dictionaryWithCapacity:1];
    selectedDict = [NSMutableDictionary dictionaryWithCapacity:1];

    for (NSDictionary *dict in dataArray) {
        NSString *name = dict[@"itemName"] ;
        [bottomArray addObject:name];
        
        NSArray *items = dict[@"items"];
        [topArray addObject:items];
        
        [selectedDict setObject:@(0) forKey:name];
    }
    

    self.bottomList = [bottomArray copy];
    self.topDataList = [topArray copy];
    
    self.bottomCollection.dataSource = self ;
    self.bottomCollection.delegate = self ;
    [self.bottomCollection reloadData];
    
    bottomIndex = 0 ;
//    self.s.hidden = YES ;
    
    self.topCollection.dataSource = self ;
    self.topCollection.delegate = self ;

}

//- (void)showTopView:(BOOL)shown {
//
//    if (shown) {    // 显示
//
//        NSString *bottomName = self.bottomList[bottomIndex];
//        NSInteger selectedIndex = [[selectedDict objectForKey:bottomName] integerValue] ;
//        self.noitemBtn.selected = selectedIndex == -1 ;
//        self.slider.hidden = selectedIndex == -1 ;
//
//        if (self.topView.hidden) {
//            self.topView.alpha = 0.0 ;
//            self.topView.transform = CGAffineTransformMakeTranslation(0, self.topView.frame.size.height / 2.0) ;
//            self.topView.hidden = NO ;
//            [UIView animateWithDuration:0.35 animations:^{
//                self.topView.transform = CGAffineTransformIdentity ;
//                self.topView.alpha = 1.0 ;
//            }];
//        }
//    }else {     // 关闭
//        self.topView.transform = CGAffineTransformIdentity ;
//        self.topView.alpha = 1.0 ;
//        self.topView.hidden = NO ;
//        [UIView animateWithDuration:0.35 animations:^{
//            self.topView.alpha = 0.0 ;
//            self.topView.transform = CGAffineTransformMakeTranslation(0, self.topView.frame.size.height / 2.0) ;
//        }completion:^(BOOL finished) {
//            self.topView.hidden = YES ;
//        }];
//    }
//    if (self.delegate && [self.delegate respondsToSelector:@selector(makeupViewDidShowTopView:)]) {
//        [self.delegate makeupViewDidShowTopView:shown];
//    }
//}

#pragma  mark ----  卸妆  -----

-(void)makeupRemove{

    NSString *bottomName = self.bottomList[bottomIndex];
    [selectedDict setObject:@(0) forKey:bottomName];
    [self.topCollection reloadData];
    if (self.delegate && [self.delegate respondsToSelector:@selector(makeupViewDidSelectedItemWithType:itemName:value:)]) {
        [self.delegate makeupViewDidSelectedItemWithType:bottomIndex itemName:@"noitem" value:1.0];
    }
    self.slider.hidden = YES ;
}


// delete current item
- (IBAction)noitemAction:(UIButton *)sender {
    self.isOpen = !self.isOpen;
    if (!_isOpen) {
        /* 有点二级,一级就不显示选中icon */
        if ([self supValueHaveChange:_supIndex]) {//组合妆是否有更改
            [self changeSelModel:-1];
            self.slider.hidden = YES ;
        }else{
            [self changeSelModel:_supIndex];
            float supValue = [self makeupSupLevelWithName:_supArray[_supIndex].name];
            self.slider.value = supValue;
        }
    }

}

- (IBAction)sliderValueChange:(FUMakeupSlider *)sender {
    if (_isOpen) {
        NSArray *dataArray = self.topDataList[bottomIndex] ;
        
        NSString *name = self.bottomList[bottomIndex] ;
        NSInteger index = [[selectedDict objectForKey:name] integerValue] ;
        NSString *itemName = dataArray[index] ;
        
        [makeupLevels setObject:@(sender.value) forKey:itemName];
        
        if ([self.delegate respondsToSelector:@selector(makeupViewDidChangeValue:Type:)]) {
            [self.delegate makeupViewDidChangeValue:sender.value Type:bottomIndex];
        }
    }else{
        FUMakeupSupModel *modle = [self getSelModel];
        if(!modle) return;
        [self setupCombinationMakeup:_supIndex supItemValue:sender.value];
        [makeupLevels setObject:@(sender.value) forKey:modle.name];
        if (!modle) return;
        if ([self.delegate respondsToSelector:@selector(makeupSupDidChangeValue:value:)]) {
            [self.delegate makeupSupDidChangeValue:_supIndex value:sender.value];
        }

    }
    

}

- (float)makeupLevelWithName:(NSString *)itemName {
    NSArray *array = makeupLevels.allKeys ;
    
    if ([array containsObject:itemName]) {
        return [[makeupLevels objectForKey:itemName] floatValue] ;
    }
    [makeupLevels setObject:@(0.5) forKey:itemName];
    return 0.5 ;
}

- (float)makeupSupLevelWithName:(NSString *)itemName {
    NSArray *array = makeupLevels.allKeys ;
    
    if ([array containsObject:itemName]) {
        return [[makeupLevels objectForKey:itemName] floatValue] ;
    }
    [makeupLevels setObject:@(1.0) forKey:itemName];
    return 1.0 ;
}


-(void)setSubSelItem:(float)value{
    
}


// 隐藏上半部分View
//-(void)hiddenMakeupViewTopView {
//    if (!self.topView.hidden) {
//        [self showTopView:NO];
//        bottomIndex = -1 ;
//        [self.bottomCollection reloadData];
//    }
//}

#pragma mark --- UICollectionViewDataSource, UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_isOpen) {
        if (collectionView == self.bottomCollection) {
            return self.bottomList.count ;
        }
        
        if (bottomIndex > -1) {
            
            NSArray *dataArray = self.topDataList[bottomIndex] ;
            return dataArray.count ;
        }else{
            return 0 ;
        }
    }else{
        return _supArray.count;
    }
    
    

}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_isOpen) {
        if (collectionView == self.bottomCollection) {
            FUMakeupBottomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FUMakeupBottomCell" forIndexPath:indexPath];
            NSString *bottomName = self.bottomList[indexPath.row];
            NSInteger selectedIndex = [[selectedDict objectForKey:bottomName] integerValue];
            cell.mImageView .hidden = selectedIndex? NO:YES;
            cell.name.textColor = bottomIndex == indexPath.row ? [UIColor colorWithRed:94/255.0 green:199/255.0 blue:254/255.0 alpha:1.0] : [UIColor whiteColor];
            cell.name.text = NSLocalizedString(self.bottomList[indexPath.row], nil) ;
            return cell ;
        }
        
        FUMakeupTopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FUMakeupTopCell" forIndexPath:indexPath];
        
        if (bottomIndex != -1) {
            NSArray *dataArray = self.topDataList[bottomIndex] ;
            NSString *imageName = dataArray[indexPath.row] ;
            cell.imageView.image = [UIImage imageNamed:imageName];
            cell.mLabel.text = @"";
            NSString *bottomName = self.bottomList[bottomIndex];
            NSInteger selectedIndex = [[selectedDict objectForKey:bottomName] integerValue] ;
            cell.imageView.layer.borderWidth = selectedIndex == indexPath.row ? 3.0 : 0.0 ;
            cell.imageView.layer.borderColor = selectedIndex == indexPath.row ? [UIColor colorWithRed:94/255.0 green:199/255.0 blue:254/255.0 alpha:1.0].CGColor : [UIColor clearColor].CGColor;
        }
        return cell ;
    }else{
        if (collectionView == self.bottomCollection) {
            FUMakeupBottomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FUMakeupBottomCell" forIndexPath:indexPath];
            
            cell.name.textColor = bottomIndex == indexPath.row ? [UIColor colorWithRed:94/255.0 green:199/255.0 blue:254/255.0 alpha:1.0] : [UIColor whiteColor];
            cell.name.text = NSLocalizedString(self.bottomList[indexPath.row], nil) ;
            return cell ;
        }
        
        FUMakeupTopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FUMakeupTopCell" forIndexPath:indexPath];
        cell.imageView.image = [UIImage imageNamed:_supArray[indexPath.row].imageStr];
        cell.mLabel.text = _supArray[indexPath.row].name;
        cell.imageView.layer.borderWidth = _supArray[indexPath.row].isSel ? 3.0 : 0.0 ;
        cell.imageView.layer.borderColor = _supArray[indexPath.row].isSel ? [UIColor colorWithRed:94/255.0 green:199/255.0 blue:254/255.0 alpha:1.0].CGColor : [UIColor clearColor].CGColor;
        return cell;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(_isOpen){
        if (collectionView == self.bottomCollection) {
            return CGSizeMake(59.0, self.bottomCollection.bounds.size.height) ;
        }
        
        return CGSizeMake(54.0, 54.0) ;
    }else{
        return CGSizeMake(54.0, 70.0) ;
    }

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(_isOpen){
        if (collectionView == self.bottomCollection) {
            bottomIndex = indexPath.row ;
             NSString *name = self.bottomList[bottomIndex] ;
            NSInteger index = [[selectedDict objectForKey:name] integerValue] ;

            if (index > 0) {
                _slider.hidden = NO;
                NSArray *dataArray = self.topDataList[bottomIndex] ;
                NSString *itemName = dataArray[index] ;
                self.slider.value = [self makeupLevelWithName:itemName];
            }else{
                _slider.hidden = YES;
            }
            
            
            [self.bottomCollection reloadData];
            [self.topCollection reloadData];
        }else {
            if (indexPath.row != 0) {
                self.slider.hidden = NO;
            }else{
                self.slider.hidden = YES;
            }
            
            NSString *bottomName = self.bottomList[bottomIndex];
            [selectedDict setObject:@(indexPath.row) forKey:bottomName];
            [self.topCollection reloadData];
            [self.bottomCollection reloadData];
            
            NSArray *dataArray = self.topDataList[bottomIndex] ;
            NSString *itemName = dataArray[indexPath.row] ;
            
            self.noitemBtn.selected = NO ;
            self.slider.value = [self makeupLevelWithName:itemName];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(makeupViewDidSelectedItemWithType:itemName:value:)]) {
                [self.delegate makeupViewDidSelectedItemWithType:bottomIndex itemName:itemName value:[self makeupLevelWithName:itemName]];
            }
        }
    }else{
        if (indexPath.row != 0) {
            self.slider.hidden = NO ;
            self.slider.value = [self makeupSupLevelWithName:_supArray[indexPath.row].name];
        }else{
             self.slider.hidden = YES;
        }
        [self changeSelModel:(int)indexPath.row];
        
        if ([self.delegate respondsToSelector:@selector(makeupSupItemDidSel:value:)]) {
            float value = [self makeupSupLevelWithName:_supArray[indexPath.row].name];
            [self.delegate makeupSupItemDidSel:(int)indexPath.row value:value];
        }
        _supIndex = (int)indexPath.row;
        float supValue = [self makeupSupLevelWithName:_supArray[indexPath.row].name];
        [self setupCombinationMakeup:_supIndex supItemValue:supValue];
        [_topCollection reloadData];
    }
}


-(void)setIsOpen:(BOOL)isOpen{
    _isOpen = isOpen;
    if (_isOpen) {
        _mTopBottom.constant = 0;
        _mSepLine.hidden = NO;
        self.bottomCollection.hidden = NO;
        self.mNoitemH.constant = 54;
        [_noitemBtn setTitle:nil forState:UIControlStateNormal];
        [_noitemBtn setImage:[UIImage imageNamed:@"makeup_return_nor"] forState:UIControlStateNormal];
        
        NSString *name = self.bottomList[bottomIndex] ;
        NSInteger index = [[selectedDict objectForKey:name] integerValue] ;
        if (index > 0) {
            _slider.hidden = NO;
            
            NSArray *dataArray = self.topDataList[bottomIndex] ;
            NSString *name = self.bottomList[bottomIndex] ;
            NSInteger index = [[selectedDict objectForKey:name] integerValue] ;
            NSString *itemName = dataArray[index] ;
            
             self.slider.value = [self makeupLevelWithName:itemName];
        }else{
            _slider.hidden = YES;
        }
    }else{
        _mTopBottom.constant = -50;
        _mSepLine.hidden = YES;
        self.bottomCollection.hidden = YES;
        self.mNoitemH.constant = 70;
        [_noitemBtn setImage:[UIImage imageNamed:@"makeup_custom_nor"] forState:UIControlStateNormal];
        [_noitemBtn setTitle:NSLocalizedString(@"自定义",nil)  forState:UIControlStateNormal];
    }
    [self.topCollection reloadData];
    [self.bottomCollection reloadData];
}





#pragma  mark ----  改变模型  -----
-(void)changeSelModel:(int)index{
    for (FUMakeupSupModel *model in _supArray) {
        model.isSel = NO;
        
    }
    if (index < _supArray.count && index >= 0) {
        _supArray[index].isSel = YES;
    }
}

-(FUMakeupSupModel *)getSelModel{
    for (FUMakeupSupModel *model in _supArray) {
        if (model.isSel) {
            return model;
        }
    }
    return nil;
}

-(int)getSelModelIndex{
    for (FUMakeupSupModel *model in _supArray) {
        if (model.isSel) {
            return (int)[_supArray indexOfObject:model];
        }
    }
    return 0;
}

#pragma  mark ----  默认组合妆选中  -----

-(void)setDefaultSupItem:(int)index{
    if (index >= _supArray.count || index < 0) {
        return;
    }
    float supValue = [self makeupSupLevelWithName:_supArray[index].name];
    if (index != 0) {
        self.slider.hidden = NO;
        self.slider.value = supValue;
    }else{
        self.slider.hidden = YES;
    }
    _supIndex = index;
    [self setupCombinationMakeup:_supIndex supItemValue:supValue];
    [self changeSelModel:index];
    [_topCollection reloadData];
    if ([self.delegate respondsToSelector:@selector(makeupSupItemDidSel:value:)]) {
        [self.delegate makeupSupItemDidSel:index value:self.slider.value];
    }
}

#pragma  mark ----  组合妆对应单个妆选中转态  -----
-(void)setupCombinationMakeup:(int)index supItemValue:(float)value{
    switch (index) {
        case 0:{
            NSArray *selArray = @[@0,@0,@0,@0,@0,@0,@0];
            for (int i = 0; i < _bottomList.count; i ++) {
                NSString *name = _bottomList[i];
                [selectedDict setObject:selArray[i] forKey:name];
            }
        }
            break;
            
        case 1:{//桃花
            NSArray *selArray = @[@1,@1,@1,@1,@1,@1,@1];
            for (int i = 0; i < _bottomList.count; i ++) {
                NSString *name = _bottomList[i];
                NSArray *dataArray = self.topDataList[i] ;
                NSInteger index = [selArray[i] intValue];
                NSString *itemName = dataArray[index];
                float itemNameValue = value * 0.7;//和组合值又 * 0.7 的关系
 
                [makeupLevels setObject:@(itemNameValue) forKey:itemName];
                [selectedDict setObject:selArray[i] forKey:name];
            }
        }
            break;
            
        case 2:{//雀斑
            NSArray *selArray = @[@2,@2,@2,@2,@2,@2,@2];
            for (int i = 0; i < _bottomList.count; i ++) {
                NSString *name = _bottomList[i];
                NSArray *dataArray = self.topDataList[i] ;
                NSInteger index = [selArray[i] intValue];
                NSString *itemName = dataArray[index];
                float itemNameValue = value * 0.7;//和组合值又 * 0.7 的关系
                
                [makeupLevels setObject:@(itemNameValue) forKey:itemName];
                [selectedDict setObject:selArray[i] forKey:name];
            }
        }
            break;
            
        case 3:{//朋克
            NSArray *selArray = @[@3,@0,@3,@3,@2,@2,@3];
            for (int i = 0; i < _bottomList.count; i ++) {
                NSString *name = _bottomList[i];
                NSArray *dataArray = self.topDataList[i] ;
                NSInteger index = [selArray[i] intValue];
                NSString *itemName = dataArray[index];
                float itemNameValue = value * 0.7;//和组合值又 * 0.7 的关系
                
                [makeupLevels setObject:@(itemNameValue) forKey:itemName];
                [selectedDict setObject:selArray[i] forKey:name];
            }
        }
            break;
        default:
            break;
    }
}

#pragma  mark ----  组合妆是否有变化  -----
-(BOOL)supValueHaveChange:(int)supIndex{
    float supValue = [self makeupSupLevelWithName:_supArray[supIndex].name];
    switch (supIndex) {
        case 0:{
            NSArray *selArray = @[@0,@0,@0,@0,@0,@0,@0];
            for (int i = 0; i < _bottomList.count; i ++) {
                NSString *name = _bottomList[i];
                int index =  [[selectedDict objectForKey:name] intValue];
                if (index != [selArray[i] intValue]) {
                    return YES;
                }
            }
        }
            break;
            
        case 1:{//桃花
            NSArray *selArray = @[@1,@1,@1,@1,@1,@1,@1];
            for (int i = 0; i < _bottomList.count; i ++) {
                NSString *name = _bottomList[i];
                int index =  [[selectedDict objectForKey:name] intValue];
                NSArray *dataArray = self.topDataList[i];
                NSString *itemName = dataArray[index];
                if (index != [selArray[i] intValue]) {
                    return YES;
                }else{
                    float itmeVlaue = [self makeupLevelWithName:itemName];
                    if (fabs(itmeVlaue - supValue * 0.7) > 0.005) {
                        return YES;
                    }
                }
            }
        }
            break;
            
        case 2:{//雀斑
            NSArray *selArray = @[@2,@2,@2,@2,@2,@2,@2];
            for (int i = 0; i < _bottomList.count; i ++) {
                NSString *name = _bottomList[i];
                int index =  [[selectedDict objectForKey:name] intValue];
                NSArray *dataArray = self.topDataList[i];
                NSString *itemName = dataArray[index];
                if (index != [selArray[i] intValue]) {
                    return YES;
                }else{
                    float itmeVlaue = [self makeupLevelWithName:itemName];
                    if (fabs(itmeVlaue - supValue * 0.7) > 0.01) {
                        return YES;
                    }
                }
            }
        }
            break;
            
        case 3:{//朋克
            NSArray *selArray = @[@3,@0,@3,@3,@2,@2,@3];
            for (int i = 0; i < _bottomList.count; i ++) {
                NSString *name = _bottomList[i];
                int index =  [[selectedDict objectForKey:name] intValue];
                NSArray *dataArray = self.topDataList[i];
                NSString *itemName = dataArray[index];
                if (index != [selArray[i] intValue]) {
                    return YES;
                }else{
                    float itmeVlaue = [self makeupLevelWithName:itemName];
                    if (fabs(itmeVlaue - supValue * 0.7) > 0.01) {
                        return YES;
                    }
                }
            }
        }
            break;
        default:
            break;
    }
    return NO;
}


@end


@implementation FUMakeupTopCell
@end

@implementation FUMakeupBottomCell
@end
