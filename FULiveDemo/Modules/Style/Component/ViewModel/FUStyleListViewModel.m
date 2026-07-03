//
//  FUStyleListViewModel.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/11/7.
//

#import "FUStyleListViewModel.h"
#import "FUStyleModel.h"

static NSString * const FUPersistentStylesKey = @"FUPersistentStyles";
static NSString * const FUPersistentSelectedStyleIndexKey = @"FUPersistentSelectedStyleIndex";
static NSString * const FUPersistentStyleDataMigrationVersionKey = @"FUPersistentStyleDataMigrationVersion";
static NSString * const FUStyleDataMigrationVersion_9_0_0 = @"9.0.0";
static NSString * const FUStyleDataMigrationVersion_9_0_1 = @"9.0.1";
static NSString * const FUDefaultStyleName = @"气质";

@interface FUStyleListViewModel ()

@property (nonatomic, copy) NSArray<FUStyleModel *> *styles;

@property (nonatomic, assign) FUDevicePerformanceLevel performanceLevel;

@end

@implementation FUStyleListViewModel

#pragma mark - Initializer

- (instancetype)init {
    self = [super init];
    if (self) {
        self.performanceLevel = [FURenderKit devicePerformanceLevel];
        if (![FURenderKit shareRenderKit].beauty) {
            // 加载默认美颜效果
            NSString *path = [[NSBundle mainBundle] pathForResource:@"face_beautification" ofType:@"bundle"];
            FUBeauty *beauty = [[FUBeauty alloc] initWithPath:path name:@"FUBeauty"];
            // 默认均匀磨皮
            beauty.blurType = 3;
            if (self.performanceLevel >= FUDevicePerformanceLevelHigh) {
                // 高性能设备设置去黑眼圈、去法令纹、大眼、嘴型最新效果
                [beauty addPropertyMode:FUBeautyPropertyMode2 forKey:FUModeKeyRemovePouchStrength];
                [beauty addPropertyMode:FUBeautyPropertyMode2 forKey:FUModeKeyRemoveNasolabialFoldsStrength];
                [beauty addPropertyMode:FUBeautyPropertyMode3 forKey:FUModeKeyEyeEnlarging];
                [beauty addPropertyMode:FUBeautyPropertyMode3 forKey:FUModeKeyIntensityMouth];
            }
            [FURenderKit shareRenderKit].beauty = beauty;
        }
        NSArray<FUStyleModel *> *defaultStyles = [self defaultStyles];
        NSArray<FUStyleModel *> *localStyles = nil;
        BOOL hasLocalStyles = [[NSUserDefaults standardUserDefaults] objectForKey:FUPersistentStylesKey] != nil;
        if (hasLocalStyles) {
            localStyles = [self localStyles];
            self.styles = [self mergedStylesWithLocal:localStyles defaultStyles:defaultStyles];
        } else {
            self.styles = defaultStyles;
        }
        
        BOOL needsRound2Migration = ![self hasCompletedStyleDataMigration];
        if (needsRound2Migration && hasLocalStyles) {
            self.styles = [self applyRound2StyleParameterRefreshWithStyles:self.styles defaultStyles:defaultStyles];
        }
        
        NSUInteger persistedSelectedIndex = 0;
        BOOL hasPersistedSelectedIndex = [[NSUserDefaults standardUserDefaults] objectForKey:FUPersistentSelectedStyleIndexKey] != nil;
        if (hasPersistedSelectedIndex) {
            persistedSelectedIndex = [[NSUserDefaults standardUserDefaults] integerForKey:FUPersistentSelectedStyleIndexKey];
        }
        BOOL needsStyleDataMigration = ![self hasCompletedStyleDataMigration];
        BOOL needsStructureMigration = hasLocalStyles && [self styles:self.styles needMigrationFromLocal:localStyles defaultStyles:defaultStyles];
        BOOL needsRound2Persist = needsRound2Migration && hasLocalStyles;
        BOOL needsLegacyIndexOffset = needsStyleDataMigration && !hasLocalStyles && hasPersistedSelectedIndex;
        NSUInteger selectedIndex = hasPersistedSelectedIndex ? persistedSelectedIndex : [self defaultStyleIndexInStyles:self.styles];
        selectedIndex = [self migratedSelectedIndexFromPersistedIndex:selectedIndex localStyles:localStyles styles:self.styles needsLegacyIndexOffset:needsLegacyIndexOffset];
        [self selectStyleAtIndex:selectedIndex completion:nil];
        
        BOOL isNewUser = !hasLocalStyles && !hasPersistedSelectedIndex;
        BOOL dataAlreadyMigrated = hasLocalStyles && !needsStructureMigration;
        if (needsStructureMigration || needsRound2Persist) {
            [self saveStylesPersistently];
            [self markStyleDataMigrationCompleted];
        } else if (hasPersistedSelectedIndex && selectedIndex != persistedSelectedIndex) {
            [[NSUserDefaults standardUserDefaults] setInteger:selectedIndex forKey:FUPersistentSelectedStyleIndexKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self markStyleDataMigrationCompleted];
        } else if (needsStyleDataMigration && (dataAlreadyMigrated || isNewUser)) {
            [self markStyleDataMigrationCompleted];
        }
        self.selectedStyleFunction = FUStyleFunctionMakeup;
    }
    return self;
}

