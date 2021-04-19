//
//  FURenderKit.h
//  FURenderKit
//
//  Created by ly-Mac on 2020/12/2.
//

#import <Foundation/Foundation.h>
#import "FUScene.h"
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

#import "FUAIKit.h"

NS_ASSUME_NONNULL_BEGIN

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

/// 3D场景实例
@property (nonatomic, strong, nullable) FUScene *scene;

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


/// 如果使用sceneView渲染需要由用户自己创建
@property (nonatomic, strong, nullable) FUGLDisplayView *glDisplayView;

@property (nonatomic, strong, readonly) FUCaptureCamera *captureCamera;

@property (nonatomic, weak) id<FURenderKitDelegate> delegate;

#pragma makr - version
+ (NSString *)getVersion;

+ (void)setLogLevel:(FULOGLEVEL)logLevel;

#pragma mark - setup
+ (void)setupWithSetupConfig:(FUSetupConfig *)setupConfig;

+ (void)destroy;

+ (void)clear;

+ (instancetype)shareRenderKit;

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


#pragma mark - Record && capture
+ (void)startRecordVideoWithFilePath:(NSString *)filePath;

+ (void)stopRecordVideoComplention:(void(^)(NSString *filePath))complention;

+ (UIImage *)captureImage;
@end

NS_ASSUME_NONNULL_END
