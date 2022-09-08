//
//  FUPosterManager.m
//  FULiveDemo
//
//  Created by lsh726 on 2021/3/7.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUPosterManager.h"

static dispatch_once_t onceToken;

static FUPosterManager *instance = nil;

@interface FUPosterManager ()

@property (nonatomic, copy) NSArray<NSString *> *posterItems;
@property (nonatomic, copy) NSArray<NSString *> *posterList;
@property (nonatomic, copy) NSArray<NSString *> *posterIcons;


@end

@implementation FUPosterManager

+ (instancetype)sharedManager {
    dispatch_once(&onceToken, ^{
        instance = [[FUPosterManager alloc] init];
    });
    return instance;
}

+ (void)destory {
    onceToken = 0;
    instance = nil;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [FUAIKit shareKit].maxTrackFaces = 4;
        [FUAIKit shareKit].faceProcessorDetectMode = FUFaceProcessorDetectModeImage;
    }
    return self;
}

- (NSArray<NSString *> *)posterItems {
    if (!_posterItems) {
        _posterItems = @[@"poster1", @"poster2", @"poster3", @"poster4", @"poster5", @"poster6", @"poster7", @"poster8"];
    }
    return _posterItems;
}


- (NSArray<NSString *> *)posterList {
    if (!_posterList) {
        _posterList = @[@"poster1_list", @"poster2_list", @"poster3_list", @"poster4_list", @"poster5_list", @"poster6_list", @"poster7_list", @"poster8_list"];
    }
    return _posterList;
}

- (NSArray<NSString *> *)posterIcons {
    if (!_posterIcons) {
        _posterIcons = @[@"poster1_icon", @"poster2_icon", @"poster3_icon", @"poster4_icon", @"poster5_icon", @"poster6_icon", @"poster7_icon", @"poster8_icon"];
    }
    return _posterIcons;
}

@end
