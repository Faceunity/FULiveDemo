//
//  FUMediaPickerViewModel.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/8/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FUMediaPickerViewModel : NSObject

@property (nonatomic, assign, readonly) FUModule module;

- (instancetype)initWithModule:(FUModule)module;

@end

NS_ASSUME_NONNULL_END
