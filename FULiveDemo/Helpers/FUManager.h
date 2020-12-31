//
//  FUManager.h
//  FULiveDemo
//
//  Created by 刘洋 on 2017/8/18.
//  Copyright © 2017年 刘洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "FURenderer.h"
#import "FUBeautyParam.h"

@class FULiveModel;

/*
 items 保存加载到Nama中bundle的操作句柄集
 注意：道具句柄数组位置可以调整，道具渲染顺序更具数组顺序渲染
 */
typedef NS_ENUM(NSUInteger, FUNamaHandleType) {
    FUNamaHandleTypeBeauty = 0,   /* items[0] ------ 放置 美颜道具句柄 */
    FUNamaHandleTypeItem = 1,     /* items[1] ------ 放置 普通道具句柄（包含很多，如：贴纸，aoimoji...若不单一存在，可放句柄集其他位置） */
    FUNamaHandleTypeFxaa = 2,     /* items[2] ------ fxaa抗锯齿道具句柄 */
    FUNamaHandleTypeGesture = 3,    /* items[3] ------ 手势识别道具句柄 */
    FUNamaHandleTypeChangeface = 4, /* items[4] ------ 海报换脸道具句柄 */
    FUNamaHandleTypeComic = 5,      /* items[5] ------ 动漫道具句柄 */
    FUNamaHandleTypeMakeup = 6,     /* items[6] ------ 美妆道具句柄 */
    FUNamaHandleTypePhotolive = 7,  /* items[7] ------ 异图道具句柄 */
    FUNamaHandleTypeAvtarHead = 8,  /* items[8] ------ Avtar头*/
    FUNamaHandleTypeAvtarHiar = 9,  /* items[9] ------ Avtar头发 */
    FUNamaHandleTypeAvtarbg = 10,  /* items[10] ------ Avtar背景 */
    FUNamaHandleTypeBodySlim = 11,  /* items[11] ------ 美体道具 */
    FUNamaHandleTypeBodyAvtar = 12,  /* 全身avtar */
    FUNamaHandleTotal = 13,
};

typedef NS_OPTIONS(NSUInteger, FUBeautyModuleType) {
    FUBeautyModuleTypeSkin = 1 << 0,
    FUBeautyModuleTypeShape = 1 << 1,
};

@interface FUManager : NSObject

@property (nonatomic, assign)               BOOL enableGesture;         /**设置是否开启手势识别，默认未开启*/
@property (nonatomic, assign)               BOOL enableMaxFaces;        /**设置人脸识别个数，默认为单人模式*/

/* 滤镜参数 */
@property (nonatomic, strong) NSMutableArray<FUBeautyParam *> *filters;
/* 美肤参数 */
@property (nonatomic, strong) NSMutableArray<FUBeautyParam *> *skinParams;
/* 美型参数 */
@property (nonatomic, strong) NSMutableArray<FUBeautyParam *> *shapeParams;
/* 风格参数 */
@property (nonatomic, strong) NSMutableArray<FUBeautyParam *> *styleParams;
@property (nonatomic, strong)               NSMutableArray<NSMutableArray<FULiveModel *>*> *dataSource;  /**道具分类数组*/
@property (nonatomic, strong)               NSString *selectedItem;     /**选中的道具名称*/

@property (nonatomic, strong)               FUBeautyParam *seletedFliter;
@property (nonatomic, strong)               FUBeautyParam *currentStyle;

@property (nonatomic, strong) dispatch_queue_t asyncLoadQueue;

// 当前页面的 model
@property (nonatomic, strong) FULiveModel *currentModel ;

@property (nonatomic) int deviceOrientation;

+ (FUManager *)shareManager;

- (void)setAsyncTrackFaceEnable:(BOOL)enable;
// 默认美颜参数
- (void)setBeautyDefaultParameters:(FUBeautyModuleType)type;

/* 设置所有美颜参数 */
-(void)setStyleBeautyParams:(FUBeautyParams*)params;

/* 设置fumanager 保存的美颜参数 */
- (void)setBeautyParameters;
/**
 判断是不是默认美型参数
 */
