//
//  FUBeautyShapeViewModel.h
//  FUBeautyComponent
//
//  Created by 项林平 on 2022/7/27.
//

#import <Foundation/Foundation.h>
#import <FURenderKit/FURenderKit.h>
#import "FUBeautyShapeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUBeautyShapeViewModel : NSObject

@property (nonatomic, copy, readonly) NSArray<FUBeautyShapeModel *> *beautyShapes;
/// 是否所有值都是默认
@property (nonatomic, assign, readonly) BOOL isDefaultValue;
/// 当前选中索引，默认为-1
@property (nonatomic, assign) NSInteger selectedIndex;
/// 美型属性需要根据高低端机适配
@property (nonatomic, assign) FUDevicePerformanceLevel performanceLevel;

/// 保存美型数据到本地
- (void)saveShapesPersistently;

/// 设置单项美型值
/// @param value 当前选中单项的值
- (void)setShapeValue:(double)value;

/// 设置当前所有美型值
- (void)setAllShapeValues;

/// 恢复所有美型值为默认
- (void)recoverAllShapeValuesToDefault;

@end

NS_ASSUME_NONNULL_END
