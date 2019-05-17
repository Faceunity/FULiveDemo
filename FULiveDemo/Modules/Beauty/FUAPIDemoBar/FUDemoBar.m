//
//  FUDemoBar.m
//  FUAPIDemoBar
//
//  Created by L on 2018/6/26.
//  Copyright © 2018年 L. All rights reserved.
//

#import "FUDemoBar.h"
#import "FUFilterView.h"
#import "FUSlider.h"
#import "FUBeautyView.h"
#import "FUFaceCollection.h"
#import "NSString+DemoBar.h"

#import "MJExtension.h"
#import "FUMakeupSupModel.h"


@interface FUDemoBar ()<FUFilterViewDelegate, FUBeautyViewDelegate, FUFaceCollectionDelegate,FUMakeUpViewDelegate>


@property (weak, nonatomic) IBOutlet UIButton *itemsBtn;
@property (weak, nonatomic) IBOutlet UIButton *skinBtn;
@property (weak, nonatomic) IBOutlet UIButton *shapeBtn;
@property (weak, nonatomic) IBOutlet UIButton *beautyFilterBtn;
@property (weak, nonatomic) IBOutlet UIButton *filterBtn;

// 上半部分
@property (weak, nonatomic) IBOutlet UIView *topView;
// 滤镜页
@property (weak, nonatomic) IBOutlet FUFilterView *filterView;
// 美颜滤镜页
@property (weak, nonatomic) IBOutlet FUFilterView *beautyFilterView;
// 滤镜程度
@property (copy, nonatomic) NSMutableDictionary<NSString *,NSNumber *> *filtersLevel;
@property (copy, nonatomic) NSMutableDictionary<NSString *,NSNumber *> *beautyFiltersLevel;
@property (weak, nonatomic) IBOutlet FUSlider *beautySlider;

// 美型页
@property (weak, nonatomic) IBOutlet FUBeautyView *shapeView;
// 美肤页
@property (weak, nonatomic) IBOutlet FUBeautyView *skinView;


// 脸型页
@property (weak, nonatomic) IBOutlet FUFaceCollection *faceCollection;
// 记录是否打开状态
@property (nonatomic, strong) NSMutableDictionary *openedDict ;

// 清晰磨皮数值_0 / 朦胧磨皮数值_1
@property (nonatomic, assign) double blurLevel_0;
@property (nonatomic, assign) double blurLevel_1;
@end

@implementation FUDemoBar

@synthesize blurLevel = _blurLevel ;
@synthesize selectedFilterLevel = _selectedFilterLevel ;

-(void)awakeFromNib {
    [super awakeFromNib];
    
    self.filterView.type = FUFilterViewTypeFilter ;
    self.filterView.mDelegate = self ;
    
    self.beautyFilterView.type = FUFilterViewTypeBeautyFilter ;
    self.beautyFilterView.mDelegate = self ;
    
    self.shapeView.type = FUBeautyViewTypeShape;
    self.shapeView.mDelegate = self ;
    
//    self.faceCollection.type = FUFaceCollectionTypeCommon;
    self.faceCollection.mDelegate = self;
    
    self.skinView.type = FUBeautyViewTypeSkin;
    self.skinView.mDelegate = self;
    
    NSString *wholePath=[[NSBundle mainBundle] pathForResource:@"makeup_whole" ofType:@"json"];
    NSData *wholeData=[[NSData alloc] initWithContentsOfFile:wholePath];
    NSDictionary *wholeDic=[NSJSONSerialization JSONObjectWithData:wholeData options:NSJSONReadingMutableContainers error:nil];
    NSArray *supArray = [FUMakeupSupModel mj_objectArrayWithKeyValuesArray:wholeDic[@"data1"]];
    _makeupView = [[FUMakeUpView alloc] initWithFrame:CGRectMake(0,-10, [UIScreen mainScreen].bounds.size.width, 160)];
    [_makeupView setDefaultSupItem:self.selMakeupIndex];
    _makeupView.delegate = self;
    [_makeupView setWholeArray:supArray];

    _makeupView.collectionLeadingLayoutConstraint.constant = 0;
    _makeupView.noitemBtn.hidden = YES;
    _makeupView.backgroundColor = [UIColor clearColor];
    [self.topView addSubview:_makeupView];
    
    [self.skinBtn setTitle:NSLocalizedString(@"美肤", nil) forState:UIControlStateNormal];
    [self.shapeBtn setTitle:NSLocalizedString(@"美型", nil) forState:UIControlStateNormal];
    [self.beautyFilterBtn setTitle:NSLocalizedString(@"滤镜", nil) forState:UIControlStateNormal];
    [self.filterBtn setTitle:NSLocalizedString(@"质感美颜", nil) forState:UIControlStateNormal];

}

-(void)layoutSubviews{
    [super layoutSubviews];
//    _makeupView.frame = self.topView.frame;
    
}

- (NSMutableDictionary<NSString *,NSNumber *> *)filtersLevel{
    if (!_filtersLevel) {
        _filtersLevel = [[NSMutableDictionary alloc] init];
    }
    return _filtersLevel;
}

