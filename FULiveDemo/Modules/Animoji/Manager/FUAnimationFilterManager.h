//
//  FUAnimationFilterManager.h
//  FULiveDemo
//
//  Created by Chen on 2021/3/4.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUMetaManager.h"
#import "FUStickerProtocol.h"
#import <FURenderKit/FUComicFilter.h>
NS_ASSUME_NONNULL_BEGIN

@interface FUAnimationFilterManager : FUMetaManager <FUStickerProtocol>

@property (nonatomic, strong, nullable) FUComicFilter *comicFilter;

@property (nonatomic, copy) NSArray *comicFilterItems;

- (void)loadItem:(NSString *)itemName
            type:(int)type
      completion:(void (^)(BOOL))completion;
@end

NS_ASSUME_NONNULL_END
