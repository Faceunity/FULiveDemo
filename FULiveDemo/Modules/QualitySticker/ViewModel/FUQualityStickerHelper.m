//
//  FUQualityStickerHelper.m
//  FULiveDemo
//
//  Created by 项林平 on 2021/3/11.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUQualityStickerHelper.h"
#import "FUNetworkingHelper.h"

#import "FUQualityStickerModel.h"

#import <SSZipArchive.h>

@implementation FUQualityStickerHelper

+ (void)itemTagsCompletion:(void (^)(BOOL, NSArray * _Nullable))complection {
    [[FUNetworkingHelper sharedInstance] getWithURL:@"guest/tags" parameters:@{@"platform" : @"mobile"} success:^(id  _Nonnull responseObject) {
        if (responseObject[@"data"]) {
            NSArray *resultArray = [responseObject[@"data"] copy];
            !complection ?: complection(YES, resultArray);
        } else {
            !complection ?: complection(NO, nil);
        }
    } failure:^(NSError * _Nonnull error) {
        !complection ?: complection(NO, nil);
    }];
}
+ (void)itemListWithTag:(NSString *)tag completion:(void (^)(NSArray<FUQualityStickerModel *> *, NSError *))completion {
    NSDictionary *params = @{
        @"platform" : @"mobile",
        @"tag" : tag
    };
    [[FUNetworkingHelper sharedInstance] postWithURL:@"guest/tools" parameters:params success:^(id  _Nonnull responseObject) {
        NSMutableArray <FUQualityStickerModel *> *resultArray = [NSMutableArray array];
        if (responseObject[@"data"][@"docs"]) {
            NSArray *array = responseObject[@"data"][@"docs"];
            for (int i = 0; i < array.count; i++) {
                NSDictionary *doc = array[i];
                if (!doc || [doc isKindOfClass:[NSNull class]]) {
                    continue;
                }
                FUQualityStickerModel *model = [[FUQualityStickerModel alloc] init];
                model.tag = tag;
                model.stickerId = doc[@"tool"][@"_id"];
                model.iconId = doc[@"tool"][@"icon"][@"uid"];
                model.iconURLString = doc[@"tool"][@"icon"][@"url"];
                model.itemId = doc[@"tool"][@"bundle"][@"uid"];
                // 道具类型
                model.type = [doc[@"tool"][@"category"] isEqualToString:@"avatar"] ? FUQualityStickerTypeAvatar : FUQualityStickerTypeCommon;
                // 特殊道具处理
                if (doc[@"tool"][@"adapter"] && [doc[@"tool"][@"adapter"] length] > 0) {
                    NSString *adapterString = doc[@"tool"][@"adapter"];
                    model.keepPortrait = [adapterString containsString:@"0"];
                    model.single = [adapterString containsString:@"1"];
                    model.makeupItem = [adapterString containsString:@"2"];
                    model.needClick = [adapterString containsString:@"3"];
                    model.is3DFlipH = [adapterString containsString:@"4"];
                } else {
                    model.keepPortrait = NO;
                    model.single = NO;
                    model.makeupItem = NO;
                    model.needClick = NO;
                    model.is3DFlipH = NO;
                }
                // toast
                if (doc[@"tool"][@"eventToast"]) {
                    model.toast = doc[@"tool"][@"eventToast"];
                }
                if (doc[@"tool"][@"eventToastEn"]) {
                    model.toastEn = doc[@"tool"][@"eventToastEn"];
                }
                [resultArray addObject:model];
            }
        }
        !completion ?: completion(resultArray, nil);
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"获取贴纸列表失败");
        !completion ?: completion(nil, error);
    }];
}

+ (void)downloadItem:(FUQualityStickerModel *)sticker completion:(void (^)(NSError * _Nullable))completion {
    [[FUNetworkingHelper sharedInstance] getWithURL:@"guest/download" parameters:@{@"id" : sticker.stickerId, @"platform" : @"mobile"} success:^(id  _Nonnull responseObject) {
        if (responseObject[@"data"][@"url"]) {
            NSString *downloadURLString = responseObject[@"data"][@"url"];
            NSString *directoryPathString = [FUStickerBundlesPath stringByAppendingPathComponent:sticker.tag];
            if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPathString]) {
                [[NSFileManager defaultManager] createDirectoryAtPath:directoryPathString withIntermediateDirectories:YES attributes:nil error:nil];
            }
            [[FUNetworkingHelper sharedInstance] downloadWithURL:downloadURLString directoryPath:directoryPathString fileName:sticker.itemId progress:^(NSProgress * _Nonnull progress) {
            } success:^(id  _Nonnull responseObject) {
                NSURL *responseURL = (NSURL *)responseObject;
                if ([responseURL.pathExtension isEqualToString:@"zip"]) {
                    // zip包需要解压，当前目录新建子目录
                    NSString *unzipDestonationPath = [directoryPathString stringByAppendingPathComponent:sticker.stickerId];
                    if (![[NSFileManager defaultManager] fileExistsAtPath:unzipDestonationPath]) {
                        [[NSFileManager defaultManager] createDirectoryAtPath:unzipDestonationPath withIntermediateDirectories:YES attributes:nil error:nil];
                    }
                    if ([SSZipArchive unzipFileAtPath:responseURL.path toDestination:unzipDestonationPath]) {
                        !completion ?: completion(nil);
                    } else {
                        NSLog(@"道具解压失败");
                        // 解压失败暂时认为压缩包有问题，删除本地文件
                        [[NSFileManager defaultManager] removeItemAtURL:responseURL error:nil];
                        !completion ?: completion([NSError errorWithDomain:NSCocoaErrorDomain code:-1 userInfo:@{NSUnderlyingErrorKey : @"Unzip failed"}]);
                    }
                } else {
                    !completion ?: completion(nil);
                }
            } failure:^(NSError * _Nonnull error) {
                !completion ?: completion(error);
            }];
        } else {
            !completion ?: completion([NSError errorWithDomain:NSCocoaErrorDomain code:-1 userInfo:@{NSUnderlyingErrorKey : @"Empty URL"}]);
        }
    } failure:^(NSError * _Nonnull error) {
        !completion ?: completion(error);
    }];
}

