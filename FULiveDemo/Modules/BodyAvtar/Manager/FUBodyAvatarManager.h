//
//  FUBodyAvatarManager.h
//  FULiveDemo
//
//  Created by Chen on 2021/3/9.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUMetaManager.h"
#import <FURenderKit/FUScene.h>
NS_ASSUME_NONNULL_BEGIN

@interface FUBodyAvatarManager : FUMetaManager

@property (nonatomic, strong, nullable) FUScene *scene;

//加载抗锯齿道具
- (void)loadAntiAliasing;

//加载身体组件
- (void)loadAvatarWithIndex:(int)index;

//切换模式: 半身还是全身
- (void)switchBodyTrackMode:(FUBodyTrackMode)mode;

//检测人体
- (int)aiHumanProcessorNums;
@end

NS_ASSUME_NONNULL_END
