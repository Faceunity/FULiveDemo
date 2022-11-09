//
//  FUMusicFilterViewModel.h
//  FULiveDemo
//
//  Created by Chen on 2021/2/25.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FURenderViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUMusicFilterViewModel : FURenderViewModel

@property (nonatomic, copy, readonly) NSArray<NSString *> *musicFilterItems;

@property (nonatomic, assign) NSInteger selectedIndex;

@end

NS_ASSUME_NONNULL_END
