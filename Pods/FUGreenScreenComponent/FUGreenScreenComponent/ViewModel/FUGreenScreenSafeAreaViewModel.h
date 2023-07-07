//
//  FUGreenScreenSafeAreaViewModel.h
//  FUGreenScreenComponent
//
//  Created by 项林平 on 2022/8/1.
//

#import <UIKit/UIKit.h>

@class FUGreenScreenSafeAreaModel;

NS_ASSUME_NONNULL_BEGIN

@interface FUGreenScreenSafeAreaViewModel : NSObject

@property (nonatomic, copy, readonly) NSArray<FUGreenScreenSafeAreaModel *> *safeAreaArray;

/// 本地安全区域图片
@property (nonatomic, strong, readonly) UIImage *localSafeAreaImage;

/// 当前选中的安全区域索引，默认为1
@property (nonatomic, assign) NSInteger selectedIndex;

/// 更新数据
- (void)realoadSafeAreaData;

/// 保存本地安全区域图片
- (BOOL)saveLocalSafeAreaImage:(UIImage *)image;

- (UIImage *)safeAreaIconAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
