//
//  FUMakeupManager.m
//  FULiveDemo
//
//  Created by 项林平 on 2021/11/15.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUMakeupManager.h"
#import "FULocalDataManager.h"

#import "FUMakeupModel.h"
#import "FUCombinationMakeupModel.h"
#import "FUSingleMakeupModel.h"

#import "FUMakeupDefine.h"

@interface FUMakeupManager ()

@property (nonatomic, copy) NSArray<FUCombinationMakeupModel *> *combinationMakeups;
@property (nonatomic, copy) NSArray<FUMakeupModel *> *makeups;

@property (nonatomic, strong) FUMakeup *makeup;

@end

@implementation FUMakeupManager

#pragma mark - Instance methods

- (void)setCurrentCombinationMakeupModel:(FUCombinationMakeupModel *)currentCombinationMakeupModel {
    if (!currentCombinationMakeupModel) {
        _currentCombinationMakeupModel = nil;
        return;
    }
    if ([currentCombinationMakeupModel.name isEqualToString:@"卸妆"]) {
        // 卸妆
        dispatch_async(self.loadQueue, ^{
            self.makeup = nil;
            [FURenderKit shareRenderKit].makeup = nil;
            _currentCombinationMakeupModel = currentCombinationMakeupModel;
        });
        return;
    }
    // 注：嗲嗲兔、冻龄、国风、混血是8.0.0新加的四个组合妆，新组合妆只需要直接加载bundle，不需要绑定到face_makeup.bundle
    if (currentCombinationMakeupModel.isCombined) {
        // 新组合妆，每次加载必须重新初始化
        dispatch_async(self.loadQueue, ^{
            NSString *path = [[NSBundle mainBundle] pathForResource:currentCombinationMakeupModel.bundleName ofType:@"bundle"];
            self.makeup = [[FUMakeup alloc] initWithPath:path name:@"makeup"];
            [FURenderKit shareRenderKit].makeup = self.makeup;
            [self updateIntensityOfCombinationMakeup:currentCombinationMakeupModel];
            _currentCombinationMakeupModel = currentCombinationMakeupModel;
        });
    } else {
        // 老组合妆
        dispatch_async(self.loadQueue, ^{
            if (!self.makeup || _currentCombinationMakeupModel.isCombined) {
                // 当前未选择或者当前选择了新组合装，需要重新初始化
                NSString *path = [[NSBundle mainBundle] pathForResource:@"face_makeup" ofType:@"bundle"];
                self.makeup = [[FUMakeup alloc] initWithPath:path name:@"makeup"];
            }
            [FURenderKit shareRenderKit].makeup = self.makeup;
            // 绑定组合妆bundle到face_makeup.bundle
            [self loadCombinationMakeupWithBundleName:currentCombinationMakeupModel.bundleName];
            // 更新程度值
            [self updateIntensityOfCombinationMakeup:currentCombinationMakeupModel];
            _currentCombinationMakeupModel = currentCombinationMakeupModel;
        });
    }
}

- (void)updateIntensityOfCombinationMakeup:(FUCombinationMakeupModel *)model {
    if (model.isCombined) {
        // 新组合妆直接设置
        self.makeup.intensity = model.value;
        self.makeup.filterIntensity = model.value * model.selectedFilterLevel;
    } else {
        // 老组合妆需要遍历所有子妆
        for (FUSingleMakeupModel *singleMakeupModel in model.singleMakeupArray) {
            // 计算子妆实际值
            singleMakeupModel.realValue = model.value * singleMakeupModel.value;
            [self updateIntensityOfSingleMakeup:singleMakeupModel];
        }
    }
}

