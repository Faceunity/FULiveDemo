//
//  FUMakeUpManager.m
//  FULiveDemo
//
//  Created by Chen on 2021/3/2.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUMakeupManager.h"
#import "FULocalDataManager.h"
#import "FUMakeupModel.h"
#import "FUMakeupSupModel.h"
#import <MJExtension/NSObject+MJKeyValue.h>
#import <FURenderKit/FURenderKit.h>

@interface FUMakeupManager ()

/// 普通美妆道具对象
@property (nonatomic, strong, nullable) FUMakeup *makeup;
/// 新组合妆对象
@property (nonatomic, strong, nullable) FUMakeup *combinationMakeup;

@property (nonatomic, strong) NSArray <FUMakeupModel *>* dataArray;

@property (nonatomic, strong) NSArray <FUMakeupSupModel *>*supArray;

@end

@implementation FUMakeupManager

- (instancetype)init {
    self = [super init];
    if (self) {
        NSDictionary *dataParms = [NSDictionary dictionaryWithDictionary:[FULocalDataManager makeupJsonData]];
        self.dataArray = [FUMakeupModel mj_objectArrayWithKeyValuesArray:dataParms[@"data"]];
        if (self.dataArray.count == 0) {
            NSLog(@"%@.dataArray数据出错",self.class);
        }
        NSDictionary *supParms = [NSDictionary dictionaryWithDictionary:[FULocalDataManager makeupWholeJsonData]];
        self.supArray = [FUMakeupSupModel mj_objectArrayWithKeyValuesArray:supParms[@"data"]];
        if (self.supArray.count == 0) {
            NSLog(@"%@.supArray数据出错",self.class);
        }
        
    }
    return self;
}

- (void)setSupModel:(FUMakeupSupModel *)model {
    dispatch_async(self.loadQueue, ^{
        [FURenderKit shareRenderKit].makeup = nil;
        if (model.isCombined) {
            // 新组合妆只需要加载一个bundle，切换时需要重新初始化
            NSString *path = [[NSBundle mainBundle] pathForResource:model.makeupBundle ofType:@"bundle"];
            self.combinationMakeup = [[FUMakeup alloc] initWithPath:path name:model.name];
            [FURenderKit shareRenderKit].makeup = self.combinationMakeup;
            [self setMakeupWholeModel:model];
        } else {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"face_makeup" ofType:@"bundle"];
            self.makeup = [[FUMakeup alloc] initWithPath:path name:@"makeUp"];
            [FURenderKit shareRenderKit].makeup = self.makeup;
            // 老道具使用绑定到face_makeup.bundle的方式
            self.makeup.isClearMakeup = YES;
            /* 防止子妆调节，把口红调乱了，注意：不需要自定义 */
            self.makeup.lipType = FUMakeupLipTypeFOG;
            [self loadMakeupPackageWithPathName:model.makeupBundle];
            self.makeup.isClearMakeup = NO;
            [self setMakeupWholeModel:model];
        }
    });
    
}

- (void)loadMakeupPackageWithPathName:(NSString *)pathName {
    NSString *path = [[NSBundle mainBundle] pathForResource:pathName ofType:@"bundle"];
    if (path) {
        FUItem *item = [[FUItem alloc] initWithPath:path name:pathName];
        [self.makeup updateMakeupPackage:item needCleanSubItem:YES];
    } else {
        [self.makeup updateMakeupPackage:nil needCleanSubItem:YES];
    }
}

- (void)releaseItem {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (_makeup) {
            _makeup = nil;
        }
        
        if (_combinationMakeup) {
            _combinationMakeup = nil;
        }
        
        [FURenderKit shareRenderKit].makeup = nil;
        
        [[FURenderKit shareRenderKit].stickerContainer removeAllSticks];
    });
}


//修改整体妆容的数据
- (void)setMakeupWholeModel:(FUMakeupSupModel *)model {
    if (model.isCombined) {
        [self updateCombinationMakeupIntensity:model.value];
        // 滤镜程度值特殊处理
        [self updateMakeupFilterLevel:model];
    } else {
        for (FUSingleMakeupModel *singleModel in model.makeups) {
            // 旧妆容设置每个子妆强度时需要乘上整体妆容程度值
            singleModel.realValue = singleModel.value * model.value;
            [self setMakeupSupModel:singleModel type:UIMAKEUITYPE_intensity];
        }
    }
}

////设置子妆容数据
- (void)setMakeupSupModel:(FUSingleMakeupModel *)model type:(UIMAKEUITYPE)type {
    switch (type) {
        case UIMAKEUITYPE_intensity:
            [self setIntensity:model];
            break;
        case UIMAKEUITYPE_color:
            [self setColor:model];
            break;
        case UIMAKEUITYPE_pattern:
            [self setPatter:model];
            break;
        default:
            break;
    }
}

