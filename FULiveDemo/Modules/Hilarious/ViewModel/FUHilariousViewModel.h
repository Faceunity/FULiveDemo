//
//  FUHilariousViewModel.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/7/18.
//  Copyright © 2022 FaceUnity. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FUHilariousViewModel : NSObject

@property (nonatomic, copy) NSArray<NSString *> *hilariousItems;

- (void)loadItem:(NSString *)item completion:(nullable void(^)(void))completion;

- (void)releaseItem;

@end

NS_ASSUME_NONNULL_END
