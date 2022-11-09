//
//  FUARMaskViewModel.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/7/18.
//  Copyright © 2022 FaceUnity. All rights reserved.
//

#import "FURenderViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUARMaskViewModel : FURenderViewModel

@property (nonatomic, copy, readonly) NSArray<NSString *> *maskItems;

- (void)loadItem:(NSString *)item completion:(nullable void(^)(void))completion;

- (void)releaseItem;

@end

NS_ASSUME_NONNULL_END