- (void)updateIntensityOfSingleMakeup:(FUSingleMakeupModel *)singleMakeupModel {
    switch (singleMakeupModel.type) {
        case FUSingleMakeupTypeFoundation:{
            self.makeup.intensityFoundation = singleMakeupModel.realValue;
        }
            break;
        case FUSingleMakeupTypeLip:{
            self.makeup.lipType = singleMakeupModel.lipType;
            self.makeup.isTwoColor = singleMakeupModel.isTwoColorLip;
            self.makeup.intensityLip = singleMakeupModel.realValue;
            if (singleMakeupModel.lipType == FUMakeupLipTypeMoisturizing) {
                // 润泽Ⅱ口红时需要开启口红高光，高光暂时为固定值
                self.makeup.isLipHighlightOn = YES;
                self.makeup.intensityLipHighlight = 0.8;
            } else {
                self.makeup.isLipHighlightOn = NO;
                self.makeup.intensityLipHighlight = 0;
            }
        }
            break;
        case FUSingleMakeupTypeBlusher:{
            self.makeup.intensityBlusher = singleMakeupModel.realValue;
        }
            break;
        case FUSingleMakeupTypeEyebrow:{
            self.makeup.intensityEyebrow = singleMakeupModel.realValue;
        }
            break;
        case FUSingleMakeupTypeEyeshadow:{
            self.makeup.intensityEyeshadow = singleMakeupModel.realValue;
        }
            break;
        case FUSingleMakeupTypeEyeliner:{
            self.makeup.intensityEyeliner = singleMakeupModel.realValue;
        }
            break;
        case FUSingleMakeupTypeEyelash:{
            self.makeup.intensityEyelash = singleMakeupModel.realValue;
        }
            break;
        case FUSingleMakeupTypeHighlight:{
            self.makeup.intensityHighlight = singleMakeupModel.realValue;
        }
            break;
        case FUSingleMakeupTypeShadow:{
            self.makeup.intensityShadow = singleMakeupModel.realValue;
        }
            break;
        case FUSingleMakeupTypePupil:{
            self.makeup.intensityPupil = singleMakeupModel.realValue;
        }
            break;
    }
}

- (void)updateCustomizedSingleMakeup:(FUSingleMakeupModel *)model {
    if (!model.bundleName) {
        return;
    }
    if (!self.makeup) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"face_makeup" ofType:@"bundle"];
        self.makeup = [[FUMakeup alloc] initWithPath:path name:@"makeup"];
        [FURenderKit shareRenderKit].makeup = self.makeup;
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:model.bundleName ofType:@"bundle"];
    FUItem *item = [[FUItem alloc] initWithPath:path name:model.bundleName];
    switch (model.type) {
        case FUSingleMakeupTypeFoundation:{
            self.makeup.subFoundation = item;
        }
            break;
        case FUSingleMakeupTypeLip:{
            self.makeup.subLip = item;
        }
            break;
        case FUSingleMakeupTypeBlusher:{
            self.makeup.subBlusher = item;
        }
            break;
        case FUSingleMakeupTypeEyebrow:{
            self.makeup.subEyebrow = item;
            self.makeup.browWarp = model.isBrowWarp;
            self.makeup.browWarpType = model.browWarpType;
        }
            break;
        case FUSingleMakeupTypeEyeshadow:{
            self.makeup.subEyeshadow = item;
        }
            break;
        case FUSingleMakeupTypeEyeliner:{
            self.makeup.subEyeliner = item;
        }
            break;
        case FUSingleMakeupTypeEyelash:{
            self.makeup.subEyelash = item;
        }
            break;
        case FUSingleMakeupTypeHighlight:{
            self.makeup.subHighlight = item;
        }
            break;
        case FUSingleMakeupTypeShadow:{
            self.makeup.subShadow = item;
        }
            break;
        case FUSingleMakeupTypePupil:{
            self.makeup.subPupil = item;
        }
            break;
    }
}

