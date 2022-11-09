//
//  FUCustomizedMakeupModel.h
//  FUMakeupComponent
//
//  Created by 项林平 on 2022/9/13.
//

#import <Foundation/Foundation.h>
#import "FUSubMakeupModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUCustomizedMakeupModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSArray<FUSubMakeupModel *> *subMakeups;
/// 当前子妆类型选中的单个子妆索引
@property (nonatomic, assign) NSInteger selectedSubMakeupIndex;

@end

NS_ASSUME_NONNULL_END
