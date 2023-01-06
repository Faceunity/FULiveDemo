//
//  FUStyleCustomizingViewModel.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/11/7.
//

#import "FUStyleCustomizingViewModel.h"
#import "FUCustomizeSkinViewModel.h"
#import "FUCustomizeShapeViewModel.h"
#import "FUStyleModel.h"

@interface FUStyleCustomizingViewModel ()

@property (nonatomic, strong) FUCustomizeSkinViewModel *skinViewModel;
@property (nonatomic, strong) FUCustomizeShapeViewModel *shapeViewModel;

@end

@implementation FUStyleCustomizingViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.selectedSegmentIndex = 0;
    }
    return self;
}

- (void)setCustomizingStyle:(FUStyleModel *)customizingStyle {
    _customizingStyle = customizingStyle;
    self.skinViewModel.skins = customizingStyle.skins;
    self.skinViewModel.effectDisabled = customizingStyle.isSkinDisabled;
    self.skinViewModel.selectedIndex = -1;
    self.shapeViewModel.shapes = customizingStyle.shapes;
    self.shapeViewModel.effectDisabled = customizingStyle.isShapeDisabled;
    self.shapeViewModel.selectedIndex = -1;
}

- (void)setSkinEffectDisabled:(BOOL)skinEffectDisabled {
    self.customizingStyle.isSkinDisabled = skinEffectDisabled;
}

- (void)setShapeEffectDisabled:(BOOL)shapeEffectDisabled {
    self.customizingStyle.isShapeDisabled = shapeEffectDisabled;
}

#pragma mark - Getters

- (BOOL)skinEffectDisabled {
    return self.customizingStyle.isSkinDisabled;
}

- (BOOL)shapeEffectDisabled {
    return self.customizingStyle.isShapeDisabled;
}

- (FUCustomizeSkinViewModel *)skinViewModel {
    if (!_skinViewModel) {
        _skinViewModel = [[FUCustomizeSkinViewModel alloc] init];
    }
    return _skinViewModel;
}

- (FUCustomizeShapeViewModel *)shapeViewModel {
    if (!_shapeViewModel) {
        _shapeViewModel = [[FUCustomizeShapeViewModel alloc] init];
    }
    return _shapeViewModel;
}

@end
