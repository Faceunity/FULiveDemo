//
//  FUGreenScreenKeyingViewModel.m
//  FUGreenScreenComponent
//
//  Created by 项林平 on 2022/8/1.
//

#import "FUGreenScreenKeyingViewModel.h"
#import "FUGreenScreenKeyingModel.h"

#import <FURenderKit/FURenderKit.h>

@interface FUGreenScreenKeyingViewModel ()

@property (nonatomic, strong) FUGreenScreenSafeAreaViewModel *safeAreaViewModel;
@property (nonatomic, copy) NSArray <FUGreenScreenKeyingModel *> *keyingArray;
@property (nonatomic, strong) NSMutableArray<UIColor *> *keyColorArray;

@end

@implementation FUGreenScreenKeyingViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setAllKeyingValues];
        self.selectedColorIndex = 1;
    }
    return self;
}

#pragma mark - Instance methods

- (void)setAllKeyingValues {
    for (FUGreenScreenKeyingModel *model in self.keyingArray) {
        [self setValue:model.currentValue forType:model.type];
    }
}

- (void)recoverCustomizedKeyColor {
    self.keyColorArray[0] = [UIColor clearColor];
}

- (void)recoverToDefault {
    for (FUGreenScreenKeyingModel *model in self.keyingArray) {
        model.currentValue = model.defaultValue;
        [self setValue:model.currentValue forType:model.type];
    }
    // 恢复锚点取色值为透明色
    self.keyColorArray[0] = [UIColor clearColor];
    // 恢复默认选择颜色
    self.selectedColorIndex = 1;
    self.safeAreaViewModel.selectedIndex = 1;
}

- (NSString *)keyingNameAtIndex:(NSInteger)index {
    FUGreenScreenKeyingModel *model = self.keyingArray[index];
    return FUGreenScreenStringWithKey(model.name);
}

- (NSString *)keyingImageNameAtIndex:(NSInteger)index {
    FUGreenScreenKeyingModel *model = self.keyingArray[index];
    return model.icon;
}

- (double)keyingDefaultValueAtIndex:(NSInteger)index {
    FUGreenScreenKeyingModel *model = self.keyingArray[index];
    return model.defaultValue;
}

- (double)keyingCurrentValueAtIndex:(NSInteger)index {
    FUGreenScreenKeyingModel *model = self.keyingArray[index];
    if (model.type == FUGreenScreenKeyingTypeSafeArea) {
        return self.safeAreaViewModel.selectedIndex > 2 ? 1 : 0;
    } else {
        return model.currentValue;
    }
}

#pragma mark - Setters

- (void)setSelectedValue:(double)selectedValue {
    if (self.selectedIndex <= FUGreenScreenKeyingTypeColor || self.selectedIndex >= FUGreenScreenKeyingTypeSafeArea) {
        // 忽略关键颜色和安全区域
        return;
    }
    FUGreenScreenKeyingModel *model = self.keyingArray[self.selectedIndex];
    model.currentValue = selectedValue;
    [self setValue:model.currentValue forType:model.type];
}

- (void)setSelectedColorIndex:(NSInteger)selectedColorIndex {
    if (selectedColorIndex < 0 || selectedColorIndex >= self.keyColorArray.count) {
        return;
    }
    _selectedColorIndex = selectedColorIndex;
    if (selectedColorIndex == 0) {
        // 设置绿幕效果失效
        [FURenderKit shareRenderKit].greenScreen.enable = NO;
    } else {
        // 设置绿幕效果有效，更新当前关键颜色
        [FURenderKit shareRenderKit].greenScreen.enable = YES;
        self.currentKeyColor = self.keyColorArray[selectedColorIndex];
    }
}

- (void)setCurrentKeyColor:(UIColor *)currentKeyColor {
    if (!currentKeyColor) {
        return;
    }
    _currentKeyColor = currentKeyColor;
    if (![FURenderKit shareRenderKit].greenScreen.enable) {
        [FURenderKit shareRenderKit].greenScreen.enable = YES;
    }
    [FURenderKit shareRenderKit].greenScreen.keyColor = FUColorMakeWithUIColor(currentKeyColor);
    
    // 设置关键颜色后FURenderKit层的相似度、平滑度、祛色度可能自动发生变化，所以需要更新程度值
    double chromaThresValue = [FURenderKit shareRenderKit].greenScreen.chromaThres;
    double chromaThresTValue = [FURenderKit shareRenderKit].greenScreen.chromaThrest;
    double alphaLValue = [FURenderKit shareRenderKit].greenScreen.alphal;
    self.keyingArray[FUGreenScreenKeyingTypeChromaThres].currentValue = chromaThresValue;
    self.keyingArray[FUGreenScreenKeyingTypeChromaThrest].currentValue = chromaThresTValue;
    self.keyingArray[FUGreenScreenKeyingTypeAlphaL].currentValue = alphaLValue;
}

- (void)setValue:(double)value forType:(FUGreenScreenKeyingType)type {
    switch (type) {
        case FUGreenScreenKeyingTypeChromaThres:
            [FURenderKit shareRenderKit].greenScreen.chromaThres = value;
            break;
        case FUGreenScreenKeyingTypeChromaThrest:
            [FURenderKit shareRenderKit].greenScreen.chromaThrest = value;
            break;
        case FUGreenScreenKeyingTypeAlphaL:
            [FURenderKit shareRenderKit].greenScreen.alphal = value;
        default:
            break;
    }
}

#pragma mark - Getters

- (double)selectedValue {
    FUGreenScreenKeyingModel *model = self.keyingArray[self.selectedIndex];
    return model.currentValue;
}

- (BOOL)isDefaultValue {
    if (self.safeAreaViewModel.selectedIndex > 2) {
        // 设置了安全区域
        return NO;
    }
    if (self.selectedColorIndex != 1) {
        // 关键颜色发生变化
        return NO;
    }
    for (FUGreenScreenKeyingModel *model in self.keyingArray) {
        if (fabs(model.currentValue - model.defaultValue) > 0.01) {
            // 抠像功能某一项值发生了变化
            return NO;
        }
    }
    return YES;
}

- (FUGreenScreenSafeAreaViewModel *)safeAreaViewModel {
    if (!_safeAreaViewModel) {
        _safeAreaViewModel = [[FUGreenScreenSafeAreaViewModel alloc] init];
    }
    return _safeAreaViewModel;
}

- (NSArray<FUGreenScreenKeyingModel *> *)keyingArray {
    if (!_keyingArray) {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSString *path = [bundle pathForResource:@"green_screen_keying" ofType:@"json"];
        NSArray<NSDictionary *> *data = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *keyings = [[NSMutableArray alloc] init];
        for (NSDictionary *dictionary in data) {
            FUGreenScreenKeyingModel *model = [[FUGreenScreenKeyingModel alloc] init];
            [model setValuesForKeysWithDictionary:dictionary];
            [keyings addObject:model];
        }
        _keyingArray = [keyings copy];
    }
    return _keyingArray;
}

- (NSMutableArray<UIColor *> *)keyColorArray {
    if (!_keyColorArray) {
        _keyColorArray = [@[
            [UIColor clearColor],
            [UIColor colorWithRed:0 green:1.0 blue:0 alpha:1.0],
            [UIColor colorWithRed:0 green:0.0 blue:1 alpha:1.0],
            [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0]] mutableCopy];
    }
    return _keyColorArray;
}

@end
