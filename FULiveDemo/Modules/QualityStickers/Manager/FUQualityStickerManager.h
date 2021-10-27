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

/// 加载精品贴纸道具
- (void)loadItemWithModel:(FUStickerModel *)stickerModel;

/// 设置当前精品贴纸 is_click 属性状态
- (void)clickCurrentItem;

@end

NS_ASSUME_NONNULL_END
