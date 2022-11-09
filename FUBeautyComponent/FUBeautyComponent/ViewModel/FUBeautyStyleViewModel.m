//
//  FUBeautyStyleViewModel.m
//  FUBeautyComponent
//
//  Created by 项林平 on 2022/6/21.
//

#import "FUBeautyStyleViewModel.h"

#import "FUBeautyDefine.h"

#import <FURenderKit/FURenderKit.h>

@interface FUBeautyStyleViewModel ()

@property (nonatomic, copy) NSArray<FUBeautyStyleModel *> *beautyStyles;

@end

@implementation FUBeautyStyleViewModel

#pragma mark - Initializer

- (instancetype)init {
    self = [super init];
    if (self) {
        self.beautyStyles = [self defaultStyles];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:FUPersistentBeautySelectedStyleIndexKey]) {
            // 获取本地保存选中的索引
            self.selectedIndex = [[NSUserDefaults standardUserDefaults] integerForKey:FUPersistentBeautySelectedStyleIndexKey];
        } else {
            // 默认索引为0
            _selectedIndex = 0;
        }
    }
    return self;
}

#pragma mark - Instance methods

- (void)saveStylesPersistently {
    if (self.selectedIndex >= 0 && self.selectedIndex < self.beautyStyles.count) {
        [[NSUserDefaults standardUserDefaults] setInteger:self.selectedIndex forKey:FUPersistentBeautySelectedStyleIndexKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (selectedIndex < 0 || selectedIndex >= self.beautyStyles.count) {
        return;
    }
    if (selectedIndex == 0) {
        _selectedIndex = selectedIndex;
        return;
    }
    
    FUBeautyStyleModel *style = self.beautyStyles[selectedIndex];
    
    // 美肤
    [FURenderKit shareRenderKit].beauty.blurLevel = style.blurLevel;
    [FURenderKit shareRenderKit].beauty.colorLevel = style.colorLevel;
    [FURenderKit shareRenderKit].beauty.redLevel = style.redLevel;
    [FURenderKit shareRenderKit].beauty.sharpen = style.faceThreed;
    [FURenderKit shareRenderKit].beauty.eyeBright = style.eyeBright;
    [FURenderKit shareRenderKit].beauty.toothWhiten = style.toothWhiten;
    [FURenderKit shareRenderKit].beauty.removePouchStrength = style.removePouchStrength;
    [FURenderKit shareRenderKit].beauty.removeNasolabialFoldsStrength = style.removeNasolabialFoldsStrength;
    
    // 美型
    [FURenderKit shareRenderKit].beauty.cheekThinning = style.cheekThinning;
    [FURenderKit shareRenderKit].beauty.cheekV = style.cheekV;
    [FURenderKit shareRenderKit].beauty.cheekNarrow = style.cheekNarrow;
    [FURenderKit shareRenderKit].beauty.cheekShort = style.cheekShort;
    [FURenderKit shareRenderKit].beauty.cheekSmall = style.cheekSmall;
    [FURenderKit shareRenderKit].beauty.intensityCheekbones = style.cheekbones;
    [FURenderKit shareRenderKit].beauty.intensityLowerJaw = style.lowerJaw;
    [FURenderKit shareRenderKit].beauty.eyeEnlarging = style.eyeEnlarging;
    [FURenderKit shareRenderKit].beauty.intensityEyeCircle = style.eyeCircle;
    [FURenderKit shareRenderKit].beauty.intensityChin = style.chin;
    [FURenderKit shareRenderKit].beauty.intensityForehead = style.forehead;
    [FURenderKit shareRenderKit].beauty.intensityNose = style.nose;
    [FURenderKit shareRenderKit].beauty.intensityMouth = style.mouth;
    [FURenderKit shareRenderKit].beauty.intensityLipThick = style.lipThick;
    [FURenderKit shareRenderKit].beauty.intensityEyeHeight = style.eyeHeight;
    [FURenderKit shareRenderKit].beauty.intensityCanthus = style.canthus;
    [FURenderKit shareRenderKit].beauty.intensityEyeLid = style.eyeLid;
    [FURenderKit shareRenderKit].beauty.intensityEyeSpace = style.eyeSpace;
    [FURenderKit shareRenderKit].beauty.intensityEyeRotate = style.eyeRotate;
    [FURenderKit shareRenderKit].beauty.intensityLongNose = style.longNose;
    [FURenderKit shareRenderKit].beauty.intensityPhiltrum = style.philtrum;
    [FURenderKit shareRenderKit].beauty.intensitySmile = style.smile;
    [FURenderKit shareRenderKit].beauty.intensityBrowHeight = style.browHeight;
    [FURenderKit shareRenderKit].beauty.intensityBrowSpace = style.browSpace;
    [FURenderKit shareRenderKit].beauty.intensityBrowThick = style.browThick;
    
    // 滤镜
    [FURenderKit shareRenderKit].beauty.filterName = style.filterName;
    [FURenderKit shareRenderKit].beauty.filterLevel = style.filterLevel;
    
    _selectedIndex = selectedIndex;
}

#pragma mark - Private methods

- (NSArray<FUBeautyStyleModel *> *)defaultStyles {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"beauty_style" ofType:@"json"];
    NSArray<NSDictionary *> *data = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:NSJSONReadingMutableContainers error:nil];
    NSMutableArray *styles = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in data) {
        FUBeautyStyleModel *model = [[FUBeautyStyleModel alloc] init];
        [model setValuesForKeysWithDictionary:dictionary];
        [styles addObject:model];
    }
    return [styles copy];
}

@end
