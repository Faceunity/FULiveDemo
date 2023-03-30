//
//  FUCombinationMakeupViewModel.m
//  FUMakeupComponent
//
//  Created by 项林平 on 2022/9/7.
//

#import "FUCombinationMakeupViewModel.h"
#import "FUCombinationMakeupModel.h"

#import <FURenderKit/FURenderKit.h>

@interface FUCombinationMakeupViewModel ()

@property (nonatomic, copy) NSArray<FUCombinationMakeupModel *> *combinationMakeups;

@property (nonatomic, strong) dispatch_queue_t loadingQueue;

@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation FUCombinationMakeupViewModel {
    void *loadingQueueKey;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _selectedIndex = 1;
    }
    return self;
}

#pragma mark - Instance methods

- (void)selectCombinationMakeupAtIndex:(NSInteger)index complectionHandler:(void (^)(void))complection {
    if (index < 0 || index >= self.combinationMakeups.count) {
        self.selectedIndex = -1;
        !complection ?: complection();
        return;
    }
    if (index == 0) {
        // 卸妆
        [FURenderKit shareRenderKit].makeup = nil;
        // 恢复美颜滤镜为原图效果
        [FURenderKit shareRenderKit].beauty.filterName = @"origin";
        [FURenderKit shareRenderKit].beauty.filterLevel = 0;
        self.selectedIndex = 0;
        !complection ?: complection();
        return;
    }
    NSInteger currentIndex = self.selectedIndex;
    self.selectedIndex = index;
    if ([FURenderKit shareRenderKit].makeup) {
        [FURenderKit shareRenderKit].makeup.enable = NO;
    }
    dispatch_async(self.loadingQueue, ^{
        FUCombinationMakeupModel *model = self.combinationMakeups[index];
        // @note 嗲嗲兔、冻龄、国风、混血是8.0.0新加的四个组合妆，新组合妆只需要直接加载bundle，不需要绑定到face_makeup.bundle
        if (model.isCombined) {
            // 新组合妆，每次加载必须重新初始化
            NSString *path = [[NSBundle mainBundle] pathForResource:model.bundleName ofType:@"bundle"];
            FUMakeup *makeup = [[FUMakeup alloc] initWithPath:path name:@"makeup"];
            // 高端机打开全脸分割
            makeup.makeupSegmentation = [FURenderKit devicePerformanceLevel] == FUDevicePerformanceLevelHigh;
            [FURenderKit shareRenderKit].makeup = makeup;
        } else {
            if (currentIndex == -1 || self.combinationMakeups[currentIndex].isCombined || ![FURenderKit shareRenderKit].makeup) {
                // 当前选择的是新组合装或者当前未加载美妆，需要重新初始化
                NSString *path = [[NSBundle mainBundle] pathForResource:@"face_makeup" ofType:@"bundle"];
                FUMakeup *makeup = [[FUMakeup alloc] initWithPath:path name:@"makeup"];
                // 高端机打开全脸分割
                makeup.makeupSegmentation = [FURenderKit devicePerformanceLevel] == FUDevicePerformanceLevelHigh;
                [FURenderKit shareRenderKit].makeup = makeup;
            }
            [self bindCombinationMakeupWithBundleName:model.bundleName];
        }
        [self updateFilterOfCombinationMakeup:model];
        [self updateIntensityOfCombinationMakeup:model];
        [FURenderKit shareRenderKit].makeup.enable = YES;
        !complection ?: complection();
    });
}

- (NSString *)combinationMakeupNameAtIndex:(NSUInteger)index {
    FUCombinationMakeupModel *model = self.combinationMakeups[index];
    return FUMakeupStringWithKey(model.name);
}

- (UIImage *)combinationMakeupIconAtIndex:(NSUInteger)index {
    FUCombinationMakeupModel *model = self.combinationMakeups[index];
    return [UIImage imageNamed:model.icon];
}

