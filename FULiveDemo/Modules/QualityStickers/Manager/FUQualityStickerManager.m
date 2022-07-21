//
//  FUQualtyStickerManager.m
//  FULiveDemo
//
//  Created by Chen on 2021/3/31.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUQualityStickerManager.h"
#import "FUStickerHelper.h"

#import <FURenderKit/FUQualitySticker.h>

/// 允许同时下载任务最大数量
static NSInteger const kFUDownloadTasksMaxNumber = 4;

@interface FUQualityStickerManager ()

@property (nonatomic, strong) FUQualitySticker *curStickItem;

// 特殊道具（Avatar）
@property (nonatomic, strong) FUScene *scene;
@property (nonatomic, strong) FUAvatar *avatar;

/// 下载队列
@property (nonatomic, strong) NSOperationQueue *downloadQueue;

@end

@implementation FUQualityStickerManager

#pragma mark - Instance methods

- (void)downloadItem:(FUStickerModel *)sticker completion:(void (^)(NSError * _Nullable))completion {
    [self.downloadQueue addOperationWithBlock:^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [FUStickerHelper downloadItem:sticker completion:^(NSError * _Nullable error) {
            dispatch_semaphore_signal(semaphore);
            if (error) {
                completion(error);
            } else {
                completion(nil);
            }
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }];
}

- (void)cancelDownloadingTasks {
    [self.downloadQueue cancelAllOperations];
}

- (void)loadItem:(FUStickerModel *)sticker {
    switch (sticker.type) {
        case FUQualityStickerTypeAvatar:{
            // Avatar道具加载
            [self loadAvatarItem:sticker];
        }
            break;
        case FUQualityStickerTypeCommon:{
            // 普通道具加载
            [self loadCommonItem:sticker];
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
    if (_scene) {
        [[FURenderKit shareRenderKit] removeScene:self.scene completion:^(BOOL success) {
            [FURenderKit shareRenderKit].currentScene = nil;
        }];
    }
    if (_curStickItem) {
        [[FURenderKit shareRenderKit].stickerContainer removeAllSticks];
    }
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
        self.avatar.humanProcessorType = 0;
        [self.avatar setEnableHumanAnimDriver:YES];
        self.scene.AIConfig.avatarTranslationScale = FUPositionMake(0.45, 0.45, 0.25);
        [self.scene.AIConfig setAvatarAnimFilter:7 pos:0.05 angle:0.1];
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
    }
    return _avatar;
}

- (NSOperationQueue *)downloadQueue {
    if (!_downloadQueue) {
        _downloadQueue = [[NSOperationQueue alloc] init];
        _downloadQueue.maxConcurrentOperationCount = kFUDownloadTasksMaxNumber;
    }
    return _downloadQueue;
}

@end
