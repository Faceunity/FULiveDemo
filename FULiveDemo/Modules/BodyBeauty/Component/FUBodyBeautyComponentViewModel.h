//
//  FUBodyBeautyComponentViewModel.h
//  FULiveDemo
//
//  Created by Cursor on 2026/6/30.
//

#import <Foundation/Foundation.h>
#import "FUBodyBeautyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUBodyBeautyComponentViewModel : NSObject

@property (nonatomic, copy, readonly) NSArray<FUBodyBeautyModel *> *bodyBeautyItems;
@property (nonatomic, assign, readonly) BOOL isDefaultValue;
@property (nonatomic, assign) NSInteger selectedIndex;

- (void)loadBodyBeautyIfNeeded;

- (void)setCurrentValue:(double)value;

- (void)recoverToDefault;

@end

NS_ASSUME_NONNULL_END
