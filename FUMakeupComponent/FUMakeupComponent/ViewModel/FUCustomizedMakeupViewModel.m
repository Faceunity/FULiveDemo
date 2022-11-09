//
//  FUCustomizedMakeupViewModel.m
//  FUMakeupComponent
//
//  Created by 项林平 on 2022/9/13.
//

#import "FUCustomizedMakeupViewModel.h"
#import "FUCustomizedMakeupModel.h"

#import <FURenderKit/FURenderKit.h>

@interface FUCustomizedMakeupViewModel ()

@property (nonatomic, copy) NSArray<FUCustomizedMakeupModel *> *customizedMakeups;

@end

@implementation FUCustomizedMakeupViewModel

#pragma mark - Instance methods

- (void)updateCustomizedMakeupsWithSubMakeupType:(FUSubMakeupType)type
                          selectedSubMakeupIndex:(NSUInteger)index
                          selectedSubMakeupValue:(double)value
                              selectedColorIndex:(NSUInteger)colorIndex {
    FUCustomizedMakeupModel *model = self.customizedMakeups[type];
    model.selectedSubMakeupIndex = index;
    FUSubMakeupModel *subModel = model.subMakeups[index];
    subModel.value = index == 0 ? 0.0 : value;
    subModel.defaultColorIndex = colorIndex;
}

- (NSUInteger)subMakeupIndexWithType:(FUSubMakeupType)type {
    return self.customizedMakeups[type].selectedSubMakeupIndex;
}

- (double)subMakeupValueWithType:(FUSubMakeupType)type {
    FUCustomizedMakeupModel *model = self.customizedMakeups[type];
    FUSubMakeupModel *subModel = model.subMakeups[model.selectedSubMakeupIndex];
    return subModel.value;
}

- (NSUInteger)subMakeupColorIndexWithType:(FUSubMakeupType)type {
    FUCustomizedMakeupModel *model = self.customizedMakeups[type];
    FUSubMakeupModel *subModel = model.subMakeups[model.selectedSubMakeupIndex];
    return subModel.defaultColorIndex;
}

- (NSString *)categoryNameAtIndex:(NSUInteger)index {
    FUCustomizedMakeupModel *model = self.customizedMakeups[index];
    return FUMakeupStringWithKey(model.name);
}

- (BOOL)hasValidValueAtCategoryIndex:(NSUInteger)index {
    FUCustomizedMakeupModel *model = self.customizedMakeups[index];
    return model.selectedSubMakeupIndex > 0 && model.subMakeups[model.selectedSubMakeupIndex].value > 0;
}

- (UIColor *)subMakeupBackgroundColorAtIndex:(NSUInteger)index {
    FUCustomizedMakeupModel *model = self.customizedMakeups[self.selectedCategoryIndex];
    FUSubMakeupModel *subMakeupModel = model.subMakeups[index];
    if (subMakeupModel.type == FUSubMakeupTypeFoundation && index > 0) {
        // 粉底只设置icon背景色
        NSArray *color = subMakeupModel.colors[subMakeupModel.defaultColorIndex];
        return [UIColor colorWithRed:[color[0] floatValue] green:[color[1] floatValue] blue:[color[2] floatValue] alpha:[color[3] floatValue]];
    } else {
        return [UIColor clearColor];
    }
}

- (UIImage *)subMakeupImageAtIndex:(NSUInteger)index {
    FUCustomizedMakeupModel *model = self.customizedMakeups[self.selectedCategoryIndex];
    FUSubMakeupModel *subMakeupModel = model.subMakeups[index];
    if (subMakeupModel.type == FUSubMakeupTypeFoundation && index > 0) {
        // 粉底不需要icon
        return nil;
    } else {
        return FUMakeupImageNamed(subMakeupModel.icon);
    }
}

#pragma mark - Private methods