- (void)updateColorOfCustomizedSingleMakeup:(FUSingleMakeupModel *)model {
    NSArray *colorValues = model.colors[model.defaultColorIndex];
    FUColor color = FUColorMake([colorValues[0] doubleValue], [colorValues[1] doubleValue], [colorValues[2] doubleValue], [colorValues[3] doubleValue]);
    switch (model.type) {
        case FUSingleMakeupTypeFoundation:{
            self.makeup.foundationColor = color;
        }
            break;
        case FUSingleMakeupTypeLip:{
            self.makeup.lipColor = color;
        }
            break;
        case FUSingleMakeupTypeBlusher:{
            self.makeup.blusherColor = color;
        }
            break;
        case FUSingleMakeupTypeEyebrow:{
            self.makeup.eyebrowColor = color;
        }
            break;
        case FUSingleMakeupTypeEyeshadow:{
            NSArray *values0 = [model.colors[model.defaultColorIndex] subarrayWithRange:NSMakeRange(0, 4)];
            NSArray *values2 = [model.colors[model.defaultColorIndex] subarrayWithRange:NSMakeRange(4, 4)];
            NSArray *values3 = [model.colors[model.defaultColorIndex] subarrayWithRange:NSMakeRange(8, 4)];
            [self.makeup setEyeColor:FUColorMake([values0[0] doubleValue], [values0[1] doubleValue], [values0[2] doubleValue], [values0[3] doubleValue])
                              color1:FUColorMake(0, 0, 0, 0)
                              color2:FUColorMake([values2[0] doubleValue], [values2[1] doubleValue], [values2[2] doubleValue], [values2[3] doubleValue])
                              color3:FUColorMake([values3[0] doubleValue], [values3[1] doubleValue], [values3[2] doubleValue], [values3[3] doubleValue])];
        }
            break;
        case FUSingleMakeupTypeEyeliner:{
            self.makeup.eyelinerColor = color;
        }
            break;
        case FUSingleMakeupTypeEyelash:{
            self.makeup.eyelashColor = color;
        }
            break;
        case FUSingleMakeupTypeHighlight:{
            self.makeup.highlightColor = color;
        }
            break;
        case FUSingleMakeupTypeShadow:{
            self.makeup.shadowColor = color;
        }
            break;
        case FUSingleMakeupTypePupil:{
            self.makeup.pupilColor = color;
        }
            break;
    }
}

- (void)compareCustomizedMakeupsWithCurrentCombinationMakeup {
    if (!self.currentCombinationMakeupModel) {
        return;
    }
    for (FUMakeupModel *makeupModel in self.makeups) {
        // 清除自定义妆容选择
        makeupModel.selectedIndex = 0;
    }
    if (![self.currentCombinationMakeupModel.name isEqualToString:@"卸妆"]) {
        // 选择组合妆进入自定义，需要对比各个妆容
        for (FUSingleMakeupType type = FUSingleMakeupTypeFoundation; type <= FUSingleMakeupTypePupil; type++) {
            // 组合妆的单个妆容
            FUSingleMakeupModel *combinationSingleMakeup = self.currentCombinationMakeupModel.singleMakeupArray[type];
            // 自定义可选单个妆容数组
            NSArray *customizedSingleMakeups = self.makeups[type].singleMakeups;
            switch (type) {
                case FUSingleMakeupTypeFoundation:{
                    // 粉底的类型和颜色都用颜色确定，粉底颜色索引和类型索引一致，json文件已经写死
                    for (NSInteger tempIndex = 0; tempIndex < customizedSingleMakeups.count; tempIndex++) {
                        FUSingleMakeupModel *singleMakeup = customizedSingleMakeups[tempIndex];
                        NSInteger index = [self indexOfColor:combinationSingleMakeup.colorsArray inArray:singleMakeup.colors];
                        if (index >= 0) {
                            self.makeups[type].selectedIndex = index + 1;
                            FUSingleMakeupModel *needChangeModel = customizedSingleMakeups[index + 1];
                            needChangeModel.value = combinationSingleMakeup.value * self.currentCombinationMakeupModel.value;
                            break;
                        }
                    }
                }
                    break;
                case FUSingleMakeupTypeLip:{
                    for (NSInteger tempIndex = 0; tempIndex < customizedSingleMakeups.count; tempIndex++) {
                        FUSingleMakeupModel *singleMakeup = customizedSingleMakeups[tempIndex];
                        if (singleMakeup.title && singleMakeup.isTwoColorLip == combinationSingleMakeup.isTwoColorLip && singleMakeup.lipType == combinationSingleMakeup.lipType) {
                            // 确定选中的口红类型
                            self.makeups[type].selectedIndex = tempIndex;
                            singleMakeup.value = combinationSingleMakeup.value * self.currentCombinationMakeupModel.value;
                            // 确定选中的口红颜色
                            NSInteger index = [self indexOfColor:combinationSingleMakeup.colorsArray inArray:singleMakeup.colors];
                            if (index >= 0) {
                                singleMakeup.defaultColorIndex = index;
                            } else {
                                singleMakeup.defaultColorIndex = 0;
                            }
                            break;
                        }
                    }
                }
                    break;
                case FUSingleMakeupTypeEyebrow:{
                    for (NSInteger tempIndex = 0; tempIndex < customizedSingleMakeups.count; tempIndex++) {
                        FUSingleMakeupModel *singleMakeup = customizedSingleMakeups[tempIndex];
                        if (singleMakeup.title && singleMakeup.browWarpType == combinationSingleMakeup.browWarpType && singleMakeup.isBrowWarp == combinationSingleMakeup.isBrowWarp) {
                            // 确定选中的眉毛类型
                            self.makeups[type].selectedIndex = tempIndex;
                            singleMakeup.value = combinationSingleMakeup.value * self.currentCombinationMakeupModel.value;
                            // 确定选中的眉毛颜色索引
                            NSInteger index = [self indexOfColor:combinationSingleMakeup.colorsArray inArray:singleMakeup.colors];
                            if (index >= 0) {
                                singleMakeup.defaultColorIndex = index;
                            } else {
                                singleMakeup.defaultColorIndex = 0;
                            }
                            break;
                        }
                    }
                }
                    break;
                default:{
                    // 注：组合妆json文件中眼影存在bundle名不对应的问题，修改了允许自定义的五个组合妆json文件，增加了"tex_eye_bundle"，原"tex_eye"保持不变，所以其他妆容都可以使用bundle名确定选中类型
                    for (NSInteger tempIndex = 0; tempIndex < customizedSingleMakeups.count; tempIndex++) {
                        FUSingleMakeupModel *singleMakeup = customizedSingleMakeups[tempIndex];
                        if (!combinationSingleMakeup.bundleName || !singleMakeup.bundleName) {
                            continue;
                        }
                        if ([combinationSingleMakeup.bundleName containsString:singleMakeup.bundleName]) {
                            // 使用bundle名确定选中类型
                            self.makeups[type].selectedIndex = tempIndex;
                            singleMakeup.value = combinationSingleMakeup.value * self.currentCombinationMakeupModel.value;
                            // 确定选中的妆容颜色索引
                            NSInteger index = [self indexOfColor:combinationSingleMakeup.colorsArray inArray:singleMakeup.colors];
                            if (index >= 0) {
                                singleMakeup.defaultColorIndex = index;
                            } else {
                                singleMakeup.defaultColorIndex = 0;
                            }
                            break;
                        }
                        
                    }
                }
                    break;
            }
        }
    }
}