-(NSMutableDictionary<NSString *,NSNumber *> *)beautyFiltersLevel {
    if (!_beautyFiltersLevel) {
        _beautyFiltersLevel = [[NSMutableDictionary alloc] init];
    }
    return _beautyFiltersLevel ;
}


-(NSMutableDictionary *)openedDict {
    if (!_openedDict) {
        _openedDict = [[NSMutableDictionary alloc] init];
    }
    return _openedDict ;
}

- (IBAction)bottomBtnsSelected:(UIButton *)sender {
    
    if (sender.selected) {
        sender.selected = NO ;
        [self hiddenTopViewWithAnimation:YES];
        return ;
    }
    
    self.itemsBtn.selected = sender == self.itemsBtn ;
    self.skinBtn.selected = sender == self.skinBtn ;
    self.shapeBtn.selected = sender == self.shapeBtn ;
    self.beautyFilterBtn.selected = sender == self.beautyFilterBtn ;
    self.filterBtn.selected = sender == self.filterBtn ;
    
    self.skinView.hidden = !self.skinBtn.selected ;
    self.shapeView.hidden = !self.shapeBtn.selected ;
    self.beautyFilterView.hidden = !self.beautyFilterBtn.selected ;
//    self.filterView.hidden = !self.filterBtn.selected ;
    _makeupView.hidden  = !self.filterBtn.selected;
    
     // 美型页面
    self.faceCollection.hidden = YES ;
    if (self.shapeBtn.selected) {
        
        NSInteger selectedIndex = self.shapeView.selectedIndex;
        if (selectedIndex < 0) {
            
            self.beautySlider.hidden = YES;
            self.faceCollection.hidden = YES ;
        }else {
            switch (selectedIndex) {
                case 0:{        // 脸型
                    self.faceCollection.hidden = NO ;
                }
                    break;
                case 1:{        // 大眼
                    self.beautySlider.type = self.faceShape == 4 ? FUFilterSliderTypeEyeLarge_new : FUFilterSliderTypeEyeLarge ;
                    self.beautySlider.value = self.faceShape == 4 ? self.enlargingLevel_new : self.enlargingLevel ;
                }
                    break;
                case 2:{        // 瘦脸
                    self.beautySlider.type = self.faceShape == 4 ? FUFilterSliderTypeThinFace_new : FUFilterSliderTypeThinFace ;
                    self.beautySlider.value = self.faceShape == 4 ? self.thinningLevel_new : self.thinningLevel ;
                }
                    break;
                case 3:{        // 下巴
                    self.beautySlider.type = FUFilterSliderTypeChin ;
                    self.beautySlider.value = self.chinLevel ;
                }
                    break;
                case 4:{        // 额头
                    self.beautySlider.type = FUFilterSliderTypeForehead ;
                    self.beautySlider.value = self.foreheadLevel ;
                }
                    break;
                case 5:{        // 鼻子
                    self.beautySlider.type = FUFilterSliderTypeNose ;
                    self.beautySlider.value = self.noseLevel ;
                }
                    break;
                case 6:{        // 嘴型
                    self.beautySlider.type = FUFilterSliderTypeMouth ;
                    self.beautySlider.value = self.mouthLevel ;
                }
                    break;
                    
                default:
                    break;
            }
            
            self.beautySlider.hidden = selectedIndex == 0 ;
        }
    }
    
    if (self.skinBtn.selected) {
        NSInteger selectedIndex = self.skinView.performance ? self.skinView.selectedIndex + 1 : self.skinView.selectedIndex;
        
        self.beautySlider.hidden = selectedIndex < 1 ;
        switch (selectedIndex) {
            case 1:{        //  磨皮
                self.beautySlider.type = FUFilterSliderTypeBlur ;
                self.beautySlider.value = _heavyBlur == 0 ? self.blurLevel_0 : self.blurLevel_1 ;
            }
                break;
            case 2:{        // 美白
                self.beautySlider.type = FUFilterSliderTypeColor ;
                self.beautySlider.value = self.colorLevel ;
            }
                break;
            case 3:{        // 红润
                self.beautySlider.type = FUFilterSliderTypeRed ;
                self.beautySlider.value = self.redLevel ;
            }
                break;
            case 4:{        // 亮眼
                self.beautySlider.type = FUFilterSliderTypeEyeLighting ;
                self.beautySlider.value = self.eyeBrightLevel ;
            }
                break;
            case 5:{        // 妹呀
                self.beautySlider.type = FUFilterSliderTypeToothWhiten ;
                self.beautySlider.value = self.toothWhitenLevel ;
            }
                break;
                
            default:
                break;
        }
    }
    
    // slider 是否显示
    if (self.beautyFilterBtn.selected) {
        
        NSInteger selectedIndex = self.beautyFilterView.selectedIndex ;
        self.beautySlider.type = FUFilterSliderTypeBeautyFilter ;
        self.beautySlider.hidden = selectedIndex < 0;
        if (selectedIndex >= 0) {
            
            float value = [self.beautyFiltersLevel[_selectedFilter] floatValue] ;
            self.beautySlider.value = value ;
        }
        
    }
    if (self.filterBtn.selected) {
        
        NSInteger selectedIndex = self.filterView.selectedIndex ;
        self.beautySlider.type = FUFilterSliderTypeFilter ;
        self.beautySlider.hidden = selectedIndex < 0;
        if (selectedIndex >= 0) {
            
            float value = [self.filtersLevel[_selectedFilter] floatValue] ;
            self.beautySlider.value = value ;
        }
    }
    
    
    [self showTopViewWithAnimation:self.topView.isHidden];
}

