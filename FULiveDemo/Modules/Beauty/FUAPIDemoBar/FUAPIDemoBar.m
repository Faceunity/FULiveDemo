//
//  FUAPIDemoBar.m
//  FUAPIDemoBar
//
//  Created by L on 2018/6/26.
//  Copyright © 2018年 L. All rights reserved.
//

#import "FUAPIDemoBar.h"


@interface FUAPIDemoBar ()<FUDemoBarDelegate>

@end

//
@implementation FUAPIDemoBar

@synthesize skinDetect = _skinDetect ;
@synthesize blurType = _blurType ;
//@synthesize blurLevel = _blurLevel ;
@synthesize blurLevel_0 = _blurLevel_0 ;
@synthesize blurLevel_1 = _blurLevel_1 ;
@synthesize blurLevel_2 = _blurLevel_2 ;

@synthesize colorLevel = _colorLevel ;
@synthesize redLevel = _redLevel ;
@synthesize eyeBrightLevel = _eyeBrightLevel ;
@synthesize toothWhitenLevel = _toothWhitenLevel ;


@synthesize vLevel = _vLevel ;
@synthesize eggLevel = _eggLevel ;
@synthesize narrowLevel = _narrowLevel ;
@synthesize smallLevel = _smallLevel ;
//@synthesize faceShape = _faceShape ;
@synthesize enlargingLevel = _enlargingLevel ;
@synthesize thinningLevel = _thinningLevel ;
//@synthesize enlargingLevel_new = _enlargingLevel_new ;
//@synthesize thinningLevel_new = _thinningLevel_new ;
@synthesize chinLevel = _chinLevel ;
@synthesize foreheadLevel = _foreheadLevel ;
@synthesize noseLevel = _noseLevel ;
@synthesize mouthLevel = _mouthLevel ;


@synthesize filtersDataSource = _filtersDataSource ;
@synthesize beautyFiltersDataSource = _beautyFiltersDataSource ;
@synthesize filtersCHName = _filtersCHName ;
@synthesize selectedFilter = _selectedFilter ;
@synthesize selectedFilterLevel = _selectedFilterLevel ;

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        NSBundle *bundle = [NSBundle bundleForClass:[FUDemoBar class]];
        self.demoBar = (FUDemoBar *)[bundle loadNibNamed:@"FUDemoBar" owner:self options:nil].firstObject;
        self.demoBar.frame = self.bounds ;
        self.demoBar.mDelegate = self ;
        [self addSubview:self.demoBar];
        
        _demoBar.skinDetect = self.skinDetect;
        _demoBar.blurType = self.blurType ;
//        _demoBar.blurLevel = self.blurLevel ;
        _demoBar.blurLevel_0 = self.blurLevel_0;
        _demoBar.blurLevel_1 = self.blurLevel_1;
        _demoBar.blurLevel_2 = self.blurLevel_2;
        _demoBar.colorLevel = self.colorLevel ;
        _demoBar.redLevel = self.redLevel;
        _demoBar.eyeBrightLevel = self.eyeBrightLevel;
        _demoBar.toothWhitenLevel = self.toothWhitenLevel ;
        
        
        _demoBar.vLevel = self.vLevel ;
        _demoBar.eggLevel = self.eggLevel ;
        _demoBar.narrowLevel = self.narrowLevel ;
        _demoBar.smallLevel = self.smallLevel ;
//        _demoBar.faceShape = self.faceShape ;
        _demoBar.enlargingLevel = self.enlargingLevel ;
        _demoBar.thinningLevel = self.thinningLevel ;
