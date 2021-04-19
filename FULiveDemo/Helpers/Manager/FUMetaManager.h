//
//  FUMetaManager.h
//  FULiveDemo
//
//  Created by Chen on 2021/2/25.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FURenderKit/FURenderKit.h>

NS_ASSUME_NONNULL_BEGIN

#define KScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define KScreenHeight ([UIScreen mainScreen].bounds.size.height)

#define iPhoneXStyle ((KScreenWidth == 375.f && KScreenHeight == 812.f ? YES : NO) || (KScreenWidth == 414.f && KScreenHeight == 896.f ? YES : NO))

@interface FUMetaManager : NSObject
//释放item，内部会自动清除相关资源文件.
- (void)releaseItem;

//把当前业务模型数据加载到FURenderKit,不同子类需要根据不同模型重写
- (void)loadItem;

//道具加载队列
@property (nonatomic, strong) dispatch_queue_t loadQueue;
@end

NS_ASSUME_NONNULL_END
