//
//  FUHomepageViewModel.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/7/4.
//  Copyright © 2022 FaceUnity. All rights reserved.
//

#import "FUHomepageViewModel.h"

@implementation FUHomepageViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        // 处理模块权限
        for (FUHomepageGroup *group in self.dataSource) {
            for (FUHomepageModule *module in group.modules) {
                // 获取模块权限码
                int permission = [FURenderKit getModuleCode:(int)module.moduleCode];
                // 判断是否有权限
                module.enable = permission & module.permissionCode;
            }
        }
    }
    return self;
}

- (NSArray<FUHomepageGroup *> *)dataSource {
    if (!_dataSource) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"homepage_data_source" ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:path];
        NSArray *jsonArray = (NSArray *)[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        NSArray *models = [FUHomepageGroup mj_objectArrayWithKeyValuesArray:jsonArray];
        _dataSource = [models copy];
    }
    return _dataSource;
}

@end
