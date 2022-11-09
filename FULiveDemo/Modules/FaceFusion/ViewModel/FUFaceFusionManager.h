//
//  FUFaceFusionManager.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/9/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 换脸图片来源
typedef NS_ENUM(NSUInteger, FUFaceFusionImageSource) {
    FUFaceFusionImageSourceCamera,  // 相机
    FUFaceFusionImageSourceAlbum    // 相册
};

@interface FUFaceFusionManager : NSObject

@property (nonatomic, copy, readonly) NSArray<NSString *> *listItems;

@property (nonatomic, copy, readonly) NSArray<NSString *> *iconItems;

@property (nonatomic, copy, readonly) NSArray<NSString *> *items;
/// 选中的海报索引
@property (nonatomic, assign) NSInteger selectedIndex;
/// 换脸图片
@property (nonatomic, strong) UIImage *image;
/// 图片来源
@property (nonatomic, assign) FUFaceFusionImageSource imageSource;

+ (instancetype)sharedManager;

+ (void)destory;

@end

NS_ASSUME_NONNULL_END
