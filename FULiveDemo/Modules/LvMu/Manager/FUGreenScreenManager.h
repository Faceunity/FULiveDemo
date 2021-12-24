//
//  FUGreenScreem.h
//  FULiveDemo
//
//  Created by Chen on 2021/3/4.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUMetaManager.h"
#import <FURenderKit/FUGreenScreen.h>
#import "FUGreenScreenDefine.h"
#import "FUGreenScreenBgModel.h"

@class FUGreenScreenModel;
NS_ASSUME_NONNULL_BEGIN

@interface FUGreenScreenManager : FUMetaManager
@property (nonatomic, strong, nullable) FUGreenScreen *greenScreen;

@property (nonatomic, strong, readonly) NSArray <FUGreenScreenModel *> *dataArray;

@property (nonatomic, strong, readonly) NSArray <FUGreenScreenBgModel *> *bgDataArray;


- (void)setGreenScreenModel:(FUGreenScreenModel *)model;

//设置颜色值
- (void)setGreenScreenWithColor:(UIColor *)color;

/// 更新安全区域图片
- (void)updateSafeAreaImage:(nullable UIImage *)image;

/// 保存本地安全区域图片
+ (BOOL)saveLocalSafeAreaImage:(UIImage *)image;

/// 获取本地安全区域图片
+ (UIImage *)localSafeAreaImage;

@end

NS_ASSUME_NONNULL_END
