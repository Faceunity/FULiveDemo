//
//  FURenderKit.h
//  FURenderKit
//
//  Created by ly-Mac on 2020/12/2.
//

#import <Foundation/Foundation.h>
#import "FUScene.h"
#import "FUGroupAnimation.h"
#import "FUCaptureCamera.h"
#import "FUInternalCameraSetting.h"
#import "FUGLDisplayView.h"
#import "FUSetupConfig.h"
#import "FURenderIO.h"

#import "FUBeauty.h"
#import "FUMakeup.h"

#import "FUStickerContainer.h"
#import "FULightMakeup.h"
#import "FUComicFilter.h"
#import "FUHairBeauty.h"
#import "FUGreenScreen.h"
#import "FUBodyBeauty.h"
#import "FUActionRecognition.h"
#import "FUPoster.h"
#import "FUMusicFilter.h"
#import "FUAnimoji.h"

#import "FUGesture.h"
#import "FUFaceRectInfo.h"
#import "FUAISegment.h"
#import "UIImage+FURenderKit.h"
#import "FUImageHelper.h"
#import "UIDevice+FURenderKit.h"

#import "FUAIKit.h"

@class FURenderKit;

// 内部相机render相关协议
@protocol FURenderKitDelegate <NSObject>

// 使用内部相机时，即将处理图像时输入回调
- (void)renderKitWillRenderFromRenderInput:(FURenderInput *)renderInput;

// 使用内部相机时，处理图像后的输出回调
- (void)renderKitDidRenderToOutput:(FURenderOutput *)renderOutput;

// 使用内部相机时，内部是否进行render处理，返回NO，将直接输出原图。
- (BOOL)renderKitShouldDoRender;

@end

@interface FURenderKit : NSObject

/// internalCameraSetting 有默认值，用户按需修改对应配置即可。
@property (nonatomic, strong, readonly) FUInternalCameraSetting *internalCameraSetting;

/// 暂停内部渲染循环，不会影响外部对renderWithInput的调用。
@property (nonatomic, assign) BOOL pause;

/// 3D场景实例，设置前需要先将 scene 通过 addScene 接口添加到 renderKit
@property (nonatomic, strong, nullable) FUScene *currentScene;

@property (nonatomic, strong, readonly) NSArray *scenes;

/**
 * 美颜模块
 */
@property (nonatomic, strong, nullable) FUBeauty *beauty;

/**
 * 美妆模块
 */
@property (nonatomic, strong, nullable) FUMakeup *makeup;

/**
 * 道具贴纸、AR面具、搞笑大头、哈哈镜、人像分割 等道具的容器对象
 */
@property (nonatomic, strong, readonly) FUStickerContainer *stickerContainer;


/**
 * 轻美妆
 */
@property (nonatomic, strong, nullable) FULightMakeup *lightMakeup;


/**
 * 动漫滤镜
 */
@property (nonatomic, strong, nullable) FUComicFilter *comicFilter;

/**
 * 美发
 */
@property (nonatomic, strong, nullable) FUHairBeauty *hairBeauty;

/**
 * 绿慕
 */
@property (nonatomic, strong, nullable) FUGreenScreen *greenScreen;

@property (nonatomic, strong, nullable) FUMusicFilter *musicFilter;
/**
 * 美体
 */
@property (nonatomic, strong, nullable) FUBodyBeauty *bodyBeauty;

/**
 * 动作识别
 */
@property (nonatomic, strong, nullable) FUActionRecognition *actionRecognition;

@property (nonatomic, strong, nullable) FUItem *antiAliasing;


/// 多重采样等级，默认为0
@property (nonatomic, assign) int msaaLevel;


/// 如果使用sceneView渲染需要由用户自己创建
@property (nonatomic, strong, nullable) FUGLDisplayView *glDisplayView;

@property (nonatomic, strong, readonly) FUCaptureCamera *captureCamera;

@property (nonatomic, weak) id<FURenderKitDelegate> delegate;

#pragma makr - version
+ (NSString *)getVersion;

+ (void)setLogLevel:(FULOGLEVEL)logLevel;

+ (void)setLogFilePath:(NSString *)filePath;

#pragma mark - setup
+ (BOOL)setupWithSetupConfig:(FUSetupConfig *)setupConfig;

/**
 *  setupconfig 里面需要填入offLinePath 离线鉴权包地址
 *  @return 第一次鉴权成功后的文件
 */
+ (NSData *)setupLocalWithSetupConfig:(FUSetupConfig *)setupConfig;

/**
 * 内部调用fuSetupInternalCheck 去初始化鉴权
 *  return NO 失败， YES成功
 */
+ (BOOL)setupInternalCheckWithSetupConfig:(FUSetupConfig *)setupConfig;

+ (void)destroy;

+ (void)clear;

+ (instancetype)shareRenderKit;

#pragma mark - scene
- (void)addScene:(FUScene *)scene completion:(void(^)(BOOL success))completion;

- (void)removeScene:(FUScene *)scene completion:(void(^)(BOOL success))completion;

- (void)replaceScene:(FUScene *)scene withNewScene:(FUScene *)newScene completion:(void(^)(BOOL success))completion;

#pragma mark - Other API
/**
 * 获取证书里面的模块权限
 * code get i-th code, currently available for 0 and 1
 */
+ (int)getModuleCode:(int)code;

#pragma mark - internalCamera

- (void)startInternalCamera;

- (void)stopInternalCamera;


#pragma mark - render
- (FURenderOutput *)renderWithInput:(FURenderInput *)input;


#pragma mark - other
+ (int)getSystemError;

+(NSString *)getSystemErrorString;

+ (int)profileGetNumTimers;
+ (long long)profileGetTimerAverage:(int)index;

/// 设备性能分级
+ (FUDevicePerformanceLevel)devicePerformanceLevel;

#pragma mark - Record && capture
+ (void)startRecordVideoWithFilePath:(NSString *)filePath;

+ (void)stopRecordVideoComplention:(void(^)(NSString *filePath))complention;

+ (UIImage *)captureImage;
@end