#pragma mark - Instance methods

- (void)selectStyleAtIndex:(NSUInteger)index completion:(void (^)(void))completion {
    if (index >= self.styles.count) {
        return;
    }
    _selectedIndex = index;
    FUStyleModel *style = self.styles[index];
    
    [FURenderQueue async:^{
        // 妆容
        if (style.makeupModel.bundleName) {
            FUMakeup *makeup = [[FUMakeup alloc] initWithPath:[[NSBundle mainBundle] pathForResource:style.makeupModel.bundleName ofType:@"bundle"] name:@"style_makeup"];
            // 高端机打开全脸分割
            makeup.makeupSegmentation = self.performanceLevel >= FUDevicePerformanceLevelHigh;
            makeup.intensity = style.makeupModel.currentValue;
            makeup.filterIntensity = style.makeupModel.filterCurrentValue;
            [FURenderKit shareRenderKit].makeup = makeup;
        } else {
            [FURenderKit shareRenderKit].makeup = nil;
        }
        // 美肤
        if (style.isSkinDisabled) {
            for (FUStyleSkinModel *model in style.skins) {
                [self setSkinValue:0 forType:model.type];
            }
        } else {
            for (FUStyleSkinModel *skin in style.skins) {
                if (skin.performanceLevel > self.performanceLevel) {
                    // 机型性能要求高于当前设备性能，则设置为无效果值
                    [self setSkinValue:0 forType:skin.type];
                } else {
                    [self setSkinValue:skin.currentValue forType:skin.type];
                }
            }
        }
        
        // 皮肤分割
        if (!style.isSkinDisabled && style.skinSegmentationEnabled) {
            [FURenderKit shareRenderKit].beauty.enableSkinSegmentation = YES;
        } else {
            [FURenderKit shareRenderKit].beauty.enableSkinSegmentation = NO;
        }
        
        // 美型
        if (style.isShapeDisabled) {
            for (FUStyleShapeModel *model in style.shapes) {
                [self setShapeValue:model.defaultValueInMiddle ? 0.5 : 0 forType:model.type];
            }
        } else {
            for (FUStyleShapeModel *shape in style.shapes) {
                if (shape.performanceLevel > self.performanceLevel) {
                    // 机型性能要求高于当前设备性能，则设置为无效果值
                    [self setShapeValue:shape.defaultValueInMiddle ? 0.5 : 0 forType:shape.type];
                } else {
                    [self setShapeValue:shape.currentValue forType:shape.type];
                }
            }
        }
        
        
        !completion ?: completion();
    }];
}

