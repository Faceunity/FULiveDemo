//
//  FUActionRecogManager.h
//  FULiveDemo
//
//  Created by Chen on 2021/3/5.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUMetaManager.h"
#import <FURenderKit/FUActionRecognition.h>
NS_ASSUME_NONNULL_BEGIN

@interface FUActionRecogManager : FUMetaManager
@property (strong, strong, nullable) FUActionRecognition *actionRecogn;
@end

NS_ASSUME_NONNULL_END
