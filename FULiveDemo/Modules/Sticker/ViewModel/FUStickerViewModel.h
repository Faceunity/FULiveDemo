//
//  FUStickerViewModel.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/7/15.
//  Copyright © 2022 FaceUnity. All rights reserved.
//

#import "FUMetaManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUStickerViewModel : NSObject

@property (nonatomic, copy) NSArray<NSString *> *stickerItems;

- (void)loadItem:(NSString *)item completion:(nullable void(^)(void))completion;

- (void)releaseItem;

@end

NS_ASSUME_NONNULL_END