- (void)resetToDefault {
    // 恢复所有风格属性
    for (FUStyleModel *style in self.styles) {
        style.makeupModel.currentValue = style.makeupModel.defaultValue;
        style.makeupModel.filterCurrentValue = style.makeupModel.filterDefaultValue;
        style.isSkinDisabled = NO;
        style.isShapeDisabled = NO;
        for (FUStyleSkinModel *skin in style.skins) {
            skin.currentValue = skin.defaultValue;
        }
        for (FUStyleShapeModel *shape in style.shapes) {
            shape.currentValue = shape.defaultValue;
        }
    }
    // 恢复当前选中风格索引
    [self selectStyleAtIndex:[self defaultStyleIndexInStyles:self.styles] completion:nil];
    // 恢复默认选择妆容功能
    self.selectedStyleFunction = FUStyleFunctionMakeup;
}

- (NSString *)styleNameAtIndex:(NSUInteger)index {
    FUStyleModel *style = self.styles[index];
    return style.name;
}

- (void)saveStylesPersistently {
    NSArray *styleData = [self.styles yy_modelToJSONObject];
    [[NSUserDefaults standardUserDefaults] setObject:styleData forKey:FUPersistentStylesKey];
    [[NSUserDefaults standardUserDefaults] setInteger:self.selectedIndex forKey:FUPersistentSelectedStyleIndexKey];
}

#pragma mark - Private methods

- (void)setSkinValue:(double)value forType:(FUStyleCustomizingSkinType)type {
    switch (type) {
        case FUStyleCustomizingSkinTypeBlurLevel:
            [FURenderKit shareRenderKit].beauty.blurLevel = value;
            break;
        case FUStyleCustomizingSkinTypeColorLevel:
            [FURenderKit shareRenderKit].beauty.colorLevel = value;
            break;
        case FUStyleCustomizingSkinTypeRedLevel:
            [FURenderKit shareRenderKit].beauty.redLevel = value;
            break;
        case FUStyleCustomizingSkinTypeSharpen:
            [FURenderKit shareRenderKit].beauty.sharpen = value;
            break;
        case FUStyleCustomizingSkinTypeFaceThreed:
            [FURenderKit shareRenderKit].beauty.faceThreed = value;
            break;
        case FUStyleCustomizingSkinTypeEyeBright:
            [FURenderKit shareRenderKit].beauty.eyeBright = value;
            break;
        case FUStyleCustomizingSkinTypeToothWhiten:
            [FURenderKit shareRenderKit].beauty.toothWhiten = value;
            break;
        case FUStyleCustomizingSkinTypeRemovePouchStrength:
            [FURenderKit shareRenderKit].beauty.removePouchStrength = value;
            break;
        case FUStyleCustomizingSkinTypeRemoveNasolabialFoldsStrength:
            [FURenderKit shareRenderKit].beauty.removeNasolabialFoldsStrength = value;
            break;
        case FUStyleCustomizingSkinTypeAntiAcneSpot:
            [FURenderKit shareRenderKit].beauty.antiAcneSpot = value;
            break;
        case FUStyleCustomizingSkinTypeClarity:
            [FURenderKit shareRenderKit].beauty.clarity = value;
            break;
        case FUStyleCustomizingSkinTypeBodyBlurLevel:
            [[FURenderKit shareRenderKit].beauty setParam:@(value) forName:@"body_blur_level" paramType:FUParamTypeDouble];
            break;
        case FUStyleCustomizingSkinTypeFacialPlump:
            [[FURenderKit shareRenderKit].beauty setParam:@(value) forName:@"facial_plump" paramType:FUParamTypeDouble];
            break;
    }
}

