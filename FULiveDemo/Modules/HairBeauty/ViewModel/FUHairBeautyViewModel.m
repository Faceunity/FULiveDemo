//
//  FUHairBeautyViewModel.m
//  FULiveDemo
//
//  Created by lsh726 on 2021/3/4.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUHairBeautyViewModel.h"
#import "FUHairBeautyModel.h"

@interface FUHairBeautyViewModel ()

@property (nonatomic, copy) NSArray<FUHairBeautyModel *> *hairItems;

@property (nonatomic, copy) NSArray<NSString *> *icons;

@end

@implementation FUHairBeautyViewModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.selectedIndex = 1;
    }
    return self;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (selectedIndex == 0) {
        [FURenderKit shareRenderKit].hairBeauty = nil;
        _selectedIndex = 0;
        return;
    }
    _selectedIndex = selectedIndex;
    FUHairBeautyModel *model = self.hairItems[selectedIndex];
    if (model.isGradient) {
        // 渐变色
        if (![FURenderKit shareRenderKit].hairBeauty || [[FURenderKit shareRenderKit].hairBeauty.name isEqualToString:@"hair_normal"]) {
            // 重新初始化
            NSString *path = [[NSBundle mainBundle] pathForResource:@"hair_gradient" ofType:@"bundle"];
            FUHairBeauty *hair = [FUHairBeauty itemWithPath:path name:@"hair_gradient"];
            [FURenderKit shareRenderKit].hairBeauty = hair;
        }
    } else {
        // 普通颜色
        if (![FURenderKit shareRenderKit].hairBeauty || [[FURenderKit shareRenderKit].hairBeauty.name isEqualToString:@"hair_gradient"]) {
            // 重新初始化
            NSString *path = [[NSBundle mainBundle] pathForResource:@"hair_normal" ofType:@"bundle"];
            FUHairBeauty *hair = [FUHairBeauty itemWithPath:path name:@"hair_normal"];
            [FURenderKit shareRenderKit].hairBeauty = hair;
        }
    }
    [FURenderKit shareRenderKit].hairBeauty.index = (int)model.index;
    [FURenderKit shareRenderKit].hairBeauty.strength = model.value;
}

- (double)strengthAtIndex:(NSInteger)index {
    FUHairBeautyModel *model = self.hairItems[index];
    return model.value;
}

- (void)setStrength:(double)strength {
    self.hairItems[self.selectedIndex].value = strength;
    [FURenderKit shareRenderKit].hairBeauty.strength = strength;
}

- (double)strength {
    FUHairBeautyModel *model = self.hairItems[self.selectedIndex];
    return model.value;
}

- (NSArray<FUHairBeautyModel *> *)hairItems {
    if (!_hairItems) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"hair_beauty" ofType:@"json"];
        _hairItems = [FUHairBeautyModel modelArrayWithJSON:[NSData dataWithContentsOfFile:path]];
    }
    return _hairItems;
}

- (NSArray<NSString *> *)icons {
    if (!_icons) {
        _icons =  @[
            @"reset_item",
            @"icon_gradualchangehair_01",
            @"icon_gradualchangehair_02",
            @"icon_gradualchangehair_03",
            @"icon_gradualchangehair_04",
            @"icon_gradualchangehair_05",
            @"hair_color_1",
            @"hair_color_2",
            @"hair_color_3",
            @"hair_color_4",
            @"hair_color_5",
            @"hair_color_6",
            @"hair_color_7",
            @"hair_color_8"
        ];
    }
    return _icons;
}

#pragma mark - Overriding

- (FUModule)module {
    return FUModuleHairBeauty;
}

- (CGFloat)captureButtonBottomConstant {
    return FUHeightIncludeBottomSafeArea(134);
}

@end
