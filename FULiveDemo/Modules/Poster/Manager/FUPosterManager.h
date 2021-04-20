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
@property (strong, nonatomic, nullable) FUPoster *poster;

- (void)setOnCameraChange;
@end

NS_ASSUME_NONNULL_END
