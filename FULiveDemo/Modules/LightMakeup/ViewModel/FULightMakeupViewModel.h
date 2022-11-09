//
//  FULightMakeupViewModel.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/8/8.
//

#import "FURenderViewModel.h"
#import "FULightMakeupModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FULightMakeupViewModel : FURenderViewModel 

@property (nonatomic, copy, readonly) NSArray<FULightMakeupModel *> *lightMakeups;
/// 选中轻美妆索引，默认为0
@property (nonatomic, assign) NSInteger selectedIndex;

- (void)setLightMakeupValue:(double)value;

@end

NS_ASSUME_NONNULL_END
