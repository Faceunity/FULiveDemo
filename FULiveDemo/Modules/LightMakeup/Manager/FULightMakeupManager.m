//
//  FULightMakeupManager.m
//  FULiveDemo
//
//  Created by Chen on 2021/3/4.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FULightMakeupManager.h"
#import "FULightModel.h"
#import "FULocalDataManager.h"

@interface FULightMakeupManager ()
@property (nonatomic, strong) NSArray <FULightModel *> *dataArray;
@end

@implementation FULightMakeupManager
- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"light_makeup" ofType:@"bundle"];
        self.lightMakeup = [[FULightMakeup alloc] initWithPath:path name:@"light_makeup"];
        self.lightMakeup.isMakeupOn = YES;
        self.lightMakeup.makeupLipMask = YES;
        self.lightMakeup.intensityLip = 1.0;
        NSDictionary *lightMakeupPar = [FULocalDataManager lightMakeupJsonData];
        self.dataArray = [FULightModel mj_objectArrayWithKeyValuesArray:lightMakeupPar[@"data"]];
        if (self.dataArray.count == 0) {
            NSLog(@"%@.dataArray数据出错",self.class);
        }
        [self loadItem];
    }
    return self;
}

//业务层设置所有子妆需要配合整体妆容程度值，所以需要带上lightvalue
- (void)setAllSubLghtMakeupModelWithLightModel:(FULightModel *)lightModel {
    //设置图片参数
    for (FUSingleLightMakeupModel *singleModel in lightModel.makeups) {
        singleModel.realValue = singleModel.value * lightModel.value;
        [self setSingModel:singleModel];
    }
}

//设置子妆整体，包括图片、程度值
- (void)setSingModel:(FUSingleLightMakeupModel *)model {
    //程度值
    [self setIntensity:model.realValue type:model.type];
    
    if (model.type == FUSingleMakeupTypeLip) {
        self.lightMakeup.lipType = model.lipType;
        self.lightMakeup.isTwoColor = model.isTwoColorLip;
        NSArray *values = model.colorsArray;
        if (values.count > 3) {
            FUColor color = FUColorMake([values[0] doubleValue], [values[1] doubleValue], [values[2] doubleValue], [values[3] doubleValue]);;
            self.lightMakeup.makeUpLipColor = color;
        }
    }
    
    //图片
    [self setImage:model.bundleName type:model.type];
}

//单独设置子妆设置强度值
- (void)setIntensityWithModel:(FUSingleLightMakeupModel *)model {
    [self setIntensity:model.realValue type:model.type];
}

//设置图片
- (void)setImage:(NSString *)imageName type:(FUSingleMakeupType)type {
    if (!imageName) {
        NSLog(@"%@:%s图片名称不正确",self.class,__func__);
        return ;
    }
    UIImage *image = [UIImage imageNamed:imageName];
    switch (type) {
        case FUSingleMakeupTypeEyebrow:
            self.lightMakeup.subEyebrowImage = image;
            break;
        case FUSingleMakeupTypeEyeshadow:
            self.lightMakeup.subEyeshadowImage = image;
            break;
        case FUSingleMakeupTypePupil:
            self.lightMakeup.subPupilImage = image;
            break;
        case FUSingleMakeupTypeEyelash:
            self.lightMakeup.subEyelashImage = image;
            break;
        case FUSingleMakeupTypeHighlight:
            self.lightMakeup.subHightLightImage = image;
            break;
        case FUSingleMakeupTypeEyeliner:
            self.lightMakeup.subEyelinerImage = image;
            break;
        case FUSingleMakeupTypeBlusher:
            self.lightMakeup.subBlusherImage = image;
            break;
        default:
            break;
    }
}

//设置程度值
- (void)setIntensity:(double)value type:(FUSingleMakeupType)type {
    switch (type) {
        case FUSingleMakeupTypeLip:
            self.lightMakeup.intensityLip = value;
            break;
        case FUSingleMakeupTypeBlusher:
            self.lightMakeup.intensityBlusher = value;
            break;
        case FUSingleMakeupTypeEyeshadow:
            self.lightMakeup.intensityEyeshadow = value;
            break;
        case FUSingleMakeupTypeEyeliner:
            self.lightMakeup.intensityEyeliner = value;
            break;
        case FUSingleMakeupTypeEyelash:
            self.lightMakeup.intensityEyelash = value;
            break;
        case FUSingleMakeupTypePupil:
            self.lightMakeup.intensityPupil = value;
            break;
        case FUSingleMakeupTypeEyebrow:
            self.lightMakeup.intensityEyebrow = value;
            break;
        default:
            break;
    }
}

- (FUColor)FUColorTransformWithValues:(NSArray *)values {
    return FUColorMake([values[0] doubleValue], [values[1] doubleValue], [values[2] doubleValue], [values[3] doubleValue]);;
}

- (void)loadItem {
    [FURenderKit shareRenderKit].lightMakeup = self.lightMakeup;
}

- (void)releaseItem {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.lightMakeup = nil;
        [FURenderKit shareRenderKit].lightMakeup = nil;
    });
}
@end