- (void)setShapeValue:(double)value forType:(FUStyleCustomizingShapeType)type {
    switch (type) {
        case FUStyleCustomizingShapeTypeCheekThinning:
            [FURenderKit shareRenderKit].beauty.cheekThinning = value;
            break;
        case FUStyleCustomizingShapeTypeCheekV:
            [FURenderKit shareRenderKit].beauty.cheekV = value;
            break;
        case FUStyleCustomizingShapeTypeCheekNarrow:
            [FURenderKit shareRenderKit].beauty.cheekNarrow = value;
            break;
        case FUStyleCustomizingShapeTypeCheekShort:
            [FURenderKit shareRenderKit].beauty.cheekShort = value;
            break;
        case FUStyleCustomizingShapeTypeCheekSmall:
            [FURenderKit shareRenderKit].beauty.cheekSmall = value;
            break;
        case FUStyleCustomizingShapeTypeCheekbones:
            [FURenderKit shareRenderKit].beauty.intensityCheekbones = value;
            break;
        case FUStyleCustomizingShapeTypeLowerJaw:
            [FURenderKit shareRenderKit].beauty.intensityLowerJaw = value;
            break;
        case FUStyleCustomizingShapeTypeEyeEnlarging:
            [FURenderKit shareRenderKit].beauty.eyeEnlarging = value;
            break;
        case FUStyleCustomizingShapeTypeEyeCircle:
            [FURenderKit shareRenderKit].beauty.intensityEyeCircle = value;
            break;
        case FUStyleCustomizingShapeTypeChin:
            [FURenderKit shareRenderKit].beauty.intensityChin = value;
            break;
        case FUStyleCustomizingShapeTypeForehead:
            [FURenderKit shareRenderKit].beauty.intensityForehead = value;
            break;
        case FUStyleCustomizingShapeTypeNose:
            [FURenderKit shareRenderKit].beauty.intensityNose = value;
            break;
        case FUStyleCustomizingShapeTypeMouth:
            [FURenderKit shareRenderKit].beauty.intensityMouth = value;
            break;
        case FUStyleCustomizingShapeTypeLipThick:
            [FURenderKit shareRenderKit].beauty.intensityLipThick = value;
            break;
        case FUStyleCustomizingShapeTypeEyeHeight:
            [FURenderKit shareRenderKit].beauty.intensityEyeHeight = value;
            break;
        case FUStyleCustomizingShapeTypeCanthus:
            [FURenderKit shareRenderKit].beauty.intensityCanthus = value;
            break;
        case FUStyleCustomizingShapeTypeEyeLid:
            [FURenderKit shareRenderKit].beauty.intensityEyeLid = value;
            break;
        case FUStyleCustomizingShapeTypeEyeSpace:
            [FURenderKit shareRenderKit].beauty.intensityEyeSpace = value;
            break;
        case FUStyleCustomizingShapeTypeEyeRotate:
            [FURenderKit shareRenderKit].beauty.intensityEyeRotate = value;
            break;
        case FUStyleCustomizingShapeTypeLongNose:
            [FURenderKit shareRenderKit].beauty.intensityLongNose = value;
            break;
        case FUStyleCustomizingShapeTypePhiltrum:
            [FURenderKit shareRenderKit].beauty.intensityPhiltrum = value;
            break;
        case FUStyleCustomizingShapeTypeSmile:
            [FURenderKit shareRenderKit].beauty.intensitySmile = value;
            break;
        case FUStyleCustomizingShapeTypeBrowHeight:
            [FURenderKit shareRenderKit].beauty.intensityBrowHeight = value;
            break;
        case FUStyleCustomizingShapeTypeBrowSpace:
            [FURenderKit shareRenderKit].beauty.intensityBrowSpace = value;
            break;
        case FUStyleCustomizingShapeTypeBrowThick:
            [FURenderKit shareRenderKit].beauty.intensityBrowThick = value;
            break;
        case FUStyleCustomizingShapeTypeEyePupil:
            [[FURenderKit shareRenderKit].beauty setParam:@(value) forName:@"intensity_eye_pupil" paramType:FUParamTypeDouble];
            break;
    }
}


#pragma mark - Setters

- (void)setSelectedMakeupValue:(double)selectedMakeupValue {
    self.styles[self.selectedIndex].makeupModel.currentValue = selectedMakeupValue;
    if (![FURenderKit shareRenderKit].makeup) {
        return;
    }
    [FURenderKit shareRenderKit].makeup.intensity = selectedMakeupValue;
}

- (void)setSelectedMakeupFilterValue:(double)selectedMakeupFilterValue {
    self.styles[self.selectedIndex].makeupModel.filterCurrentValue = selectedMakeupFilterValue;
    if (![FURenderKit shareRenderKit].makeup) {
        return;
    }
    [FURenderKit shareRenderKit].makeup.filterIntensity = selectedMakeupFilterValue;
}

#pragma mark - Getters

- (NSArray<FUStyleModel *> *)localStyles {
    NSArray *data = [[NSUserDefaults standardUserDefaults] objectForKey:FUPersistentStylesKey];
    NSArray *styles = [FUStyleModel modelArrayWithJSON:data];
    return [styles copy];
}

