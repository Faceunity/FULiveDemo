//
//  FUAvatarCheck.h
//  FURenderKit
//
//  Created by 刘保健 on 2021/12/30.
//

#import <Foundation/Foundation.h>
#import "FUAvatar.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUAvatarCheck : NSObject

+ (FUAvatarCheck *)initWithControllerConfigPath:(NSString *)controllerConfigPath litemListJson:(NSString *)litemListJson;

- (void)checkAvatarComponentFileIds:(NSArray <NSString *>*)fileIds avatar:(FUAvatar *)avatar assetRootPath:(NSString *)assetRootPath;

@end

NS_ASSUME_NONNULL_END