//        _demoBar.enlargingLevel_new = self.enlargingLevel_new ;
//        _demoBar.thinningLevel_new = self.thinningLevel_new ;
        _demoBar.chinLevel = self.chinLevel ;
        _demoBar.foreheadLevel = self.foreheadLevel ;
        _demoBar.noseLevel = self.noseLevel ;
        _demoBar.mouthLevel = self.mouthLevel ;
        
        _demoBar.filtersDataSource = _filtersDataSource ;
        _demoBar.beautyFiltersDataSource = _beautyFiltersDataSource ;
        _demoBar.filtersCHName = _filtersCHName ;
    }
    return self ;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {self.backgroundColor = [UIColor clearColor];
        
        NSBundle *bundle = [NSBundle bundleForClass:[FUDemoBar class]];
        self.demoBar = (FUDemoBar *)[bundle loadNibNamed:@"FUDemoBar" owner:self options:nil].firstObject;
        self.demoBar.frame = self.bounds ;
        self.demoBar.mDelegate = self ;
        [self addSubview:self.demoBar];
        
        _demoBar.skinDetect = self.skinDetect;
        _demoBar.blurType = self.blurType ;
        _demoBar.blurLevel_0 = self.blurLevel_0;
        _demoBar.blurLevel_1 = self.blurLevel_1;
        _demoBar.blurLevel_2 = self.blurLevel_2;
        _demoBar.colorLevel = self.colorLevel ;
        _demoBar.redLevel = self.redLevel;
        _demoBar.eyeBrightLevel = self.eyeBrightLevel;
        _demoBar.toothWhitenLevel = self.toothWhitenLevel ;
        
        
        _demoBar.vLevel = self.vLevel ;
        _demoBar.eggLevel = self.eggLevel ;
        _demoBar.narrowLevel = self.narrowLevel ;
        _demoBar.smallLevel = self.smallLevel ;
        
//        _demoBar.faceShape = self.faceShape ;
        _demoBar.enlargingLevel = self.enlargingLevel ;
        _demoBar.thinningLevel = self.thinningLevel ;
//        _demoBar.enlargingLevel_new = self.enlargingLevel_new ;
//        _demoBar.thinningLevel_new = self.thinningLevel_new ;
        _demoBar.chinLevel = self.chinLevel ;
        _demoBar.foreheadLevel = self.foreheadLevel ;
        _demoBar.noseLevel = self.noseLevel ;
        _demoBar.mouthLevel = self.mouthLevel ;
        
        _demoBar.filtersDataSource = _filtersDataSource ;
        _demoBar.beautyFiltersDataSource = _beautyFiltersDataSource ;
        _demoBar.filtersCHName = _filtersCHName ;
    }
    return self ;
}

// 隐藏上半部分
- (void)hiddeTopView {
    [self.demoBar hiddenTopViewWithAnimation:YES];
}

#pragma mark ---- FUDemoBarDelegate

-(void)showMessage:(NSString *)message {
    if (self.delegate && [self.delegate respondsToSelector:@selector(demoBarShouldShowMessage:)]) {
        [self.delegate demoBarShouldShowMessage:message];
    }
}

-(void)showTopView:(BOOL)shown {
    if (self.delegate && [self.delegate respondsToSelector:@selector(demoBarDidShowTopView:)]) {
        [self.delegate demoBarDidShowTopView:shown];
    }
}

// 精准美肤
-(void)setSkinDetect:(BOOL)skinDetect {
    _skinDetect = skinDetect ;
    self.demoBar.skinDetect = skinDetect ;
}
-(BOOL)skinDetect {
    
    return self.demoBar.skinDetect ;
}

// 美肤类型
-(void)setBlurType:(NSInteger)blurType {
    _blurType = blurType ;
    self.demoBar.blurType = blurType ;
}
-(NSInteger)blurType {
    return self.demoBar.blurType ;
}

// 磨皮
//-(void)setBlurLevel:(double)blurLevel {
//    _blurLevel = blurLevel ;
//    self.demoBar.blurLevel = blurLevel ;
//}
//-(double)blurLevel {
//    return self.demoBar.blurLevel ;
//}

