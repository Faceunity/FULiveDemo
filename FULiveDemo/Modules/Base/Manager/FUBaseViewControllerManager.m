//
//  FUBaseViewControllerManager.m
//  FULiveDemo
//
//  Created by Chen on 2021/2/24.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUBaseViewControllerManager.h"
#import "FUManager.h"
#import "FULocalDataManager.h"
#import "FUBeautyDefine.h"
#import <FURenderKit/FUAIKit.h>
#import <FURenderKit/FUGLContext.h>
#import <FURenderKit/UIDevice+FURenderKit.h>

@interface FUBaseViewControllerManager ()

/* 滤镜参数 */
@property (nonatomic, strong) NSArray<FUBeautyModel *> *filters;
/* 美肤参数 */
@property (nonatomic, strong) NSArray<FUBeautyModel *> *skinParams;
/* 美型参数 */
@property (nonatomic, strong) NSArray<FUBeautyModel *> *shapeParams;
/* 风格参数 ，用父类，因为View 用的就是父类泛型，后续需要优化*/
@property (nonatomic, strong) NSArray<FUStyleModel *> *styleParams;

@end

@implementation FUBaseViewControllerManager

- (void)updateBeautyCache:(BOOL)isPersistent {
    // 更新缓存参数
    [FULocalDataManager shareManager].persistentBeauty.beautySkins = [self.skinParams copy];
    [FULocalDataManager shareManager].persistentBeauty.beautyShapes = [self.shapeParams copy];
    [FULocalDataManager shareManager].persistentBeauty.beautyFilters = [self.filters copy];
    NSInteger index = [self.filters indexOfObject:self.seletedFliter];
    [FULocalDataManager shareManager].persistentBeauty.selectedFilterIndex = index;
    if (self.currentStyle) {
        [FULocalDataManager shareManager].persistentBeauty.selectedStyleIndex = [self.styleParams indexOfObject:self.currentStyle];
    }
    if (isPersistent) {
        // 本地持久化保存
        [[FULocalDataManager shareManager] save];
    }
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _cameraPosition = AVCaptureDevicePositionFront;
        [FURenderKit shareRenderKit].internalCameraSetting.position = _cameraPosition;
        [self reloadBeautyParams];
    }
    return self;
}

//初始化美颜数据
- (void)initBeauty {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"face_beautification.bundle" ofType:nil];
    self.beauty = [[FUBeauty alloc] initWithPath:path name:@"FUBeauty"];
    /* 默认均匀磨皮 */
    self.beauty.heavyBlur = 0;
    self.beauty.blurType = 3;
    /* 默认自定义脸型 */
    self.beauty.faceShape = 4;
    
    // 高性能设备设置去黑眼圈、去法令纹、大眼、嘴型最新效果
    if ([FUManager shareManager].devicePerformanceLevel == FUDevicePerformanceLevelHigh) {
        [self.beauty addPropertyMode:FUBeautyPropertyMode2 forKey:FUModeKeyRemovePouchStrength];
        [self.beauty addPropertyMode:FUBeautyPropertyMode2 forKey:FUModeKeyRemoveNasolabialFoldsStrength];
        [self.beauty addPropertyMode:FUBeautyPropertyMode3 forKey:FUModeKeyEyeEnlarging];
        [self.beauty addPropertyMode:FUBeautyPropertyMode3 forKey:FUModeKeyIntensityMouth];
    }
    
    //如果有设置默认风格，直接美颜、美肤、美型
    if (self.currentStyle.mParam != FUBeautyStyleTypeNone) {
        [self setStyleBeautyParams: self.currentStyle];
    } else {
        [self setBeautyParameters];
    }
}

- (void)clearItems {
    [FUAIKit unloadAllAIMode];
    [FURenderKit clear];
}

- (void)setFaceProcessorDetectMode:(FUFaceProcessorDetectMode)mode {
    [FUAIKit shareKit].faceProcessorDetectMode = mode;
}

- (void)setOnCameraChange {
    [FUAIKit resetTrackedResult];
}

- (BOOL)faceTrace {
    BOOL ret = [FUAIKit shareKit].trackedFacesCount > 0;
    return ret;
}

