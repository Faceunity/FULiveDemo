//
//  FUHomepageViewModel.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/7/4.
//  Copyright © 2022 FaceUnity. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FUHomepageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUHomepageViewModel : NSObject

@property (nonatomic, copy) NSArray<FUHomepageGroup *> *dataSource;

@end

NS_ASSUME_NONNULL_END