#pragma mark - Private methods

/// 更新组合妆（老组合妆方法）
/// @param bundleName bundle名称
- (void)loadCombinationMakeupWithBundleName:(NSString *)bundleName {
    NSString *path = [[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"];
    FUItem *item = [[FUItem alloc] initWithPath:path name:bundleName];
    [self.makeup updateMakeupPackage:item needCleanSubItem:YES];
}

/// 获取颜色值在可选颜色数组中的索引
- (NSInteger)indexOfColor:(NSArray *)color inArray:(NSArray *)colors {
    if (!color || color.count == 0 || !colors || colors.count == 0) {
        return -1;
    }
    NSInteger resultIndex = -1;
    for (NSInteger i = 0; i < colors.count; i++) {
        NSArray *tempArray = colors[i];
        if ([self color:tempArray isEqualToColor:color]) {
            resultIndex = i;
            break;
        }
    }
    return resultIndex;
}

/// 对比两个颜色值是否一样
- (BOOL)color:(NSArray *)color isEqualToColor:(NSArray *)otherColor {
    NSInteger count = MIN(color.count, otherColor.count);
    for (NSInteger index = 0; index < count; index ++) {
        if (fabsf([color[index] floatValue] - [otherColor[index] floatValue]) > 0.01 ) {
            // 色值不同
            return NO;
        }
    }
    return YES;
}

#pragma mark - Override methods

- (void)releaseItem {
    [FURenderKit shareRenderKit].makeup = nil;
}

#pragma mark - Getters

/// 组合妆数组（包含子妆数据）
- (NSArray<FUCombinationMakeupModel *> *)combinationMakeups {
    if (!_combinationMakeups) {
        NSDictionary *combinationMakeupParams = [[FULocalDataManager makeupWholeJsonData] copy];
        _combinationMakeups = [FUCombinationMakeupModel mj_objectArrayWithKeyValuesArray:combinationMakeupParams[@"data"]];
        for (FUCombinationMakeupModel *model in _combinationMakeups) {
            @autoreleasepool {
                // 对应组合妆json文件
                NSString *path = [[NSBundle mainBundle] pathForResource:model.bundleName ofType:@"json"];
                NSData *data = [[NSData alloc] initWithContentsOfFile:path];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                // 初始化子妆容数组（保存不同子妆容模型）
                NSMutableArray *singleMakeups = [[NSMutableArray alloc] init];
                for (FUSingleMakeupType type = FUSingleMakeupTypeFoundation; type <= FUSingleMakeupTypePupil; type ++) {
                    FUSingleMakeupModel *singleMakeupModel = [[FUSingleMakeupModel alloc] init];
                    singleMakeupModel.type = type;
                    switch (type) {
                        case FUSingleMakeupTypeFoundation:{
                            singleMakeupModel.bundleName = dic[@"tex_foundation"];
                            singleMakeupModel.value  = [dic[@"makeup_intensity_foundation"] floatValue];
                            singleMakeupModel.colorsArray = dic[@"makeup_foundation_color"];
                        }
                            break;
                        case FUSingleMakeupTypeLip:{
                            singleMakeupModel.value  = [dic[@"makeup_intensity_lip"] floatValue];
                            singleMakeupModel.colorsArray = dic[@"makeup_lip_color"];
                            singleMakeupModel.isTwoColorLip = [dic[@"is_two_color"] boolValue];
                            singleMakeupModel.lipType = [dic[@"lip_type"] integerValue];
                        }
                            break;
                        case FUSingleMakeupTypeBlusher:{
                            singleMakeupModel.bundleName = dic[@"tex_blusher"];
                            singleMakeupModel.value  = [dic[@"makeup_intensity_blusher"] floatValue];
                            singleMakeupModel.colorsArray = dic[@"makeup_blusher_color"];
                        }
                            break;
                        case FUSingleMakeupTypeEyebrow:{
                            singleMakeupModel.bundleName = dic[@"tex_brow"];
                            singleMakeupModel.isBrowWarp = [dic[@"brow_warp"] boolValue];
                            singleMakeupModel.browWarpType = [dic[@"brow_warp_type"] integerValue];
                            singleMakeupModel.value  = [dic[@"makeup_intensity_eyeBrow"] floatValue];
                            singleMakeupModel.colorsArray = dic[@"makeup_eyeBrow_color"];
                        }
                            break;
                        case FUSingleMakeupTypeEyeshadow:{
                            // 允许自定义组合妆json文件新加了key：tex_eye_bundle，为了准确判断眼影类型
                            singleMakeupModel.bundleName = dic[@"tex_eye_bundle"] ?: dic[@"tex_eye"];
                            singleMakeupModel.value  = [dic[@"makeup_intensity_eye"] floatValue];
                            singleMakeupModel.colorsArray = dic[@"makeup_eye_color"];
                        }
                            break;
                        case FUSingleMakeupTypeEyeliner:{
                            singleMakeupModel.bundleName = dic[@"tex_eyeLiner"];
                            singleMakeupModel.value  = [dic[@"makeup_intensity_eyeLiner"] floatValue];
                            singleMakeupModel.colorsArray = dic[@"makeup_eyeLiner_color"];
                        }
                            break;
                        case FUSingleMakeupTypeEyelash:{
                            singleMakeupModel.bundleName = dic[@"tex_eyeLash"];
                            singleMakeupModel.value  = [dic[@"makeup_intensity_eyelash"] floatValue];
                            singleMakeupModel.colorsArray = dic[@"makeup_eyelash_color"];
                        }
                            break;
                        case FUSingleMakeupTypeHighlight:{
                            singleMakeupModel.bundleName = dic[@"tex_highlight"];
                            singleMakeupModel.value  = [dic[@"makeup_intensity_highlight"] floatValue];
                            singleMakeupModel.colorsArray = dic[@"makeup_highlight_color"];
                        }
                            break;
                        case FUSingleMakeupTypeShadow:{
                            singleMakeupModel.bundleName = dic[@"tex_shadow"];
                            singleMakeupModel.value  = [dic[@"makeup_intensity_shadow"] floatValue];
                            singleMakeupModel.colorsArray = dic[@"makeup_shadow_color"];
                        }
                            break;
                        case FUSingleMakeupTypePupil:{
                            singleMakeupModel.bundleName = dic[@"tex_pupil"];
                            singleMakeupModel.value  = [dic[@"makeup_intensity_pupil"] floatValue];
                            singleMakeupModel.colorsArray = dic[@"makeup_pupil_color"];
                        }
                            break;
                    }
                    [singleMakeups addObject:singleMakeupModel];
                }
                model.singleMakeupArray = [singleMakeups copy];
            }
            
        }
    }
    return _combinationMakeups;
}

- (NSArray<FUMakeupModel *> *)makeups {
    if (!_makeups) {
        NSDictionary *makeupParams = [NSDictionary dictionaryWithDictionary:[FULocalDataManager makeupJsonData]];
        _makeups = [FUMakeupModel mj_objectArrayWithKeyValuesArray:makeupParams[@"data"]];
    }
    return _makeups;
}

- (BOOL)isChangedMakeup {
    if (!self.currentCombinationMakeupModel || [self.currentCombinationMakeupModel.name isEqualToString:@"卸妆"]) {
        // 只需要判断自定义妆容是否有值
        for (FUMakeupModel *model in self.makeups) {
            if (model.selectedIndex > 0 && model.singleMakeups[model.selectedIndex].value > 0) {
                return YES;
            }
        }
        return NO;
    } else {
        // 对比各个妆容
        for (FUSingleMakeupType type = FUSingleMakeupTypeFoundation; type <= FUSingleMakeupTypePupil; type++) {
            FUSingleMakeupModel *combinationSingleMakeup = self.currentCombinationMakeupModel.singleMakeupArray[type];
            NSArray *customizedSingleMakeups = self.makeups[type].singleMakeups;
            FUSingleMakeupModel *selectedSingleMakeup = customizedSingleMakeups[self.makeups[type].selectedIndex];
            BOOL isSameColor = YES;
            if (selectedSingleMakeup.colors.count > 0 && combinationSingleMakeup.colorsArray) {
                isSameColor = [self color:selectedSingleMakeup.colors[selectedSingleMakeup.defaultColorIndex] isEqualToColor:combinationSingleMakeup.colorsArray];
            }
            BOOL isSameIntensity = fabs(selectedSingleMakeup.value - self.currentCombinationMakeupModel.value * combinationSingleMakeup.value) <= 0.01;
            switch (type) {
                case FUSingleMakeupTypeFoundation:{
                    // 粉底只需要对比颜色和程度值
                    if (!isSameColor || !isSameIntensity) {
                        return YES;
                    }
                }
                    break;
                case FUSingleMakeupTypeLip:{
                    // 对比口红类型、颜色、程度值
                    if (selectedSingleMakeup.lipType != combinationSingleMakeup.lipType || !isSameColor || !isSameIntensity) {
                        return YES;
                    }
                }
                    break;
                case FUSingleMakeupTypeEyebrow:{
                    // 对比眉毛类型、颜色、程度值
                    if (selectedSingleMakeup.browWarpType != combinationSingleMakeup.browWarpType || !isSameColor || !isSameIntensity) {
                        return YES;
                    }
                }
                    break;
                default: {
                    // 其他妆容对比bundle名、颜色索引和程度值
                    // 注：存在组合妆的子妆颜色不存在于可选颜色数组中的情况，所以这里对比颜色索引，取不到索引默认为0
                    if (!combinationSingleMakeup.bundleName && !selectedSingleMakeup.bundleName) {
                        continue;
                    }
                    if (combinationSingleMakeup.bundleName && !selectedSingleMakeup.bundleName) {
                        return YES;
                    }
                    if (!combinationSingleMakeup.bundleName && selectedSingleMakeup.bundleName) {
                        return YES;
                    }
                    if (![combinationSingleMakeup.bundleName containsString:selectedSingleMakeup.bundleName]) {
                        return YES;
                    }
                    NSInteger colorIndex = [self indexOfColor:combinationSingleMakeup.colorsArray inArray:selectedSingleMakeup.colors];
                    if (colorIndex == -1) {
                        colorIndex = 0;
                    }
                    if (colorIndex != selectedSingleMakeup.defaultColorIndex || !isSameIntensity) {
                        return YES;
                    }
                }
                    break;
            }
        }
    }
    
    return NO;
}

@end
