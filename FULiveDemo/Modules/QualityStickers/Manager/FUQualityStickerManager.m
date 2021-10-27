//
//  FUQualtyStickerManager.m
//  FULiveDemo
//
//  Created by Chen on 2021/3/31.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUQualityStickerManager.h"
#import "FULiveDefine.h"

#import <FURenderKit/FUQualitySticker.h>

@interface FUQualityStickerManager ()

@property (nonatomic, strong) FUQualitySticker *curStickItem;

// 特殊道具（Avatar）
@property (nonatomic, strong) FUScene *scene;
@property (nonatomic, strong) FUAvatar *avatar;

@end

@implementation FUQualityStickerManager

#pragma mark - Instance methods
- (void)loadItemWithModel:(FUStickerModel *)stickerModel {
    switch (stickerModel.type) {
        case FUQualityStickerTypeAvatar:{
            // Avatar道具加载
            [self loadAvatarItem:stickerModel];
        }
            break;
        case FUQualityStickerTypeCommon:{
            // 普通道具加载
            [self loadCommonItem:stickerModel];
        }
            break;
    }
}

- (void)clickCurrentItem {
    if (!_curStickItem) {
        return;
    }
    [_curStickItem clickToChange];
}

- (void)releaseItem {
    
    [[FURenderKit shareRenderKit] removeScene:self.scene completion:nil];
    if (_avatar) {
        _avatar = nil;
    }
    if (_scene) {
        _scene = nil;
    }
    if (_curStickItem) {
        _curStickItem = nil;
    }
    [[FURenderKit shareRenderKit].stickerContainer removeAllSticks];
}

#pragma mark - Private methods
- (void)loadAvatarItem:(FUStickerModel *)stickerModel {
    
    [[FURenderKit shareRenderKit] addScene:self.scene completion:^(BOOL success) {
        // 读取json配置文件
        NSString *jsonFilePath = [[[FUStickerBundlesPath stringByAppendingPathComponent:stickerModel.tag] stringByAppendingPathComponent:stickerModel.stickerId] stringByAppendingPathComponent:@"info.json"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:jsonFilePath]) {
            NSLog(@"Avatar道具缺少info.json文件");
            return;
        }
        
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:jsonFilePath] options:NSJSONReadingMutableLeaves error:nil];
        if (!dictionary) {
            NSLog(@"info.json文件错误");
            return;
        }
        
        
        
        for (NSString *keyString in dictionary.allKeys) {
            if ([keyString isEqualToString:@"components"]) {
                // 身体组件
                NSArray *components = (NSArray *)dictionary[keyString];
                for (NSString *componentBundleString in components) {
                    NSString *componentPath = [[[FUStickerBundlesPath stringByAppendingPathComponent:stickerModel.tag] stringByAppendingPathComponent:stickerModel.stickerId] stringByAppendingPathComponent:componentBundleString];
                    FUItem *componentItem = [FUItem itemWithPath:componentPath name:componentBundleString];
                    [self.avatar addComponent:componentItem];
                }
            } else if ([keyString isEqualToString:@"anims"]) {
                // 动画
                NSArray *animations = (NSArray *)dictionary[keyString];
                for (NSString *animationBundleString in animations) {
                    NSString *animationPath = [[[FUStickerBundlesPath stringByAppendingPathComponent:stickerModel.tag] stringByAppendingPathComponent:stickerModel.stickerId] stringByAppendingPathComponent:animationBundleString];
                    FUAnimation *animationItem = [FUAnimation itemWithPath:animationPath name:animationBundleString];
                    if (animationItem) {
                        [self.avatar addAnimation:animationItem];
                    }
                }
            }
        }
        [self.scene addAvatar:self.avatar];
        self.avatar.position = FUPositionMake(25.2, iPhoneXStyle ? (56.14 - 50.0*24.0/72.0) : 56.14, -537.94);
        self.scene.AIConfig.avatarTranslationScale = FUPositionMake(0.45, 0.45, 0.25);
        [self.scene.AIConfig setAvatarAnimFilter:7 pos:0.05 angle:0.1];
        self.avatar.visible = YES;
        NSLog(@"Load success");
        [FURenderKit shareRenderKit].currentScene = self.scene;
        
    }];
}

- (void)loadCommonItem:(FUStickerModel *)stickerModel {
    NSString *filePath = [[FUStickerBundlesPath stringByAppendingPathComponent:stickerModel.tag] stringByAppendingPathComponent:stickerModel.itemId];
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (isExist) {
        FUQualitySticker *item = [[FUQualitySticker alloc] initWithPath:filePath name:stickerModel.stickerId];
        item.isFlipPoints = stickerModel.isMakeupItem;
        item.is3DFlipH = stickerModel.is3DFlipH;
        [[FURenderKit shareRenderKit].stickerContainer replaceSticker:self.curStickItem withSticker:item completion:^{
            NSLog(@"Load success");
        }];
        self.curStickItem = item;
    } else {
        NSLog(@"精品贴纸道具不存在");
    }
}

#pragma mark - Getters
- (FUScene *)scene {
    if (!_scene) {
        _scene = [[FUScene alloc] init];
        _scene.AIConfig.bodyTrackEnable = YES;
        _scene.AIConfig.bodyTrackMode = FUBodyTrackModeFull;
    }
    return _scene;
}

- (FUAvatar *)avatar {
    if (!_avatar) {
        _avatar = [[FUAvatar alloc] init];
        _avatar.visible = NO;
    }
    return _avatar;
}

@end