// 开启上半部分
- (void)showTopViewWithAnimation:(BOOL)animation {
    
    if (animation) {
        self.topView.alpha = 0.0 ;
        self.topView.transform = CGAffineTransformMakeTranslation(0, self.topView.frame.size.height / 2.0) ;
        self.topView.hidden = NO ;
        [UIView animateWithDuration:0.35 animations:^{
            self.topView.transform = CGAffineTransformIdentity ;
            self.topView.alpha = 1.0 ;
        }];
        
        if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(showTopView:)]) {
            [self.mDelegate showTopView:YES];
        }
    }else {
        self.topView.transform = CGAffineTransformIdentity ;
        self.topView.alpha = 1.0 ;
    }
}

// 关闭上半部分
-(void)hiddenTopViewWithAnimation:(BOOL)animation {
    
    if (self.topView.hidden) {
        return ;
    }
    if (animation) {
        self.topView.alpha = 1.0 ;
        self.topView.transform = CGAffineTransformIdentity ;
        self.topView.hidden = NO ;
        [UIView animateWithDuration:0.35 animations:^{
            self.topView.transform = CGAffineTransformMakeTranslation(0, self.topView.frame.size.height / 2.0) ;
            self.topView.alpha = 0.0 ;
        }completion:^(BOOL finished) {
            self.topView.hidden = YES ;
            self.topView.alpha = 1.0 ;
            self.topView.transform = CGAffineTransformIdentity ;
            
            self.itemsBtn.selected = NO ;
            self.skinBtn.selected = NO ;
            self.shapeBtn.selected = NO ;
            self.beautyFilterBtn.selected = NO ;
            self.filterBtn.selected = NO ;
        }];
        
        if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(showTopView:)]) {
            [self.mDelegate showTopView:NO];
        }
    }else {
        
        self.topView.hidden = YES ;
        self.topView.alpha = 1.0 ;
        self.topView.transform = CGAffineTransformIdentity ;
    }
}



#pragma mark ---- FUFilterViewDelegate
// 开启滤镜
- (void)filterViewDidSelectedFilter:(NSString *)filterName Type:(FUFilterViewType)type {
    
    if ([_selectedFilter isEqualToString:filterName] && ![_selectedFilter isEqualToString:@"origin"]) {
        return ;
    }
    _selectedFilter = filterName;
    
    NSArray *keys = type == FUFilterViewTypeFilter ? self.filtersLevel.allKeys : self.beautyFiltersLevel.allKeys;

    if (![keys containsObject:_selectedFilter]) {
        
        if (type == FUFilterViewTypeFilter) {
            self.filtersLevel[_selectedFilter] = @(1.0);
        }else {
            self.beautyFiltersLevel[_selectedFilter] = @(1.0);
        }
    }
    
    if (type == FUFilterViewTypeFilter) {
        self.beautyFilterView.selectedIndex = -1 ;
    }
    if (type == FUFilterViewTypeBeautyFilter) {
        self.filterView.selectedIndex = -1 ;
    }
    
    float value = type == FUFilterViewTypeFilter ? [self.filtersLevel[_selectedFilter] floatValue] : [self.beautyFiltersLevel[_selectedFilter] floatValue] ;
    
    self.beautySlider.type = type == FUFilterViewTypeFilter ? FUFilterSliderTypeFilter : FUFilterSliderTypeBeautyFilter;
    self.beautySlider.value = value ;
    if (self.beautySlider.isHidden) {
        self.beautySlider.hidden = NO ;
    }
    if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(beautyParamChanged)]) {
        [self.mDelegate beautyParamChanged];
    }
}

#pragma mark ---- FUBeautyViewDelegate
// 美型页点击
-(void)shapeViewDidSelectedIndex:(NSInteger)index {
    
    self.beautySlider.hidden = index == 0 ;
    self.faceCollection.hidden = YES ;
    
    switch (index) {
        case 0:{        //  脸型
            self.faceCollection.hidden = NO ;
        }
            break;
        case 1:{        //  大眼
            self.beautySlider.type = self.faceShape == 4 ? FUFilterSliderTypeEyeLarge_new : FUFilterSliderTypeEyeLarge ;
            self.beautySlider.value = self.faceShape == 4 ? self.enlargingLevel_new : self.enlargingLevel ;
        }
            break;
        case 2:{        //  瘦脸
            self.beautySlider.type = self.faceShape == 4 ? FUFilterSliderTypeThinFace_new : FUFilterSliderTypeThinFace ;
            
            self.beautySlider.value = self.faceShape == 4 ? self.thinningLevel_new : self.thinningLevel ;
        }
            break;
        case 3:{        //  下巴
            self.beautySlider.type = FUFilterSliderTypeChin ;
            self.beautySlider.value = self.chinLevel ;
        }
            break;
        case 4:{        //  额头
            self.beautySlider.type = FUFilterSliderTypeForehead ;
            self.beautySlider.value = self.foreheadLevel ;
        }
            break;
        case 5:{        //  👃
            self.beautySlider.type = FUFilterSliderTypeNose ;
            self.beautySlider.value = self.noseLevel ;
        }
            break;
        case 6:{        //  👄
            self.beautySlider.type = FUFilterSliderTypeMouth ;
            self.beautySlider.value = self.mouthLevel ;
        }
            break;
            
        default:
            break;
    }
}

