//
//  FUHilariousViewModel.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/7/18.
//  Copyright © 2022 FaceUnity. All rights reserved.
//

#import "FURenderViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUHilariousViewModel : FURenderViewModel

@property (nonatomic, copy, readonly) NSArray<NSString *> *hilariousItems;

@property (nonatomic, copy, readonly) NSDictionary<NSString *, NSString *> *hilariousTips;

- (void)loadItem:(NSString *)item completion:(nullable void(^)(void))completion;

- (void)releaseItem;

@end

NS_ASSUME_NONNULL_END
