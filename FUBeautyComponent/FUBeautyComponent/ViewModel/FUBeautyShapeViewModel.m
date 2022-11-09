//
//  FUBeautyShapeViewModel.m
//  FUBeautyComponent
//
//  Created by 项林平 on 2022/7/27.
//

#import "FUBeautyShapeViewModel.h"
#import "FUBeautyDefine.h"

#import <FURenderKit/FURenderKit.h>

@interface FUBeautyShapeViewModel ()

@property (nonatomic, copy) NSArray<FUBeautyShapeModel *> *beautyShapes;

@end

@implementation FUBeautyShapeViewModel

#pragma mark - Initializer

- (instancetype)init {
    self = [super init];
    if (self) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:FUPersistentBeautyShapeKey]) {
            // 获取本地美肤数据
            self.beautyShapes = [self localShapes];
        } else {
            // 获取默认美肤数据
            self.beautyShapes = [self defaultShapes];
        }
        self.selectedIndex = -1;
        self.performanceLevel = [FURenderKit devicePerformanceLevel];
    }
    return self;
}

#pragma mark - Instance methods

- (void)saveShapesPersistently {
    if (self.beautyShapes.count == 0) {
        return;
    }
    NSMutableArray *shapes = [[NSMutableArray alloc] init];
    for (FUBeautyShapeModel *model in self.beautyShapes) {
        NSDictionary *dictionary = [model dictionaryWithValuesForKeys:@[@"name", @"type", @"currentValue", @"defaultValue", @"defaultValueInMiddle", @"differentiateDevicePerformance"]];
        [shapes addObject:dictionary];
    }
    [[NSUserDefaults standardUserDefaults] setObject:shapes forKey:FUPersistentBeautyShapeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setShapeValue:(double)value {
    if (self.selectedIndex < 0 || self.selectedIndex >= self.beautyShapes.count) {
        return;
    }
    FUBeautyShapeModel *model = self.beautyShapes[self.selectedIndex];
    model.currentValue = value;
    [self setValue:model.currentValue forType:model.type];
}

- (void)setAllShapeValues {
    for (FUBeautyShapeModel *shape in self.beautyShapes) {
        [self setValue:shape.currentValue forType:shape.type];
    }
}

- (void)recoverAllShapeValuesToDefault {
    for (FUBeautyShapeModel *shape in self.beautyShapes) {
        shape.currentValue = shape.defaultValue;
        [self setValue:shape.currentValue forType:shape.type];
    }
}

#pragma mark - Private methods

- (void)setValue:(double)value forType:(FUBeautyShape)type {
    switch (type) {
        case FUBeautyShapeCheekThinning:
            [FURenderKit shareRenderKit].beauty.cheekThinning = value;
            break;
        case FUBeautyShapeCheekV:
            [FURenderKit shareRenderKit].beauty.cheekV = value;
            break;
        case FUBeautyShapeCheekNarrow:
            [FURenderKit shareRenderKit].beauty.cheekNarrow = value;
            break;
        case FUBeautyShapeCheekShort:
            [FURenderKit shareRenderKit].beauty.cheekShort = value;
            break;
        case FUBeautyShapeCheekSmall:
            [FURenderKit shareRenderKit].beauty.cheekSmall = value;
            break;
        case FUBeautyShapeCheekbones:
            [FURenderKit shareRenderKit].beauty.intensityCheekbones = value;
            break;
        case FUBeautyShapeLowerJaw:
            [FURenderKit shareRenderKit].beauty.intensityLowerJaw = value;
            break;
        case FUBeautyShapeEyeEnlarging:
            [FURenderKit shareRenderKit].beauty.eyeEnlarging = value;
            break;
        case FUBeautyShapeEyeCircle:
            [FURenderKit shareRenderKit].beauty.intensityEyeCircle = value;
            break;
        case FUBeautyShapeChin:
            [FURenderKit shareRenderKit].beauty.intensityChin = value;
            break;
        case FUBeautyShapeForehead:
            [FURenderKit shareRenderKit].beauty.intensityForehead = value;
            break;
        case FUBeautyShapeNose:
            [FURenderKit shareRenderKit].beauty.intensityNose = value;
            break;
        case FUBeautyShapeMouth:
            [FURenderKit shareRenderKit].beauty.intensityMouth = value;
            break;
        case FUBeautyShapeLipThick:
            [FURenderKit shareRenderKit].beauty.intensityLipThick = value;
            break;
        case FUBeautyShapeEyeHeight:
            [FURenderKit shareRenderKit].beauty.intensityEyeHeight = value;
            break;
        case FUBeautyShapeCanthus:
            [FURenderKit shareRenderKit].beauty.intensityCanthus = value;
            break;
        case FUBeautyShapeEyeLid:
            [FURenderKit shareRenderKit].beauty.intensityEyeLid = value;
            break;
        case FUBeautyShapeEyeSpace:
            [FURenderKit shareRenderKit].beauty.intensityEyeSpace = value;
            break;
        case FUBeautyShapeEyeRotate:
            [FURenderKit shareRenderKit].beauty.intensityEyeRotate = value;
            break;
        case FUBeautyShapeLongNose:
            [FURenderKit shareRenderKit].beauty.intensityLongNose = value;
            break;
        case FUBeautyShapePhiltrum:
            [FURenderKit shareRenderKit].beauty.intensityPhiltrum = value;
            break;
        case FUBeautyShapeSmile:
            [FURenderKit shareRenderKit].beauty.intensitySmile = value;
            break;
        case FUBeautyShapeBrowHeight:
            [FURenderKit shareRenderKit].beauty.intensityBrowHeight = value;
            break;
        case FUBeautyShapeBrowSpace:
            [FURenderKit shareRenderKit].beauty.intensityBrowSpace = value;
            break;
        case FUBeautyShapeBrowThick:
            [FURenderKit shareRenderKit].beauty.intensityBrowThick = value;
            break;
    }
}

- (NSArray<FUBeautyShapeModel *> *)localShapes {
    NSArray *shapes = [[NSUserDefaults standardUserDefaults] objectForKey:FUPersistentBeautyShapeKey];
    NSMutableArray *mutableShapes = [[NSMutableArray alloc] init];
    for (NSDictionary *shape in shapes) {
        FUBeautyShapeModel *model = [[FUBeautyShapeModel alloc] init];
        [model setValuesForKeysWithDictionary:shape];
        [mutableShapes addObject:model];
    }
    return [mutableShapes copy];
}

- (NSArray<FUBeautyShapeModel *> *)defaultShapes {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *shapePath = [bundle pathForResource:@"beauty_shape" ofType:@"json"];
    NSArray<NSDictionary *> *shapeData = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:shapePath] options:NSJSONReadingMutableContainers error:nil];
    NSMutableArray *shapes = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in shapeData) {
        FUBeautyShapeModel *model = [[FUBeautyShapeModel alloc] init];
        [model setValuesForKeysWithDictionary:dictionary];
        [shapes addObject:model];
    }
    return [shapes copy];
}

#pragma mark - Getters

- (BOOL)isDefaultValue {
    for (FUBeautyShapeModel *shape in self.beautyShapes) {
        int currentIntValue = shape.defaultValueInMiddle ? (int)(shape.currentValue * 100 - 50) : (int)(shape.currentValue * 100);
        int defaultIntValue = shape.defaultValueInMiddle ? (int)(shape.defaultValue * 100 - 50) : (int)(shape.defaultValue * 100);
        if (currentIntValue != defaultIntValue) {
            return NO;
        }
    }
    return YES;
}

@end