- (NSUInteger)subMakeupIndexOfSelectedCombinationMakeupWithType:(FUSubMakeupType)type {
    if (self.selectedIndex <= 0) {
        return 0;
    }
    FUCombinationMakeupModel *model = self.combinationMakeups[self.selectedIndex];
    NSUInteger index = 0;
    switch (type) {
        case FUSubMakeupTypeFoundation:
            index = model.foundationModel.index;
            break;
        case FUSubMakeupTypeLip:
            index = model.lipstickModel.index;
            break;
        case FUSubMakeupTypeBlusher:
            index = model.blusherModel.index;
            break;
        case FUSubMakeupTypeEyebrow:
            index = model.eyebrowModel.index;
            break;
        case FUSubMakeupTypeEyeShadow:
            index = model.eyeShadowModel.index;
            break;
        case FUSubMakeupTypeEyeliner:
            index = model.eyelinerModel.index;
            break;
        case FUSubMakeupTypeEyelash:
            index = model.eyelashModel.index;
            break;
        case FUSubMakeupTypeHighlight:
            index = model.highlightModel.index;
            break;
        case FUSubMakeupTypeShadow:
            index = model.shadowModel.index;
            break;
        case FUSubMakeupTypePupil:
            index = model.pupilModel.index;
            break;
    }
    return index;
}

- (double)subMakeupValueOfSelectedCombinationMakeupWithType:(FUSubMakeupType)type {
    if (self.selectedIndex <= 0) {
        return self.selectedMakeupValue;
    }
    FUCombinationMakeupModel *model = self.combinationMakeups[self.selectedIndex];
    double value = 0;
    switch (type) {
        case FUSubMakeupTypeFoundation:
            value = model.foundationModel.value * self.selectedMakeupValue;
            break;
        case FUSubMakeupTypeLip:
            value = model.lipstickModel.value * self.selectedMakeupValue;
            break;
        case FUSubMakeupTypeBlusher:
            value = model.blusherModel.value * self.selectedMakeupValue;
            break;
        case FUSubMakeupTypeEyebrow:
            value = model.eyebrowModel.value * self.selectedMakeupValue;
            break;
        case FUSubMakeupTypeEyeShadow:
            value = model.eyeShadowModel.value * self.selectedMakeupValue;
            break;
        case FUSubMakeupTypeEyeliner:
            value = model.eyelinerModel.value * self.selectedMakeupValue;
            break;
        case FUSubMakeupTypeEyelash:
            value = model.eyelashModel.value * self.selectedMakeupValue;
            break;
        case FUSubMakeupTypeHighlight:
            value = model.highlightModel.value * self.selectedMakeupValue;
            break;
        case FUSubMakeupTypeShadow:
            value = model.shadowModel.value * self.selectedMakeupValue;
            break;
        case FUSubMakeupTypePupil:
            value = model.pupilModel.value * self.selectedMakeupValue;
            break;
    }
    return value;
}

- (NSUInteger)subMakeupColorIndexOfSelectedCombinationMakeupWithType:(FUSubMakeupType)type {
    if (self.selectedIndex <= 0) {
        return 0;
    }
    FUCombinationMakeupModel *model = self.combinationMakeups[self.selectedIndex];
    NSUInteger index = 0;
    switch (type) {
        case FUSubMakeupTypeLip:
            index = model.lipstickModel.defaultColorIndex;
            break;
        case FUSubMakeupTypeBlusher:
            index = model.blusherModel.defaultColorIndex;
            break;
        case FUSubMakeupTypeEyebrow:
            index = model.eyebrowModel.defaultColorIndex;
            break;
        case FUSubMakeupTypeEyeShadow:
            index = model.eyeShadowModel.defaultColorIndex;
            break;
        case FUSubMakeupTypeEyeliner:
            index = model.eyelinerModel.defaultColorIndex;
            break;
        case FUSubMakeupTypeEyelash:
            index = model.eyelashModel.defaultColorIndex;
            break;
        case FUSubMakeupTypeHighlight:
            index = model.highlightModel.defaultColorIndex;
            break;
        case FUSubMakeupTypeShadow:
            index = model.shadowModel.defaultColorIndex;
            break;
        case FUSubMakeupTypePupil:
            index = model.pupilModel.defaultColorIndex;
            break;
        default:
            break;
    }
    return index;
}

#pragma mark - Private methods

