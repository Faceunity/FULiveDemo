//
//  FUCustomizeSkinViewModel.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/11/7.
//

#import <Foundation/Foundation.h>

@class FUStyleSkinModel;

NS_ASSUME_NONNULL_BEGIN

@interface FUCustomizeSkinViewModel : NSObject

@property (nonatomic, copy) NSArray<FUStyleSkinModel *> *skins;
/// 当前选中索引，默认为-1
@property (nonatomic, assign) NSInteger selectedIndex;
/// 是否关闭效果
@property (nonatomic, assign, getter=isEffectDisabled) BOOL effectDisabled;

- (void)setSkinValue:(double)value;

- (NSString *)nameAtIndex:(NSUInteger)index;

- (double)defaultValueAtIndex:(NSUInteger)index;

- (double)currentValueAtIndex:(NSUInteger)index;

- (NSUInteger)ratioAtIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