- (NSArray<FUStyleModel *> *)defaultStyles {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"style_list" ofType:@"json"];
    NSArray *styles = [FUStyleModel modelArrayWithJSON:[NSData dataWithContentsOfFile:path]];
    return [styles copy];
}

- (double)selectedMakeupValue {
    return self.styles[self.selectedIndex].makeupModel.currentValue;
}

- (double)selectedMakeupFilterValue {
    return self.styles[self.selectedIndex].makeupModel.filterCurrentValue;
}

- (BOOL)isDefault {
    if (self.selectedIndex != [self defaultStyleIndexInStyles:self.styles]) {
        // 选中的风格索引不是默认
        return NO;
    }
    __block BOOL result = YES;
    // 选中的风格索引是默认时需要比对各个风格的所有效果值
    [self.styles enumerateObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, self.styles.count - 1)] options:NSEnumerationConcurrent usingBlock:^(FUStyleModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.skinSegmentationEnabled) {
            // 皮肤分割开启
            result = NO;
            *stop = YES;
        }
        if ((int)(obj.makeupModel.currentValue * 100) != (int)(obj.makeupModel.defaultValue * 100) || (int)(obj.makeupModel.filterCurrentValue * 100) != (int)(obj.makeupModel.filterDefaultValue * 100)) {
            // 妆容程度值发生变化
            result = NO;
            *stop = YES;
        }
        if (obj.isSkinDisabled || obj.isShapeDisabled) {
            // 美肤或者美型效果关闭
            result = NO;
            *stop = YES;
        }
        for (FUStyleSkinModel *skinModel in obj.skins) {
            if ((int)(skinModel.currentValue / skinModel.ratio * 100) != (int)(skinModel.defaultValue / skinModel.ratio * 100)) {
                // 美肤效果值有变化
                result = NO;
                break;
            }
        }
        for (FUStyleShapeModel *shapeModel in obj.shapes) {
            int currentIntValue = shapeModel.defaultValueInMiddle ? (int)(shapeModel.currentValue * 100 - 50) : (int)(shapeModel.currentValue * 100);
            int defaultIntValue = shapeModel.defaultValueInMiddle ? (int)(shapeModel.defaultValue * 100 - 50) : (int)(shapeModel.defaultValue * 100);
            if (currentIntValue != defaultIntValue) {
                // 美型效果值有变化
                result = NO;
                break;
            }
        }
        if (!result) {
            *stop = YES;
        }
    }];
    return result;
}

#pragma mark - Migration

- (BOOL)hasCompletedStyleDataMigration {
    return [[[NSUserDefaults standardUserDefaults] stringForKey:FUPersistentStyleDataMigrationVersionKey] isEqualToString:FUStyleDataMigrationVersion_9_0_1];
}

