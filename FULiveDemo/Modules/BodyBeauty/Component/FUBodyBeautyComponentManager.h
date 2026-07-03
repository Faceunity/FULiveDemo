//
//  FUBodyBeautyComponentManager.h
//  FULiveDemo
//
//  Created by Cursor on 2026/6/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FUBodyBeautyComponentManager : NSObject

@property (nonatomic, assign, readonly) CGFloat componentViewHeight;

+ (instancetype)sharedManager;

+ (void)destory;

- (void)addComponentViewToView:(UIView *)view;

- (void)removeComponentView;

- (void)loadBodyBeautyIfNeeded;

@end

NS_ASSUME_NONNULL_END