// 美肤页点击
-(void)skinViewDidSelectedIndex:(NSInteger)index {
    self.beautySlider.hidden = index == 0 ;
    
    switch (index) {
        case 0:{        // 精准美肤
            self.skinDetect = !self.skinDetect ;
            if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(beautyParamChanged)]) {
                [self.mDelegate beautyParamChanged];
            }
        }
            break;
        case 1:{        // 清晰磨皮
            self.beautySlider.type = FUFilterSliderTypeBlur ;
            self.beautySlider.value = self.heavyBlur == 0 ? self.blurLevel_0 : self.blurLevel_1 ;
        }
            break;
        case 2:{        // 美白
            self.beautySlider.type = FUFilterSliderTypeColor ;
            self.beautySlider.value = self.colorLevel ;
        }
            break;
        case 3:{        // 红润
            self.beautySlider.type = FUFilterSliderTypeRed ;
            self.beautySlider.value = self.redLevel ;
        }
            break;
        case 4:{        // 亮眼
            self.beautySlider.type = FUFilterSliderTypeEyeLighting ;
            self.beautySlider.value = self.eyeBrightLevel ;
        }
            break;
        case 5:{        // 妹呀
            self.beautySlider.type = FUFilterSliderTypeToothWhiten ;
            self.beautySlider.value = self.toothWhitenLevel ;
        }
            break;
            
        default:
            break;
    }
}

// skin detect 改变
-(void)skinDetectChanged:(BOOL)detect {
    _skinDetect = detect ;
    
    self.beautySlider.hidden = YES ;
    if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(beautyParamChanged)]) {
        [self.mDelegate beautyParamChanged];
    }
    
    if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(showMessage:)]) {
        NSString *message = detect ? [@"精准美肤 开启" LocalizableString] : [@"精准美肤 关闭" LocalizableString] ;
        [self.mDelegate showMessage:message];
    }
}

// 清晰磨皮 朦胧磨皮切换
- (void)heavyBlurChange:(NSInteger)heavyBlur {
    _heavyBlur = heavyBlur ;
    if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(beautyParamChanged)]) {
        [self.mDelegate beautyParamChanged];
    }
    if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(showMessage:)]) {
        [self.mDelegate showMessage:heavyBlur == 0 ? [@"当前为清晰磨皮模式" LocalizableString] : [@"当前为朦胧磨皮模式" LocalizableString] ];
    }
    
    self.beautySlider.type = FUFilterSliderTypeToothWhiten ;
    self.beautySlider.value = self.heavyBlur == 0 ? _blurLevel_0 : _blurLevel_1 ;
}

// 滑条滑动
- (IBAction)filterSliderValueChange:(FUSlider *)sender {
    
    switch (sender.type) {
            
            // 滤镜程度改变
        case FUFilterSliderTypeFilter:{     // 滤镜程度
            if (_selectedFilter) {
                
                if ([self.filtersLevel.allKeys containsObject:_selectedFilter]) {
                    self.filtersLevel[_selectedFilter] = @(sender.value);
                }
            }
            if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(filterValueChange:)]) {
                [self.mDelegate filterValueChange:sender.value];
            }
        }
            break;
        case FUFilterSliderTypeBeautyFilter: {      // 美颜滤镜
            if (_selectedFilter) {
                
                if ([self.beautyFiltersLevel.allKeys containsObject:_selectedFilter]) {
                    self.beautyFiltersLevel[_selectedFilter] = @(sender.value) ;
                }
            }
            if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(filterValueChange:)]) {
                [self.mDelegate filterValueChange:sender.value];
            }
        }
            break;
        case FUFilterSliderTypeBlur: {      // 磨皮
            if (self.heavyBlur == 0) {
                
                self.blurLevel_0 = sender.value ; // 清晰磨皮
            }else {
                
                self.blurLevel_1 = sender.value ; // 朦胧磨皮
            }
            break;
        }
        case FUFilterSliderTypeColor: {      // 美白
            self.colorLevel = sender.value ;
            break;
        }
        case FUFilterSliderTypeRed: {      // 红润
            self.redLevel = sender.value ;
            break;
        }
        case FUFilterSliderTypeEyeLighting: {      // 亮眼
            self.eyeBrightLevel = sender.value ;
            break;
        }
        case FUFilterSliderTypeToothWhiten: {      // 妹呀
            self.toothWhitenLevel = sender.value ;
            break;
        }
        case FUFilterSliderTypeEyeLarge:{   // 大眼
            self.enlargingLevel = sender.value ;
        }
            break ;
        case FUFilterSliderTypeThinFace:{   // 瘦脸
            self.thinningLevel = sender.value ;
        }
            break ;
        case FUFilterSliderTypeEyeLarge_new:{   // 大眼——新版
            self.enlargingLevel_new = sender.value ;
        }
            break ;
        case FUFilterSliderTypeThinFace_new:{   // 大眼——新版
            self.thinningLevel_new = sender.value ;
        }
            break ;
        case FUFilterSliderTypeChin:{   // 下巴
            self.chinLevel = sender.value ;
        }
            break ;
        case FUFilterSliderTypeForehead:{   // 额头
            self.foreheadLevel = sender.value ;
        }
            break ;
        case FUFilterSliderTypeNose:{   // 鼻子
            self.noseLevel = sender.value ;
        }
            break ;
        case FUFilterSliderTypeMouth:{   // 嘴型
            self.mouthLevel = sender.value ;
        }
            break ;
    }
    
    if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(beautyParamChanged)]) {
        [self.mDelegate beautyParamChanged];
    }
}