- (void)markStyleDataMigrationCompleted {
    [[NSUserDefaults standardUserDefaults] setObject:FUStyleDataMigrationVersion_9_0_1 forKey:FUPersistentStyleDataMigrationVersionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray<NSString *> *)round2RefreshedStyleNames {
    return @[@"白开水", @"甜心派", @"混血baby"];
}

- (NSArray<FUStyleModel *> *)applyRound2StyleParameterRefreshWithStyles:(NSArray<FUStyleModel *> *)styles defaultStyles:(NSArray<FUStyleModel *> *)defaultStyles {
    NSMutableDictionary<NSString *, FUStyleModel *> *defaultStylesByName = [NSMutableDictionary dictionary];
    for (FUStyleModel *style in defaultStyles) {
        defaultStylesByName[style.name] = style;
    }
    NSMutableArray<FUStyleModel *> *refreshedStyles = [NSMutableArray arrayWithCapacity:styles.count];
    for (FUStyleModel *style in styles) {
        if ([[self round2RefreshedStyleNames] containsObject:style.name]) {
            FUStyleModel *defaultStyle = defaultStylesByName[style.name];
            FUStyleModel *refreshedStyle = defaultStyle ? [self copyStyle:defaultStyle] : [self copyStyle:style];
            refreshedStyle.isSkinDisabled = style.isSkinDisabled;
            refreshedStyle.isShapeDisabled = style.isShapeDisabled;
            refreshedStyle.skinSegmentationEnabled = style.skinSegmentationEnabled;
            [refreshedStyles addObject:refreshedStyle];
        } else {
            [refreshedStyles addObject:style];
        }
    }
    return [refreshedStyles copy];
}

- (NSArray<NSString *> *)insertedStyleNamesForMigrationVersion_9_0_0 {
    return @[@"白开水", @"甜心派", @"混血baby"];
}

- (NSUInteger)legacyStyleIndexOffsetInStyles:(NSArray<FUStyleModel *> *)styles {
    NSUInteger offset = 0;
    for (NSString *name in [self insertedStyleNamesForMigrationVersion_9_0_0]) {
        if ([self indexOfStyleNamed:name inStyles:styles] == NSNotFound) {
            break;
        }
        offset++;
    }
    return offset;
}

- (NSUInteger)defaultStyleIndexInStyles:(NSArray<FUStyleModel *> *)styles {
    for (NSUInteger index = 0; index < styles.count; index++) {
        if ([styles[index].name isEqualToString:FUDefaultStyleName]) {
            return index;
        }
    }
    return MIN(4, styles.count > 0 ? styles.count - 1 : 0);
}

- (NSUInteger)migratedSelectedIndexFromPersistedIndex:(NSUInteger)persistedIndex localStyles:(NSArray<FUStyleModel *> *)localStyles styles:(NSArray<FUStyleModel *> *)styles needsLegacyIndexOffset:(BOOL)needsLegacyIndexOffset {
    if (styles.count == 0) {
        return 0;
    }
    if (localStyles.count > 0 && persistedIndex < localStyles.count) {
        NSString *styleName = localStyles[persistedIndex].name;
        NSUInteger migratedIndex = [self indexOfStyleNamed:styleName inStyles:styles];
        if (migratedIndex != NSNotFound) {
            return migratedIndex;
        }
    }
    if (needsLegacyIndexOffset && persistedIndex >= 1) {
        NSUInteger offset = [self legacyStyleIndexOffsetInStyles:styles];
        if (offset > 0) {
            NSUInteger offsetIndex = persistedIndex + offset;
            if (offsetIndex < styles.count) {
                return offsetIndex;
            }
        }
    }
    return MIN(persistedIndex, styles.count - 1);
}

- (NSUInteger)indexOfStyleNamed:(NSString *)name inStyles:(NSArray<FUStyleModel *> *)styles {
    for (NSUInteger index = 0; index < styles.count; index++) {
        if ([styles[index].name isEqualToString:name]) {
            return index;
        }
    }
    return NSNotFound;
}

- (NSArray<FUStyleModel *> *)mergedStylesWithLocal:(NSArray<FUStyleModel *> *)localStyles defaultStyles:(NSArray<FUStyleModel *> *)defaultStyles {
    NSMutableDictionary<NSString *, FUStyleModel *> *localStylesByName = [NSMutableDictionary dictionary];
    for (FUStyleModel *style in localStyles) {
        localStylesByName[style.name] = style;
    }
    NSMutableArray<FUStyleModel *> *mergedStyles = [NSMutableArray arrayWithCapacity:defaultStyles.count];
    for (FUStyleModel *defaultStyle in defaultStyles) {
        FUStyleModel *localStyle = localStylesByName[defaultStyle.name];
        if (localStyle) {
            [mergedStyles addObject:[self mergedStyleWithDefault:defaultStyle local:localStyle]];
        } else {
            [mergedStyles addObject:[self copyStyle:defaultStyle]];
        }
    }
    return [mergedStyles copy];
}

- (FUStyleModel *)copyStyle:(FUStyleModel *)style {
    return [FUStyleModel yy_modelWithJSON:[style yy_modelToJSONObject]];
}

- (FUStyleModel *)mergedStyleWithDefault:(FUStyleModel *)defaultStyle local:(FUStyleModel *)localStyle {
    FUStyleModel *mergedStyle = [self copyStyle:defaultStyle];
    mergedStyle.isSkinDisabled = localStyle.isSkinDisabled;
    mergedStyle.isShapeDisabled = localStyle.isShapeDisabled;
    mergedStyle.skinSegmentationEnabled = localStyle.skinSegmentationEnabled;
    if (localStyle.makeupModel) {
        mergedStyle.makeupModel.currentValue = localStyle.makeupModel.currentValue;
        mergedStyle.makeupModel.filterCurrentValue = localStyle.makeupModel.filterCurrentValue;
    }
    mergedStyle.skins = [self mergedStyleSkinsWithDefault:mergedStyle.skins local:localStyle.skins];
    mergedStyle.shapes = [self mergedStyleShapesWithDefault:mergedStyle.shapes local:localStyle.shapes];
    return mergedStyle;
}

- (NSArray<FUStyleSkinModel *> *)mergedStyleSkinsWithDefault:(NSArray<FUStyleSkinModel *> *)defaultSkins local:(NSArray<FUStyleSkinModel *> *)localSkins {
    NSMutableDictionary<NSNumber *, FUStyleSkinModel *> *localSkinsByType = [NSMutableDictionary dictionary];
    for (FUStyleSkinModel *skin in localSkins) {
        localSkinsByType[@(skin.type)] = skin;
    }
    for (FUStyleSkinModel *defaultSkin in defaultSkins) {
        FUStyleSkinModel *localSkin = localSkinsByType[@(defaultSkin.type)];
        if (localSkin) {
            defaultSkin.currentValue = localSkin.currentValue;
        }
    }
    return defaultSkins;
}

- (NSArray<FUStyleShapeModel *> *)mergedStyleShapesWithDefault:(NSArray<FUStyleShapeModel *> *)defaultShapes local:(NSArray<FUStyleShapeModel *> *)localShapes {
    NSMutableDictionary<NSNumber *, FUStyleShapeModel *> *localShapesByType = [NSMutableDictionary dictionary];
    for (FUStyleShapeModel *shape in localShapes) {
        localShapesByType[@(shape.type)] = shape;
    }
    for (FUStyleShapeModel *defaultShape in defaultShapes) {
        FUStyleShapeModel *localShape = localShapesByType[@(defaultShape.type)];
        if (localShape) {
            defaultShape.currentValue = localShape.currentValue;
        }
    }
    return defaultShapes;
}

- (BOOL)styles:(NSArray<FUStyleModel *> *)styles needMigrationFromLocal:(NSArray<FUStyleModel *> *)localStyles defaultStyles:(NSArray<FUStyleModel *> *)defaultStyles {
    if (styles.count != defaultStyles.count || localStyles.count != defaultStyles.count) {
        return YES;
    }
    for (FUStyleModel *defaultStyle in defaultStyles) {
        FUStyleModel *localStyle = nil;
        for (FUStyleModel *style in localStyles) {
            if ([style.name isEqualToString:defaultStyle.name]) {
                localStyle = style;
                break;
            }
        }
        if (!localStyle) {
            return YES;
        }
        if ([self style:localStyle missingSkinTypesFrom:defaultStyle] || [self style:localStyle missingShapeTypesFrom:defaultStyle]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)style:(FUStyleModel *)localStyle missingSkinTypesFrom:(FUStyleModel *)defaultStyle {
    NSMutableSet<NSNumber *> *localSkinTypes = [NSMutableSet set];
    for (FUStyleSkinModel *skin in localStyle.skins) {
        [localSkinTypes addObject:@(skin.type)];
    }
    for (FUStyleSkinModel *skin in defaultStyle.skins) {
        if (![localSkinTypes containsObject:@(skin.type)]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)style:(FUStyleModel *)localStyle missingShapeTypesFrom:(FUStyleModel *)defaultStyle {
    NSMutableSet<NSNumber *> *localShapeTypes = [NSMutableSet set];
    for (FUStyleShapeModel *shape in localStyle.shapes) {
        [localShapeTypes addObject:@(shape.type)];
    }
    for (FUStyleShapeModel *shape in defaultStyle.shapes) {
        if (![localShapeTypes containsObject:@(shape.type)]) {
            return YES;
        }
    }
    return NO;
}

@end
