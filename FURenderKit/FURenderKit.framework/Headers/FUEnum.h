//
//  FUEnum.h
//  FUAvatarSDK
//
//  Created by ly-Mac on 2020/11/26.
//
#import "FUType.h"

#define FUEnum(ENUM_TYPENAME, ENUM_CONSTANTS...)    \
    typedef enum {  \
        ENUM_CONSTANTS  \
    } ENUM_TYPENAME;    \
    static NSString *_##ENUM_TYPENAME##_constants_string = @"" #ENUM_CONSTANTS; \
    _FUEnum_GenerateImplementation(ENUM_TYPENAME)


//--

#define FUEnumDeclare(ENUM_TYPENAME, ENUM_CONSTANTS...) \
    typedef enum {  \
        ENUM_CONSTANTS  \
    } ENUM_TYPENAME;    \
    extern NSDictionary* ENUM_TYPENAME##ByValue(void);  \
    extern NSDictionary* ENUM_TYPENAME##ByLabel(void);  \
    extern NSString* ENUM_TYPENAME##ToString(int enumValue);    \
    extern BOOL ENUM_TYPENAME##FromString(NSString *enumLabel, ENUM_TYPENAME *enumValue);   \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Wunused-variable\"") \
    static NSString *_##ENUM_TYPENAME##_constants_string = @"" #ENUM_CONSTANTS; \
    _Pragma("clang diagnostic pop")

//--

#define FUEnumDefine(ENUM_TYPENAME) \
    _FUEnum_GenerateImplementation(ENUM_TYPENAME)

//--

#define _FUEnum_GenerateImplementation(ENUM_TYPENAME)  \
    NSArray* _FUEnumParse##ENUM_TYPENAME##ConstantsString() {    \
        NSString *constantsString = _##ENUM_TYPENAME##_constants_string; \
        constantsString = [[constantsString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsJoinedByString:@""]; \
        if ([constantsString hasSuffix:@","]) { \
            constantsString = [constantsString substringToIndex:[constantsString length]-1]; \
        } \
        NSArray *stringPairs = [constantsString componentsSeparatedByString:@","];    \
        NSMutableArray *labelsAndValues = [NSMutableArray arrayWithCapacity:[stringPairs count]];    \
        int nextDefaultValue = 0;    \
        for (NSString *stringPair in stringPairs) {    \
            NSArray *labelAndValueString = [stringPair componentsSeparatedByString:@"="];    \
            NSString *label = [labelAndValueString objectAtIndex:0];    \
            NSString *valueString = [labelAndValueString count] > 1 ? [labelAndValueString objectAtIndex:1] : nil;    \
            int value; \
            if (valueString) { \
                NSRange shiftTokenRange = [valueString rangeOfString:@"<<"]; \
                if (shiftTokenRange.location != NSNotFound) { \
                    valueString = [valueString substringFromIndex:shiftTokenRange.location + 2]; \
                    value = 1 << [valueString intValue]; \
                } else if ([valueString hasPrefix:@"0x"]) { \
                    [[NSScanner scannerWithString:valueString] scanHexInt:(unsigned int*)&value]; \
                } else { \
                    value = [valueString intValue]; \
                } \
            } else { \
                value = nextDefaultValue; \
            } \
            nextDefaultValue = value + 1;    \
            [labelsAndValues addObject:label];    \
            [labelsAndValues addObject:[NSNumber numberWithInt:value]];    \
        }    \
        return labelsAndValues;    \
    }    \
        \
    NSDictionary* ENUM_TYPENAME##ByLabel() {    \
        NSArray *constants = _FUEnumParse##ENUM_TYPENAME##ConstantsString();    \
        NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:[constants count] / 2];    \
        for (NSUInteger i = 0; i < [constants count]; i += 2) {    \
            NSString *label = [constants objectAtIndex:i];    \
            NSNumber *value = [constants objectAtIndex:i+1];    \
            [result setObject:value forKey:label];    \
        }    \
        return result;    \
    }    \
\
    NSArray* ENUM_TYPENAME##AllLabels() {    \
    NSArray *constants = _FUEnumParse##ENUM_TYPENAME##ConstantsString();    \
        NSMutableArray *result = [NSMutableArray array];    \
        for (NSUInteger i = 0; i < [constants count]; i += 2) {    \
            NSString *label = [constants objectAtIndex:i];    \
            [result addObject: label];    \
        }    \
        return [result copy];    \
    }    \
    
#define FUEnumImplementation(Class, ENUM_TYPENAME) \
    @implementation Class (FUEnum)\
    \
    + (id)_fieldNames \
    { \
        static NSArray<NSString *> *_fieldNames; \
        static dispatch_once_t onceToken; \
        dispatch_once(&onceToken, ^{ \
            _fieldNames = ENUM_TYPENAME##AllLabels(); \
        }); \
\
        return _fieldNames; \
    } \
\
    + (FUOvonicMap *)_fieldNamesToValues \
    { \
        static FUOvonicMap *_fieldNamesToValues; \
        static dispatch_once_t onceToken; \
        dispatch_once(&onceToken, ^{ \
            _fieldNamesToValues = [FUOvonicMap mapWithDictionary:ENUM_TYPENAME##ByLabel()]; \
        }); \
        return _fieldNamesToValues; \
    } \
\
    @end\