#pragma mark --- FUFaceCollectionDelegate

-(void)didSelectedFaceType:(NSInteger)index {
    NSInteger faceShape = 0 ;
    
    switch (index) {
        case 0:{        // 自定义
            faceShape = 4 ;
        }
            break;
        case 1:{        // 默认
            faceShape = 3 ;
        }
            break;
        case 2:{        // 女神
            faceShape = 0 ;
        }
            break;
        case 3:{        // 网红
            faceShape = 1 ;
        }
            break;
        case 4:{        // 自然
            faceShape = 2 ;
        }
            break;
            
        default:
            break;
    }
    if (_faceShape == faceShape) {
        return ;
    }
    
    _faceShape = faceShape ;
    self.shapeView.faceShape = faceShape ;
    if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(beautyParamChanged)]) {
        [self.mDelegate beautyParamChanged];
    }
}

#pragma mark --- setter

-(void)setSelMakeupIndex:(int)selMakeupIndex{
    _selMakeupIndex = selMakeupIndex;
    [_makeupView setDefaultSupItem:selMakeupIndex];
}


/** 精准美肤 (0、1)    */
-(void)setSkinDetect:(BOOL)skinDetect {
    _skinDetect = skinDetect ;
    self.skinView.skinDetect = skinDetect ;
    
    BOOL current = skinDetect ;
    BOOL selected = [[self.openedDict objectForKey:@"skinDetect"] boolValue];
    
    if (current != selected) {
        
        [_openedDict setObject:@(current) forKey:@"skinDetect"];
        self.skinView.openedDict = _openedDict ;
    }
}

-(void)setHeavyBlur:(NSInteger)heavyBlur {
    _heavyBlur = heavyBlur ;
    
    if (_heavyBlur == 0) {
        
        _blurLevel_0 = self.blurLevel ;
        
        BOOL current = _blurLevel > 0.0 ;
        BOOL selected = [[self.openedDict objectForKey:@"blurLevel_0"] boolValue];
        
        if (current != selected) {
            
            [_openedDict setObject:@(current) forKey:@"blurLevel_0"];
            self.skinView.openedDict = _openedDict ;
        }
        
    }else if (_heavyBlur == 1){
        
        _blurLevel_1 = self.blurLevel ;
        
        BOOL current = _blurLevel > 0.0 ;
        BOOL selected = [[self.openedDict objectForKey:@"blurLevel_1"] boolValue];
        
        if (current != selected) {
            
            [_openedDict setObject:@(current) forKey:@"blurLevel_1"];
            self.skinView.openedDict = _openedDict ;
        }
    }
    
    self.skinView.heavyBlur = heavyBlur ;
}

-(void)setBlurLevel:(double)blurLevel {
    _blurLevel = blurLevel ;
    
    
    if (self.heavyBlur == 0) {
        
        _blurLevel_0 = blurLevel ;
        
        BOOL current = blurLevel > 0.0 ;
        BOOL selected = [[self.openedDict objectForKey:@"blurLevel_0"] boolValue];
        
        if (current != selected) {
            
            [_openedDict setObject:@(current) forKey:@"blurLevel_0"];
            self.skinView.openedDict = _openedDict ;
        }
        
    }else if (self.heavyBlur == 1){
        
        _blurLevel_1 = blurLevel ;
        
        BOOL current = blurLevel > 0.0 ;
        BOOL selected = [[self.openedDict objectForKey:@"blurLevel_1"] boolValue];
        
        if (current != selected) {
            
            [_openedDict setObject:@(current) forKey:@"blurLevel_1"];
            self.skinView.openedDict = _openedDict ;
        }
    }
}

-(double)blurLevel {
    return self.heavyBlur == 0 ? _blurLevel_0 : _blurLevel_1 ;
}


