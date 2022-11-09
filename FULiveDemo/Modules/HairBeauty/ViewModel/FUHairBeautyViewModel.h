//
//  FUHairBeautyViewModel.h
//  FULiveDemo
//
//  Created by lsh726 on 2021/3/4.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FURenderViewModel.h"

@class FUHairBeautyModel;

NS_ASSUME_NONNULL_BEGIN

@interface FUHairBeautyViewModel : FURenderViewModel

@property (nonatomic, copy, readonly) NSArray<FUHairBeautyModel *> *hairItems;

@property (nonatomic, copy, readonly) NSArray<NSString *> *icons;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, assign) double strength;

- (double)strengthAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