/// 更新子妆bundle
- (void)updateSubMakeupBundle:(FUSubMakeupModel *)model {
    if (!model.bundleName) {
        return;
    }
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    if (![FURenderKit shareRenderKit].makeup) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"face_makeup" ofType:@"bundle"];
        FUMakeup *makeup = [[FUMakeup alloc] initWithPath:path name:@"makeup"];
        // 高端机打开口红遮挡
        makeup.makeupSegmentation = [FURenderKit devicePerformanceLevel] == FUDevicePerformanceLevelHigh;
        [FURenderKit shareRenderKit].makeup = makeup;
    }
    NSString *subPath = [bundle pathForResource:model.bundleName ofType:@"bundle"];
    FUItem *item = [[FUItem alloc] initWithPath:subPath name:model.bundleName];
    switch (model.type) {
        case FUSubMakeupTypeFoundation:{
            [FURenderKit shareRenderKit].makeup.subFoundation = item;
        }
            break;
        case FUSubMakeupTypeLip:{
            [FURenderKit shareRenderKit].makeup.subLip = item;
        }
            break;
        case FUSubMakeupTypeBlusher:{
            [FURenderKit shareRenderKit].makeup.subBlusher = item;
        }
            break;
        case FUSubMakeupTypeEyebrow:{
            [FURenderKit shareRenderKit].makeup.subEyebrow = item;
        }
            break;
        case FUSubMakeupTypeEyeShadow:{
            [FURenderKit shareRenderKit].makeup.subEyeshadow = item;
        }
            break;
        case FUSubMakeupTypeEyeliner:{
            [FURenderKit shareRenderKit].makeup.subEyeliner = item;
        }
            break;
        case FUSubMakeupTypeEyelash:{
            [FURenderKit shareRenderKit].makeup.subEyelash = item;
        }
            break;
        case FUSubMakeupTypeHighlight:{
            [FURenderKit shareRenderKit].makeup.subHighlight = item;
        }
            break;
        case FUSubMakeupTypeShadow:{
            [FURenderKit shareRenderKit].makeup.subShadow = item;
        }
            break;
        case FUSubMakeupTypePupil:{
            [FURenderKit shareRenderKit].makeup.subPupil = item;
        }
            break;
    }
}

/// 更新子妆颜色
- (void)updateSubMakeupColor:(FUSubMakeupModel *)model {
    if (model.colors.count <= model.defaultColorIndex) {
        return;
    }
    NSArray *colorValues = model.colors[model.defaultColorIndex];
    FUColor color = FUColorMake([colorValues[0] doubleValue], [colorValues[1] doubleValue], [colorValues[2] doubleValue], [colorValues[3] doubleValue]);
    switch (model.type) {
        case FUSubMakeupTypeFoundation:{
            [FURenderKit shareRenderKit].makeup.foundationColor = color;
        }
            break;
        case FUSubMakeupTypeLip:{
            [FURenderKit shareRenderKit].makeup.lipColor = color;
        }
            break;
        case FUSubMakeupTypeBlusher:{
            [FURenderKit shareRenderKit].makeup.blusherColor = color;
        }
            break;
        case FUSubMakeupTypeEyebrow:{
            [FURenderKit shareRenderKit].makeup.eyebrowColor = color;
        }
            break;
        case FUSubMakeupTypeEyeShadow:{
            NSArray *values0 = [model.colors[model.defaultColorIndex] subarrayWithRange:NSMakeRange(0, 4)];
            NSArray *values2 = [model.colors[model.defaultColorIndex] subarrayWithRange:NSMakeRange(4, 4)];
            NSArray *values3 = [model.colors[model.defaultColorIndex] subarrayWithRange:NSMakeRange(8, 4)];
            [[FURenderKit shareRenderKit].makeup setEyeColor:FUColorMake([values0[0] doubleValue], [values0[1] doubleValue], [values0[2] doubleValue], [values0[3] doubleValue])
                              color1:FUColorMake(0, 0, 0, 0)
                              color2:FUColorMake([values2[0] doubleValue], [values2[1] doubleValue], [values2[2] doubleValue], [values2[3] doubleValue])
                              color3:FUColorMake([values3[0] doubleValue], [values3[1] doubleValue], [values3[2] doubleValue], [values3[3] doubleValue])];
        }
            break;
        case FUSubMakeupTypeEyeliner:{
            [FURenderKit shareRenderKit].makeup.eyelinerColor = color;
        }
            break;
        case FUSubMakeupTypeEyelash:{
            [FURenderKit shareRenderKit].makeup.eyelashColor = color;
        }
            break;
        case FUSubMakeupTypeHighlight:{
            [FURenderKit shareRenderKit].makeup.highlightColor = color;
        }
            break;
        case FUSubMakeupTypeShadow:{
            [FURenderKit shareRenderKit].makeup.shadowColor = color;
        }
            break;
        case FUSubMakeupTypePupil:{
            [FURenderKit shareRenderKit].makeup.pupilColor = color;
        }
            break;
    }
}