-(void)setBlurLevel_0:(double)blurLevel_0{
    _blurLevel_0 = blurLevel_0 ;
    self.demoBar.blurLevel_0 = blurLevel_0 ;
}
-(double)blurLevel_0{
    return self.demoBar.blurLevel_0;
}

-(void)setBlurLevel_1:(double)blurLevel_1{
    _blurLevel_1 = blurLevel_1 ;
    self.demoBar.blurLevel_1 = blurLevel_1 ;
}
-(double)blurLevel_1{
    return self.demoBar.blurLevel_1;
}

-(void)setBlurLevel_2:(double)blurLevel_2{
    _blurLevel_2 = blurLevel_2 ;
    self.demoBar.blurLevel_2 = blurLevel_2 ;
}
-(double)blurLevel_2{
    return self.demoBar.blurLevel_2;
}

// 美白
-(void)setColorLevel:(double)colorLevel {
    _colorLevel = colorLevel ;
    self.demoBar.colorLevel = colorLevel ;
}
-(double)colorLevel {
    return self.demoBar.colorLevel ;
}

// 红润
-(void)setRedLevel:(double)redLevel {
    _redLevel = redLevel ;
    self.demoBar.redLevel = redLevel ;
}
-(double)redLevel {
    return self.demoBar.redLevel ;
}

// 亮眼
-(void)setEyeBrightLevel:(double)eyeBrightLevel {
    _eyeBrightLevel = eyeBrightLevel ;
    self.demoBar.eyeBrightLevel = eyeBrightLevel ;
}
-(double)eyeBrightLevel {
    return self.demoBar.eyeBrightLevel ;
}

// 没牙
-(void)setToothWhitenLevel:(double)toothWhitenLevel {
    _toothWhitenLevel = toothWhitenLevel ;
    self.demoBar.toothWhitenLevel = toothWhitenLevel ;
}
-(double)toothWhitenLevel {
    return self.demoBar.toothWhitenLevel ;
}

-(void)setVLevel:(double)vLevel{
    _vLevel = vLevel;
    self.demoBar.vLevel = vLevel;
}
-(double)vLevel{
    return self.demoBar.vLevel
    ;
}
-(void)setEggLevel:(double)eggLevel{
    _eggLevel = eggLevel;
    self.demoBar.eggLevel = eggLevel;
}
-(double)eggLevel{
    return self.demoBar.eggLevel;
}

-(void)setNarrowLevel:(double)narrowLevel{
    _narrowLevel = narrowLevel;
    self.demoBar.narrowLevel = narrowLevel;
}
-(double)narrowLevel{
    return self.demoBar.narrowLevel;
}

-(void)setSmallLevel:(double)smallLevel{
    _smallLevel = smallLevel;
    self.demoBar.smallLevel = smallLevel;
}
-(double)smallLevel{
    return self.demoBar.smallLevel;
}

// 脸型
//-(void)setFaceShape:(NSInteger)faceShape {
//    _faceShape = faceShape ;
//    self.demoBar.faceShape = faceShape ;
//}
//-(NSInteger)faceShape {
//    return self.demoBar.faceShape ;
//}

// 大眼
-(void)setEnlargingLevel:(double)enlargingLevel {
    _enlargingLevel = enlargingLevel ;
    self.demoBar.enlargingLevel = enlargingLevel ;
}
-(double)enlargingLevel {
    return self.demoBar.enlargingLevel ;
}

// 瘦脸
-(void)setThinningLevel:(double)thinningLevel {
    _thinningLevel = thinningLevel ;
    self.demoBar.thinningLevel = thinningLevel ;
}
-(double)thinningLevel {
    return self.demoBar.thinningLevel ;
}

// 大眼新版
//-(void)setEnlargingLevel_new:(double)enlargingLevel_new {
//    _enlargingLevel_new = enlargingLevel_new ;
//    self.demoBar.enlargingLevel_new = enlargingLevel_new ;
//}
//-(double)enlargingLevel_new {
//    return self.demoBar.enlargingLevel_new ;
//}

