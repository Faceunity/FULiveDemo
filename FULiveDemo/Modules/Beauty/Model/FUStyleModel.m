//
//  FUStyleModel.m
//  FULiveDemo
//
//  Created by Chen on 2021/3/23.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUStyleModel.h"

@implementation FUStyleModel

+ (FUStyleModel *)defaultParams {
    FUStyleModel *defaultModel = [[FUStyleModel alloc] init];
   
    //美肤
    NSMutableArray *skinArr = [NSMutableArray array];
    NSArray *skinTitles = @[@"精细磨皮",@"美白",@"红润",@"锐化",@"亮眼",@"美牙",@"去黑眼圈",@"去法令纹"];//
    float ratio[FUBeautifySkinMax] = {6.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0};
    for (NSUInteger i = 0; i < FUBeautifySkinMax; i ++) {
        FUBeautyModel *model = [[FUBeautyModel alloc] init];
        model.type = FUBeautyDefineSkin;
        model.mParam = i;
        model.mTitle = [skinTitles objectAtIndex:i];
        model.mValue = 0.0;
        model.defaultValue = model.mValue;
        model.ratio = ratio[i];
        [skinArr addObject:model];
    }
    defaultModel.skins = [NSArray arrayWithArray: skinArr];
    
    //美型
    NSMutableArray *shapArr = [NSMutableArray array];
    NSArray *titleAndValues = @[@{@"key": @"瘦脸",@"value":@0.0},
                                @{@"key": @"v脸",@"value":@0.0},
                                @{@"key": @"窄脸",@"value":@0.0},
                                @{@"key": @"小脸",@"value":@0.0},
                                @{@"key": @"瘦颧骨",@"value":@0.0},
                                @{@"key": @"瘦下颌骨",@"value":@0.0},
                                @{@"key": @"大眼",@"value":@0.0},
                                @{@"key": @"圆眼",@"value":@(0.0)},
                                @{@"key": @"下巴",@"value":@0.5},
                                @{@"key": @"额头",@"value":@0.5},
                                @{@"key": @"瘦鼻",@"value":@0.0},
                                @{@"key": @"嘴型",@"value":@0.5},
                                @{@"key": @"开眼角",@"value":@0.0},
                                @{@"key": @"眼距",@"value":@0.5},
                                @{@"key": @"眼睛角度",@"value":@0.5},
                                @{@"key": @"长鼻",@"value":@0.5},
                                @{@"key": @"缩人中",@"value":@0.5},
                                @{@"key": @"微笑嘴角",@"value":@0.0}];
    float shapeRatio[FUBeautifyShapeMax] = {1.0, 1.0, 0.5, 0.5, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0};
    for (NSUInteger i = 0; i < FUBeautifyShapeMax; i ++) {
        NSDictionary *keyValues = [titleAndValues objectAtIndex:i];
        
        FUBeautyModel *model = [[FUBeautyModel alloc] init];
        model.type = FUBeautyDefineShape;
        model.mParam = i;
        model.mTitle = [keyValues objectForKey:@"key"];
        model.mValue = [[keyValues objectForKey:@"value"] doubleValue];
        model.defaultValue = model.mValue;
        model.ratio = shapeRatio[i];
        [shapArr addObject:model];
    }
    defaultModel.shapes = [NSArray arrayWithArray: shapArr];
    
    //滤镜
    FUBeautyModel *filterModel = [[FUBeautyModel alloc] init];
    filterModel.type = FUBeautyDefineFilter;
    filterModel.strValue = @"origin";
    filterModel.mTitle = @"无";
    filterModel.mValue = 0.4;
    
    defaultModel.filter = filterModel;
    
    return defaultModel;
}

- (void)styleWithType:(FUBeautyStyleType)type {
    if (type == FUBeautyStyleType1) {
        [self style1];
    }
    if (type == FUBeautyStyleType2) {
        [self style2];
    }
    if (type == FUBeautyStyleType3) {
        [self style3];
    }
    if (type == FUBeautyStyleType4) {
        [self style4];
    }
    if (type == FUBeautyStyleType5) {
        [self style5];
    }
    if (type == FUBeautyStyleType6) {
        [self style6];
    }
    if (type == FUBeautyStyleType7) {
        [self style7];
    }
}

//设置美肤程度值
- (void)setSkinModelWithIndex:(NSUInteger)index value:(float)value {
    if (index < self.skins.count) {
        FUBeautyModel *skin = [self.skins objectAtIndex:index];
        skin.mValue = value;
    }
}

