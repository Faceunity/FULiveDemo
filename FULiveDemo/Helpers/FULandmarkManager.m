//
//  FULandmarkManager.m
//  FULiveDemo
//
//  Created by 项林平 on 2021/10/9.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FULandmarkManager.h"

#import <FURenderKit/FURenderKit.h>

/// 设置是否显示点位开关，默认为NO
BOOL const FUShowLandmark = NO;

@interface FULandmarkManager ()

@property (nonatomic, strong) FUSticker *landmarksItem;

@end

@implementation FULandmarkManager

+ (FULandmarkManager *)shared {
    static FULandmarkManager *landmarkView;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        landmarkView = [[self alloc] initWithFrame:CGRectMake(10, CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) + 60, 50, 30)];
    });
    [landmarkView addTarget:self action:@selector(landmarkSwitchAction:) forControlEvents:UIControlEventValueChanged];
    return landmarkView;
}

+ (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:[self shared]];
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

- (FUSticker *)landmarksItem {
    if (!_landmarksItem) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"landmarks" ofType:@"bundle"];
        _landmarksItem = [[FUSticker alloc] initWithPath:path name:@"landmarks"];
    }
    return _landmarksItem;
}

@end