+ (void)cancelStickerHTTPTasks {
    [[FUNetworkingHelper sharedInstance] cancelAllHttpRequests];
}

+ (NSArray<FUQualityStickerModel *> *)localStickersWithTag:(NSString *)stickerTag {
    NSString *stickersDataPathString = [[FUStickersPath stringByAppendingPathComponent:stickerTag] stringByAppendingPathComponent:@"FUQualityStickerModels.data"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:stickersDataPathString]) {
        return nil;
    }
    return [[NSKeyedUnarchiver unarchiveObjectWithFile:stickersDataPathString] copy];
}

+ (void)updateLocalStickersWithStickers:(NSArray<FUQualityStickerModel *> *)stickers tag:(NSString *)stickerTag {
    if (stickers.count == 0) {
        return;
    }
    NSString *stickersFilePathString = [FUStickersPath stringByAppendingPathComponent:stickerTag];
    NSString *stickersDataPathString = [stickersFilePathString stringByAppendingPathComponent:@"FUQualityStickerModels.data"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:stickersFilePathString]) {
        // 本地还没有创建文件夹，先创建文件夹，再保存最新贴纸
        if ([[NSFileManager defaultManager] createDirectoryAtPath:stickersFilePathString withIntermediateDirectories:YES attributes:nil error:nil]) {
            [NSKeyedArchiver archiveRootObject:stickers toFile:stickersDataPathString];
        }
        return;
    }
    NSArray *localStickers = [NSKeyedUnarchiver unarchiveObjectWithFile:stickersDataPathString];
    if (!localStickers || localStickers.count == 0) {
        // 本地贴纸为空，直接保存最新贴纸
        [NSKeyedArchiver archiveRootObject:stickers toFile:stickersDataPathString];
        return;
    }
    
    // 删除本地数据
    [[NSFileManager defaultManager] removeItemAtPath:stickersDataPathString error:nil];
    
    // 更新为最新数据
    [NSKeyedArchiver archiveRootObject:stickers toFile:stickersDataPathString];
    
    // 删除本地多余的icon数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSString *iconsPath = [FUStickerIconsPath stringByAppendingPathComponent:stickerTag];
        NSArray *iconDataArray = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:iconsPath error:nil] copy];
        for (NSString *iconName in iconDataArray) {
            BOOL needDelete = YES;
            for (FUQualityStickerModel *model in stickers) {
                if ([model.iconId isEqualToString:iconName]) {
                    // 新贴纸中存在该icon，不需要删除
                    needDelete = NO;
                    break;
                }
            }
            if (needDelete) {
                // 需要删除该icon
                [[NSFileManager defaultManager] removeItemAtPath:[iconsPath stringByAppendingPathComponent:iconName] error:nil];
            }
        }
    });
    
    // 删除本地多余的道具包
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSString *itemsPath = [FUStickerIconsPath stringByAppendingPathComponent:stickerTag];
        NSArray *itemDataArray = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:itemsPath error:nil] copy];
        for (NSString *itemName in itemDataArray) {
            BOOL needDelete = YES;
            for (FUQualityStickerModel *model in stickers) {
                if ([model.iconId isEqualToString:itemName]) {
                    // 新贴纸中存在该道具，不需要删除
                    needDelete = NO;
                    break;
                }
            }
            if (needDelete) {
                // 需要删除该道具
                [[NSFileManager defaultManager] removeItemAtPath:[itemsPath stringByAppendingPathComponent:itemName] error:nil];
            }
        }
    });
}

+ (BOOL)downloadStatusOfSticker:(FUQualityStickerModel *)sticker {
    NSString *itemPath = [[FUStickerBundlesPath stringByAppendingPathComponent:sticker.tag] stringByAppendingPathComponent:sticker.itemId];
    return [[NSFileManager defaultManager] fileExistsAtPath:itemPath];
}

@end