- (void)updateSubMakeupIntensity:(FUSubMakeupModel *)model {
    switch (model.type) {
        case FUSubMakeupTypeFoundation:{
            [FURenderKit shareRenderKit].makeup.intensityFoundation = model.value;
        }
            break;
        case FUSubMakeupTypeLip:{
            FULipstickModel *lipModel = (FULipstickModel *)model;
            [FURenderKit shareRenderKit].makeup.lipType = lipModel.lipstickType;
            [FURenderKit shareRenderKit].makeup.isTwoColor = lipModel.isTwoColorLipstick;
            [FURenderKit shareRenderKit].makeup.intensityLip = lipModel.value;
            if (lipModel.lipstickType == FUMakeupLipTypeMoisturizing) {
                // 润泽Ⅱ口红时需要开启口红高光，高光暂时为固定值0.8
                [FURenderKit shareRenderKit].makeup.isLipHighlightOn = YES;
                [FURenderKit shareRenderKit].makeup.intensityLipHighlight = 0.8;
            } else {
                [FURenderKit shareRenderKit].makeup.isLipHighlightOn = NO;
                [FURenderKit shareRenderKit].makeup.intensityLipHighlight = 0;
            }
        }
            break;
        case FUSubMakeupTypeBlusher:{
            [FURenderKit shareRenderKit].makeup.intensityBlusher = model.value;
        }
            break;
        case FUSubMakeupTypeEyebrow:{
            [FURenderKit shareRenderKit].makeup.intensityEyebrow = model.value;
        }
            break;
        case FUSubMakeupTypeEyeShadow:{
            [FURenderKit shareRenderKit].makeup.intensityEyeshadow = model.value;
        }
            break;
        case FUSubMakeupTypeEyeliner:{
            [FURenderKit shareRenderKit].makeup.intensityEyeliner = model.value;
        }
            break;
        case FUSubMakeupTypeEyelash:{
            [FURenderKit shareRenderKit].makeup.intensityEyelash = model.value;
        }
            break;
        case FUSubMakeupTypeHighlight:{
            [FURenderKit shareRenderKit].makeup.intensityHighlight = model.value;
        }
            break;
        case FUSubMakeupTypeShadow:{
            [FURenderKit shareRenderKit].makeup.intensityShadow = model.value;
        }
            break;
        case FUSubMakeupTypePupil:{
            [FURenderKit shareRenderKit].makeup.intensityPupil = model.value;
        }
            break;
    }
}

#pragma mark - Setters

- (void)setSelectedColorIndex:(NSUInteger)selectedColorIndex {
    FUCustomizedMakeupModel *currentModel = self.customizedMakeups[self.selectedCategoryIndex];
    FUSubMakeupModel *subMakeupModel = currentModel.subMakeups[currentModel.selectedSubMakeupIndex];
    if (subMakeupModel.defaultColorIndex == selectedColorIndex || selectedColorIndex < 0 || selectedColorIndex >= subMakeupModel.colors.count) {
        return;
    }
    subMakeupModel.defaultColorIndex = selectedColorIndex;
    [self updateSubMakeupColor:subMakeupModel];
}

- (void)setSelectedSubMakeupIndex:(NSUInteger)selectedSubMakeupIndex {
    FUCustomizedMakeupModel *currentModel = self.customizedMakeups[self.selectedCategoryIndex];
    if (currentModel.selectedSubMakeupIndex == selectedSubMakeupIndex) {
        return;
    }
    currentModel.selectedSubMakeupIndex = selectedSubMakeupIndex;
    FUSubMakeupModel *subMakeupModel = currentModel.subMakeups[currentModel.selectedSubMakeupIndex];
    [self updateSubMakeupBundle:subMakeupModel];
    [self updateSubMakeupColor:subMakeupModel];
    [self updateSubMakeupIntensity:subMakeupModel];
}

