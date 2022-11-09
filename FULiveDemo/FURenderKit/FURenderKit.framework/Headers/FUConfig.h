//
//  FUConfig.h
//  FUAvatarSDK
//
//  Created by ly-Mac on 2020/11/23.
//

#import <Foundation/Foundation.h>
#import "FUParam.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUConfig : NSObject

- (int)setValue:(id)value forName:(NSString *)name paramType:(FUParamType)paramType;

- (id)getValueForName:(NSString *)name paramType:(FUParamType)paramType;
@end

NS_ASSUME_NONNULL_END
