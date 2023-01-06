//
//  FUCustomizeSkinViewModel.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/11/7.
//

#import "FUCustomizeSkinViewModel.h"
#import "FUStyleModel.h"

@implementation FUCustomizeSkinViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.selectedIndex = -1;
    }
    return self;
}

#pragma mark - Instance methods

- (void)setSkinValue:(double)value {
    if (self.selectedIndex < 0 || self.selectedIndex >= self.skins.count) {
        return;
    }
    FUStyleSkinModel *model = self.skins[self.selectedIndex];
    model.currentValue = value * model.ratio;
    [self setValue:model.currentValue forType:model.type];
}

- (NSString *)nameAtIndex:(NSUInteger)index {
    return self.skins[index].name;
}

- (double)defaultValueAtIndex:(NSUInteger)index {
    return self.skins[index].defaultValue;
}

- (double)currentValueAtIndex:(NSUInteger)index {
    return self.skins[index].currentValue;
}

- (NSUInteger)ratioAtIndex:(NSUInteger)index {
    return self.skins[index].ratio;
}

#pragma mark - Private methods

- (void)setValue:(double)value forType:(FUStyleCustomizingSkinType)type {
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
    }
}

#pragma mark - Setters

- (void)setEffectDisabled:(BOOL)effectDisabled {
    if (_effectDisabled == effectDisabled) {
        return;
    }
    _effectDisabled = effectDisabled;
    if (effectDisabled) {
        for (FUStyleSkinModel *model in self.skins) {
            [self setValue:0 forType:model.type];
        }
    } else {
        for (FUStyleSkinModel *model in self.skins) {
            [self setValue:model.currentValue forType:model.type];
        }
    }
}

@end
