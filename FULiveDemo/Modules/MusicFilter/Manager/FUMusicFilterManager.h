//
//  FUMusicFilterManager.h
//  FULiveDemo
//
//  Created by Chen on 2021/2/25.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUMetaManager.h"
#import <FURenderKit/FUMusicFilter.h>
#import "FUStickerProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface FUMusicFilterManager : FUMetaManager <FUStickerProtocol>

@property (nonatomic, strong, nullable) FUMusicFilter *musicItem;

@property (nonatomic, copy) NSArray *musicFilterItems;

@end

NS_ASSUME_NONNULL_END