-(void)setBlurLevel_0:(double)blurLevel_0 {
    _blurLevel_0 = blurLevel_0 ;
    
    BOOL current = blurLevel_0 > 0.0 ;
    BOOL selected = [[self.openedDict objectForKey:@"blurLevel_0"] boolValue];
    
    if (current != selected) {
        
        [_openedDict setObject:@(current) forKey:@"blurLevel_0"];
        self.skinView.openedDict = _openedDict ;
        
//        if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(showMessage:)]) {
//            [self.mDelegate showMessage:current ? @"清晰磨皮开启" : @"清晰磨皮关闭"];
//        }
    }
}

-(void)setBlurLevel_1:(double)blurLevel_1 {
    _blurLevel_1 = blurLevel_1 ;
    
    BOOL current = blurLevel_1 > 0.0 ;
    BOOL selected = [[self.openedDict objectForKey:@"blurLevel_1"] boolValue];
    
    if (current != selected) {
        
        [_openedDict setObject:@(current) forKey:@"blurLevel_1"];
        self.skinView.openedDict = _openedDict ;
        
//        if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(showMessage:)]) {
//            [self.mDelegate showMessage:current ? @"朦胧磨皮开启" : @"朦胧磨皮关闭"];
//        }
    }
}

-(void)setColorLevel:(double)colorLevel {
    _colorLevel = colorLevel ;
    
    BOOL current = colorLevel > 0.0 ;
    BOOL selected = [[self.openedDict objectForKey:@"colorLevel"] boolValue];
    
    if (current != selected) {
        
        [_openedDict setObject:@(current) forKey:@"colorLevel"];
        self.skinView.openedDict = _openedDict ;
        
//        if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(showMessage:)]) {
//            [self.mDelegate showMessage:current ? @"美白开启" : @"美白关闭"];
//        }
    }
}

-(void)setRedLevel:(double)redLevel {
    _redLevel = redLevel ;
    
    BOOL current = redLevel > 0.0 ;
    BOOL selected = [[self.openedDict objectForKey:@"redLevel"] boolValue];
    
    if (current != selected) {
        
        [_openedDict setObject:@(current) forKey:@"redLevel"];
        self.skinView.openedDict = _openedDict ;
        
//        if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(showMessage:)]) {
//            [self.mDelegate showMessage:current ? @"红润开启" : @"红润关闭"];
//        }
    }
}

-(void)setEyeBrightLevel:(double)eyeBrightLevel {
    _eyeBrightLevel = eyeBrightLevel ;
    
    BOOL current = eyeBrightLevel > 0.0 ;
    BOOL selected = [[self.openedDict objectForKey:@"eyeBrightLevel"] boolValue];
    
    if (current != selected) {
        
        [_openedDict setObject:@(current) forKey:@"eyeBrightLevel"];
        self.skinView.openedDict = _openedDict ;
        
//        if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(showMessage:)]) {
//            [self.mDelegate showMessage:current ? @"亮眼开启" : @"亮眼关闭"];
//        }
    }
}

-(void)setToothWhitenLevel:(double)toothWhitenLevel{
    _toothWhitenLevel = toothWhitenLevel ;
    
    BOOL current = toothWhitenLevel > 0.0 ;
    BOOL selected = [[self.openedDict objectForKey:@"toothWhitenLevel"] boolValue];
    
    if (current != selected) {
        
        [_openedDict setObject:@(current) forKey:@"toothWhitenLevel"];
        self.skinView.openedDict = _openedDict ;
        
//        if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(showMessage:)]) {
//            [self.mDelegate showMessage:current ? @"美牙开启" : @"美牙关闭"];
//        }
    }
}

/**     美型参数    **/
-(void)setFaceShape:(NSInteger)faceShape {
    _faceShape = faceShape ;
    
    NSInteger selectedIndex = 0 ;
    switch (faceShape) {
        case 0:{        // 女神
            selectedIndex = _performance ? 1 : 2 ;
        }
            break;
        case 1:{        // 网红
            selectedIndex = _performance ? 2 : 3 ;
        }
            break;
        case 2:{        // 自然
            selectedIndex = _performance ? 3 : 4 ;
        }
            break;
        case 3:{        // 默认
            selectedIndex = _performance ? 0 : 1 ;
        }
            break;
        case 4:{        // 自定义
            selectedIndex = 0 ;
        }
            break;
            
        default:
            break;
    }
    
    self.shapeView.faceShape = faceShape ;
    self.faceCollection.selectedIndex = selectedIndex ;
}

// 大眼
-(void)setEnlargingLevel:(double)enlargingLevel {
    _enlargingLevel = enlargingLevel ;
    
    BOOL current = enlargingLevel > 0.0 ;
    BOOL selected = [[self.openedDict objectForKey:@"enlargingLevel"] boolValue];
    
    if (current != selected) {
        
        [_openedDict setObject:@(current) forKey:@"enlargingLevel"];
        self.shapeView.openedDict = _openedDict ;
        
//        if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(showMessage:)]) {
//            [self.mDelegate showMessage:current ? @"大眼开启" : @"大眼关闭"];
//        }
    }
}

