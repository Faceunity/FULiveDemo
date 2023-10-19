//
//  FULandmarkManager.m
//  FULiveDemo
//
//  Created by 项林平 on 2021/10/9.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FULandmarkManager.h"

#import <FURenderKit/FUFacialFeatures.h>

@interface FULandmarkManager ()

@property (nonatomic, strong) FUFacialFeatures *landmarksItem;

@end

@implementation FULandmarkManager

+ (FULandmarkManager *)shared {
    static FULandmarkManager *landmarkView;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGFloat top = FUHeightIncludeTopSafeArea(0);
        landmarkView = [[self alloc] initWithFrame:CGRectMake(10, top + 60, 50, 30)];
    });
    [landmarkView addTarget:self action:@selector(landmarkSwitchAction:) forControlEvents:UIControlEventValueChanged];
    return landmarkView;
}

+ (void)show {
    [FUKeyWindow() addSubview:[self shared]];
}

+ (void)dismiss {
    if ([self shared].superview) {
        [self shared].on = NO;
        [[FURenderKit shareRenderKit].stickerContainer removeSticker:[self shared].landmarksItem completion:nil];
        [[self shared] removeFromSuperview];
    }
}

+ (void)landmarkSwitchAction:(UISwitch *)sender {
    if (sender.isOn) {
        [[FURenderKit shareRenderKit].stickerContainer addSticker:[self shared].landmarksItem completion:nil];
    } else {
        [[FURenderKit shareRenderKit].stickerContainer removeSticker:[self shared].landmarksItem completion:nil];
    }
}

- (FUFacialFeatures *)landmarksItem {
    if (!_landmarksItem) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"landmarks" ofType:@"bundle"];
        _landmarksItem = [[FUFacialFeatures alloc] initWithPath:path name:@"landmarks"];
        _landmarksItem.landmarksType = FUAITYPE_FACELANDMARKS239;
    }
    return _landmarksItem;
}

@end
