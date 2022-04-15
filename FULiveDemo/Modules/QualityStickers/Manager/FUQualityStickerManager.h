//
//  FUQualtyStickerManager.h
//  FULiveDemo
//
//  Created by Chen on 2021/3/31.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUMetaManager.h"

#import "FUStickerModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface FUQualityStickerManager : FUMetaManager

/// 下载道具
- (void)downloadItem:(FUStickerModel *)sticker completion:(void (^)(NSError * _Nullable error))completion;

/// 取消当前队列中的下载任务
- (void)cancelDownloadingTasks;

/// 加载精品贴纸道具
- (void)loadItem:(FUStickerModel *)sticker;

/// 设置当前精品贴纸 is_click 属性状态
- (void)clickCurrentItem;

@end

NS_ASSUME_NONNULL_END
