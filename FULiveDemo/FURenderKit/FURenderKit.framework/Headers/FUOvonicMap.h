//
//  FUBidirectionalMap.h
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/4/15.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FUOvonicMap : NSObject
@property (nonatomic, strong) NSMutableDictionary *keysToValues;
@property (nonatomic, strong) NSMapTable *valuesToKeys;
@property (nonatomic, readonly) unsigned long long count;

+ (FUOvonicMap*)map;
+ (FUOvonicMap*)mapWithDictionary:(NSDictionary *)dictionary;
- (FUOvonicMap*)initWithDictionary:(NSDictionary *)dictionary;

- (void)createValuesToKeysMapping;
- (id)objectForKeyedSubscript:(id)key;
- (void)setObject:(id)object forKeyedSubscript:(id)key;
- (void)removeObjectForKey:(id)key;
- (id)keyForObject:(id)object;

- (NSArray *)allKeys;
- (NSArray *)allValues;
- (NSDictionary *)dictionary;
@end

NS_ASSUME_NONNULL_END
