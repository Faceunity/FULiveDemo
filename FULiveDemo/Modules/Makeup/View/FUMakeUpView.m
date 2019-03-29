//
//  FUMakeUpView.m
//  FULiveDemo
//
//  Created by L on 2018/8/2.
//  Copyright © 2018年 L. All rights reserved.
//

#import "FUMakeUpView.h"
#import "FUMakeupSlider.h"
#import "MJExtension.h"
#import "FUMakeupModel.h"
#import "FUMakeupTopCell.h"
#import "FUMakeupBottomCell.h"
#import "FUMakeupSupModel.h"

struct FUMakeupIndexPath {
    int topIndex;
    int bottomIndex;
};

@interface FUMakeUpView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *topCollection;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mNoitemH;

@property (weak, nonatomic) IBOutlet FUMakeupSlider *slider;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mTopBottom;
@property (weak, nonatomic) IBOutlet UIView *mSepLine;

@property (nonatomic, strong) NSArray <FUMakeupSupModel *>*supArray;
@property (nonatomic, assign) BOOL isOpen;

@property (assign, nonatomic) struct FUMakeupIndexPath currentSel;
@property (nonatomic, strong) NSArray <FUMakeupModel *>* dataArray;
@property (nonatomic,strong)  NSArray *supToSingelArr;

@end

static NSString *topCellID = @"FUMakeupTopCell";
static NSString *bottomCellID = @"FUMakeupBottomCell";
@implementation FUMakeUpView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"FUMakeUpView" owner:self options:nil] firstObject];
        self.frame = frame;
        
    }
    
    return self;
}


-(void)awakeFromNib {
    [super awakeFromNib];

    _currentSel.bottomIndex = 0;
    _currentSel.topIndex = 0;
    self.slider.hidden = YES;
    
    [_noitemBtn setTitle:NSLocalizedString(@"自定义",nil)  forState:UIControlStateNormal];
    self.backgroundColor = [UIColor clearColor];
    [self setupData];
    

//    [self setupWholeMakeup];
//    self.supToSingelArr = @[@[@0,@0,@0,@0,@0,@0,@0],@[@6,@6,@6,@6,@6,@6,@6],@[@7,@7,@7,@7,@7,@7,@7],@[@8,@0,@8,@8,@8,@8,@8],@[@1,@1,@1,@1,@1,@1,@1],@[@2,@2,@2,@2,@2,@2,@2],@[@3,@3,@3,@3,@3,@3,@3],@[@4,@4,@4,@4,@4,@4,@4],@[@5,@5,@5,@5,@5,@5,@5]];
  //  self.supToSingelArr = @[@[@0,@0,@0,@0,@0,@0,@0],@[@6,@6,@6,@6,@0,@0,@6],@[@7,@7,@7,@7,@0,@0,@7],@[@8,@0,@8,@8,@0,@0,@8],@[@1,@1,@1,@1,@0,@0,@1],@[@2,@2,@2,@2,@0,@0,@2],@[@3,@3,@3,@3,@0,@0,@3],@[@4,@4,@4,@4,@0,@0,@4],@[@5,@5,@5,@5,@0,@0,@5]];
    
    self.supToSingelArr = @[@[@0,@0,@0,@0,@0,@0,@0],@[@1,@1,@1,@1,@0,@0,@0],@[@3,@0,@3,@3,@0,@0,@0],@[@10,@13,@10,@10,@0,@0,@0],@[@12,@15,@12,@12,@0,@0,@0],@[@13,@16,@13,@13,@0,@0,@0],@[@14,@17,@14,@14,@0,@0,@0],@[@11,@14,@11,@11,@0,@0,@0],
                            @[@15,@0,@15,@15,@0,@0,@0],
                            @[@16,@18,@10,@16,@0,@0,@0],
                            @[@17,@19,@12,@17,@0,@0,@0],
                            @[@18,@20,@16,@18,@0,@0,@0],
                            @[@19,@21,@19,@19,@0,@0,@0],
                            @[@20,@22,@18,@20,@0,@0,@0],
                            @[@21,@23,@19,@21,@0,@0,@0],
                            @[@22,@24,@13,@22,@0,@0,@0]];
    
    /* 初始化collection */
    [_topCollection registerNib:[UINib nibWithNibName:@"FUMakeupTopCell" bundle:nil] forCellWithReuseIdentifier:topCellID];
    [_bottomCollection registerNib:[UINib nibWithNibName:@"FUMakeupBottomCell" bundle:nil] forCellWithReuseIdentifier:bottomCellID];
    self.bottomCollection.dataSource = self ;
    self.bottomCollection.delegate = self;
    [self.bottomCollection reloadData];
    self.topCollection.dataSource = self ;
    self.topCollection.delegate = self ;
    
    self.isOpen = NO;
}

