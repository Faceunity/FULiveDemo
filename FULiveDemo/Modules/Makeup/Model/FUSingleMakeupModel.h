//
//  FUSingleMakeupModel.h
//  FULiveDemo
//
//  Created by 孙慕 on 2019/2/28.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FUMakeupProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUSingleMakeupModel : NSObject<NSCopying,NSMutableCopying, FUMakeupProtocol>

/* icon */
@property (nonatomic, copy) NSString* iconStr;

/* 美妆妆容bundle键值*/
@property (nonatomic, assign) SUBMAKEUPTYPE namaBundleType;

/* 一些妆容标题 */
@property (nonatomic, copy) NSString *title;

/* 眼影相关 */
@property (nonatomic, copy) NSString *tex_eye2;
@property (nonatomic, copy) NSString *tex_eye3;

/* 眉毛相关 */
@property (nonatomic, assign) int brow_warp;
//0柳叶眉  1上挑眉  2一字眉  3英气眉  4远山眉  5标准眉  6扶形眉  7剑眉  8日常风  9日系风
@property (nonatomic, assign) int brow_warp_type;

/* 样式所有可选的颜色 */
@property (nonatomic, strong) NSArray <NSArray *>* colors;
@property (nonatomic, assign) int defaultColorIndex;

@end

NS_ASSUME_NONNULL_END
