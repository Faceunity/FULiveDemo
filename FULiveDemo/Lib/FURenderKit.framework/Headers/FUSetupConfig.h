//
//  FUSetupConfig.h
//  FURenderKit
//
//  Created by liuyang on 2020/12/30.
//

#import <Foundation/Foundation.h>
#import "FUStruct.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUSetupConfig : NSObject

@property (nonatomic, assign) FUAuthPack authPack;

@property (nonatomic, copy) NSString *controllerPath;

@property (nonatomic, copy) NSString *controllerConfigPath;

@end

NS_ASSUME_NONNULL_END