-(BOOL)isDefaultShapeValue;
/* 判断是不是默认美肤 */
-(BOOL)isDefaultSkinValue;
- (void)resetAllBeautyParams;
/**初始化Faceunity,加载道具*/
- (void)loadItems;
/* 加载美颜bundle */
- (void)loadMakeupBundleWithName:(NSString *)name;
/* 加载bundle 到指定items位置 */
- (void)loadBundleWithName:(NSString *)name aboutType:(FUNamaHandleType)type;
/**加载美颜道具*/
- (void)loadFilter ;
/**销毁全部道具*/
- (void)destoryItems;
/*
 销毁指定道具
 */
- (void)destoryItemAboutType:(FUNamaHandleType)type;

/* 获取handle */
- (int)getHandleAboutType:(FUNamaHandleType)type;

/**加载普通道具*/
- (void)loadItem:(NSString *)itemName completion:(void (^)(BOOL finished))completion;

/* 添加动漫滤镜 */
- (void)loadFilterAnimoji:(NSString *)itemName style:(int)style;

/* 跳过渲染的道具 */
-(void)preventRenderingAarray:(NSArray <NSNumber *>*)array;

/* 将道具绘制到imager */
- (UIImage *)renderItemsToImage:(UIImage *)image;
/**将道具绘制到pixelBuffer*/
- (CVPixelBufferRef)renderItemsToPixelBuffer:(CVPixelBufferRef)pixelBuffer;

- (CVPixelBufferRef)renderAvatarPixelBuffer:(CVPixelBufferRef)pixelBuffer;

/* 3D 渲染接口 */
-(void)renderItemsWithPtaPixelBuffer:(CVPixelBufferRef)pixelBuffer;

/* 加载海报道具 */
- (void)loadPoster;
/**
 合成海报输入参数

 @param posterImage 海报模板照片
 @param photoImage 人脸照片
 @param photoLandmarks 要处理人脸点位
 */
-(void)setPosterItemParamImage:(UIImage *)posterImage photo:(UIImage *)photoImage photoLandmarks:(float *)photoLandmarks warpValue:(id)warpValue;

/**
 美妆贴纸

 @param image 贴纸图片
 @param paramStr 美妆部位参数
 */
-(void)setMakeupItemParamImageName:(NSString *)image param:(NSString *)paramStr;
/**
 美妆程度值

 @param value 0~1
 @param paramStr 美妆部位参数
 */
-(void)setMakeupItemIntensity:(float )value param:(NSString *)paramStr;

/**
 美妆颜色设置

 @param sdkStr sdk键值
 @param valueArr 值
 */
-(void)setMakeupItemStr:(NSString *)sdkStr valueArr:(NSArray *)valueArr;


/// 将道具句柄移除nama 渲染，注意：b该操作不会销毁道具
/// @param type 句柄索引
-(void)removeNamaRenderWithType:(FUNamaHandleType)type;

/// 将移除的道具句柄，重新加入，渲染出效果
/// @param type 句柄索引
-(void)rejoinNamaRenderWithType:(FUNamaHandleType)type;


- (void)musicFilterSetMusicTime;

/**获取item的提示语*/
- (NSString *)hintForItem:(NSString *)item;

- (void)set3DFlipH ;

/**获取75个人脸特征点*/
- (void)getLandmarks:(float *)landmarks index:(int)index;

/**
 获取图像中人脸中心点位置

 @param frameSize 图像的尺寸，该尺寸要与视频处理接口或人脸信息跟踪接口中传入的图像宽高相一致
 @return 返回一个以图像左上角为原点的中心点
 */
- (CGPoint)getFaceCenterInFrameSize:(CGSize)frameSize;

/**判断是否检测到人脸*/
- (BOOL)isTracking;

/**切换摄像头要调用此函数*/
- (void)onCameraChange;

/**获取错误信息*/
- (NSString *)getError;

/**判断 SDK 是否是 lite 版本**/
- (BOOL)isLiteSDK ;

/* 是否正脸 */
-(BOOL)isGoodFace:(int)index;

/* 是否夸张 */
-(BOOL)isExaggeration:(int)index;

-(void)setParamItemAboutType:(FUNamaHandleType)type name:(NSString *)paramName value:(float)value;

/* 判断屏幕方向是否改变 */
-(BOOL)isDeviceMotionChange;
@end