-(void)setupData{
    /* 子妆容 */
    /* 美妆数据转modle */
    NSString *path=[[NSBundle mainBundle] pathForResource:@"makeup" ofType:@"json"];
    NSData *data=[[NSData alloc] initWithContentsOfFile:path];
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    self.dataArray = [FUMakeupModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
    
    /* 整体妆容 */
    NSString *wholePath=[[NSBundle mainBundle] pathForResource:@"makeup_whole" ofType:@"json"];
    NSData *wholeData=[[NSData alloc] initWithContentsOfFile:wholePath];
    NSDictionary *wholeDic=[NSJSONSerialization JSONObjectWithData:wholeData options:NSJSONReadingMutableContainers error:nil];
    _supArray = [FUMakeupSupModel mj_objectArrayWithKeyValuesArray:wholeDic[@"data1"]];
}


// delete current item
- (IBAction)noitemAction:(UIButton *)sender {
    self.isOpen = !self.isOpen;
    if (!_isOpen) {
        /* 有点二级,一级就不显示选中icon */
        if ([self supValueHaveChange:_supIndex]) {//组合妆是否有更改
            [self changeSelModel:-1];
            _supIndex = -1;
            self.slider.hidden = YES ;
        }else{
            [self changeSelModel:_supIndex];
            self.slider.value = _supArray[_supIndex].value;
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(makeupCustomShow:)]) {
        [self.delegate makeupCustomShow:self.isOpen];
    }
}

- (IBAction)sliderValueChange:(FUMakeupSlider *)sender {
    if (_isOpen) {
        FUSingleMakeupModel *model = self.dataArray[self.currentSel.bottomIndex].sgArr[self.currentSel.topIndex];
        model.value  =  sender.value;
        if ([self.delegate respondsToSelector:@selector(makeupViewDidChangeValue:namaValueStr:)]) {
            [self.delegate makeupViewDidChangeValue:model.value namaValueStr:self.dataArray[self.currentSel.bottomIndex].namaValueStr];
        }
    }else{
        FUMakeupSupModel *model = _supArray[_supIndex];
        if(!model) return;
        model.value = sender.value;
        model.selectedFilterLevel = sender.value;
        
        for (int i = 0; i < model.makeups.count; i ++) {
            [self.delegate makeupViewDidChangeValue:model.value * model.makeups[i].value namaValueStr:model.makeups[i].namaValueStr];
        }
        
        if ([self.delegate respondsToSelector:@selector(makeupFilter:value:)]){
            [self.delegate makeupFilter:model.selectedFilter value:model.value];
        }
    }
}

#pragma mark --- UICollectionViewDataSource, UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.bottomCollection) {
        return self.dataArray.count;
    }
    if (_isOpen) {
        return self.dataArray[self.currentSel.bottomIndex].sgArr.count;
    }else{
        return self.supArray.count;
    }
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.bottomCollection) {
        FUMakeupBottomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:bottomCellID forIndexPath:indexPath];
        FUMakeupModel *model = _dataArray[indexPath.row];
        cell.mImageView.hidden = _dataArray[indexPath.row].singleSelIndex? NO:YES;
        cell.name.textColor = self.currentSel.bottomIndex == (int)indexPath.row ? [UIColor colorWithRed:94/255.0 green:199/255.0 blue:254/255.0 alpha:1.0] : [UIColor whiteColor];
        cell.name.text = NSLocalizedString(model.name, nil) ;
        return cell ;
    }
    
    if (_isOpen) {
        FUMakeupTopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:topCellID forIndexPath:indexPath];
        FUSingleMakeupModel *model = _dataArray[self.currentSel.bottomIndex].sgArr[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:model.iconStr];
        
        cell.mLabel.text = @"";
        cell.imageView.layer.borderWidth = _dataArray[self.currentSel.bottomIndex].singleSelIndex == indexPath.row ? 3.0 : 0.0 ;
        cell.imageView.layer.borderColor = _dataArray[self.currentSel.bottomIndex].singleSelIndex == indexPath.row ? [UIColor colorWithRed:94/255.0 green:199/255.0 blue:254/255.0 alpha:1.0].CGColor : [UIColor clearColor].CGColor;
        return cell ;
        
    }else{
        FUMakeupTopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:topCellID forIndexPath:indexPath];
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
            return CGSizeMake(70.0, self.bottomCollection.bounds.size.height) ;
        }
        
        return CGSizeMake(54.0, 54.0) ;
    }else{
        return CGSizeMake(54.0, 70.0) ;
    }
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(_isOpen){
        if (collectionView == self.bottomCollection) {
            _currentSel.bottomIndex = (int)indexPath.row;
            FUMakeupModel *model = self.dataArray[_currentSel.bottomIndex];
            _currentSel.topIndex = model.singleSelIndex;
            if (model.singleSelIndex > 0) {
                _slider.hidden = NO;
                self.slider.value = model.sgArr[model.singleSelIndex].value;
            }else{
                _slider.hidden = YES;
            }
            
            [self.bottomCollection reloadData];
            [self.topCollection reloadData];
        }else {
            _currentSel.topIndex = (int)indexPath.row;
            _dataArray[_currentSel.bottomIndex].singleSelIndex = (int)indexPath.row;
            if (indexPath.row != 0) {
                self.slider.hidden = NO;
            }else{
                self.slider.hidden = YES;
            }
            [self.topCollection reloadData];
            [self.bottomCollection reloadData];
            
            FUSingleMakeupModel *model = _dataArray[_currentSel.bottomIndex].sgArr[_currentSel.topIndex];
            self.noitemBtn.selected = NO ;
            self.slider.value = model.value;
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(makeupViewDidSelectedItemName:namaStr:isLip:)]) {
                if (_currentSel.bottomIndex == 0) {
                    [self.delegate makeupViewDidSelectedItemName:model.namaImgStr namaStr:_dataArray[_currentSel.bottomIndex].namaTypeStr isLip:YES];
                }else{
                    [self.delegate makeupViewDidSelectedItemName:model.namaImgStr namaStr:_dataArray[_currentSel.bottomIndex].namaTypeStr isLip:NO];
                    
                }
                
                [self.delegate makeupViewDidChangeValue:model.value namaValueStr:_dataArray[_currentSel.bottomIndex].namaValueStr];
            }
        }
    }else{
        FUMakeupSupModel *modle = _supArray[indexPath.row];
        _supIndex = (int)indexPath.row;
        if (indexPath.row != 0) {
            self.slider.hidden = NO ;
            self.slider.value = modle.value;
        }else{
            self.slider.hidden = YES;
        }
        for (int i = 0; i < _supArray[_supIndex].makeups.count; i ++) {
            FUSingleMakeupModel *sModel = _supArray[_supIndex].makeups[i];
            
            if ([self.delegate respondsToSelector:@selector(makeupViewDidSelectedItemName:namaStr:isLip:)]){
                if (i == 0) {
                    [self.delegate makeupViewDidSelectedItemName:sModel.namaImgStr namaStr:sModel.namaTypeStr isLip:YES];
                }else{
                    [self.delegate makeupViewDidSelectedItemName:sModel.namaImgStr namaStr:sModel.namaTypeStr isLip:NO];
                }
            }
            
            if ([self.delegate respondsToSelector:@selector(makeupViewDidChangeValue:namaValueStr:)]){
                [self.delegate makeupViewDidChangeValue:sModel.value * _supArray[_supIndex].value namaValueStr:sModel.namaValueStr];
            }
            
        }
        
        if ([self.delegate respondsToSelector:@selector(makeupFilter:value:)]){
            [self.delegate makeupFilter:modle.selectedFilter value:modle.selectedFilterLevel];
        }
        
        [self setDefaultSupItem:(int)indexPath.row];
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
        
        if(_supIndex >= 0){//组合妆点击
            _currentSel.bottomIndex = 0;
            _currentSel.topIndex =[_supToSingelArr[_supIndex][0] intValue];
            [self setupCombinationMakeup:_supIndex supItemValue:self.supArray[_supIndex].value];
        }
        
        if (_currentSel.topIndex > 0) {
            _slider.hidden = NO;
            self.slider.value = _dataArray[_currentSel.bottomIndex].sgArr[_currentSel.topIndex].value;
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
    
    /* 滑动到指定位置 */
    if(_isOpen){
        [_topCollection scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentSel.topIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }else{
        if (_supIndex > 0) {
            [_topCollection scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_supIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        }
    }
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

#pragma  mark ----  接口方法  -----

-(void)setDefaultSupItem:(int)index{
    if (index >= _supArray.count || index < 0) {
        return;
    }
    
    float supValue = _supArray[_supIndex].value;
    if (index != 0) {
        self.slider.hidden = NO;
        self.slider.value = supValue;
    }else{
        self.slider.hidden = YES;
    }
    
   // [self setupCombinationMakeup:_supIndex supItemValue:supValue];
    [self changeSelModel:index];
    [_topCollection reloadData];
}


/* 组合妆数组 */
-(void)setWholeArray:(NSArray <FUMakeupSupModel *> *)dataArray{
    _supArray = dataArray;
    [_topCollection reloadData];
    [_bottomCollection reloadData];
}
/* 组合妆，对应子妆容表 */
-(void)setSupToSingelArr:(NSArray *)supTosingeArr{
    _supToSingelArr = supTosingeArr;
    
    [_topCollection reloadData];
    [_bottomCollection reloadData];
}

#pragma  mark ----  组合妆对应单个妆选中转态  -----
-(void)setupCombinationMakeup:(int)index supItemValue:(float)value{
    if (index < 0 || index >= _supArray.count ) {
        return;
    }
    /* 重置 */
    for (FUMakeupModel *model in _dataArray) {
        for (int i = 0;i < model.sgArr.count;i++) {
            FUSingleMakeupModel *model0 = model.sgArr[i];
            if (i == 0) {
                model0.value = 0.0;
            }else{
                model0.value = 1.0;
            }
            NSLog(@"-----%d",i);
        }
        model.singleSelIndex = 0;
    }
    
    /* 设置单个妆的值 */
    NSArray *singleArr = _supToSingelArr[index];
    for (int i = 0; i < _dataArray.count; i ++) {
        int singeIdex = [singleArr[i] intValue];
        FUSingleMakeupModel *sModel = _dataArray[i].sgArr[singeIdex];
        /* 单个妆的value = supValue * supSingleValue */
        sModel.value = value * self.supArray[_supIndex].makeups[i].value;
        
        _dataArray[i].singleSelIndex = singeIdex;
    }
}

#pragma  mark ----  组合妆是否有变化  -----
-(BOOL)supValueHaveChange:(int)supIndex{
    if(supIndex < 0 ){
        return YES;
    }
    NSArray *singleArr = _supToSingelArr[supIndex];
    for (int i = 0; i < _dataArray.count; i ++) {
        int singeIdex = [singleArr[i] intValue];
        FUSingleMakeupModel *sModel = _dataArray[i].sgArr[singeIdex];
        BOOL isValueChange = fabs(sModel.value - _supArray[_supIndex].value * _supArray[_supIndex].makeups[i].value) > 0.005;
        BOOL isSelChange  =  _dataArray[i].singleSelIndex != [singleArr[i] intValue];
        if (isValueChange || isSelChange) {
            return YES;
        }
    }
    return NO;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"点击了----");
}


@end

