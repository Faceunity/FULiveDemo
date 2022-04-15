//
//  FUMainViewControllerManager.m
//  FULiveDemo
//
//  Created by Chen on 2021/2/24.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUMainViewControllerManager.h"

@interface FUMainViewControllerManager ()
@property (nonatomic, strong) NSArray<NSArray<FULiveModel *>*> *dataSource;
@end

@implementation FUMainViewControllerManager
- (instancetype)init {
    self = [super init];
    if (self) {
        self.dataSource = [self archiveItemDataSource];
    }
    return self;
}

/** 根据证书判断权限
 *  有权限的排列在前，没有权限的在后
 */
- (NSArray<NSArray<FULiveModel *>*> *)archiveItemDataSource {
    
    NSMutableArray *totalArray = [NSMutableArray arrayWithCapacity:1];
    NSArray *dataArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dataSource.plist" ofType:nil]];
    
    NSInteger count = dataArray.count;
    for (int i = 0 ; i < count; i ++) {
        NSMutableArray *modesArray = [NSMutableArray array];
        NSArray *tempArray = (NSArray *)dataArray[i];
        for (int j = 0; j < tempArray.count; j ++) {
            
            NSDictionary *dict = tempArray[j] ;
            FULiveModel *model = [[FULiveModel alloc] init];
            NSString *itemName = dict[@"itemName"] ;
            model.title = itemName ;
            model.maxFace = [dict[@"maxFace"] integerValue] ;
            model.enble = NO;
            model.type = [dict[@"itemType"] intValue];
            model.modules = dict[@"modules"] ;
            model.items = dict[@"items"] ;
            model.conpareCode = [dict[@"conpareCode"] intValue];

            model.animationIcon = [dict[@"animationIcon"] boolValue];
            model.animationNamed = dict[@"animationNamed"];
            [modesArray addObject:model];
        }
        [totalArray addObject:modesArray];
        
    }
    
    int module = [FURenderKit getModuleCode:0];
    int module1 = [FURenderKit getModuleCode:1];
    
    NSMutableArray *dataSource = [NSMutableArray arrayWithCapacity:1];
    for (NSMutableArray *array in totalArray) {
        NSMutableArray *mutArray = [NSMutableArray array];
        
        NSMutableArray *eablMutArray = [NSMutableArray array];
        
        NSMutableArray *unEablmutArray = [NSMutableArray array];
        for (FULiveModel *model in array) {
            
            model.enble = YES ;
            BOOL isEable = YES;
            for (NSNumber *num in model.modules) {
                
                /* 权限码：分前32位和后32位 不同功能需要区别判断下*/
                if (model.conpareCode == 0) {
                    isEable = (module & [num intValue]) > 0 ? YES:NO;
                }else{
                    isEable = (module1 & [num intValue]) > 0 ? YES:NO;
                }
                model.enble = model.enble && isEable;
            }
            
            if (model.enble) {
                [eablMutArray addObject:model];
            }else{
                [unEablmutArray addObject:model];
            }

        }
        
        [mutArray addObjectsFromArray:eablMutArray];
        [mutArray addObjectsFromArray:unEablmutArray];
        
        [dataSource addObject:mutArray];
    }
    return [NSArray arrayWithArray:dataSource];
}

@end
