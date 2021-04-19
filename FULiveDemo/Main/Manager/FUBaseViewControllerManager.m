//
//  FUBaseViewControllerManager.m
//  FULiveDemo
//
//  Created by Chen on 2021/2/24.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUBaseViewControllerManager.h"
#import "FUManager.h"
#import "FUBeautyDefine.h"

@interface FUBaseViewControllerManager ()
/* 滤镜参数 */
@property (nonatomic, strong) NSArray<FUBeautyModel *> *filters;
/* 美肤参数 */
@property (nonatomic, strong) NSArray<FUBeautyModel *> *skinParams;
/* 美型参数 */
@property (nonatomic, strong) NSArray<FUBeautyModel *> *shapeParams;
@end

@implementation FUBaseViewControllerManager
- (void)dealloc {
    [FURenderKit shareRenderKit].beauty = nil;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        /* 美颜 */
        self.filters = [self setupFilterData];
        self.seletedFliter = self.filters[2];
        self.skinParams =  [self setupSkinData];
        self.shapeParams =  [self setupShapData];
        [self loadFilter];
    }
    return self;
}

- (void)setFaceProcessorDetectMode:(int)mode {
    fuSetFaceProcessorDetectMode(mode);
}

- (void)setDefaultRotationMode:(int)orientation {
    fuSetDefaultRotationMode(orientation);
}

/**加载美颜道具*/
- (void)loadFilter {

//    dispatch_async(_asyncLoadQueue, ^{
//    if (items[FUNamaHandleTypeBeauty] == 0) {

    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();

    NSString *path = [[NSBundle mainBundle] pathForResource:@"face_beautification.bundle" ofType:nil];
    self.beauty = [[FUBeauty alloc] initWithPath:path name:@"FUBeauty"];
//    items[FUNamaHandleTypeBeauty] = [FURenderer itemWithContentsOfFile:path];
    /* 默认精细磨皮 */
    self.beauty.heavyBlur = 0;
    self.beauty.blurType = 2;
//    [FURenderer itemSetParam:items[FUNamaHandleTypeBeauty] withName:@"heavy_blur" value:@(0)];
//    [FURenderer itemSetParam:items[FUNamaHandleTypeBeauty] withName:@"blur_type" value:@(2)];
    /* 默认自定义脸型 */
    self.beauty.faceShape = 4;
//    [FURenderer itemSetParam:items[FUNamaHandleTypeBeauty] withName:@"face_shape" value:@(4)];
    [self setBeautyParameters];

    [FURenderKit shareRenderKit].beauty = self.beauty;

    CFAbsoluteTime endTime = (CFAbsoluteTimeGetCurrent() - startTime);

    NSLog(@"加载美颜道具耗时: %f ms", endTime * 1000.0);

//    }
//    });
}

- (void)setBeautyParameters {
    
    for (FUBeautyModel *modle in self.skinParams){
        if (modle.mParam == FUBeautifySkinBlurLevel) {
            [self setSkin:modle.mValue * 6 forKey:modle.mParam];
//            [FURenderer itemSetParam:items[FUNamaHandleTypeBeauty] withName:modle.mParam value:@(modle.mValue * 6)];
        }else{
            [self setSkin:modle.mValue forKey:modle.mParam];
//            [FURenderer itemSetParam:items[FUNamaHandleTypeBeauty] withName:modle.mParam value:@(modle.mValue)];
        }
        NSLog(@"key===%ld,value ==%f",modle.mParam, modle.mValue);
    }
    
    for (FUBeautyModel *modle in self.shapeParams){
        [self setShap:modle.mValue forKey:modle.mParam];
//         [FURenderer itemSetParam:items[FUNamaHandleTypeBeauty] withName:modle.mParam value:@(modle.mValue)];
        NSLog(@"key===%ld,value ==%f",modle.mParam, modle.mValue);
     }
    
    
    /* 设置默认状态 */
    if (self.filters) {
        [self setFilterkey:[self.seletedFliter.strValue lowercaseString]];
        self.beauty.filterLevel = self.seletedFliter.mValue;
//        [FURenderer itemSetParam:items[FUNamaHandleTypeBeauty] withName:@"filter_name" value:[self.seletedFliter.mParam lowercaseString]];
//        [FURenderer itemSetParam:items[FUNamaHandleTypeBeauty] withName:@"filter_level" value:@(self.seletedFliter.mValue)];
    }

}