- (BOOL)bodyTrace {
    return [FUAIKit aiHumanProcessorNums] > 0;
}

- (void)setMaxFaces:(int)maxFaces {
    [FUAIKit shareKit].maxTrackFaces = maxFaces;
}

- (void)setMaxBodies:(int)maxBodies {
    [FUAIKit shareKit].maxTrackBodies = maxBodies;
}


- (CGPoint)getFaceCenterInFrameSize:(CGSize)frameSize{
    CGPoint preCenter = CGPointMake(0.49, 0.5);
    // 获取人脸矩形框，坐标系原点为图像右下角，float数组为矩形框右下角及左上角两个点的x,y坐标（前两位为右下角的x,y信息，后两位为左上角的x,y信息）
    CGRect faceRect = [FUPoster cacluteRectWithIndex:0 height:frameSize.height width:frameSize.width];
    
    if (faceRect.origin.x < 0 || faceRect.origin.y < 0 || (faceRect.origin.x + faceRect.size.width > frameSize.width) || (faceRect.origin.y + faceRect.size.height > frameSize.height)) {
        self.trackedFullFace = NO;
    } else {
        self.trackedFullFace = YES;
    }
    
    // 计算出中心点的坐标值
    CGFloat centerX = (faceRect.origin.x + (faceRect.origin.x + faceRect.size.width)) * 0.5;
    CGFloat centerY = (faceRect.origin.y + (faceRect.origin.y + faceRect.size.height)) * 0.5;
    
    // 将坐标系转换成以左上角为原点的坐标系
    centerX = centerX / frameSize.width;
    centerY = centerY / frameSize.height;
    
    CGPoint center = CGPointMake(centerX, centerY);
    
    preCenter = center;
    
    return center;
}

- (void)reloadBeautyParams {
    // 风格推荐数据固定
    self.styleParams = [self getStyleData];
    //优先获取缓存的美颜参数
    FUPersistentBeautyModel *persistentBeautyModel = [FULocalDataManager shareManager].persistentBeauty;
    if (persistentBeautyModel.beautySkins && persistentBeautyModel.beautyShapes && persistentBeautyModel.beautyFilters) {
        // 存在缓存数据
        self.skinParams = [persistentBeautyModel.beautySkins copy];
        self.shapeParams = [persistentBeautyModel.beautyShapes copy];
        self.filters = [persistentBeautyModel.beautyFilters copy];
        if (persistentBeautyModel.selectedFilterIndex >= 0 && persistentBeautyModel.selectedFilterIndex < self.filters.count) {
            self.seletedFliter = self.filters[persistentBeautyModel.selectedFilterIndex];
        } else {
            self.seletedFliter = self.filters[2];
        }
        if (persistentBeautyModel.selectedStyleIndex >= 0 && persistentBeautyModel.selectedStyleIndex < self.styleParams.count) {
            self.currentStyle = self.styleParams[persistentBeautyModel.selectedStyleIndex];
        }
    } else {
        // 不存在缓存数据
        self.filters = [self getFilterData];
        self.seletedFliter = self.filters[2];
        self.skinParams =  [self getSkinData];
        self.shapeParams =  [self getShapData];
    }
    
    //如果有设置默认风格，直接美颜、美肤、美型
    if (self.currentStyle.mParam != FUBeautyStyleTypeNone) {
        [self setStyleBeautyParams: self.currentStyle];
    } else {
        [self setBeautyParameters];
    }
}

/**加载美颜道具到FURenderKit*/
- (void)loadItem {
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    [self initBeauty];
    [FURenderKit shareRenderKit].beauty = self.beauty;
    CFAbsoluteTime endTime = (CFAbsoluteTimeGetCurrent() - startTime);
    NSLog(@"加载美颜道具耗时: %f ms", endTime * 1000.0);
}