//设置美型程度值
- (void)setShapeModelWithIndex:(NSUInteger)index value:(float)value {
    if (index < self.shapes.count) {
        FUBeautyModel *shape = [self.shapes objectAtIndex:index];
        shape.mValue = value;
    }
}


- (void)style1 {
    self.filter.strValue = @"bailiang1";
    self.filter.mValue = 0.2;

    [self setSkinModelWithIndex:FUBeautifySkinColorLevel value:0.5];
    [self setSkinModelWithIndex:FUBeautifySkinBlurLevel value:3.0];
    [self setSkinModelWithIndex:FUBeautifySkinEyeBright value:0.35];
    [self setSkinModelWithIndex:FUBeautifySkinToothWhiten value:0.25];
    
    [self setShapeModelWithIndex:FUBeautifyShapeCheekThinning value:0.45];
    [self setShapeModelWithIndex:FUBeautifyShapeCheekV value:0.08];
    [self setShapeModelWithIndex:FUBeautifyShapeCheekSmall value:0.05];
    [self setShapeModelWithIndex:FUBeautifyShapeEyeEnlarging value:0.3];
}

- (void)style2 {
    self.filter.strValue = @"ziran3";
    self.filter.mValue = 0.35;
    
    [self setSkinModelWithIndex:FUBeautifySkinColorLevel value:0.7];
    [self setSkinModelWithIndex:FUBeautifySkinRedLevel value:0.3];
    [self setSkinModelWithIndex:FUBeautifySkinBlurLevel value:3.0];
    [self setSkinModelWithIndex:FUBeautifySkinEyeBright value:0.5];
    [self setSkinModelWithIndex:FUBeautifySkinToothWhiten value:0.4];
    
    [self setShapeModelWithIndex:FUBeautifyShapeCheekThinning value:0.3];
    [self setShapeModelWithIndex:FUBeautifyShapeIntensityNose value:0.5];
    [self setShapeModelWithIndex:FUBeautifyShapeEyeEnlarging value:0.25];
}

- (void)style3 {
    [self setSkinModelWithIndex:FUBeautifySkinColorLevel value:0.6];
    [self setSkinModelWithIndex:FUBeautifySkinRedLevel value:0.1];
    [self setSkinModelWithIndex:FUBeautifySkinBlurLevel value:1.8];

    [self setShapeModelWithIndex:FUBeautifyShapeCheekThinning value:0.3];
    [self setShapeModelWithIndex:FUBeautifyShapeCheekSmall value:0.15];
    [self setShapeModelWithIndex:FUBeautifyShapeEyeEnlarging value:0.65];
    [self setShapeModelWithIndex:FUBeautifyShapeIntensityNose value:0.3];
}

- (void)style4 {
    [self setSkinModelWithIndex:FUBeautifySkinColorLevel value:0.25];
    [self setSkinModelWithIndex:FUBeautifySkinBlurLevel value:3.0];
}

- (void)style5 {
    self.filter.strValue = @"fennen1";
    self.filter.mValue = 0.4;
    [self setSkinModelWithIndex:FUBeautifySkinColorLevel value:0.7];
    [self setSkinModelWithIndex:FUBeautifySkinBlurLevel value:3];
    
    [self setShapeModelWithIndex:FUBeautifyShapeCheekThinning value:0.35];
    [self setShapeModelWithIndex:FUBeautifyShapeEyeEnlarging value:0.65];
}

- (void)style6 {
    self.filter.strValue = @"fennen1";
    self.filter.mValue = 0.4;
    
    [self setSkinModelWithIndex:FUBeautifySkinColorLevel value:0.5];
    [self setSkinModelWithIndex:FUBeautifySkinBlurLevel value:3.0];
}

- (void)style7 {
    self.filter.strValue = @"ziran5";
    self.filter.mValue = 0.55;
    
    [self setSkinModelWithIndex:FUBeautifySkinColorLevel value:0.2];
    [self setSkinModelWithIndex:FUBeautifySkinRedLevel value:0.65];
    [self setSkinModelWithIndex:FUBeautifySkinBlurLevel value:3.3];

    [self setShapeModelWithIndex:FUBeautifyShapeCheekThinning value:0.1];
    [self setShapeModelWithIndex:FUBeautifyShapeCheekSmall value:0.05];
}

@end
