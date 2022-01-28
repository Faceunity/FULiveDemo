//
//  FUCustomBackground.h
//  FURenderKit
//
//  Created by liuyang on 2022/1/7.
//
#import "FUBackground.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FUCustomBackground : FUBackground

@property (nonatomic, strong) UIImage *image;

- (instancetype)initWithPath:(NSString *)path name:(NSString *)name image:(UIImage *)image;

+ (instancetype)backgroundWithPath:(NSString *)path name:(NSString *)name image:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