- (void)setIntensity:(FUSingleMakeupModel *)model {
    switch (model.makeType) {
        case MAKEUPTYPE_foundation:
            self.makeup.intensityFoundation = model.realValue;
            break;
        case MAKEUPTYPE_Lip: {
            self.makeup.intensityLip = model.realValue;
            self.makeup.lipType = model.lip_type;
            self.makeup.isTwoColor = model.is_two_color == 1?YES:NO;
            if (model.lip_type == FUMakeupLipTypeMoisturizing) {
                // 润泽Ⅱ口红时需要开启口红高光，高光暂时为固定值
                self.makeup.isLipHighlightOn = YES;
                self.makeup.intensityLipHighlight = 0.8;
            } else {
                self.makeup.isLipHighlightOn = NO;
                self.makeup.intensityLipHighlight = 0;
            }
        }
            break;
        case MAKEUPTYPE_blusher:
            self.makeup.intensityBlusher = model.realValue;
            break;
        case MAKEUPTYPE_eyeBrow: {
            self.makeup.intensityEyebrow = model.realValue;
        }
            break;
        case MAKEUPTYPE_eyeShadow:
            self.makeup.intensityEyeshadow = model.realValue;
            break;
        case MAKEUPTYPE_eyeLiner:
            self.makeup.intensityEyeliner = model.realValue;
            break;
        case MAKEUPTYPE_eyelash:
            self.makeup.intensityEyelash = model.realValue;
            break;
        case MAKEUPTYPE_highlight:
            self.makeup.intensityHighlight = model.realValue;
            break;
        case MAKEUPTYPE_shadow:
            self.makeup.intensityShadow = model.realValue;
            break;
        case MAKEUPTYPE_pupil:
            self.makeup.intensityPupil = model.realValue;
            break;
        default:
            break;
    }
}

- (void)setColor:(FUSingleMakeupModel *)model {
    NSArray *values = model.colors[model.defaultColorIndex];
    FUColor color = [self FUColorTransformWithValues:values];
    switch (model.makeType) {
        case MAKEUPTYPE_foundation:
            self.makeup.foundationColor = color;
            break;
        case MAKEUPTYPE_Lip:
            if (model.lip_type == FUMakeupLipTypeMoisturizing) {
                // 润泽Ⅱ口红颜色设置lipColorV2
                self.makeup.lipColorV2 = color;
            } else {
                self.makeup.lipColor = color;
            }
            break;
        case MAKEUPTYPE_blusher:
            self.makeup.blusherColor = color;
            break;
        case MAKEUPTYPE_eyeBrow:
            self.makeup.eyebrowColor = color;
            break;
        case MAKEUPTYPE_eyeShadow: {
            NSArray *values0 = [model.colors[model.defaultColorIndex] subarrayWithRange:NSMakeRange(0, 4)];
            NSArray *values2 = [model.colors[model.defaultColorIndex] subarrayWithRange:NSMakeRange(4, 4)];
            NSArray *values3 = [model.colors[model.defaultColorIndex] subarrayWithRange:NSMakeRange(8, 4)];
            [self.makeup setEyeColor:[self FUColorTransformWithValues:values0]
                              color1:FUColorMake(0, 0, 0, 0)
                              color2:[self FUColorTransformWithValues:values2]
                              color3:[self FUColorTransformWithValues:values3]];
        }
            break;
        case MAKEUPTYPE_eyeLiner:
            self.makeup.eyelinerColor = color;
            break;
        case MAKEUPTYPE_eyelash:
            self.makeup.eyelashColor = color;
            break;
        case MAKEUPTYPE_highlight:
            self.makeup.highlightColor = color;
            break;
        case MAKEUPTYPE_shadow:
            self.makeup.shadowColor = color;
            break;
        case MAKEUPTYPE_pupil:
            self.makeup.pupilColor = color;
            break;
        default:
            break;
    }
}

/// 更新新组合妆程度值
- (void)updateCombinationMakeupIntensity:(CGFloat)makeupIntensity {
    // 新组合妆程度值使用整体妆容程度值
    self.combinationMakeup.intensity = makeupIntensity;
}

- (void)updateMakeupFilterLevel:(FUMakeupSupModel *)model {
    NSLog(@"⭐️滤镜值：%@", @(model.value * model.selectedFilterLevel));
    self.combinationMakeup.filterIntensity = model.value * model.selectedFilterLevel;
}

- (FUColor)FUColorTransformWithValues:(NSArray *)values {
    return FUColorMake([values[0] doubleValue], [values[1] doubleValue], [values[2] doubleValue], [values[3] doubleValue]);;
}

- (void)setPatter:(FUSingleMakeupModel *)model {
    if (!model.namaBundle) {
        return;
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:model.namaBundle ofType:@"bundle"];
    FUItem *item = [[FUItem alloc] initWithPath:path name:model.namaBundle];
    switch (model.namaBundleType) {
        case SUBMAKEUPTYPE_foundation:
            self.makeup.subFoundation = item;
            break;
        case SUBMAKEUPTYPE_lip:
            self.makeup.subLip = item;
            break;
        case SUBMAKEUPTYPE_blusher:
            self.makeup.subBlusher = item;
            break;
        case SUBMAKEUPTYPE_eyeBrow:
            self.makeup.subEyebrow = item;
            self.makeup.browWarp = model.brow_warp;
            self.makeup.browWarpType = model.brow_warp_type;
            break;
        case SUBMAKEUPTYPE_eyeShadow:
            self.makeup.subEyeshadow = item;
            break;
        case SUBMAKEUPTYPE_eyeLiner:
            self.makeup.subEyeliner = item;
            break;
        case SUBMAKEUPTYPE_eyeLash:
            self.makeup.subEyelash = item;
            break;
        case SUBMAKEUPTYPE_highlight:
            self.makeup.subHighlight = item;
            break;
        case SUBMAKEUPTYPE_shadow:
            self.makeup.subShadow = item;
            break;
        case SUBMAKEUPTYPE_pupil:
            self.makeup.subPupil = item;
            self.makeup.blendTypePupil = 1;
            break;
        default:
            break;
    }
    
}

@end
