//
//  FUGanImageModel.h
//  FULiveDemo
//
//  Created by 孙慕 on 2018/12/27.
//  Copyright © 2018年 FaceUnity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@interface FUGanSubImageModel : NSObject<NSCopying>
/* 子图片 */
@property(strong ,nonatomic) UIImage *subImage;
/* 对应的处理索引 */
@property(assign ,nonatomic) int type;

@end

@interface FUGanImageModel : NSObject

@property(strong ,nonatomic) NSMutableArray <FUGanSubImageModel *>*images;

@property(strong ,nonatomic) UIImage *currentImage;

@property(assign ,nonatomic) int viewSelIndex;

@end


