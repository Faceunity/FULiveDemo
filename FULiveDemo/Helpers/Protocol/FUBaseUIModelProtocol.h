//
//  FUBaseUIModelProtocol.h
//  FULiveDemo
//
//  Created by Chen on 2021/3/5.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 基础UI模型数据协议，
 * 为了解决 共性UI 结构设计的属性模型协议
 * 不同业务模型按照需要 选取对应的属性
 * ex: @synthesize title, imageName
 */
@protocol FUBaseUIModelProtocol <NSObject>

@optional
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imageName;

@property (nonatomic, strong) id value;

@property (nonatomic, strong) id defaultValue;
@end

NS_ASSUME_NONNULL_END
