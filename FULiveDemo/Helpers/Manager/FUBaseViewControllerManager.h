//
//  FUBaseViewControllerManager.h
//  FULiveDemo
//
//  Created by Chen on 2021/2/24.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUMetaManager.h"
#import <FURenderKit/FUKeysDefine.h>
#import <FURenderKit/FUBeauty.h>
#import "FUBeautyModel.h"
#import "FUBeautyDefine.h"
#import "FUStyleModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * 处理美颜的业务逻辑和数据类
 */
@interface FUBaseViewControllerManager : FUMetaManager
/* 滤镜参数 */
@property (nonatomic, strong, readonly) NSArray<FUBeautyModel *> *filters;
/* 美肤参数 */
@property (nonatomic, strong, readonly) NSArray<FUBeautyModel *> *skinParams;
/* 美型参数 */
@property (nonatomic, strong, readonly) NSArray<FUBeautyModel *> *shapeParams;
/* 风格参数 ，用父类，因为View 用的就是父类泛型，后续需要优化*/ 
@property (nonatomic, strong, readonly) NSArray<FUStyleModel *> *styleParams;

/// 当前选中的风格
@property (nonatomic, strong) FUStyleModel *currentStyle;

@property (nonatomic, strong) FUBeautyModel *seletedFliter;

@property (nonatomic, strong) FUBeauty *beauty;

/// 缓存渲染线程的人脸中心点
@property (nonatomic, assign) CGPoint faceCenter;

/// 当前页面绑定的相机朝向
@property (assign, nonatomic) AVCaptureDevicePosition cameraPosition;


- (void)setSkin:(double)value forKey:(FUBeautifySkin)key;

- (void)setShap:(double)value forKey:(FUBeautifyShape)key;

///// 切换脸型：切换时需要关闭将其他脸型值设为0
///// @param value 脸型值
///// @param type 脸型类型
//- (void)switchFaceShape:(double)value type:(FUFaceShapeType)type;
//
///// 更新脸型值
///// @param value 脸型值
///// @param type 脸型类型
//- (void)updateFaceShapeValue:(double)value type:(FUFaceShapeType)type;

- (void)setFilterkey:(FUFilter)filterKey;

- (void)setFaceProcessorDetectMode:(FUFaceProcessorDetectMode)mode;

- (void)setOnCameraChange;

- (void)setMaxFaces:(int)maxFaces;

- (void)setMaxBodies:(int)maxBodies;

- (void)setAsyncTrackFaceEnable:(BOOL)enable;

/// 获取图像中人脸中心点位置
/// @param frameSize 图像的尺寸，该尺寸要与视频处理接口或人脸信息跟踪接口中传入的图像宽高相一致
/// @return 返回一个以图像左上角为原点的中心点
- (CGPoint)getFaceCenterInFrameSize:(CGSize)frameSize;

/// 检测是否有人脸
- (BOOL)faceTrace;

/// 检测是否有人体
- (BOOL)bodyTrace;

/// 判断是不是默认美型参数
-(BOOL)isDefaultShapeValue;

/// 判断是不是默认美肤
-(BOOL)isDefaultSkinValue;

/// 默认美颜参数
- (void)resetDefaultParams:(FUBeautyDefine)type;

/// 更新美颜参数到缓存
- (void)updateBeautyCache;

- (void)setStyleBeautyParams:(FUStyleModel *)styleModel;

/// 刷新数据，比如从自定义视频或图片返回需要刷新
/// 内部会决定从缓存还是重新初始化数据
- (void)reloadBeautyParams;

/// 更新美颜磨皮效果（根据人脸检测置信度设置不同磨皮效果）
- (void)updateBeautyBlurEffect;

@end

NS_ASSUME_NONNULL_END
