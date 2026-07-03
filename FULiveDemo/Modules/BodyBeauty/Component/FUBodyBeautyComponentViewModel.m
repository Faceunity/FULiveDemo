//
//  FUBodyBeautyComponentViewModel.m
//  FULiveDemo
//
//  Created by Cursor on 2026/6/30.
//

#import "FUBodyBeautyComponentViewModel.h"

@interface FUBodyBeautyComponentViewModel ()

@property (nonatomic, copy) NSArray<FUBodyBeautyModel *> *bodyBeautyItems;

@end

@implementation FUBodyBeautyComponentViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _selectedIndex = 0;
    }
    return self;
}

- (void)loadBodyBeautyIfNeeded {
    if (![FURenderKit shareRenderKit].bodyBeauty) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"body_slim" ofType:@"bundle"];
        FUBodyBeauty *bodyBeauty = [[FUBodyBeauty alloc] initWithPath:path name:@"body_slim"];
        [FURenderKit shareRenderKit].bodyBeauty = bodyBeauty;
    }
    for (FUBodyBeautyModel *bodyBeauty in self.bodyBeautyItems) {
        [self setValue:bodyBeauty.currentValue forParts:bodyBeauty.parts];
    }
}

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

- (void)setValue:(double)value forParts:(FUBodyBeautyParts)parts {
    switch (parts) {
        case FUBodyBeautyPartsSlimming:
            [FURenderKit shareRenderKit].bodyBeauty.bodySlimStrength = value;
            break;
        case FUBodyBeautyPartsLongLegs:
            [FURenderKit shareRenderKit].bodyBeauty.legSlimStrength = value;
            break;
        case FUBodyBeautyPartsWaist:
            [FURenderKit shareRenderKit].bodyBeauty.waistSlimStrength = value;
            break;
        case FUBodyBeautyPartsShoulder:
            [FURenderKit shareRenderKit].bodyBeauty.shoulderSlimStrength = value;
            break;
        case FUBodyBeautyPartsHip:
            [FURenderKit shareRenderKit].bodyBeauty.hipSlimStrength = value;
            break;
        case FUBodyBeautyPartsHeadSlim:
            [FURenderKit shareRenderKit].bodyBeauty.headSlim = value;
            break;
        case FUBodyBeautyPartsLegSlim:
            [FURenderKit shareRenderKit].bodyBeauty.legSlim = value;
            break;
        case FUBodyBeautyPartsBreast:
            [[FURenderKit shareRenderKit].bodyBeauty setParam:@(value) forName:@"BreastStrength" paramType:FUParamTypeDouble];
            break;
    }
}

- (NSArray<FUBodyBeautyModel *> *)bodyBeautyItems {
    if (!_bodyBeautyItems) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"body_beauty" ofType:@"json"];
        _bodyBeautyItems = [FUBodyBeautyModel modelArrayWithJSON:[NSData dataWithContentsOfFile:path]];
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

@end
