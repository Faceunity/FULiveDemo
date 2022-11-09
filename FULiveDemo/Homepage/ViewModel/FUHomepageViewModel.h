//
//  FUHomepageViewModel.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/7/4.
//  Copyright © 2022 FaceUnity. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FUHomepageGroup;

NS_ASSUME_NONNULL_BEGIN

@interface FUHomepageViewModel : NSObject

@property (nonatomic, copy, readonly) NSArray<FUHomepageGroup *> *dataSource;

- (NSString *)groupNameOfGroup:(NSUInteger)group;

- (NSUInteger)modulesCountOfGroup:(NSUInteger)group;

- (FUModule)moduleAtIndex:(NSUInteger)index group:(NSUInteger)group;

- (UIImage *)moduleIconAtIndex:(NSUInteger)index group:(NSUInteger)group;

- (NSString *)moduleTitleAtIndex:(NSUInteger)index group:(NSUInteger)group;

- (UIImage *)moduleBottomBackgroundImageAtIndex:(NSUInteger)index group:(NSUInteger)group;

- (BOOL)moduleEnableStatusAtIndex:(NSUInteger)index group:(NSUInteger)group;

@end

NS_ASSUME_NONNULL_END
