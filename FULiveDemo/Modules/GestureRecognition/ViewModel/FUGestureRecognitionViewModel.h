//
//  FUGestureRecognitionViewModel.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/7/18.
//  Copyright © 2022 FaceUnity. All rights reserved.
//

#import "FURenderViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUGestureRecognitionViewModel : FURenderViewModel

@property (nonatomic, copy, readonly) NSArray<NSString *> *gestureRecognitionItems;

@property (nonatomic, copy, readonly) NSDictionary<NSString *, NSString *> *gestureRecognitionTips;

- (void)loadItem:(NSString *)item completion:(nullable void(^)(void))completion;

- (void)releaseItem;

@end

NS_ASSUME_NONNULL_END
