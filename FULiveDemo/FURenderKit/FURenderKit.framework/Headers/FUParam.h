//
//  FUParam.h
//  FUAvatarSDK
//
//  Created by ly-Mac on 2020/11/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    FUParamTypeString,
    FUParamTypeDouble,
    FUParamTypeUInt64,
    FUParamTypeBufferByte,
    FUParamTypeBufferDouble,
    FUParamTypeBufferFloat,
} FUParamType;

@interface FUParam : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) FUParamType type;

@property (nonatomic, strong) id paramValue;

+ (FUParam *)paramWithName:(NSString *)name value:(id)paramValue type:(FUParamType)type;

@end

NS_ASSUME_NONNULL_END
