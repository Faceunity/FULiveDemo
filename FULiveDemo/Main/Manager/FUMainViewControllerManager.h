//
//  FUMainViewControllerManager.h
//  FULiveDemo
//
//  Created by Chen on 2021/2/24.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FULiveModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface FUMainViewControllerManager : NSObject
@property (nonatomic, strong, readonly) NSArray<NSArray<FULiveModel *>*> *dataSource;
@end

NS_ASSUME_NONNULL_END
