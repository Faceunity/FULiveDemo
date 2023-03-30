//
//  FUKeysDefine.h
//  FUAvatarSDK
//
//  Created by ly-Mac on 2020/12/22.
//
#import "metamacros.h"

#define FUParamsKeysDefine(keyPreName,...) \
    typedef NSString * keyPreName NS_STRING_ENUM; \
    metamacro_foreach_cxt(params_key_define,,static keyPreName , __VA_ARGS__) \
    static NSString *_##keyPreName##_constants_string = @"" #__VA_ARGS__; \
    _FUParamsKeys_GenerateImplementation(keyPreName)

#define params_key_define(INDEX, CONTEXT, VAR) CONTEXT const VAR;

#define _FUParamsKeys_GenerateImplementation(keyPreName)    \
    static inline  NSArray * keyPreName##AllKeys(){    \
        static NSArray *_##keyPreName##AllKeys = NULL;   \
        static dispatch_once_t onceToken;   \
        dispatch_once(&onceToken, ^{    \
            NSString *constantsString = _##keyPreName##_constants_string; \
            constantsString = [[constantsString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsJoinedByString:@""]; \
            if ([constantsString hasSuffix:@","]) { \
                constantsString = [constantsString substringToIndex:[constantsString length]-1]; \
            } \
            NSArray *stringPairs = [constantsString componentsSeparatedByString:@","];    \
            NSMutableArray *keys = [NSMutableArray arrayWithCapacity:[stringPairs count]];    \
            for (NSString *stringPair in stringPairs) {    \
                NSArray *labelAndValueString = [stringPair componentsSeparatedByString:@"="];    \
                NSString *key = [labelAndValueString objectAtIndex:1];    \
                key = [key stringByReplacingOccurrencesOfString:@"@\"" withString:@""];    \
                key = [key stringByReplacingOccurrencesOfString:@"\"" withString:@""];    \
                [keys addObject:key];    \
            }    \
            _##keyPreName##AllKeys = [keys copy];    \
        }); \
        return _##keyPreName##AllKeys;   \
    }
