//
//  FUHomepageViewModel.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/7/4.
//  Copyright © 2022 FaceUnity. All rights reserved.
//

#import "FUHomepageViewModel.h"
#import "FUHomepageModel.h"

@interface FUHomepageViewModel ()

@property (nonatomic, copy) NSArray<FUHomepageGroup *> *dataSource;

@property (nonatomic, copy) NSArray<UIImage *> *animationImages;

@end

@implementation FUHomepageViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        FUDevicePerformanceLevel level = [FURenderKit devicePerformanceLevel];
        // 处理模块权限
        NSInteger moduleCode0 = [FURenderKit getModuleCode:0];
        NSInteger moduleCode1 = [FURenderKit getModuleCode:1];
        for (FUHomepageGroup *group in self.dataSource) {
            for (FUHomepageModule *module in group.modules) {
                if (!module.authCode) {
                    module.enable = YES;
                } else {
                    NSString *authCodeString = module.authCode;
                    // 分割权限码
                    NSArray *authCodes = [authCodeString componentsSeparatedByString:@"-"];
                    NSInteger code0 = [authCodes[0] integerValue], code1 = [authCodes[1] integerValue];
                    // 判断是否有权限(moduleCode0对比code0，moduleCode1对比code1)
                    module.enable = (moduleCode0 & code0) || (moduleCode1 & code1);
                }
                // 性能等级判断
                module.enable = level >= module.performanceLevel;
            }
        }
        NSMutableArray<UIImage *> *images = [[NSMutableArray alloc] init];
        for (NSUInteger i = 0; i < 83; i++) {
            NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"animation_icon_%@", @(i)] ofType:@"png"];
            UIImage *image = [UIImage imageWithContentsOfFile:path];
            [images addObject:image];
        }
        self.animationImages = [images copy];
    }
    return self;
}

- (NSString *)groupNameOfGroup:(NSUInteger)group {
    return FULocalizedString(self.dataSource[group].name);
}

- (NSUInteger)modulesCountOfGroup:(NSUInteger)group {
    return self.dataSource[group].modules.count;
}

- (FUModule)moduleAtIndex:(NSUInteger)index group:(NSUInteger)group {
    return self.dataSource[group].modules[index].module;
}

- (UIImage *)moduleIconAtIndex:(NSUInteger)index group:(NSUInteger)group {
    FUHomepageModule *module = self.dataSource[group].modules[index];
    return [UIImage imageNamed:module.title];
}

- (NSString *)moduleTitleAtIndex:(NSUInteger)index group:(NSUInteger)group {
    FUHomepageModule *module = self.dataSource[group].modules[index];
    return FULocalizedString(module.title);
}

- (UIImage *)moduleBottomBackgroundImageAtIndex:(NSUInteger)index group:(NSUInteger)group {
    FUHomepageModule *module = self.dataSource[group].modules[index];
    return module.enable ? [UIImage imageNamed:@"homepage_cell_bottom_image"] : [UIImage imageNamed:@"homepage_cell_bottom_image_gray"];
}

- (BOOL)moduleEnableStatusAtIndex:(NSUInteger)index group:(NSUInteger)group {
    FUHomepageModule *module = self.dataSource[group].modules[index];
    return module.enable;
}

- (NSArray<FUHomepageGroup *> *)dataSource {
    if (!_dataSource) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"homepage_data_source" ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:path];
        NSArray *jsonArray = (NSArray *)[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        NSArray *models = [NSArray yy_modelArrayWithClass:[FUHomepageGroup class] json:jsonArray];
        _dataSource = [models copy];
    }
    return _dataSource;
}

@end
