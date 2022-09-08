//
//  FUHairManager.m
//  FULiveDemo
//
//  Created by lsh726 on 2021/3/4.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUHairManager.h"
#import <FURenderKit/FUAIKit.h>
@implementation FUHairManager
- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"hair_gradient" ofType:@"bundle"];
        self.hair = [[FUHairBeauty alloc] initWithPath:path name:@"hair"];
        self.hair.index = 0;
        self.hair.strength = 0.5;
        [self loadItem];
        self.curMode = FUHairModelModelGradient;
    }
    return self;
}

- (void)loadItem {
    [FURenderKit shareRenderKit].hairBeauty = self.hair;
}

- (void)loadItemWithPath:(NSString *)path {
    self.hair = [[FUHairBeauty alloc] initWithPath:path name:@"hair"];
    [self loadItem];
}

- (NSArray *)hairItems {
    if (!_hairItems) {
        _hairItems = @[@"resetItem", @"icon_gradualchangehair_01", @"icon_gradualchangehair_02", @"icon_gradualchangehair_03", @"icon_gradualchangehair_04", @"icon_gradualchangehair_05", @"hair_color_1", @"hair_color_2", @"hair_color_3", @"hair_color_4", @"hair_color_5", @"hair_color_6", @"hair_color_7", @"hair_color_8"];
    }
    return _hairItems;
}

@end