// 瘦脸
-(void)setThinningLevel:(double)thinningLevel {
    _thinningLevel = thinningLevel ;
    
    BOOL current = thinningLevel > 0.0 ;
    BOOL selected = [[self.openedDict objectForKey:@"thinningLevel"] boolValue];
    
    if (current != selected) {
        
        [_openedDict setObject:@(current) forKey:@"thinningLevel"];
        self.shapeView.openedDict = _openedDict ;
        
//        if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(showMessage:)]) {
//            [self.mDelegate showMessage:current ? @"瘦脸开启" : @"瘦脸关闭"];
//        }
    }
}

// 大眼新版
-(void)setEnlargingLevel_new:(double)enlargingLevel_new {
    _enlargingLevel_new = enlargingLevel_new ;
    
    BOOL current = enlargingLevel_new > 0.0 ;
    BOOL selected = [[self.openedDict objectForKey:@"enlargingLevel_new"] boolValue];
    
    if (current != selected) {
        
        [_openedDict setObject:@(current) forKey:@"enlargingLevel_new"];
        self.shapeView.openedDict = _openedDict ;
        
//        if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(showMessage:)]) {
//            [self.mDelegate showMessage:current ? @"大眼开启" : @"大眼关闭"];
//        }
    }
}

// 瘦脸新版
-(void)setThinningLevel_new:(double)thinningLevel_new {
    _thinningLevel_new = thinningLevel_new ;
    
    BOOL current = thinningLevel_new > 0.0 ;
    BOOL selected = [[self.openedDict objectForKey:@"thinningLevel_new"] boolValue];
    
    if (current != selected) {
        
        [_openedDict setObject:@(current) forKey:@"thinningLevel_new"];
        self.shapeView.openedDict = _openedDict ;
        
//        if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(showMessage:)]) {
//            [self.mDelegate showMessage:current ? @"瘦脸开启" : @"瘦脸关闭"];
//        }
    }
}

// 下巴
-(void)setChinLevel:(double)chinLevel {
    _chinLevel = chinLevel ;
    
    // 给个范围，不然显示不出来
    double d = chinLevel - 0.5 ;
    
    BOOL current = d < -0.05 || d > 0.05 ;
    BOOL selected = [[self.openedDict objectForKey:@"chinLevel"] boolValue];
    
    if (current != selected) {
        
        [_openedDict setObject:@(current) forKey:@"chinLevel"];
        self.shapeView.openedDict = _openedDict ;
        
//        if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(showMessage:)]) {
//            [self.mDelegate showMessage:current ? @"下巴开启" : @"下巴关闭"];
//        }
    }
}

// 额头
-(void)setForeheadLevel:(double)foreheadLevel {
    _foreheadLevel = foreheadLevel ;
    
    // 给个范围，不然显示不出来
    double d = foreheadLevel - 0.5 ;
    
    BOOL current = d < -0.05 || d > 0.05 ;
    BOOL selected = [[self.openedDict objectForKey:@"foreheadLevel"] boolValue];
    
    if (current != selected) {
        
        [_openedDict setObject:@(current) forKey:@"foreheadLevel"];
        self.shapeView.openedDict = _openedDict ;
        
//        if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(showMessage:)]) {
//            [self.mDelegate showMessage:current ? @"额头开启" : @"额头关闭"];
//        }
    }
}

// 鼻子
-(void)setNoseLevel:(double)noseLevel {
    _noseLevel = noseLevel ;
    
    BOOL current = noseLevel > 0.0 ;
    BOOL selected = [[self.openedDict objectForKey:@"noseLevel"] boolValue];
    
    if (current != selected) {
        
        [_openedDict setObject:@(current) forKey:@"noseLevel"];
        self.shapeView.openedDict = _openedDict ;
        
//        if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(showMessage:)]) {
//            [self.mDelegate showMessage:current ? @"瘦鼻开启" : @"瘦鼻关闭"];
//        }
    }
}

// 嘴型
-(void)setMouthLevel:(double)mouthLevel {
    _mouthLevel = mouthLevel ;
    
    // 给个范围，不然显示不出来
    double d = mouthLevel - 0.5 ;
    
    BOOL current = d < -0.05 || d > 0.05 ;
    BOOL selected = [[self.openedDict objectForKey:@"mouthLevel"] boolValue];
    
    if (current != selected) {
        
        [_openedDict setObject:@(current) forKey:@"mouthLevel"];
        self.shapeView.openedDict = _openedDict ;
        
//        if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(showMessage:)]) {
//            [self.mDelegate showMessage:current ? @"嘴型开启" : @"嘴型关闭"];
//        }
    }
}


