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

@class FULiveModel ;

/*
 items 保存加载到Nama中bundle的操作句柄集
 为方便演示阅读，这里将
 */
typedef NS_ENUM(NSUInteger, FUNamaHandleType) {
    FUNamaHandleTypeBeauty = 0,   /* items[0] ------ 放置 美颜道具句柄 */
    FUNamaHandleTypeItem = 1,     /* items[1] ------ 放置 普通道具句柄（包含很多，如：贴纸，aoimoji...若不单一存在，可放句柄集其他位置） */
    FUNamaHandleTypeFxaa = 2,     /* items[2] ------ fxaa抗锯齿道具句柄 */
    FUNamaHandleTypeGesture = 3,    /* items[3] ------ 手势识别道具句柄 */
    FUNamaHandleTypeChangeface = 4, /* items[4] ------ 海报换脸道具句柄 */
    FUNamaHandleTypeComic = 5,      /* items[5] ------ 动漫道具句柄 */
    FUNamaHandleTypeMakeup = 6,     /* items[6] ------ 美妆道具句柄 */
    FUNamaHandleTypeMakeupType = 7,  /* items[7] ------ 美妆类型 ---- 由类型bundle 控制*/
    FUNamaHandleTypePhotolive = 8,  /* items[8] ------ 异图道具句柄 */
    FUNamaHandleTypeAvtarHead = 9,  /* items[9] ------ Avtar头*/
    FUNamaHandleTypeAvtarHiar = 10,  /* items[10] ------ Avtar头发 */
    FUNamaHandleTypeAvtarbg = 11,  /* items[11] ------ Avtar背景 */
    FUNamaHandleTypeBodySlim = 12,  /* items[12] ------ 美体道具 */
    FUNamaHandleTypeHairModel = 13,  /* items[13] ------ 美发的模型 */
    FUNamaHandleTotal = 14
};

typedef NS_OPTIONS(NSUInteger, FUBeautyModuleType) {
    FUBeautyModuleTypeSkin = 1 << 0,
    FUBeautyModuleTypeShape = 1 << 1,
};

@interface FUManager : NSObject

@property (nonatomic, assign)               BOOL enableGesture;         /**设置是否开启手势识别，默认未开启*/
@property (nonatomic, assign)               BOOL enableMaxFaces;        /**设置人脸识别个数，默认为单人模式*/

@property (nonatomic, assign) BOOL skinDetectEnable ;   // 精准美肤
@property (nonatomic, assign) NSInteger blurType;      // 0清晰磨皮 1重度磨皮 2精细磨皮
//@property (nonatomic, assign) double blurLevel;         // 磨皮(0.0 - 6.0)
/* 0清晰磨皮  1重度磨皮   2精细磨皮 */
@property (nonatomic, assign) double blurLevel_0;
@property (nonatomic, assign) double blurLevel_1;
@property (nonatomic, assign) double blurLevel_2;
@property (nonatomic, assign) double whiteLevel;        // 美白
@property (nonatomic, assign) double redLevel;          // 红润
@property (nonatomic, assign) double eyelightingLevel;  // 亮眼
@property (nonatomic, assign) double beautyToothLevel;  // 美牙


@property (nonatomic, assign) NSInteger faceShape;        //脸型 (0、1、2、3、4)女神：0，网红：1，自然：2，默认：3，自定义：4
/* v脸 (0~1) */
@property (nonatomic, assign) double vLevel;
/* 鹅蛋 (0~1) */
@property (nonatomic, assign) double eggLevel;
/* 窄脸(0~1) */
@property (nonatomic, assign) double narrowLevel;
/* 小脸 (0~1) */
@property (nonatomic, assign) double smallLevel;

@property (nonatomic, assign) double enlargingLevel;      /**大眼 (0~1)*/
@property (nonatomic, assign) double thinningLevel;       /**瘦脸 (0~1)*/
//@property (nonatomic, assign) double enlargingLevel_new;  /**大眼 (0~1) --  新版美颜*/
//@property (nonatomic, assign) double thinningLevel_new;   /**瘦脸 (0~1) --  新版美颜*/

