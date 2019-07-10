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

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineBottomConstraint;

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
    _supArray = [FUMakeupSupModel mj_objectArrayWithKeyValuesArray:wholeDic[@"data"]];

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
            if (_supIndex > 0) {
                self.slider.value = _supArray[_supIndex].value;
            }else{
                 self.slider.hidden = YES ;
            }
            
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(makeupCustomShow:)]) {
        [self.delegate makeupCustomShow:self.isOpen];
    }
}

- (IBAction)sliderValueChange:(FUMakeupSlider *)sender {
    if (_isOpen) {
        FUSingleMakeupModel *model = self.dataArray[self.currentSel.bottomIndex].sgArr[self.currentSel.topIndex];
        float oldValue = model.value;
        model.value  =  sender.value;
        if ([self.delegate respondsToSelector:@selector(makeupViewDidChangeValue:namaValueStr:)]) {
            [self.delegate makeupViewDidChangeValue:model.value namaValueStr:model.namaValueStr];
        }
        if ((oldValue == 0 && sender.value > 0) ||(oldValue > 0 && sender.value == 0)) {//这种情况，UI显示不一样
            [self.bottomCollection reloadData];
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
        
        /* 上部分隐藏，没有选中状态 */
        if (self.topHidden) {
            int  selIndex = _dataArray[indexPath.row].singleSelIndex;
            BOOL imageHiddn = selIndex == 0 || _dataArray[indexPath.row].sgArr[selIndex].value == 0;
            cell.mImageView.hidden = imageHiddn ? YES :NO;
            cell.name.textColor = [UIColor whiteColor];
        }else{
            int  selIndex = _dataArray[indexPath.row].singleSelIndex;
            BOOL imageHiddn = selIndex == 0 || _dataArray[indexPath.row].sgArr[selIndex].value == 0;
            cell.mImageView.hidden = imageHiddn ? YES :NO;
            cell.name.textColor = self.currentSel.bottomIndex == (int)indexPath.row ? [UIColor colorWithRed:94/255.0 green:199/255.0 blue:254/255.0 alpha:1.0] : [UIColor whiteColor];
        }
        cell.name.text = NSLocalizedString(model.name, nil);
        
        return cell ;
    }
    
    if (_isOpen) {
        FUMakeupTopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:topCellID forIndexPath:indexPath];
        FUSingleMakeupModel *model = _dataArray[self.currentSel.bottomIndex].sgArr[indexPath.row];
        if (model.makeType == FUMakeupModelTypeFoundation && indexPath.row != 0) {
            cell.imageView.image = nil;
            NSArray *color = model.colors[indexPath.row - 1];
            float r,g,b,a;
            r = [color[0] floatValue];
            g = [color[1] floatValue];
            b = [color[2] floatValue];
            a = [color[3] floatValue];
            
            cell.imageView.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:a];
        }else{
            cell.imageView.backgroundColor = [UIColor clearColor];
            cell.imageView.image = [UIImage imageNamed:model.iconStr];
        }
        
        cell.mLabel.text = @"";
        cell.mLabel.textColor = _dataArray[self.currentSel.bottomIndex].singleSelIndex == indexPath.row ? [UIColor colorWithRed:94/255.0 green:199/255.0 blue:254/255.0 alpha:1.0] : [UIColor whiteColor];
        cell.imageView.layer.borderWidth = _dataArray[self.currentSel.bottomIndex].singleSelIndex == indexPath.row ? 3.0 : 0.0 ;
        cell.imageView.layer.borderColor = _dataArray[self.currentSel.bottomIndex].singleSelIndex == indexPath.row ? [UIColor colorWithRed:94/255.0 green:199/255.0 blue:254/255.0 alpha:1.0].CGColor : [UIColor clearColor].CGColor;
        return cell ;
        
    }else{
        FUMakeupTopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:topCellID forIndexPath:indexPath];
        cell.imageView.backgroundColor = [UIColor clearColor];
        cell.imageView.image = [UIImage imageNamed:_supArray[indexPath.row].imageStr];
        cell.mLabel.text = NSLocalizedString(_supArray[indexPath.row].name, nil);;
        cell.mLabel.textColor = _supArray[indexPath.row].isSel ? [UIColor colorWithRed:94/255.0 green:199/255.0 blue:254/255.0 alpha:1.0] : [UIColor whiteColor];
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
    
    _currentModel = nil;
    
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
            [self setColorViewStata:model];
            
            _currentModel = model.sgArr[_currentSel.topIndex];
            
            [self hiddenTopCollectionView:NO];
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
            
            if (model.makeType == FUMakeupModelTypeFoundation ){
                if (indexPath.row != 0) {
                    model.colorStrV = model.colors[indexPath.row - 1];
                }else{
                    model.colorStrV = @[@(0),@(0),@(0),@(0)];
                }
                model.defaultColorIndex = (int)indexPath.row - 1;
            }
                /* 是否可以选择颜色回调 */
            [self setColorViewStata:_dataArray[_currentSel.bottomIndex]];
            
            [self setSelSubItem:model];
            _currentModel = model;
            
            if ([self.delegate respondsToSelector:@selector(makeupViewDidSelTitle:)]) {
                [self.delegate makeupViewDidSelTitle:model.title];
            }

        }
    }else{
        if (_supIndex == indexPath.row) {
            return;
        }
        
        [self setSelSupItem:(int)indexPath.row];
        
    }
}