- (void)setSelectedSubMakeupValue:(double)selectedSubMakeupValue {
    FUCustomizedMakeupModel *currentModel = self.customizedMakeups[self.selectedCategoryIndex];
    FUSubMakeupModel *subMakeupModel = currentModel.subMakeups[currentModel.selectedSubMakeupIndex];
    subMakeupModel.value = selectedSubMakeupValue;
    [self updateSubMakeupIntensity:subMakeupModel];
}

#pragma mark - Getters

- (NSArray<FUCustomizedMakeupModel *> *)customizedMakeups {
    if (!_customizedMakeups) {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSString *path = [bundle pathForResource:@"customized_makeups" ofType:@"json"];
        NSArray<NSDictionary *> *data = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray<FUCustomizedMakeupModel *> *makeups = [[NSMutableArray alloc] init];
        [data enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            FUCustomizedMakeupModel *customizedMakeupModel = [[FUCustomizedMakeupModel alloc] init];
            customizedMakeupModel.name = obj[@"name"];
            NSArray *tempArray = (NSArray *)obj[@"sgArr"];
            NSMutableArray<FUSubMakeupModel *> *subMakeups = [[NSMutableArray alloc] init];
            for (NSUInteger i = 0; i < tempArray.count; i++) {
                NSDictionary *dictionary = tempArray[i];
                FUSubMakeupModel *model;
                if (idx == FUSubMakeupTypeLip) {
                    model = [[FULipstickModel alloc] init];
                } else if (idx == FUSubMakeupTypeEyebrow) {
                    model = [[FUEyebrowModel alloc] init];
                } else {
                    model = [[FUSubMakeupModel alloc] init];
                }
                [model setValuesForKeysWithDictionary:dictionary];
                model.index = i;
                [subMakeups addObject:model];
            }
            customizedMakeupModel.subMakeups = [subMakeups copy];
            [makeups addObject:customizedMakeupModel];
        }];
        _customizedMakeups = [makeups copy];
    }
    return _customizedMakeups;
}

- (NSArray<FUSubMakeupModel *> *)selectedSubMakeups {
    return self.customizedMakeups[self.selectedCategoryIndex].subMakeups;
}

- (BOOL)needsColorPicker {
    FUCustomizedMakeupModel *currentModel = self.customizedMakeups[self.selectedCategoryIndex];
    FUSubMakeupModel *subMakeupModel = currentModel.subMakeups[currentModel.selectedSubMakeupIndex];
    if (subMakeupModel.type != FUSubMakeupTypeFoundation && subMakeupModel.colors.count > 0) {
        return YES;
    }
    return NO;
}

- (NSArray<NSArray<NSNumber *> *> *)currentColors {
    FUCustomizedMakeupModel *currentModel = self.customizedMakeups[self.selectedCategoryIndex];
    FUSubMakeupModel *subMakeupModel = currentModel.subMakeups[currentModel.selectedSubMakeupIndex];
    return subMakeupModel.colors;
}

- (NSString *)selectedSubMakeupTitle {
    FUCustomizedMakeupModel *currentModel = self.customizedMakeups[self.selectedCategoryIndex];
    FUSubMakeupModel *subMakeupModel = currentModel.subMakeups[currentModel.selectedSubMakeupIndex];
    return FUMakeupStringWithKey(subMakeupModel.title);
}

- (NSUInteger)selectedColorIndex {
    FUCustomizedMakeupModel *currentModel = self.customizedMakeups[self.selectedCategoryIndex];
    FUSubMakeupModel *subMakeupModel = currentModel.subMakeups[currentModel.selectedSubMakeupIndex];
    return subMakeupModel.defaultColorIndex;
}

- (NSUInteger)selectedSubMakeupIndex {
    FUCustomizedMakeupModel *currentModel = self.customizedMakeups[self.selectedCategoryIndex];
    return currentModel.selectedSubMakeupIndex;
}

- (double)selectedSubMakeupValue {
    FUCustomizedMakeupModel *currentModel = self.customizedMakeups[self.selectedCategoryIndex];
    FUSubMakeupModel *subMakeupModel = currentModel.subMakeups[currentModel.selectedSubMakeupIndex];
    return subMakeupModel.value;
}

@end
