//
//  FUItem.h
//  FUAvatarSDK
//
//  Created by ly-Mac on 2020/11/16.
//

#import <Foundation/Foundation.h>
#import "FUParam.h"
#import "FURenderableObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUItem : FURenderableObject

@property (nonatomic, copy) NSString *name; // 道具名称

@property (nonatomic, copy) NSString *path; // 道具绝对路径

@property (nonatomic, assign) BOOL supportARMode; // 是否支持 AR 模式

@property (nonatomic, copy) NSSet<NSNumber *> *bodyInvisibleList; // 身体隐藏区域

/// 根据道具路径创建道具对象，可支持自动加载
/// @param path 道具路径
/// @param name 道具名称
- (instancetype)initWithPath:(NSString *)path name:(nullable NSString *)name;

+ (instancetype)itemWithPath:(NSString *)path name:(nullable NSString *)name;

- (int)setParam:(FUParam *)param;

- (int)setParam:(id)param forName:(NSString *)name paramType:(FUParamType)paramType;

- (id)getParamForName:(NSString *)name paramType:(FUParamType)paramType;

//把缓存的属性值全部设置一边
- (BOOL)setAllProperty;

////replaceObj 被替换的对象
//- (BOOL)replaceOldObj:(FUItem *)replaceObj;

////replaceOldBeauty 过滤不替换的属性名称
//@property (nonatomic, copy) NSArray *(^FiltersBlock)(void);
//
///**
// * 遇到结构体属性上抛给特定的FUItem处理，如 FUMakeup，FUHairItem*
// * typeName属性类型，name 属性名称
// */
//@property (nonatomic, copy) void (^StructBlock)(NSString *typeName, NSString *name);
//
///**
// * 遇到资源类的item上抛给特定的FUItem处理，如FUMakeup
// * oldItem 属性类的item，如果是资源类，上层处理。否则就递归处理非资源类FUItem
// * name 属性名称
// */
//@property (nonatomic, copy) void (^ResourceBlock)(FUItem *oldItem, NSString *name);

@end

NS_ASSUME_NONNULL_END