@property (nonatomic, assign) double jewLevel;            /**下巴 (0~1)*/
@property (nonatomic, assign) double foreheadLevel;       /**额头 (0~1)*/
@property (nonatomic, assign) double noseLevel;           /**鼻子 (0~1)*/
@property (nonatomic, assign) double mouthLevel;          /**嘴型 (0~1)*/

@property (nonatomic, strong) NSArray<NSString *> *filtersDataSource;     /**滤镜名称数组*/
@property (nonatomic, strong) NSArray<NSString *> *beautyFiltersDataSource;     /**美颜滤镜名称数组*/
@property (nonatomic, strong) NSDictionary<NSString *,NSString *> *filtersCHName;       /**滤镜中文名称数组*/
@property (nonatomic, strong) NSString *selectedFilter; /* 选中的滤镜 */
@property (nonatomic, assign) double selectedFilterLevel; /* 选中滤镜的 level*/

@property (nonatomic, strong)               NSMutableArray<FULiveModel *> *dataSource;  /**道具分类数组*/
@property (nonatomic, strong)               NSString *selectedItem;     /**选中的道具名称*/

/****  美妆程度  ****/
//@property (nonatomic, assign) double lipstick;          // 口红
//@property (nonatomic, assign) double blush;             // 腮红
//@property (nonatomic, assign) double eyebrow;           // 眉毛
//@property (nonatomic, assign) double eyeShadow;         // 眼影
//@property (nonatomic, assign) double eyeLiner;          // 眼线
//@property (nonatomic, assign) double eyelash;           // 睫毛
//@property (nonatomic, assign) double contactLens;       // 美瞳

// 当前页面的 model
@property (nonatomic, strong) FULiveModel *currentModel ;

+ (FUManager *)shareManager;

- (void)setAsyncTrackFaceEnable:(BOOL)enable;
/* 默认滤镜 */
-(void)setDefaultFilter;
// 默认美颜参数
- (void)setBeautyDefaultParameters:(FUBeautyModuleType)type;
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

/* 点位模式 */
-(void)loadMakeupType:(NSString *)itemName;

/* 添加动漫滤镜 */
- (void)loadFilterAnimoji:(NSString *)itemName style:(int)style;

/* 将道具绘制到imager */
- (UIImage *)renderItemsToImage:(UIImage *)image;
/**将道具绘制到pixelBuffer*/
- (CVPixelBufferRef)renderItemsToPixelBuffer:(CVPixelBufferRef)pixelBuffer;

- (CVPixelBufferRef)renderAvatarPixelBuffer:(CVPixelBufferRef)pixelBuffer;

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

/**
 意图道具参数设置

 @param image 图片数据
 @param g_points 点位数组
 @param g_type 五官类型
 */
-(void)setEspeciallyItemParamImage:(UIImage *)image group_points:(NSArray *)g_points group_type:(NSArray *)g_type;


#pragma  mark -  捏脸
-(void)enterAvatar;
-(void)recomputeAvatar;
-(void)clearAvatar;
-(void)quitAvatar;
-(void)lazyAvatar;

/* 暂时 */
-(void)avatarBundleAddRender:(BOOL)isAdd;
-(BOOL)avatarBundleIsload;

/* 扭脸维度 */
-(void)setAvatarParam:(NSString *)paramStr value:(float )value;
/* 部位颜色 */
-(void)setAvatarItemParam:(NSString *)paramStr colorWithRed:(float )r green:(int)g blue:(int)b;
/* 捏脸模型缩放 */
-(void)setAvatarItemScale:(float)scaleValue;
/* 头平移 */
-(void)setAvatarItemTranslateX:(int)x y:(int)y z:(int)z;

-(void)avatarBindHairItem:(NSString *)bundleName;
    
-(void)setAvatarHairColorParam:(NSString *)paramStr colorWithRed:(float )r green:(int)g blue:(int)b intensity:(int)i;

-(void)loadBgAvatar;

-(void)loadAvatarBundel;

/* 销毁海报道具 */
- (void)destroyItemPoster;

- (void)loadAnimojiFaxxBundle;
- (void)musicFilterSetMusicTime;

/**设置美发参数**/
- (void)setHairColor:(int)colorIndex ;
/* 设置美发程度值 */
- (void)setHairStrength:(float)strength;
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
@end