- (void)setSkin:(double)value forKey:(FUBeautifySkin)key {
    switch (key) {
        case FUBeautifySkinBlurLevel: {
            self.beauty.blurLevel = value;
        }
            break;
        case FUBeautifySkinColorLevel: {
            self.beauty.colorLevel = value;
        }
            break;
        case FUBeautifySkinRedLevel: {
            self.beauty.redLevel = value;
        }
            break;
        case FUBeautifySkinSharpen: {
            self.beauty.sharpen = value;
        }
            break;
        case FUBeautifySkinEyeBright: {
            self.beauty.eyeBright = value;
        }
            break;
        case FUBeautifySkinToothWhiten: {
            self.beauty.toothWhiten = value;
        }
            break;
        case FUBeautifySkinRemovePouchStrength: {
            self.beauty.removePouchStrength = value;
        }
            break;
        case FUBeautifySkinRemoveNasolabialFoldsStrength: {
            self.beauty.removeNasolabialFoldsStrength = value;
        }
            break;
        default:
            break;
    }
}

- (void)setShap:(double)value forKey:(FUBeautifyShape)key {
    switch (key) {
        case FUBeautifyShapeCheekThinning: {
            self.beauty.cheekThinning = value;
        }
            break;
        case FUBeautifyShapeCheekV: {
            self.beauty.cheekV = value;
        }
            break;
        case FUBeautifyShapeCheekNarrow: {
            self.beauty.cheekNarrow = value;
        }
            break;
        case FUBeautifyShapeCheekSmall: {
            self.beauty.cheekSmall = value;
        }
            break;
        case FUBeautifyShapeIntensityCheekbones: {
            self.beauty.intensityCheekbones = value;
        }
            break;
        case FUBeautifyShapeIntensityLowerJaw: {
            self.beauty.intensityLowerJaw = value;
        }
            break;
        case FUBeautifyShapeEyeEnlarging: {
            self.beauty.eyeEnlarging = value;
        }
            break;
        case FUBeautifyShapeIntensityChin: {
            self.beauty.intensityChin = value;
        }
            break;
        case FUBeautifyShapeIntensityForehead: {
            self.beauty.intensityForehead = value;
        }
            break;
        case FUBeautifyShapeIntensityNose: {
            self.beauty.intensityNose = value;
        }
            break;
        case FUBeautifyShapeIntensityMouth: {
            self.beauty.intensityMouth = value;
        }
            break;
        case FUBeautifyShapeIntensityCanthus: {
            self.beauty.intensityCanthus = value;
        }
            break;
        case FUBeautifyShapeIntensityEyeSpace: {
            self.beauty.intensityEyeSpace = value;
        }
            break;
        case FUBeautifyShapeIntensityEyeRotate: {
            self.beauty.intensityEyeRotate = value;
        }
            break;
        case FUBeautifyShapeIntensityLongNose: {
            self.beauty.intensityLongNose = value;
        }
            break;
        case FUBeautifyShapeIntensityPhiltrum: {
            self.beauty.intensityPhiltrum = value;
        }
            break;
        case FUBeautifyShapeIntensitySmile: {
            self.beauty.intensitySmile = value;
        }
            break;
        default:
            break;
    }
}

- (void)setFilterkey:(FUFilter)filterKey {
    self.beauty.filterName = filterKey;
}


- (void)releaseItem {
    //释放item，内部会自动清除句柄
    [FURenderKit shareRenderKit].beauty = nil;
    //demo 是单例持有 beauty 所以必须主动设置nil, 如果是每个模块自己持有beauty 则随着模块的释放系统自动释放beauty，无需再设置
//    self.beauty = nil;
}

