//
//  FUPosterManager.h
//  FULiveDemo
//
//  Created by lsh726 on 2021/3/7.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUMetaManager.h"
#import <FURenderKit/FUPoster.h>
NS_ASSUME_NONNULL_BEGIN

@interface FUPosterManager : FUMetaManager

+ (instancetype)sharedManager;

+ (void)destory;

@property (nonatomic, copy, readonly) NSArray<NSString *> *posterItems;

@property (nonatomic, copy, readonly) NSArray<NSString *> *posterIcons;

@property (nonatomic, copy, readonly) NSArray<NSString *> *posterList;

@property (nonatomic, assign) NSInteger selectedIndex;

@end

NS_ASSUME_NONNULL_END