- (void)setBeautyParameters {
    for (FUBeautyModel *model in self.skinParams){
        [self setSkin:model.mValue forKey:model.mParam];
        NSLog(@"key===%lu,value ==%f",(unsigned long)model.mParam, model.mValue);
    }
    
    for (FUBeautyModel *model in self.shapeParams){
        [self setShap:model.mValue forKey:model.mParam];
        NSLog(@"key===%lu,value ==%f",(unsigned long)model.mParam, model.mValue);
    }
    
    /* 设置默认状态 */
    if (self.filters) {
        [self setFilterkey:[self.seletedFliter.strValue lowercaseString]];
        self.beauty.filterLevel = self.seletedFliter.mValue;
    }

}


- (void)setStyleBeautyParams:(FUStyleModel *)styleModel {
    self.currentStyle = styleModel;
    
    if (self.currentStyle.mParam == FUBeautyStyleTypeNone) {
        [self setBeautyParameters];
        return ;
    }

    //设置美肤
    for (FUBeautyModel *skin in styleModel.skins) {
        [self setSkin:skin.mValue forKey:skin.mParam];
    }

    //设置美型的其他参数
    for (FUBeautyModel *shape in styleModel.shapes) {
        [self setShap:shape.mValue forKey:shape.mParam];
    }
    
    //设置滤镜
    [self setFilterkey:[styleModel.filter.strValue lowercaseString]];
    self.beauty.filterLevel = styleModel.filter.mValue;
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
        case FUBeautifyShapeCheekShort: {
            self.beauty.cheekShort = value;
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
        case FUBeautifyShapeEyeCircle: {
            self.beauty.intensityEyeCircle = value;
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
        case FUBeautifyShapeIntensityBrowHeight: {
            self.beauty.intensityBrowHeight = value;
        }
            break;
        case FUBeautifyShapeIntensityBrowSpace: {
            self.beauty.intensityBrowSpace = value;
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
    [FURenderKit shareRenderKit].beauty = nil;
}

- (BOOL)isDefaultSkinValue {
    for (FUBeautyModel *model in _skinParams){
        if (fabs(model.mValue - model.defaultValue) > 0.01 ) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)isDefaultShapeValue {
    for (FUBeautyModel *model in _shapeParams){
        if (fabs(model.mValue - model.defaultValue) > 0.01 ) {
            return NO;
        }
    }
    return YES;
}


- (NSArray <FUBeautyModel *> *)getFilterData {
    NSArray *beautyFiltersDataSource = @[
        @"origin",
        @"ziran1",
        @"ziran2",
        @"ziran3",
        @"ziran4",
        @"ziran5",
        @"ziran6",
        @"ziran7",
        @"ziran8",
        @"zhiganhui1",
        @"zhiganhui2",
        @"zhiganhui3",
        @"zhiganhui4",
        @"zhiganhui5",
        @"zhiganhui6",
        @"zhiganhui7",
        @"zhiganhui8",
        @"mitao1",
        @"mitao2",
        @"mitao3",
        @"mitao4",
        @"mitao5",
        @"mitao6",
        @"mitao7",
        @"mitao8",
        @"bailiang1",
        @"bailiang2",
        @"bailiang3",
        @"bailiang4",
        @"bailiang5",
        @"bailiang6",
        @"bailiang7",
        @"fennen1",
        @"fennen2",
        @"fennen3",
        @"fennen5",
        @"fennen6",
        @"fennen7",
        @"fennen8",
        @"lengsediao1",
        @"lengsediao2",
        @"lengsediao3",
        @"lengsediao4",
        @"lengsediao7",
        @"lengsediao8",
        @"lengsediao11",
        @"nuansediao1",
        @"nuansediao2",
        @"gexing1",
        @"gexing2",
        @"gexing3",
        @"gexing4",
        @"gexing5",
        @"gexing7",
        @"gexing10",
        @"gexing11",
        @"xiaoqingxin1",
        @"xiaoqingxin3",
        @"xiaoqingxin4",
        @"xiaoqingxin6",
        @"heibai1",
        @"heibai2",
        @"heibai3",
        @"heibai4"
    ];
    
    NSDictionary *filtersCHName = @{
        @"origin" : @"原图",
        @"bailiang1" : @"白亮1",
        @"bailiang2" : @"白亮2",
        @"bailiang3" : @"白亮3",
        @"bailiang4" : @"白亮4",
        @"bailiang5" : @"白亮5",
        @"bailiang6" : @"白亮6",
        @"bailiang7" : @"白亮7",
        @"fennen1" : @"粉嫩1",
        @"fennen2" : @"粉嫩2",
        @"fennen3" : @"粉嫩3",
        @"fennen4" : @"粉嫩4",
        @"fennen5" : @"粉嫩5",
        @"fennen6" : @"粉嫩6",
        @"fennen7" : @"粉嫩7",
        @"fennen8" : @"粉嫩8",
        @"gexing1" : @"个性1",
        @"gexing2" : @"个性2",
        @"gexing3" : @"个性3",
        @"gexing4" : @"个性4",
        @"gexing5" : @"个性5",
        @"gexing6" : @"个性6",
        @"gexing7" : @"个性7",
        @"gexing8" : @"个性8",
        @"gexing9" : @"个性9",
        @"gexing10" : @"个性10",
        @"gexing11" : @"个性11",
        @"heibai1" : @"黑白1",
        @"heibai2" : @"黑白2",
        @"heibai3" : @"黑白3",
        @"heibai4" : @"黑白4",
        @"heibai5" : @"黑白5",
        @"lengsediao1" : @"冷色调1",
        @"lengsediao2" : @"冷色调2",
        @"lengsediao3" : @"冷色调3",
        @"lengsediao4" : @"冷色调4",
        @"lengsediao5" : @"冷色调5",
        @"lengsediao6" : @"冷色调6",
        @"lengsediao7" : @"冷色调7",
        @"lengsediao8" : @"冷色调8",
        @"lengsediao9" : @"冷色调9",
        @"lengsediao10" : @"冷色调10",
        @"lengsediao11" : @"冷色调11",
        @"nuansediao1" : @"暖色调1",
        @"nuansediao2" : @"暖色调2",
        @"nuansediao3" : @"暖色调3",
        @"xiaoqingxin1" : @"小清新1",
        @"xiaoqingxin2" : @"小清新2",
        @"xiaoqingxin3" : @"小清新3",
        @"xiaoqingxin4" : @"小清新4",
        @"xiaoqingxin5" : @"小清新5",
        @"xiaoqingxin6" : @"小清新6",
        @"ziran1" : @"自然1",
        @"ziran2" : @"自然2",
        @"ziran3" : @"自然3",
        @"ziran4" : @"自然4",
        @"ziran5" : @"自然5",
        @"ziran6" : @"自然6",
        @"ziran7" : @"自然7",
        @"ziran8" : @"自然8",
        @"mitao1" : @"蜜桃1",
        @"mitao2" : @"蜜桃2",
        @"mitao3" : @"蜜桃3",
        @"mitao4" : @"蜜桃4",
        @"mitao5" : @"蜜桃5",
        @"mitao6" : @"蜜桃6",
        @"mitao7" : @"蜜桃7",
        @"mitao8" : @"蜜桃8",
        @"zhiganhui1" : @"质感灰1",
        @"zhiganhui2" : @"质感灰2",
        @"zhiganhui3" : @"质感灰3",
        @"zhiganhui4" : @"质感灰4",
        @"zhiganhui5" : @"质感灰5",
        @"zhiganhui6" : @"质感灰6",
        @"zhiganhui7" : @"质感灰7",
        @"zhiganhui8" : @"质感灰8"
    };
    NSMutableArray *filters = [NSMutableArray array];
   
    
    for (NSString *str in beautyFiltersDataSource) {
        FUBeautyModel *model = [[FUBeautyModel alloc] init];
        model.strValue = str;
        model.mTitle = [filtersCHName valueForKey:str];
        model.mValue = 0.4;
        model.type = FUBeautyDefineFilter;
        model.ratio = 1.0;
        [filters addObject:model];
    }
    
    return [NSArray arrayWithArray:filters];
}

- (NSArray <FUBeautyModel *> *)getSkinData {
    NSArray *prams = @[
        @"blur_level",
        @"color_level",
        @"red_level",
        @"sharpen",
        @"eye_bright",
        @"tooth_whiten",
        @"remove_pouch_strength",
        @"remove_nasolabial_folds_strength"
    ];
    NSDictionary *titelDic = @{
        @"blur_level" : @"磨皮",
        @"color_level" : @"美白",
        @"red_level" : @"红润",
        @"sharpen" : @"锐化",
        @"remove_pouch_strength" : @"去黑眼圈",
        @"remove_nasolabial_folds_strength" : @"去法令纹",
        @"eye_bright" : @"亮眼",
        @"tooth_whiten" : @"美牙"
    };
    NSDictionary *defaultValueDic = @{
        @"blur_level":@(4.2),
        @"color_level":@(0.3),
        @"red_level":@(0.3),
        @"sharpen":@(0.2),
        @"remove_pouch_strength":@(0),
        @"remove_nasolabial_folds_strength":@(0),
        @"eye_bright":@(0),
        @"tooth_whiten":@(0)
    };
    
    float ratio[FUBeautifySkinMax] = {6.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0};
    NSMutableArray *skinParams = [NSMutableArray array];

    for (NSUInteger i = 0; i < FUBeautifySkinMax; i ++) {
        NSString *str = prams[i];
        FUBeautyModel *model = [[FUBeautyModel alloc] init];
        model.mParam = i;
        model.type = FUBeautyDefineSkin;
        model.mTitle = [titelDic valueForKey:str];
        model.mValue = [[defaultValueDic valueForKey:str] floatValue];
        model.defaultValue = model.mValue;
        model.ratio = ratio[i];
        [skinParams addObject:model];
    }
    return [NSArray arrayWithArray:skinParams];
}

- (NSArray <FUBeautyModel *> *)getShapData {
    NSArray *prams = @[
        @"cheek_thinning",
        @"cheek_v",
        @"cheek_narrow",
        @"cheek_short",
        @"cheek_small",
        @"intensity_cheekbones",
        @"intensity_lower_jaw",
        @"eye_enlarging",
        @"intensity_eye_circle",
        @"intensity_chin",
        @"intensity_forehead",
        @"intensity_nose",
        @"intensity_mouth",
        @"intensity_canthus",
        @"intensity_eye_space",
        @"intensity_eye_rotate",
        @"intensity_long_nose",
        @"intensity_philtrum",
        @"intensity_smile",
        @"intensity_brow_hight",
        @"intensity_brow_space"
    ];
    NSDictionary *titelDic = @{
        @"cheek_thinning" : @"瘦脸",
        @"cheek_v" : @"v脸",
        @"cheek_narrow" : @"窄脸",
        @"cheek_short" : @"短脸",
        @"cheek_small" : @"小脸",
        @"intensity_cheekbones" : @"瘦颧骨",
        @"intensity_lower_jaw" : @"瘦下颌骨",
        @"eye_enlarging" : @"大眼",
        @"intensity_eye_circle" : @"圆眼",
        @"intensity_chin" : @"下巴",
        @"intensity_forehead" : @"额头",
        @"intensity_nose" : @"瘦鼻",
        @"intensity_mouth" : @"嘴型",
        @"intensity_canthus" : @"开眼角",
        @"intensity_eye_space" : @"眼距",
        @"intensity_eye_rotate" : @"眼睛角度",
        @"intensity_long_nose" : @"长鼻",
        @"intensity_philtrum" : @"缩人中",
        @"intensity_smile" : @"微笑嘴角",
        @"intensity_brow_hight" : @"眉毛上下",
        @"intensity_brow_space" : @"眉间距"
    };
    NSDictionary *defaultValueDic = @{
        @"cheek_thinning":@(0),
        @"cheek_v":@(0.5),
        @"cheek_narrow":@(0),
        @"cheek_short":@(0),
        @"cheek_small":@(0),
        @"intensity_cheekbones":@(0),
        @"intensity_lower_jaw":@(0),
        @"eye_enlarging":@(0.4),
        @"intensity_eye_circle":@(0.0),
        @"intensity_chin":@(0.3),
        @"intensity_forehead":@(0.3),
        @"intensity_nose":@(0.5),
        @"intensity_mouth":@(0.4),
        @"intensity_canthus":@(0),
        @"intensity_eye_space":@(0.5),
        @"intensity_eye_rotate":@(0.5),
        @"intensity_long_nose":@(0.5),
        @"intensity_philtrum":@(0.5),
        @"intensity_smile":@(0),
        @"intensity_brow_hight":@(0.5),
        @"intensity_brow_space":@(0.5)
    };
    
    float ratio[FUBeautifyShapeMax] = {1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0};
    NSMutableArray *shapeParams = [NSMutableArray array];
    for (NSUInteger i = 0; i < FUBeautifyShapeMax; i ++) {
        BOOL isStyle101 = NO;
        NSString *str = prams[i];
        if ([str isEqualToString:@"intensity_chin"] || [str isEqualToString:@"intensity_forehead"] || [str isEqualToString:@"intensity_mouth"] || [str isEqualToString:@"intensity_eye_space"] || [str isEqualToString:@"intensity_eye_rotate"] || [str isEqualToString:@"intensity_long_nose"] || [str isEqualToString:@"intensity_philtrum"] || [str isEqualToString:@"intensity_brow_hight"] || [str isEqualToString:@"intensity_brow_space"]) {
            isStyle101 = YES;
        }
        FUBeautyModel *model = [[FUBeautyModel alloc] init];
        model.mParam = i;
        model.type = FUBeautyDefineShape;
        model.mTitle = [titelDic valueForKey:str];
        model.mValue = [[defaultValueDic valueForKey:str] floatValue];
        model.defaultValue = model.mValue;
        model.iSStyle101 = isStyle101;
        model.ratio = ratio[i];
        if ([FUManager shareManager].devicePerformanceLevel != FUDevicePerformanceLevelHigh && ([str isEqualToString:@"intensity_brow_hight"] || [str isEqualToString:@"intensity_brow_space"])) {
            // 低性能手机禁用眉毛上下和眉间距
            model.disabled = YES;
        }
        [shapeParams addObject:model];
    }
    return [NSArray arrayWithArray:shapeParams];
}

-(NSArray <FUStyleModel *> *)getStyleData {
    NSArray *titles = @[@"None", @"Style1", @"Style2",  @"Style3",  @"Style4",  @"Style5",  @"Style6",  @"Style7"];
    
    NSMutableArray *temp = [NSMutableArray array];
    
    for(int i = 0; i < FUBeautyStyleMax; i++) {
        FUStyleModel *model = [FUStyleModel defaultParams];
        model.type = FUBeautyDefineStyle;
        model.mParam = i;
        model.mTitle = [titles objectAtIndex:i];
        if (i > 0) {
            [model styleWithType:i];
        }
        [temp addObject:model];
    }
    
    return [NSArray arrayWithArray:temp];
}

// 默认美颜参数
- (void)resetDefaultParams:(FUBeautyDefine)type {
    switch (type) {
        case FUBeautyDefineSkin: {
            for (FUBeautyModel *model in _skinParams){
                model.mValue = model.defaultValue;
                [self setSkin:model.mValue forKey:model.mParam];
            }
        }
            break;
        case FUBeautyDefineShape: {
            for (FUBeautyModel *model in _shapeParams){
                model.mValue = model.defaultValue;
                [self setShap:model.mValue forKey:model.mParam];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)updateBeautyBlurEffect {
    if (!self.beauty || !self.beauty.enable) {
        return;
    }
    if ([FUManager shareManager].devicePerformanceLevel == FUDevicePerformanceLevelHigh) {
        // 根据人脸置信度设置不同磨皮效果
        CGFloat score = [FUAIKit fuFaceProcessorGetConfidenceScore:0];
        if (score > 0.95) {
            self.beauty.blurType = 3;
            self.beauty.blurUseMask = YES;
        } else {
            self.beauty.blurType = 2;
            self.beauty.blurUseMask = NO;
        }
    } else {
        // 设置精细磨皮效果
        self.beauty.blurType = 2;
        self.beauty.blurUseMask = NO;
    }
    
}

@end
