//
//  FUBodyBeautyViewModel.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/8/10.
//

#import "FUBodyBeautyViewModel.h"

@interface FUBodyBeautyViewModel ()

@property (nonatomic, copy) NSArray<FUBodyBeautyModel *> *bodyBeautyItems;

@end

@implementation FUBodyBeautyViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"body_slim" ofType:@"bundle"];
        FUBodyBeauty *bodyBeauty = [[FUBodyBeauty alloc] initWithPath:path name:@"body_slim"];
        [FURenderKit shareRenderKit].bodyBeauty = bodyBeauty;
        self.selectedIndex = 0;
    }
    return self;
}

#pragma mark - Instance methods

- (void)setCurrentValue:(double)value {
    if (self.selectedIndex < 0 || self.selectedIndex >= self.bodyBeautyItems.count) {
        return;
    }
    FUBodyBeautyModel *model = self.bodyBeautyItems[self.selectedIndex];
    model.currentValue = value;
    [self setValue:model.currentValue forParts:model.parts];
}

- (void)recoverToDefault {
    for (FUBodyBeautyModel *bodyBeauty in self.bodyBeautyItems) {
        bodyBeauty.currentValue = bodyBeauty.defaultValue;
        [self setValue:bodyBeauty.currentValue forParts:bodyBeauty.parts];
    }
}

#pragma mark - Private methods

- (void)setValue:(double)value forParts:(FUBodyBeautyParts)parts {
    switch (parts) {
        case FUBodyBeautyPartsSlimming:{
            [FURenderKit shareRenderKit].bodyBeauty.bodySlimStrength = value;
        }
            break;
        case FUBodyBeautyPartsLongLegs:{
            [FURenderKit shareRenderKit].bodyBeauty.legSlimStrength = value;
        }
            break;
        case FUBodyBeautyPartsWaist:{
            [FURenderKit shareRenderKit].bodyBeauty.waistSlimStrength = value;
        }
            break;
        case FUBodyBeautyPartsShoulder:{
            [FURenderKit shareRenderKit].bodyBeauty.shoulderSlimStrength = value;
        }
            break;
        case FUBodyBeautyPartsHip:{
            [FURenderKit shareRenderKit].bodyBeauty.hipSlimStrength = value;
        }
            break;
        case FUBodyBeautyPartsHeadSlim:{
            [FURenderKit shareRenderKit].bodyBeauty.headSlim = value;
        }
            break;
        case FUBodyBeautyPartsLegSlim:{
            [FURenderKit shareRenderKit].bodyBeauty.legSlim = value;
        }
    }
}

#pragma mark - Getters

- (NSArray<FUBodyBeautyModel *> *)bodyBeautyItems {
    if (!_bodyBeautyItems) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"body_beauty" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        _bodyBeautyItems = [FUBodyBeautyModel mj_objectArrayWithKeyValuesArray:jsonArray];
    }
    return _bodyBeautyItems;
}

- (BOOL)isDefaultValue {
    for (FUBodyBeautyModel *bodyBeauty in self.bodyBeautyItems) {
        int currentIntValue = bodyBeauty.defaultValueInMiddle ? (int)(bodyBeauty.currentValue * 100 - 50) : (int)(bodyBeauty.currentValue * 100);
        int defaultIntValue = bodyBeauty.defaultValueInMiddle ? (int)(bodyBeauty.defaultValue * 100 - 50) : (int)(bodyBeauty.defaultValue * 100);
        if (currentIntValue != defaultIntValue) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - Overriding

- (FUModule)module {
    return FUModuleBodyBeauty;
}

- (FUAIModelType)necessaryAIModelTypes {
    return FUAIModelTypeFace | FUAIModelTypeHuman;;
}

- (FUDetectingParts)detectingParts {
    return FUDetectingPartsHuman;
}

@end