#pragma  mark -  颜色选择状态
-(void)setColorViewStata:(FUMakeupModel *)model{
    if([self.delegate respondsToSelector:@selector(makeupSelColorStata:)]){
        if (model.sgArr[0].makeType == FUMakeupModelTypeFoundation) {
            [self.delegate makeupSelColorStata:NO];
        }else{
            [self.delegate makeupSelColorStata:_currentSel.topIndex == 0 ?NO:YES];
        }
    }
    if (_currentSel.topIndex != 0) {
        [self setColorViewColorArray:model.sgArr[_currentSel.topIndex]];
    }
    
}

-(void)setColorViewColorArray:(FUSingleMakeupModel *)model{
    if ([self.delegate respondsToSelector:@selector(makeupViewSelectiveColorArray:selColorIndex:)]) {
        [self.delegate makeupViewSelectiveColorArray:model.colors selColorIndex:model.defaultColorIndex];
    }
}


#pragma  mark -  二级开关

-(void)setIsOpen:(BOOL)isOpen{
    _isOpen = isOpen;
    if (_isOpen) {
        _mTopBottom.constant = 0;
        _mSepLine.hidden = NO;
        self.bottomCollection.hidden = NO;
        self.mNoitemH.constant = 54;
        [_noitemBtn setTitle:nil forState:UIControlStateNormal];
        [_noitemBtn setImage:[UIImage imageNamed:@"makeup_return_nor"] forState:UIControlStateNormal];
        
        /* 对应到子妆转态 */
        [self setupCombinationSupMakeup:_supIndex];
        
        /* 重新设置一些参数 */
        [self restData];
        
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
        
        if([self.delegate respondsToSelector:@selector(makeupSelColorStata:)]){
            [self.delegate makeupSelColorStata:NO];
        }
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

-(void)restData{
    _currentSel.bottomIndex = 0;
    _currentSel.topIndex = 0;
    if(_supIndex > 0){//组合妆点击
        /* 标记 0-x */
        _currentSel.topIndex = _dataArray[0].singleSelIndex;
 
        FUMakeupModel *model = self.dataArray[0];
        [self setColorViewStata:model];
    }
    
    if(_supIndex < 0){//自定义
        _currentSel.topIndex = _dataArray[0].singleSelIndex;
        FUMakeupModel *model = self.dataArray[0];
        [self setColorViewStata:model];
    }
}

-(void)setNoitemBtnSata:(int)supSelIndex{
    if (supSelIndex > 5 ) {
        self.noitemBtn.enabled = NO;
        self.noitemBtn.titleLabel.alpha = 0.7;
    }else{
        self.noitemBtn.enabled = YES;
        self.noitemBtn.titleLabel.alpha = 1.0;
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

/* 子妆容相关参数，回调出去 */
-(void)setSelSubItem:(FUSingleMakeupModel *)modle{
    
    /* 妆容素材图 */
    if ([self.delegate respondsToSelector:@selector(makeupViewDidSelectedNamaStr:imageName:)]){
        [self.delegate makeupViewDidSelectedNamaStr:modle.namaTypeStr imageName:modle.namaImgStr];
        if(modle.makeType == FUMakeupModelTypeEye){//眼影
            [self.delegate makeupViewDidSelectedNamaStr:@"tex_eye2" imageName:modle.tex_eye2];
            [self.delegate makeupViewDidSelectedNamaStr:@"tex_eye3" imageName:modle.tex_eye3];
        }
    }
    
    /* 妆容颜色 */
    if (modle.colorStrV.count && [self.delegate respondsToSelector:@selector(makeupViewDidSelectedNamaStr:valueArr:)]) {
        if (modle.makeType == FUMakeupModelTypeLip && modle.is_two_color) {
           [self.delegate makeupViewDidSelectedNamaStr:modle.colorStr2 valueArr:modle.colorStr2V];
        }
        [self.delegate makeupViewDidSelectedNamaStr:modle.colorStr valueArr:modle.colorStrV];
    }
    
    /* 值 */
    if ([self.delegate respondsToSelector:@selector(makeupViewDidChangeValue:namaValueStr:)]){
        if(modle.makeType == FUMakeupModelTypeBrow){//眉毛形变开启
            [self.delegate makeupViewDidChangeValue:modle.brow_warp namaValueStr:@"brow_warp"];
            [self.delegate makeupViewDidChangeValue:modle.brow_warp_type namaValueStr:@"brow_warp_type"];
        }else if(modle.makeType == FUMakeupModelTypeLip){
            [self.delegate makeupViewDidChangeValue:modle.lip_type namaValueStr:@"lip_type"];
            [self.delegate makeupViewDidChangeValue:modle.is_two_color namaValueStr:@"is_two_color"];
        }
        [self.delegate makeupViewDidChangeValue:modle.value namaValueStr:modle.namaValueStr];
    }
    
    /* 有可选色 */
    if (modle.colors.count) {
        [self setColorViewColorArray:modle];
        /* 选中一个颜色 */
        [self.delegate makeupViewDidSelectedNamaStr:modle.colorStr valueArr:modle.colors[modle.defaultColorIndex]];
    }
}

-(void)setSelSupItem:(int)index{
    if (index >= _supArray.count || index < 0) {
        return;
    }
    
    /* 一些妆容进编辑 */
    [self setNoitemBtnSata:index];
    
    FUMakeupSupModel *modle = _supArray[index];
    _supIndex = index;
    /* 遍历所有子妆，上妆 */
    for (int i = 0; i < _supArray[_supIndex].makeups.count; i ++) {
        FUSingleMakeupModel *sModel = _supArray[_supIndex].makeups[i];
        [self setSelSubItem:sModel];
        if ([self.delegate respondsToSelector:@selector(makeupViewDidChangeValue:namaValueStr:)]){
            [self.delegate makeupViewDidChangeValue:modle.value * sModel.value namaValueStr:sModel.namaValueStr];
        }
    }
    
    /* 加上对应滤镜 */
    if ([self.delegate respondsToSelector:@selector(makeupFilter:value:)]){
        [self.delegate makeupFilter:modle.selectedFilter value:modle.selectedFilterLevel];
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

#pragma  mark ----  组合妆对应单个妆选中状态  -----
-(void)setupCombinationSupMakeup:(int)index{
    if(index < 0 || index >= _supArray.count) return;
    for (FUMakeupModel *modle in _dataArray) {
        modle.singleSelIndex = 0;
    }
    if(index == 0){//卸妆状态没有对关系
        return;
    }
    FUMakeupSupModel *supModle = _supArray[index];
    for (FUSingleMakeupModel *modle0 in supModle.makeups) {
        for (FUMakeupModel *modle1 in _dataArray) {
            if(modle0.makeType != modle1.sgArr[0].makeType){
                continue;
            }
            for (FUSingleMakeupModel *modle2 in modle1.sgArr) {
                /* 样式对应 */
                if(modle0.makeType == FUMakeupModelTypeLip){//口红特殊比较
                    if (modle0.lip_type == modle2.lip_type){
                       modle1.singleSelIndex = (int)[modle1.sgArr indexOfObject:modle2];
                        /* 值 */
                        modle2.value = modle0.value * supModle.value;
                    }
                }else if(modle0.makeType == FUMakeupModelTypeFoundation){
                       /* 粉底通过颜色，计算选中 */
                }else if(modle0.makeType == FUMakeupModelTypeBrow){
                    if (modle0.brow_warp_type == modle2.brow_warp_type) {
                        modle1.singleSelIndex = (int)[modle1.sgArr indexOfObject:modle2];//   modle0.brow_warp_type + 1;
                        modle2.value = modle0.value * supModle.value;
                    }
                }else{
                    if([modle0.namaImgStr isEqualToString:modle2.namaImgStr]) {//样式一样
                        modle1.singleSelIndex = (int)[modle1.sgArr indexOfObject:modle2];
                        /* 值 */
                        modle2.value = modle0.value * supModle.value;
                    }
                }
                
                /* 对应的颜色 */
                for (NSArray *color in modle2.colors) {
                    if ([self array:modle0.colorStrV isEqualTo:color]) {
                        modle2.defaultColorIndex = (int)[modle2.colors indexOfObject:color];
                        
                        if (modle2.makeType == FUMakeupModelTypeFoundation) {
                            if ([modle2.colors containsObject:color]) {
                                modle1.singleSelIndex = (int)[modle2.colors indexOfObject:color] + 1;
                                /* 值 */
                                modle1.sgArr[modle1.singleSelIndex].value = modle0.value * supModle.value;
//                                modle2.value = modle0.value * supModle.value;
                            }
                        }
                        
                        if (modle2.makeType == FUMakeupModelTypeEye){
                            if ([modle2.colors containsObject:color]) {
                                modle1.singleSelIndex = (int)[modle2.colors indexOfObject:color] + 1;
                                /* 值 */
                                modle1.sgArr[modle1.singleSelIndex].value = modle0.value * supModle.value;
                                //                                modle2.value = modle0.value * supModle.value;
                            }
                        }
                        
                    }
                }
     
            }
        }
    }
}


- (BOOL)array:(NSArray *)array1 isEqualTo:(NSArray *)array2 {
    if (array1.count != array2.count) {
        return NO;
    }
    for (int i = 0; i  < array1.count; i ++) {
        if ([array1[i] floatValue] != [array2[i] floatValue]) {
            return NO;
        }
    }
    return YES;
}

-(void)changeSubItemColorIndex:(int)index{
    _currentModel.defaultColorIndex = index;
    
    [self setSelSubItem:_currentModel];
}


#pragma  mark ----  组合妆是否有变化  -----

-(BOOL)supValueHaveChange:(int)index{
    BOOL isValueChange = NO;
    BOOL isColorChange = NO;
    BOOL isSelChange = NO;
    if(index < 0 || index >= _supArray.count) return NO;
    FUMakeupSupModel *supModle = _supArray[index];
    for (FUSingleMakeupModel *modle0 in supModle.makeups) {
        for (FUMakeupModel *modle1 in _dataArray) {
            if(modle0.makeType != modle1.sgArr[0].makeType){
                continue;
            }
            for (FUSingleMakeupModel *modle2 in modle1.sgArr) {
                /* 样式对应 */
                if(modle0.makeType == FUMakeupModelTypeLip){//口红特殊比较
                    if (modle0.lip_type == modle2.lip_type && modle2.title){
                        isValueChange = fabs(modle2.value - modle0.value * supModle.value) > 0.01;
                        isSelChange   = modle1.singleSelIndex != (int)[modle1.sgArr indexOfObject:modle2];
                    }
                }else if(modle0.makeType == FUMakeupModelTypeFoundation){
                    
                }else if(modle0.makeType == FUMakeupModelTypeBrow){
                    if (modle0.brow_warp_type == modle2.brow_warp_type) {
                        isSelChange  = modle1.singleSelIndex != modle0.brow_warp_type + 1;
                        isValueChange = fabs(modle2.value - modle0.value * supModle.value) > 0.01;
                    }
                }else{
                    if([modle0.namaImgStr isEqualToString:modle2.namaImgStr]) {//样式一样
                        isValueChange = fabs(modle2.value - modle0.value * supModle.value) > 0.01;
                        isSelChange   = modle1.singleSelIndex != (int)[modle1.sgArr indexOfObject:modle2];
                    }
                }
                
                /* 对应的颜色 */
                for (NSArray *color in modle2.colors) {
                    if ([self array:modle0.colorStrV isEqualTo:color]) {
                        isColorChange = modle2.defaultColorIndex != (int)[modle2.colors indexOfObject:color];
                        if (modle2.makeType == FUMakeupModelTypeFoundation) {
                            /* 值 */
                            isValueChange = fabs(modle1.sgArr[modle1.singleSelIndex].value - modle0.value * supModle.value) > 0.01;
                            isSelChange   = modle1.singleSelIndex != (int)[modle2.colors indexOfObject:color] + 1;;
                        }
                    }
                }
                
                if (isValueChange || isSelChange || isColorChange) {
                    return YES;
                }
                
            }
        }
    }
    
    return NO;
}


#pragma  mark -  隐藏top

-(void)hiddenTopCollectionView:(BOOL)isHidden{
    if (!_isOpen) {
        return;
    }
    self.topHidden  = isHidden;
    if (isHidden) {
        if (_lineBottomConstraint.constant == 0) {
            [UIView animateWithDuration:0.25 animations:^{
                _lineBottomConstraint.constant = -240;
                [self layoutIfNeeded];
            }];
        }
    }else{
        if (_lineBottomConstraint.constant < 0) {
            [self setNeedsLayout];
            [UIView animateWithDuration:0.25 animations:^{
                _lineBottomConstraint.constant = 0;
                [self layoutIfNeeded];
            }];
        }
    }
    [self.bottomCollection reloadData];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"点击了----");
}


@end

