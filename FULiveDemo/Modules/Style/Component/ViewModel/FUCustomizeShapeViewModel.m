//
//  FUCustomizeShapeViewModel.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/11/7.
//

#import "FUCustomizeShapeViewModel.h"
#import "FUStyleModel.h"

@interface FUCustomizeShapeViewModel ()

@property (nonatomic, assign) FUDevicePerformanceLevel performanceLevel;

@end

@implementation FUCustomizeShapeViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.performanceLevel = [FURenderKit devicePerformanceLevel];
        self.selectedIndex = -1;
    }
    return self;
}

#pragma mark - Instance methods

- (void)setShapeValue:(double)value {
    if (self.selectedIndex < 0 || self.selectedIndex >= self.shapes.count) {
        return;
    }
    FUStyleShapeModel *model = self.shapes[self.selectedIndex];
    model.currentValue = value;
    [self setValue:model.currentValue forType:model.type];
}

- (NSString *)nameAtIndex:(NSUInteger)index {
    return self.shapes[index].name;
}

- (double)defaultValueAtIndex:(NSUInteger)index {
    return self.shapes[index].defaultValue;
}

- (double)currentValueAtIndex:(NSUInteger)index {
    return self.shapes[index].currentValue;
}

- (BOOL)isDefaultValueInMiddleAtIndex:(NSUInteger)index {
    return self.shapes[index].defaultValueInMiddle;
}

- (BOOL)isDifferentiateDevicePerformanceAtIndex:(NSUInteger)index {
    return self.shapes[index].differentiateDevicePerformance;
}

#pragma mark - Private methods

- (void)setValue:(double)value forType:(FUStyleCustomizingShapeType)type {
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
    }
}

#pragma mark - Setters

- (void)setEffectDisabled:(BOOL)effectDisabled {
    if (_effectDisabled == effectDisabled) {
        return;
    }
    _effectDisabled = effectDisabled;
    if (effectDisabled) {
        for (FUStyleShapeModel *model in self.shapes) {
            [self setValue:model.defaultValueInMiddle ? 0.5 : 0 forType:model.type];
        }
    } else {
        for (FUStyleShapeModel *model in self.shapes) {
            [self setValue:model.currentValue forType:model.type];
        }
    }
}

@end
