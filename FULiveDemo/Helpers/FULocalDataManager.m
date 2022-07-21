//
//  FULocalDataManager.m
//  FULiveDemo
//
//  Created by Chen on 2021/2/25.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FULocalDataManager.h"
#import <MJExtension.h>

NSString * const FUPersistentBeautyKey = @"FUPersistentBeauty";

@interface FULocalDataManager ()
@property (nonatomic, strong) NSDictionary *stickTipsData;
@property (nonatomic, strong) NSDictionary *makeupJsonData;
@property (nonatomic, strong) NSDictionary *makeupWholeJsonData;
@property (nonatomic, strong) NSDictionary *lightMakupJsonData;
@property (nonatomic, strong) NSArray *bodyBeautyJsonData;
@end

@implementation FULocalDataManager
+ (instancetype)shareManager {
    static FULocalDataManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[FULocalDataManager alloc] init];
    });
    return _manager;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        self.stickTipsData = [self stickerTipsJsonData];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:FUPersistentBeautyKey]) {
            // 获取本地持久化数据
            NSDictionary *beautyData = [[NSUserDefaults standardUserDefaults] objectForKey:FUPersistentBeautyKey];
            self.persistentBeauty = [FUPersistentBeautyModel mj_objectWithKeyValues:beautyData];
        } else {
            self.persistentBeauty = [[FUPersistentBeautyModel alloc] init];
        }
    }
    return self;
}

- (void)save {
    if (!self.persistentBeauty.beautySkins || !self.persistentBeauty.beautyShapes || !self.persistentBeauty.beautyFilters) {
        return;
    }
    NSDictionary *beautyData = self.persistentBeauty.mj_JSONObject;
    [[NSUserDefaults standardUserDefaults] setObject:beautyData forKey:FUPersistentBeautyKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSDictionary *)stickerTipsJsonData {
    return [[FULocalDataManager shareManager] stickerTipsJsonData];
}

+ (NSDictionary *)makeupJsonData {
    return [[FULocalDataManager shareManager] makeupJsonData];
}

+ (NSDictionary *)makeupWholeJsonData {
    return [[FULocalDataManager shareManager] makeupWholeJsonData];
}

//轻美妆数据
+ (NSDictionary *)lightMakeupJsonData {
    return [[FULocalDataManager shareManager] lightMakupJsonData];
}

+ (NSArray *)bodyBeautyJsonData {
    return [[FULocalDataManager shareManager] bodyBeautyJsonData];
}

//道具贴纸提示语数据
- (NSDictionary *)stickerTipsJsonData {
    if (!_stickTipsData) {
        _stickTipsData =  @{
            @"hez_ztt_fu_mp":@"张嘴试试",
            @"future_warrior":@"张嘴试试",
            @"jet_mask":@"鼓腮帮子",
            @"sdx2":@"皱眉触发",
            @"luhantongkuan_ztt_fu":@"眨一眨眼",
            @"qingqing_ztt_fu":@"嘟嘴试试",
            @"xiaobianzi_zh_fu":@"微笑触发",
            @"xiaoxueshen_ztt_fu":@"吹气触发",
            @"hez_ztt_fu":@"张嘴试试",
            @"ssd_thread_korheart":@"单手手指比心",
            @"fu_zh_baoquan":@"双手抱拳",
            @"fu_zh_hezxiong":@"双手合十",
            @"fu_ztt_live520":@"双手比心",
            @"ssd_thread_thumb":@"竖个拇指",
            @"ssd_thread_six":@"比个六",
            @"ssd_thread_cute":@"双拳靠近脸颊卖萌",
            @"ctrl_rain":@"推出手掌",
            @"ctrl_snow":@"推出手掌",
            @"ctrl_flower":@"推出手掌",
            @"big_head_facewarp3":@"微笑触发"
        };
    }
    return _stickTipsData;
}


//获取美妆业务数据
- (NSDictionary *)makeupJsonData {
    if (!_makeupJsonData) {
        NSString *path= [[NSBundle mainBundle] pathForResource:@"makeup" ofType:@"json"];
        NSData *data= [[NSData alloc] initWithContentsOfFile:path];
        _makeupJsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    }
    return _makeupJsonData;
}

//美妆 - 整体妆容
- (NSDictionary *)makeupWholeJsonData {
    if (!_makeupWholeJsonData) {
        /* 整体妆容 */
        /*注意： 子妆信息makeups，FUMakeupSupModel 设置bundleName会自动在mainBundle中对应的json信息配置，详情查看FUMakeupSupModel.m
         makeups 信息做组合妆匹配单个子妆，选中icon高亮业务用*/
        NSString *wholePath = [[NSBundle mainBundle] pathForResource:@"makeup_whole" ofType:@"json"];
        NSData *wholeData = [[NSData alloc] initWithContentsOfFile:wholePath];
        _makeupWholeJsonData = [NSJSONSerialization JSONObjectWithData:wholeData options:NSJSONReadingMutableContainers error:nil];
    }
    return _makeupWholeJsonData;
}

- (NSDictionary *)lightMakupJsonData {
    if (!_lightMakupJsonData) {
        NSString *lightMakeupPath = [[NSBundle mainBundle] pathForResource:@"lightMakeup" ofType:@"json"];
        NSData *lightMakeupData = [[NSData alloc] initWithContentsOfFile:lightMakeupPath];
        _lightMakupJsonData = [NSJSONSerialization JSONObjectWithData:lightMakeupData options:NSJSONReadingMutableContainers error:nil];
    }
    return _lightMakupJsonData;
}

- (NSArray *)bodyBeautyJsonData {
    if (!_bodyBeautyJsonData) {
        NSString *bodyBeautyPath = [[NSBundle mainBundle] pathForResource:@"BodyBeautyDefault" ofType:@"json"];
        NSData *bodyData = [[NSData alloc] initWithContentsOfFile:bodyBeautyPath];
        _bodyBeautyJsonData = [NSJSONSerialization JSONObjectWithData:bodyData options:NSJSONReadingMutableContainers error:nil];
    }
    return _bodyBeautyJsonData;
}
@end
