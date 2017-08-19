//
//  FUManager.h
//  FULiveDemo
//
//  Created by 刘洋 on 2017/8/18.
//  Copyright © 2017年 刘洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface FUManager : NSObject

@property (nonatomic, assign)               BOOL enableGesture;         /**设置是否开启手势识别，默认未开启*/
@property (nonatomic, assign)               BOOL enableMaxFaces;        /**设置人脸识别个数，默认为单人模式*/

@property (nonatomic, assign)               NSInteger selectedBlur;     /**磨皮(0、1、2、3、4、5、6)*/
@property (nonatomic, assign)               double redLevel;            /**红润 (0~1)*/
@property (nonatomic, assign)               double faceShapeLevel;      /**美型等级 (0~1)*/
@property (nonatomic, assign)               NSInteger faceShape;        /**美型类型 (0、1、2、3) 默认：3，女神：0，网红：1，自然：2*/
@property (nonatomic, assign)               double beautyLevel;         /**美白 (0~1)*/
@property (nonatomic, assign)               double thinningLevel;       /**瘦脸 (0~1)*/
@property (nonatomic, assign)               double enlargingLevel;      /**大眼 (0~1)*/
@property (nonatomic, strong)               NSString *selectedFilter;   /**选中的滤镜名称*/
@property (nonatomic, strong)               NSString *selectedItem;     /**选中的道具名称*/
@property (nonatomic, strong)               NSArray<NSString *> *itemsDataSource;       /**道具名称数组*/
@property (nonatomic, strong)               NSArray<NSString *> *filtersDataSource;     /**滤镜名称数组*/

+ (FUManager *)shareManager;

/**初始化Faceunity,加载道具*/
- (void)setUpFaceunity;

/**销毁全部道具*/
- (void)destoryFaceunityItems;

/**加载普通道具*/
- (void)loadItem:(NSString *)itemName;

/**处理pixelBuffer*/
- (void)processPixelBuffer:(CVPixelBufferRef)pixelBuffer;

/**获取75个人脸特征点*/
- (void)getLandmarks:(float *)landmarks;

/**判断是否检测到人脸*/
- (BOOL)isTracking;

/**切换摄像头要调用此函数*/
- (void)onCameraChange;

@end
