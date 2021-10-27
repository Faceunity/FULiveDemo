//
//  FUBodyBeautyManager.m
//  FULiveDemo
//
//  Created by Chen on 2021/3/5.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUBodyBeautyManager.h"
#import "FUPositionInfo.h"
#import <MJExtension/NSObject+MJKeyValue.h>
#import "FULocalDataManager.h"
#import <FURenderKit/FUAIKit.h>

@interface FUBodyBeautyManager ()
@property (nonatomic, strong) NSArray <FUPositionInfo *> *dataArray;
@end

@implementation FUBodyBeautyManager

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"body_slim" ofType:@"bundle"];
        self.bodyBeauty = [[FUBodyBeauty alloc] initWithPath:filePath name:@"body_slim"];
        self.bodyBeauty.debug = 0;
        [self loadItem];
        NSArray *par = [FULocalDataManager bodyBeautyJsonData];
        self.dataArray = [FUPositionInfo mj_objectArrayWithKeyValuesArray: par];
    }
    return self;
}

//调整人体数据
- (void)setBodyBeautyModel:(FUPositionInfo *)model {
    switch (model.type) {
        case FUPositionInfoTypeSlimming:
            self.bodyBeauty.bodySlimStrength = model.value;
            break;
        case FUPositionInfoTypeLegged:
            self.bodyBeauty.legSlimStrength = model.value;
            break;
        case FUPositionInfoTypeWaist:
            self.bodyBeauty.waistSlimStrength = model.value;
            break;
        case FUPositionInfoTypeshoulder:
            self.bodyBeauty.shoulderSlimStrength = model.value;
            break;
        case FUPositionInfoTypeHip:
            self.bodyBeauty.hipSlimStrength = model.value;
            break;
        case FUPositionInfoTypeHeadSlim:
            self.bodyBeauty.headSlim = model.value;
            break;
        case FUPositionInfoTypeLegSlim:
            self.bodyBeauty.legSlim = model.value;
            break;
        default:
            break;
    }
}

- (void)loadItem {
    [FURenderKit shareRenderKit].bodyBeauty = self.bodyBeauty;
}
- (void)releaseItem {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [FURenderKit shareRenderKit].bodyBeauty = nil;
        self.bodyBeauty = nil;
    });
}
@end
