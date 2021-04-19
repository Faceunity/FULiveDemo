//
//  FUGreenScreenBgModel.h
//  FULiveDemo
//
//  Created by Chen on 2021/3/5.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FUBaseUIModelProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface FUGreenScreenBgModel : NSObject <FUBaseUIModelProtocol>
//录像文件名称
@property (nonatomic, copy) NSString *videoPath;
@end

NS_ASSUME_NONNULL_END
