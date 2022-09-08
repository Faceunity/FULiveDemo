//
//  FUGreenScreenModel.h
//  FULiveDemo
//
//  Created by Chen on 2021/3/5.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FUBaseUIModelProtocol.h"
#import "FUGreenScreenDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUGreenScreenModel : NSObject <FUBaseUIModelProtocol>
@property (nonatomic, assign) GREENSCREENTYPE type;

/* 双向的参数  0.5是原始值*/
@property (nonatomic,assign) BOOL iSStyle101;
@end

NS_ASSUME_NONNULL_END
