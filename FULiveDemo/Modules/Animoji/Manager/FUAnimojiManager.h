//
//  FUAnimojiManager.h
//  FULiveDemo
//
//  Created by Chen on 2021/2/25.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUMetaManager.h"
#import "FUStickerProtocol.h"
#import <FURenderKit/FUAnimoji.h>

NS_ASSUME_NONNULL_BEGIN

@interface FUAnimojiManager : FUMetaManager <FUStickerProtocol>

@property (nonatomic, strong) FUAnimoji * _Nullable animoji;

@end

NS_ASSUME_NONNULL_END
