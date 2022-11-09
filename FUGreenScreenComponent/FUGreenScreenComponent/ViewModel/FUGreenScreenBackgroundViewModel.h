//
//  FUGreenScreenBackgroundViewModel.h
//  FUGreenScreenComponent
//
//  Created by 项林平 on 2022/8/1.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class FUGreenScreenBackgroundModel;

NS_ASSUME_NONNULL_BEGIN

@interface FUGreenScreenBackgroundViewModel : NSObject

@property (nonatomic, copy, readonly) NSArray<FUGreenScreenBackgroundModel *> *backgroundArray;
/// 当前选中的背景索引，默认为2
@property (nonatomic, assign) NSInteger selectedIndex;

- (UIImage *)backgroundIconAtIndex:(NSInteger)index;

- (NSString *)backgroundNameAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