- (BOOL)isDefaultSkinValue {
    for (FUBeautyModel *modle in _skinParams){
        if (fabs(modle.mValue - modle.defaultValue) > 0.01 ) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)isDefaultShapeValue {
    for (FUBeautyModel *modle in _shapeParams){
        if (fabs(modle.mValue - modle.defaultValue) > 0.01 ) {
            return NO;
        }
    }
    return YES;
}


- (NSArray <FUBeautyModel *> *)setupFilterData {
    NSArray *beautyFiltersDataSource = @[@"origin",@"ziran1",@"ziran2",@"ziran3",@"ziran4",@"ziran5",@"ziran6",@"ziran7",@"ziran8",
    @"zhiganhui1",@"zhiganhui2",@"zhiganhui3",@"zhiganhui4",@"zhiganhui5",@"zhiganhui6",@"zhiganhui7",@"zhiganhui8",
                                          @"mitao1",@"mitao2",@"mitao3",@"mitao4",@"mitao5",@"mitao6",@"mitao7",@"mitao8",
                                         @"bailiang1",@"bailiang2",@"bailiang3",@"bailiang4",@"bailiang5",@"bailiang6",@"bailiang7"
                                         ,@"fennen1",@"fennen2",@"fennen3",@"fennen5",@"fennen6",@"fennen7",@"fennen8",
                                         @"lengsediao1",@"lengsediao2",@"lengsediao3",@"lengsediao4",@"lengsediao7",@"lengsediao8",@"lengsediao11",
                                         @"nuansediao1",@"nuansediao2",
                                         @"gexing1",@"gexing2",@"gexing3",@"gexing4",@"gexing5",@"gexing7",@"gexing10",@"gexing11",
                                         @"xiaoqingxin1",@"xiaoqingxin3",@"xiaoqingxin4",@"xiaoqingxin6",
                                         @"heibai1",@"heibai2",@"heibai3",@"heibai4"];
    
    NSDictionary *filtersCHName = @{@"origin":@"原图",@"bailiang1":@"白亮1",@"bailiang2":@"白亮2",@"bailiang3":@"白亮3",@"bailiang4":@"白亮4",@"bailiang5":@"白亮5",@"bailiang6":@"白亮6",@"bailiang7":@"白亮7"
                                    ,@"fennen1":@"粉嫩1",@"fennen2":@"粉嫩2",@"fennen3":@"粉嫩3",@"fennen4":@"粉嫩4",@"fennen5":@"粉嫩5",@"fennen6":@"粉嫩6",@"fennen7":@"粉嫩7",@"fennen8":@"粉嫩8",
                                    @"gexing1":@"个性1",@"gexing2":@"个性2",@"gexing3":@"个性3",@"gexing4":@"个性4",@"gexing5":@"个性5",@"gexing6":@"个性6",@"gexing7":@"个性7",@"gexing8":@"个性8",@"gexing9":@"个性9",@"gexing10":@"个性10",@"gexing11":@"个性11",
                                    @"heibai1":@"黑白1",@"heibai2":@"黑白2",@"heibai3":@"黑白3",@"heibai4":@"黑白4",@"heibai5":@"黑白5",
                                    @"lengsediao1":@"冷色调1",@"lengsediao2":@"冷色调2",@"lengsediao3":@"冷色调3",@"lengsediao4":@"冷色调4",@"lengsediao5":@"冷色调5",@"lengsediao6":@"冷色调6",@"lengsediao7":@"冷色调7",@"lengsediao8":@"冷色调8",@"lengsediao9":@"冷色调9",@"lengsediao10":@"冷色调10",@"lengsediao11":@"冷色调11",
                                    @"nuansediao1":@"暖色调1",@"nuansediao2":@"暖色调2",@"nuansediao3":@"暖色调3",@"xiaoqingxin1":@"小清新1",@"xiaoqingxin2":@"小清新2",@"xiaoqingxin3":@"小清新3",@"xiaoqingxin4":@"小清新4",@"xiaoqingxin5":@"小清新5",@"xiaoqingxin6":@"小清新6",
                                    @"ziran1":@"自然1",@"ziran2":@"自然2",@"ziran3":@"自然3",@"ziran4":@"自然4",@"ziran5":@"自然5",@"ziran6":@"自然6",@"ziran7":@"自然7",@"ziran8":@"自然8",
                                    @"mitao1":@"蜜桃1",@"mitao2":@"蜜桃2",@"mitao3":@"蜜桃3",@"mitao4":@"蜜桃4",@"mitao5":@"蜜桃5",@"mitao6":@"蜜桃6",@"mitao7":@"蜜桃7",@"mitao8":@"蜜桃8",
                                    @"zhiganhui1":@"质感灰1",@"zhiganhui2":@"质感灰2",@"zhiganhui3":@"质感灰3",@"zhiganhui4":@"质感灰4",@"zhiganhui5":@"质感灰5",@"zhiganhui6":@"质感灰6",@"zhiganhui7":@"质感灰7",@"zhiganhui8":@"质感灰8"
    };
    NSMutableArray *filters = [NSMutableArray array];
   
    
    for (NSString *str in beautyFiltersDataSource) {
        FUBeautyModel *modle = [[FUBeautyModel alloc] init];
        modle.strValue = str;
        modle.mTitle = [filtersCHName valueForKey:str];
        modle.mValue = 0.4;
        modle.type = FUBeautyDefineFilter;
        [filters addObject:modle];
    }
    
    return [NSArray arrayWithArray:filters];
}

- (NSArray <FUBeautyModel *> *)setupSkinData {
    NSArray *prams = @[@"blur_level",@"color_level",@"red_level",@"sharpen",@"eye_bright",@"tooth_whiten",@"remove_pouch_strength",@"remove_nasolabial_folds_strength"];//
    NSDictionary *titelDic = @{@"blur_level":@"精细磨皮",@"color_level":@"美白",@"red_level":@"红润",@"sharpen":@"锐化",@"remove_pouch_strength":@"去黑眼圈",@"remove_nasolabial_folds_strength":@"去法令纹",@"eye_bright":@"亮眼",@"tooth_whiten":@"美牙"};
    NSDictionary *defaultValueDic = @{@"blur_level":@(0.7),@"color_level":@(0.3),@"red_level":@(0.3),@"sharpen":@(0.2),@"remove_pouch_strength":@(0),@"remove_nasolabial_folds_strength":@(0),@"eye_bright":@(0),@"tooth_whiten":@(0)};
    
    NSMutableArray *skinParams = [NSMutableArray array];

    for (NSUInteger i = 0; i < FUBeautifySkinMax; i ++) {
        NSString *str = prams[i];
        FUBeautyModel *modle = [[FUBeautyModel alloc] init];
        modle.mParam = i;
        modle.type = FUBeautyDefineSkin;
        modle.mTitle = [titelDic valueForKey:str];
        modle.mValue = [[defaultValueDic valueForKey:str] floatValue];
        modle.defaultValue = modle.mValue;
        [skinParams addObject:modle];
    }
    return [NSArray arrayWithArray:skinParams];
}

- (NSArray <FUBeautyModel *> *)setupShapData {
   NSArray *prams = @[@"cheek_thinning",@"cheek_v",@"cheek_narrow",@"cheek_small",@"intensity_cheekbones",@"intensity_lower_jaw",@"eye_enlarging",@"intensity_chin",@"intensity_forehead",@"intensity_nose",@"intensity_mouth",@"intensity_canthus",@"intensity_eye_space",@"intensity_eye_rotate",@"intensity_long_nose",@"intensity_philtrum",@"intensity_smile"];
    NSDictionary *titelDic = @{@"cheek_thinning":@"瘦脸",@"cheek_v":@"v脸",@"cheek_narrow":@"窄脸",@"cheek_small":@"小脸",@"intensity_cheekbones":@"瘦颧骨",@"intensity_lower_jaw":@"瘦下颌骨",@"eye_enlarging":@"大眼",@"intensity_chin":@"下巴",
                               @"intensity_forehead":@"额头",@"intensity_nose":@"瘦鼻",@"intensity_mouth":@"嘴型",@"intensity_canthus":@"开眼角",@"intensity_eye_space":@"眼距",@"intensity_eye_rotate":@"眼睛角度",@"intensity_long_nose":@"长鼻",@"intensity_philtrum":@"缩人中",@"intensity_smile":@"微笑嘴角"
    };
   NSDictionary *defaultValueDic = @{@"cheek_thinning":@(0),@"cheek_v":@(0.5),@"cheek_narrow":@(0),@"cheek_small":@(0),@"intensity_cheekbones":@(0),@"intensity_lower_jaw":@(0),@"eye_enlarging":@(0.4),@"intensity_chin":@(0.3),
                              @"intensity_forehead":@(0.3),@"intensity_nose":@(0.5),@"intensity_mouth":@(0.4),@"intensity_canthus":@(0),@"intensity_eye_space":@(0.5),@"intensity_eye_rotate":@(0.5),@"intensity_long_nose":@(0.5),@"intensity_philtrum":@(0.5),@"intensity_smile":@(0)
   };
   
    NSMutableArray *shapeParams = [NSMutableArray array];
    for (NSUInteger i = 0; i < FUBeautifyShapeMax; i ++) {
        BOOL isStyle101 = NO;
        NSString *str = prams[i];
        if ([str isEqualToString:@"intensity_chin"] || [str isEqualToString:@"intensity_forehead"] || [str isEqualToString:@"intensity_mouth"] || [str isEqualToString:@"intensity_eye_space"] || [str isEqualToString:@"intensity_eye_rotate"] || [str isEqualToString:@"intensity_long_nose"] || [str isEqualToString:@"intensity_philtrum"]) {
            isStyle101 = YES;
        }
        FUBeautyModel *modle = [[FUBeautyModel alloc] init];
        modle.mParam = i;
        modle.type = FUBeautyDefineShape;
        modle.mTitle = [titelDic valueForKey:str];
        modle.mValue = [[defaultValueDic valueForKey:str] floatValue];
        modle.defaultValue = modle.mValue;
        modle.iSStyle101 = isStyle101;
        [shapeParams addObject:modle];
    }
    return [NSArray arrayWithArray:shapeParams];
}

// 默认美颜参数
- (void)resetDefaultParams:(FUBeautyDefine)type {
    switch (type) {
        case FUBeautyDefineSkin: {
            for (FUBeautyModel *modle in _skinParams){
                modle.mValue = modle.defaultValue;
                if (modle.mParam == FUBeautifySkinBlurLevel) {
                    [self setSkin:modle.mValue * 6 forKey:modle.mParam];
                }else{
                    [self setSkin:modle.mValue forKey:modle.mParam];
                }
            }
        }
            break;
        case FUBeautyDefineShape: {
            for (FUBeautyModel *modle in _shapeParams){
                modle.mValue = modle.defaultValue;
                [self setShap:modle.mValue forKey:modle.mParam];
            }
        }
            break;
            
        default:
            break;
    }
}

@end