// 瘦脸新版
//-(void)setThinningLevel_new:(double)thinningLevel_new {
//    _thinningLevel_new = thinningLevel_new ;
//    self.demoBar.thinningLevel_new = thinningLevel_new ;
//}
//-(double)thinningLevel_new {
//    return self.demoBar.thinningLevel_new ;
//}

// 下巴
-(void)setChinLevel:(double)chinLevel {
    _chinLevel = chinLevel ;
    self.demoBar.chinLevel = chinLevel ;
}
-(double)chinLevel {
    return self.demoBar.chinLevel ;
}

// 额头
-(void)setForeheadLevel:(double)foreheadLevel {
    _foreheadLevel = foreheadLevel;
    self.demoBar.foreheadLevel = foreheadLevel ;
}
-(double)foreheadLevel {
    return self.demoBar.foreheadLevel ;
}

// 鼻子
-(void)setNoseLevel:(double)noseLevel {
    _noseLevel = noseLevel;
    self.demoBar.noseLevel = noseLevel ;
}
-(double)noseLevel {
    return self.demoBar.noseLevel;
}

// 嘴型
-(void)setMouthLevel:(double)mouthLevel {
    _mouthLevel = mouthLevel ;
    self.demoBar.mouthLevel = mouthLevel ;
}
-(double)mouthLevel {
    return self.demoBar.mouthLevel ;
}

// 美颜参数改变
- (void)beautyParamChanged {
    if (self.delegate && [self.delegate respondsToSelector:@selector(demoBarBeautyParamChanged)]) {
        [self.delegate demoBarBeautyParamChanged];
    }
}

-(void)restDefaultValue:(int)type{
    if (self.delegate && [self.delegate respondsToSelector:@selector(restDefaultValue:)]) {
        [self.delegate restDefaultValue:type];
    }
}

// 滤镜程度改变
- (void)filterValueChange:(float)value {
    _selectedFilterLevel = value ;
    if (self.delegate && [self.delegate respondsToSelector:@selector(demoBarFilterValueChange:)]) {
        [self.delegate demoBarFilterValueChange:value];
    }
}

-(void)blurDidSelect:(BOOL)isSel{
    if (self.delegate && [self.delegate respondsToSelector:@selector(blurDidSelect:)]) {
        [self.delegate blurDidSelect:isSel];
    }
}

#pragma mark ---- setter

// 滤镜
-(void)setFiltersDataSource:(NSArray<NSString *> *)filtersDataSource {
    _filtersDataSource = filtersDataSource ;
    self.demoBar.filtersDataSource = filtersDataSource ;
}

// 美颜滤镜
-(void)setBeautyFiltersDataSource:(NSArray<NSString *> *)beautyFiltersDataSource {
    _beautyFiltersDataSource = beautyFiltersDataSource ;
    self.demoBar.beautyFiltersDataSource = beautyFiltersDataSource ;
}

// 滤镜数组中文
-(void)setFiltersCHName:(NSDictionary<NSString *,NSString *> *)filtersCHName {
    _filtersCHName = filtersCHName ;
    self.demoBar.filtersCHName = filtersCHName ;
}

// 选中的滤镜
-(void)setSelectedFilter:(NSString *)selectedFilter {
    _selectedFilter = selectedFilter ;
    self.demoBar.selectedFilter = selectedFilter ;
}

-(NSString *)selectedFilter {
    return self.demoBar.selectedFilter ;
}

-(double)selectedFilterLevel {
    return self.demoBar.selectedFilterLevel ;
}
-(void)setSelectedFilterLevel:(double)selectedFilterLevel {
    _selectedFilterLevel = selectedFilterLevel ;
    self.demoBar.selectedFilterLevel = selectedFilterLevel ;
}


-(BOOL)isTopViewShow {
    return self.demoBar.isTopViewShow ;
}


@end
