//
//  FUStickerModel.h
//  FULive
//
//  Created by L on 2018/9/12.
//  Copyright © 2018年 faceUnity. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 精品贴纸类型
typedef NS_ENUM(NSUInteger, FUQualityStickerType) {
    FUQualityStickerTypeCommon,         // 通用
    FUQualityStickerTypeAvatar          // Avatar
};

@interface FUStickerModel : NSObject<NSCoding>

@property (nonatomic, assign) FUQualityStickerType type;

@property (nonatomic, copy) NSString *tag;
/// 道具ID，根据此ID获取道具包
@property (nonatomic, copy) NSString *stickerId;
/// icon唯一标识，用该标识命名本地icon路径
@property (nonatomic, copy) NSString *iconId;
/// icon网络地址
@property (nonatomic, copy) NSString *iconURLString;
/// 道具包唯一标识，用该标识命名本地道具包路径
@property (nonatomic, copy) NSString *itemId;
/// 是否正在下载
@property (nonatomic, assign, getter=isLoading) BOOL loading;
/// 是否维持竖屏
@property (nonatomic, assign, getter=isKeepPortrait) BOOL keepPortrait;
/// 是否仅限一人
@property (nonatomic, assign, getter=isSingle) BOOL single;
/// 是否美妆道具
@property (nonatomic, assign, getter=isMakeupItem) BOOL makeupItem;
/// 是否需要点击事件
@property (nonatomic, assign, getter=isNeedClick) BOOL needClick;
/// 是否翻转模型
@property (nonatomic, assign) BOOL is3DFlipH;
/// 是否被选中
@property (nonatomic, assign, getter=isSelected) BOOL selected;

@end
