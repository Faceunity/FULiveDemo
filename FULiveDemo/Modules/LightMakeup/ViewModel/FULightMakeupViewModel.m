//
//  FULightMakeupViewModel.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/8/8.
//

#import "FULightMakeupViewModel.h"

@interface FULightMakeupViewModel ()

@property (nonatomic, copy) NSArray<FULightMakeupModel *> *lightMakeups;

@end

@implementation FULightMakeupViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.selectedIndex = 0;
    }
    return self;
}

- (void)setLightMakeupValue:(double)value {
    FULightMakeupModel *model = self.lightMakeups[self.selectedIndex];
    model.value = value;
    for (FUSingleLightMakeupModel *singleModel in model.makeups) {
        singleModel.realValue = singleModel.value * model.value;
        [self setIntensity:singleModel.realValue type:singleModel.type];
    }
    if ([FURenderKit shareRenderKit].beauty) {
        [FURenderKit shareRenderKit].beauty.filterName = model.selectedFilter;
        [FURenderKit shareRenderKit].beauty.filterLevel = model.selectedFilterLevel * model.value;
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (selectedIndex < 0 || selectedIndex >= self.lightMakeups.count) {
        return;
    }
    _selectedIndex = selectedIndex;
    FULightMakeupModel *model = self.lightMakeups[selectedIndex];
    if (selectedIndex == 0) {
        // 取消选中
        [FURenderKit shareRenderKit].lightMakeup = nil;
    } else {
        if (![FURenderKit shareRenderKit].lightMakeup) {
            // 初始化
            NSString *path = [[NSBundle mainBundle] pathForResource:@"light_makeup" ofType:@"bundle"];
            FULightMakeup *lightMakeup = [[FULightMakeup alloc] initWithPath:path name:@"light_makeup"];
            lightMakeup.isMakeupOn = YES;
            lightMakeup.makeupLipMask = YES;
            lightMakeup.intensityLip = 1.0;
            [FURenderKit shareRenderKit].lightMakeup = lightMakeup;
        }
        // 遍历子妆容设置程度值、图片
        for (FUSingleLightMakeupModel *singleModel in model.makeups) {
            singleModel.realValue = singleModel.value * model.value;
            if (singleModel.type == FUSingleMakeupTypeLip) {
                // 口红特殊处理
                [FURenderKit shareRenderKit].lightMakeup.lipType = singleModel.lipType;
                [FURenderKit shareRenderKit].lightMakeup.isTwoColor = singleModel.isTwoColorLipstick;
                NSArray *values = singleModel.colorsArray;
                if (values.count > 3) {
                    FUColor color = FUColorMake([values[0] doubleValue], [values[1] doubleValue], [values[2] doubleValue], [values[3] doubleValue]);;
                    [FURenderKit shareRenderKit].lightMakeup.makeUpLipColor = color;
                }
            }
            [self setIntensity:singleModel.realValue type:singleModel.type];
            [self setImage:singleModel.bundleName type:singleModel.type];
        }
    }
    // 美颜滤镜
    if ([FURenderKit shareRenderKit].beauty) {
        [FURenderKit shareRenderKit].beauty.filterName = model.selectedFilter;
        [FURenderKit shareRenderKit].beauty.filterLevel = model.selectedFilterLevel * model.value;
    }
}

/// 设置程度值
- (void)setIntensity:(double)value type:(FUSingleMakeupType)type {
    switch (type) {
        case FUSingleMakeupTypeLip:
            [FURenderKit shareRenderKit].lightMakeup.intensityLip = value;
            break;
        case FUSingleMakeupTypeBlusher:
            [FURenderKit shareRenderKit].lightMakeup.intensityBlusher = value;
            break;
        case FUSingleMakeupTypeEyeshadow:
            [FURenderKit shareRenderKit].lightMakeup.intensityEyeshadow = value;
            break;
        case FUSingleMakeupTypeEyeliner:
            [FURenderKit shareRenderKit].lightMakeup.intensityEyeliner = value;
            break;
        case FUSingleMakeupTypeEyelash:
            [FURenderKit shareRenderKit].lightMakeup.intensityEyelash = value;
            break;
        case FUSingleMakeupTypePupil:
            [FURenderKit shareRenderKit].lightMakeup.intensityPupil = value;
            break;
        case FUSingleMakeupTypeEyebrow:
            [FURenderKit shareRenderKit].lightMakeup.intensityEyebrow = value;
            break;
        default:
            break;
    }
}

/// 设置图片
- (void)setImage:(NSString *)imageName type:(FUSingleMakeupType)type {
    if (!imageName) {
        NSLog(@"%@:%s图片名称不正确",self.class,__func__);
        return;
    }
    UIImage *image = [UIImage imageNamed:imageName];
    if (!image) {
        return;
    }
    switch (type) {
        case FUSingleMakeupTypeEyebrow:
            [FURenderKit shareRenderKit].lightMakeup.subEyebrowImage = image;
            break;
        case FUSingleMakeupTypeEyeshadow:
            [FURenderKit shareRenderKit].lightMakeup.subEyeshadowImage = image;
            break;
        case FUSingleMakeupTypePupil:
            [FURenderKit shareRenderKit].lightMakeup.subPupilImage = image;
            break;
        case FUSingleMakeupTypeEyelash:
            [FURenderKit shareRenderKit].lightMakeup.subEyelashImage = image;
            break;
        case FUSingleMakeupTypeHighlight:
            [FURenderKit shareRenderKit].lightMakeup.subHightLightImage = image;
            break;
        case FUSingleMakeupTypeEyeliner:
            [FURenderKit shareRenderKit].lightMakeup.subEyelinerImage = image;
            break;
        case FUSingleMakeupTypeBlusher:
            [FURenderKit shareRenderKit].lightMakeup.subBlusherImage = image;
            break;
        default:
            break;
    }
}

#pragma mark - Getters

- (NSArray<FULightMakeupModel *> *)lightMakeups {
    if (!_lightMakeups) {
        NSString *lightMakeupPath = [[NSBundle mainBundle] pathForResource:@"light_makeup" ofType:@"json"];
        NSData *lightMakeupData = [[NSData alloc] initWithContentsOfFile:lightMakeupPath];
        NSArray *jsonArray = (NSArray *)[NSJSONSerialization JSONObjectWithData:lightMakeupData options:NSJSONReadingMutableContainers error:nil];
        _lightMakeups = [FULightMakeupModel mj_objectArrayWithKeyValuesArray:jsonArray];
    }
    return _lightMakeups;
}

#pragma mark - Overriding

- (FUModule)module {
    return FUModuleLightMakeup;
}

@end