// 滤镜
-(void)setFiltersDataSource:(NSArray<NSString *> *)filtersDataSource {
    _filtersDataSource = filtersDataSource ;
    self.filterView.filterDataSource = filtersDataSource.count > 0 ? self.filtersDataSource:@[@"origin", @"delta", @"electric", @"slowlived", @"tokyo", @"warm"];
    if ([self.filterView.filterDataSource containsObject:_selectedFilter]) {
        self.filterView.selectedIndex = [self.filterView.filterDataSource indexOfObject:_selectedFilter];
    }else{
        self.filterView.selectedIndex = -1;
    }
    
    if (filtersDataSource.count > 0) {
        for (NSString *filter in filtersDataSource) {
            self.filtersLevel[filter] = @(1.0);
        }
    }
}

// 美颜滤镜
-(void)setBeautyFiltersDataSource:(NSArray<NSString *> *)beautyFiltersDataSource {
    _beautyFiltersDataSource = beautyFiltersDataSource ;
    self.beautyFilterView.filterDataSource = beautyFiltersDataSource.count >0 ? beautyFiltersDataSource:@[@"origin", @"qingxin", @"fennen", @"ziran", @"hongrun"];
    
    if ([self.beautyFilterView.filterDataSource containsObject:_selectedFilter]) {
        self.beautyFilterView.selectedIndex = [self.beautyFilterView.filterDataSource indexOfObject:_selectedFilter];
    }else{
        self.beautyFilterView.selectedIndex = -1;
    }
    
    if (beautyFiltersDataSource.count > 0) {
        for (NSString *filter in beautyFiltersDataSource) {
            self.beautyFiltersLevel[filter] = @(0.7);
        }
    }
}
// 滤镜中文
-(void)setFiltersCHName:(NSDictionary<NSString *,NSString *> *)filtersCHName {
    _filtersCHName = filtersCHName ;
//    self.filterView.filtersCHName = filtersCHName ;
    self.beautyFilterView.filtersCHName = filtersCHName ;
}
// 选择的滤镜
-(void)setSelectedFilter:(NSString *)selectedFilter {
    _selectedFilter = selectedFilter ;
    
    if ([self.filtersDataSource containsObject:selectedFilter]) {
        self.filterView.selectedIndex = [self.filtersDataSource indexOfObject:selectedFilter];
        self.beautyFilterView.selectedIndex = -1 ;
        
        NSArray *keys = self.filtersLevel.allKeys;
        if (![keys containsObject:_selectedFilter]) {
            self.filtersLevel[_selectedFilter] = @(1.0);
        }
        self.beautySlider.value = self.filtersLevel[_selectedFilter].doubleValue;
        
    }else{
        self.filterView.selectedIndex = -1;
    }
    
    if ([self.beautyFiltersDataSource containsObject:selectedFilter]) {
        self.beautyFilterView.selectedIndex = [self.beautyFilterView.filterDataSource indexOfObject:selectedFilter];
        self.filterView.selectedIndex = -1;
        
        NSArray *keys = self.beautyFiltersLevel.allKeys;
        if (![keys containsObject:_selectedFilter]) {
            self.beautyFiltersLevel[_selectedFilter] = @(1.0);
        }
        self.beautySlider.value = self.beautyFiltersLevel[_selectedFilter].doubleValue;
        
    }else{
        self.beautyFilterView.selectedIndex = -1;
    }
    
}

- (double)selectedFilterLevel {
    if (!_selectedFilter) {
        return 1.0;
    }
    NSArray *keys0 = self.filtersLevel.allKeys;
    NSArray *keys1 = self.beautyFiltersLevel.allKeys;
    double value = 0.0 ;
    if (![keys0 containsObject:_selectedFilter] && ![keys1 containsObject:_selectedFilter]) {
        value = 0.0 ;
    }else {
        if ([keys0 containsObject:_selectedFilter]) {
            value = [self.filtersLevel[_selectedFilter] doubleValue] ;
        }
        
        if ([keys1 containsObject:_selectedFilter]) {
            value = [self.beautyFiltersLevel[_selectedFilter] doubleValue] ;
        }
    }
    return value;
}
-(void)setSelectedFilterLevel:(double)selectedFilterLevel {
    _selectedFilterLevel = selectedFilterLevel ;
    if (_selectedFilter) {
        NSArray *keys0 = self.filtersLevel.allKeys;
        NSArray *keys1 = self.beautyFiltersLevel.allKeys;
        if ([keys0 containsObject:_selectedFilter]) {
            self.filtersLevel[_selectedFilter] = @(selectedFilterLevel) ;
        }
        if ([keys1 containsObject:_selectedFilter]) {
            self.beautyFiltersLevel[_selectedFilter] = @(selectedFilterLevel) ;
        }
    }
}



-(void)setPerformance:(BOOL)performance {
    _performance = performance ;
    
    self.skinView.performance = performance ;
    self.shapeView.performance = performance ;
    self.faceCollection.performance = performance ;
    
    self.faceShape = performance ? 3 : 4 ;
    
    self.heavyBlur = performance ? 1 : 0 ;
    
    self.beautySlider.hidden = YES;
    self.faceCollection.hidden = YES ;
    
    if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(beautyParamChanged)]) {
        [self.mDelegate beautyParamChanged];
    }
}

-(BOOL)isTopViewShow {
    return !self.topView.hidden ;
}

@end