/// 绑定组合妆到face_makeup.bundle（老组合妆方法）
- (void)bindCombinationMakeupWithBundleName:(NSString *)bundleName {
    NSString *path = [[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"];
    FUItem *item = [[FUItem alloc] initWithPath:path name:bundleName];
    [[FURenderKit shareRenderKit].makeup updateMakeupPackage:item needCleanSubItem:YES];
}

- (void)updateIntensityOfCombinationMakeup:(FUCombinationMakeupModel *)model {
    if (model.isCombined) {
        // 新组合妆直接设置
        [FURenderKit shareRenderKit].makeup.intensity = model.value;
    } else {
        // 老组合妆需要设置所有子妆值，子妆实际值=组合妆值*子妆默认值
        FUMakeup *makeup = [FURenderKit shareRenderKit].makeup;
        makeup.intensityFoundation = model.foundationModel.value * model.value;
        makeup.lipType = model.lipstickModel.lipstickType;
        makeup.isTwoColor = model.lipstickModel.isTwoColorLipstick;
        makeup.intensityLip = model.lipstickModel.value * model.value;
        if (makeup.lipType == FUMakeupLipTypeMoisturizing) {
            // 润泽Ⅱ口红时需要开启口红高光，高光暂时为固定值
            makeup.isLipHighlightOn = YES;
            makeup.intensityLipHighlight = 0.8;
        } else {
            makeup.isLipHighlightOn = NO;
            makeup.intensityLipHighlight = 0;
        }
        makeup.intensityBlusher = model.blusherModel.value * model.value;
        makeup.intensityEyebrow = model.eyebrowModel.value * model.value;
        makeup.intensityEyeshadow = model.eyeShadowModel.value * model.value;
        makeup.intensityEyeliner = model.eyelinerModel.value * model.value;
        makeup.intensityEyelash = model.eyelashModel.value * model.value;
        makeup.intensityHighlight = model.highlightModel.value * model.value;
        makeup.intensityShadow = model.shadowModel.value * model.value;
        makeup.intensityPupil = model.pupilModel.value * model.value;
    }
}

/// 更新组合妆的滤镜
/// @note 老组合妆滤镜设置给FUBeauty实例，新组合妆滤镜直接设置给FUMakeup实例
- (void)updateFilterOfCombinationMakeup:(FUCombinationMakeupModel *)model {
    if (model.isCombined) {
        // 恢复美颜滤镜为原图效果
        [FURenderKit shareRenderKit].beauty.filterName = @"origin";
        // 设置美妆滤镜值
        [FURenderKit shareRenderKit].makeup.filterIntensity = model.value * model.selectedFilterLevel;
    } else {
        if (![FURenderKit shareRenderKit].beauty) {
            return;
        }
        if (!model.selectedFilter || [model.selectedFilter isEqualToString:@""]) {
            // 没有滤镜则使用默认滤镜"origin"
            [FURenderKit shareRenderKit].beauty.filterName = @"origin";
            [FURenderKit shareRenderKit].beauty.filterLevel = model.value;
        } else {
            [FURenderKit shareRenderKit].beauty.filterName = [model.selectedFilter lowercaseString];
            [FURenderKit shareRenderKit].beauty.filterLevel = model.value;
        }
    }
}

#pragma mark - Setters

- (void)setSelectedMakeupValue:(double)selectedMakeupValue {
    if (self.selectedIndex < 0 || self.selectedIndex >= self.combinationMakeups.count) {
        return;
    }
    FUCombinationMakeupModel *model = self.combinationMakeups[self.selectedIndex];
    model.value = selectedMakeupValue;
    [self updateIntensityOfCombinationMakeup:model];
    [self updateFilterOfCombinationMakeup:model];
}

#pragma mark - Getters

- (NSArray<FUCombinationMakeupModel *> *)combinationMakeups {
    if (!_combinationMakeups) {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSString *path = [bundle pathForResource:@"combination_makeups" ofType:@"json"];
        NSArray<NSDictionary *> *data = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *makeups = [[NSMutableArray alloc] init];
        for (NSDictionary *dictionary in data) {
            FUCombinationMakeupModel *model = [[FUCombinationMakeupModel alloc] init];
            [model setValuesForKeysWithDictionary:dictionary];
            if (![model.name isEqualToString:@"卸妆"]) {
                // 解析对应组合妆的json文件
                NSString *combinationPath = [[NSBundle mainBundle] pathForResource:model.bundleName ofType:@"json"];
                NSDictionary *combinationDictionary = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:combinationPath] options:NSJSONReadingMutableContainers error:nil];
                // 设置子妆内容
                FUSubMakeupModel *foundation = [[FUSubMakeupModel alloc] init];
                foundation.value = [combinationDictionary[@"makeup_intensity_foundation"] doubleValue];
                foundation.color = (NSArray *)combinationDictionary[@"makeup_foundation_color"];
                model.foundationModel = foundation;
                
                FULipstickModel *lip = [[FULipstickModel alloc] init];
                lip.value = [combinationDictionary[@"makeup_intensity_lip"] doubleValue];
                lip.color = (NSArray *)combinationDictionary[@"makeup_lip_color"];
                lip.isTwoColorLipstick = [combinationDictionary[@"is_two_color"] boolValue];
                lip.lipstickType = [combinationDictionary[@"lip_type"] integerValue];
                model.lipstickModel = lip;
                
                FUSubMakeupModel *blusher = [[FUSubMakeupModel alloc] init];
                blusher.value = [combinationDictionary[@"makeup_intensity_blusher"] doubleValue];
                blusher.color = (NSArray *)combinationDictionary[@"makeup_blusher_color"];
                model.blusherModel = blusher;
                
                FUEyebrowModel *eyebrow = [[FUEyebrowModel alloc] init];
                eyebrow.value = [combinationDictionary[@"makeup_intensity_eyeBrow"] doubleValue];
                eyebrow.color = (NSArray *)combinationDictionary[@"makeup_eyeBrow_color"];
                eyebrow.isBrowWarp = [combinationDictionary[@"brow_warp"] boolValue];
                eyebrow.browWarpType = [combinationDictionary[@"brow_warp_type"] integerValue];
                model.eyebrowModel = eyebrow;
                
                FUSubMakeupModel *eyeShadow = [[FUSubMakeupModel alloc] init];
                eyeShadow.value = [combinationDictionary[@"makeup_intensity_eye"] doubleValue];
                eyeShadow.color = (NSArray *)combinationDictionary[@"makeup_eye_color"];
                model.eyeShadowModel = eyeShadow;
                
                FUSubMakeupModel *eyeliner = [[FUSubMakeupModel alloc] init];
                eyeliner.value = [combinationDictionary[@"makeup_intensity_eyeLiner"] doubleValue];
                eyeliner.color = (NSArray *)combinationDictionary[@"makeup_eyeLiner_color"];
                model.eyelinerModel = eyeliner;
                
                FUSubMakeupModel *eyelash = [[FUSubMakeupModel alloc] init];
                eyelash.value = [combinationDictionary[@"makeup_intensity_eyelash"] doubleValue];
                eyelash.color = (NSArray *)combinationDictionary[@"makeup_eyelash_color"];
                model.eyelashModel = eyelash;
                
                FUSubMakeupModel *highlight = [[FUSubMakeupModel alloc] init];
                highlight.value = [combinationDictionary[@"makeup_intensity_highlight"] doubleValue];
                highlight.color = (NSArray *)combinationDictionary[@"makeup_highlight_color"];
                model.highlightModel = highlight;
                
                FUSubMakeupModel *shadow = [[FUSubMakeupModel alloc] init];
                shadow.value = [combinationDictionary[@"makeup_intensity_shadow"] doubleValue];
                shadow.color = (NSArray *)combinationDictionary[@"makeup_shadow_color"];
                model.shadowModel = shadow;
                
                FUSubMakeupModel *pupil = [[FUSubMakeupModel alloc] init];
                pupil.value = [combinationDictionary[@"makeup_intensity_pupil"] doubleValue];
                pupil.color = (NSArray *)combinationDictionary[@"makeup_pupil_color"];
                model.pupilModel = pupil;
                
                // 允许自定义组合妆包含的各个子妆对应自定义子妆索引和颜色索引
                if ([model.name isEqualToString:@"性感"]) {
                    foundation.index = 1;
                    lip.index = 1;
                    lip.defaultColorIndex = 0;
                    blusher.index = 2;
                    blusher.defaultColorIndex = 0;
                    eyebrow.index = 1;
                    eyebrow.defaultColorIndex = 0;
                    eyeShadow.index = 2;
                    eyeShadow.defaultColorIndex = 0;
                    eyeliner.index = 1;
                    eyeliner.defaultColorIndex = 0;
                    eyelash.index = 4;
                    eyelash.defaultColorIndex = 0;
                    highlight.index = 2;
                    highlight.defaultColorIndex = 0;
                    shadow.index = 1;
                    shadow.defaultColorIndex = 0;
                    pupil.index = 0;
                    pupil.defaultColorIndex = 0;
                } else if ([model.name isEqualToString:@"甜美"]) {
                    foundation.index = 2;
                    lip.index = 1;
                    lip.defaultColorIndex = 1;
                    blusher.index = 4;
                    blusher.defaultColorIndex = 1;
                    eyebrow.index = 4;
                    eyebrow.defaultColorIndex = 0;
                    eyeShadow.index = 1;
                    eyeShadow.defaultColorIndex = 0;
                    eyeliner.index = 2;
                    eyeliner.defaultColorIndex = 1;
                    eyelash.index = 2;
                    eyelash.defaultColorIndex = 0;
                    highlight.index = 1;
                    highlight.defaultColorIndex = 1;
                    shadow.index = 1;
                    shadow.defaultColorIndex = 0;
                    pupil.index = 0;
                    pupil.defaultColorIndex = 0;
                } else if ([model.name isEqualToString:@"邻家"]) {
                    foundation.index = 3;
                    lip.index = 1;
                    lip.defaultColorIndex = 2;
                    blusher.index = 1;
                    blusher.defaultColorIndex = 2;
                    eyebrow.index = 2;
                    eyebrow.defaultColorIndex = 0;
                    eyeShadow.index = 1;
                    eyeShadow.defaultColorIndex = 0;
                    eyeliner.index = 6;
                    eyeliner.defaultColorIndex = 2;
                    eyelash.index = 1;
                    eyelash.defaultColorIndex = 0;
                    highlight.index = 0;
                    highlight.defaultColorIndex = 0;
                    shadow.index = 0;
                    shadow.defaultColorIndex = 0;
                    pupil.index = 0;
                    pupil.defaultColorIndex = 0;
                } else if ([model.name isEqualToString:@"欧美"]) {
                    foundation.index = 2;
                    lip.index = 1;
                    lip.defaultColorIndex = 3;
                    blusher.index = 2;
                    blusher.defaultColorIndex = 3;
                    eyebrow.index = 1;
                    eyebrow.defaultColorIndex = 0;
                    eyeShadow.index = 4;
                    eyeShadow.defaultColorIndex = 0;
                    eyeliner.index = 5;
                    eyeliner.defaultColorIndex = 3;
                    eyelash.index = 5;
                    eyelash.defaultColorIndex = 0;
                    highlight.index = 2;
                    highlight.defaultColorIndex = 3;
                    shadow.index = 1;
                    shadow.defaultColorIndex = 3;
                    pupil.index = 0;
                    pupil.defaultColorIndex = 0;
                } else if ([model.name isEqualToString:@"妩媚"]) {
                    foundation.index = 4;
                    lip.index = 1;
                    lip.defaultColorIndex = 4;
                    blusher.index = 3;
                    blusher.defaultColorIndex = 4;
                    eyebrow.index = 1;
                    eyebrow.defaultColorIndex = 0;
                    eyeShadow.index = 2;
                    eyeShadow.defaultColorIndex = 1;
                    eyeliner.index = 3;
                    eyeliner.defaultColorIndex = 2;
                    eyelash.index = 3;
                    eyelash.defaultColorIndex = 0;
                    highlight.index = 1;
                    highlight.defaultColorIndex = 4;
                    shadow.index = 0;
                    shadow.defaultColorIndex = 0;
                    pupil.index = 0;
                    pupil.defaultColorIndex = 0;
                }
            }
            [makeups addObject:model];
        }
        _combinationMakeups = [makeups copy];
    }
    return _combinationMakeups;
}

- (BOOL)isSelectedMakeupAllowedEdit {
    return self.combinationMakeups[self.selectedIndex].isAllowedEdit;
}

- (double)selectedMakeupValue {
    return self.combinationMakeups[self.selectedIndex].value;
}

- (dispatch_queue_t)loadingQueue {
    if (_loadingQueue == NULL) {
        loadingQueueKey = &loadingQueueKey;
        _loadingQueue = dispatch_queue_create("com.faceunity.FUMakeupComponent.loadingQueue", DISPATCH_QUEUE_SERIAL);
#if OS_OBJECT_USE_OBJC
        dispatch_queue_set_specific(_loadingQueue, loadingQueueKey, (__bridge void *)self, NULL);
#endif
    }
    return _loadingQueue;
}

@end
