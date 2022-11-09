//
//  FUBeautyStyleViewModel.h
//  FUBeautyComponent
//
//  Created by 项林平 on 2022/6/21.
//

#import <Foundation/Foundation.h>
#import "FUBeautyStyleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUBeautyStyleViewModel : NSObject

@property (nonatomic, copy, readonly) NSArray<FUBeautyStyleModel *> *beautyStyles;
/// 选中风格推荐索引
@property (nonatomic, assign) NSInteger selectedIndex;

/// 保存风格推荐数据到本地
- (void)saveStylesPersistently;

@end

NS_ASSUME_NONNULL_END
