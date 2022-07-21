//
//  FURenderKit.h
//  FURenderKit
//
//  Created by ly-Mac on 2020/12/2.
//

#import <Foundation/Foundation.h>
#import "FUScene.h"
#import "FUAvatarCheck.h"
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

NS_ASSUME_NONNULL_BEGIN

@class FURenderKit;

// 内部相机render相关协议
@protocol FURenderKitDelegate <NSObject>
@optional

// 使用内部相机时，即将处理图像时输入回调
- (void)renderKitWillRenderFromRenderInput:(FURenderInput *)renderInput;

// 使用内部相机时，处理图像后的输出回调
- (void)renderKitDidRenderToOutput:(FURenderOutput *)renderOutput;

// 使用内部相机时，内部是否进行render处理，返回NO，将直接输出原图。
- (BOOL)renderKitShouldDoRender;

@end

@interface FURenderKit : NSObject

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


/// 如果使用 glDisplayView 渲染，需要由用户自己创建并赋值给该属性，当内部或外部调用 renderWithInput 时，会自动显示在该 View 中。
@property (nonatomic, strong, nullable) FUGLDisplayView *glDisplayView;


#pragma mark - 内部相机与回调
/// internalCameraSetting 有默认值，用户按需修改对应配置即可。
/// @see FUInternalCameraSetting
@property (nonatomic, strong, readonly) FUInternalCameraSetting *internalCameraSetting;

/// 暂停内部渲染循环，不会影响外部对renderWithInput的调用。
@property (nonatomic, assign) BOOL pause;

/// 内部相机，当 使用内部相机，并且 internalCameraSetting 中 useVirtualCamera ==  NO 时，才会开启内部真实相机。
@property (nonatomic, strong, readonly, nullable) FUCaptureCamera *captureCamera;

/// 内部渲染回调，只有使用内部相机时对应的代理方法才会执行
/// @see FURenderKitDelegate
@property (nonatomic, weak, nullable) id<FURenderKitDelegate> delegate;

#pragma mark - setup and destroy

/// FURenderKit 单例
+ (instancetype)shareRenderKit;

/// SDK 初始化
/// @param setupConfig 初始化配置
/// @see FUSetupConfig
+ (BOOL)setupWithSetupConfig:(FUSetupConfig *)setupConfig;

/// setupconfig 里面需要填入offLinePath 离线鉴权包地址
/// @return 第一次鉴权成功后的文件
+ (NSData *)setupLocalWithSetupConfig:(FUSetupConfig *)setupConfig;

/// 内部调用fuSetupInternalCheck 去初始化鉴权
/// @return NO 失败， YES成功
+ (BOOL)setupInternalCheckWithSetupConfig:(FUSetupConfig *)setupConfig;

/// 销毁 FURenderKit，释放内存，同时会清空所有的特效模型。
+ (void)destroy;

/// 清空所有的特效模型：美颜、美型、美妆、3D场景与形象等。
+ (void)clear;

#pragma mark - version
/// 获取版本信息
/// @return 版本信息
+ (NSString *)getVersion;

/// 设置 log 等级
/// @param logLevel log 等级
+ (void)setLogLevel:(FULOGLEVEL)logLevel;

/// 设置 log 保存路径
/// @param filePath log 保存路径
+ (void)setLogFilePath:(NSString *)filePath;


#pragma mark - scene
/**
 异步添加场景，添加完成后需要将场景设置为 currentScene 才可以生效
 @param scene 被添加的场景
 @param completion 添加完成的回调
 */
- (void)addScene:(FUScene *)scene completion:(nullable void(^)(BOOL success))completion;

/**
 移除场景，如果被移除的场景为当前场景，当前渲染效果也会失效。
 @param scene 需要被移除的场景
 @param completion 移除完成的回调
 */
- (void)removeScene:(FUScene *)scene completion:(nullable void(^)(BOOL success))completion;

/**
 替换场景，如果需要让新的场景生效，需要将其设置为 currentScene
 @param scene 被替换的场景，为空时直接添加新的场景
 @param newScene 新的场景，为空时直接移除被替换的场景
 @param completion 替换成功的回调
 */
- (void)replaceScene:(nullable FUScene *)scene withNewScene:(nullable FUScene *)newScene completion:(nullable void(^)(BOOL success))completion;

#pragma mark - internalCamera

/// 开启内部相机，相机配置请修改 internalCameraSetting 相关属性
/// @see FUInternalCameraSetting
- (void)startInternalCamera;

/// 关闭内部相机
- (void)stopInternalCamera;

#pragma mark - Record && capture

/// 开始录像
/// @param filePath 录像保存地址
+ (void)startRecordVideoWithFilePath:(NSString *)filePath;

/// 结束录像
/// @param complention 录制结束回调
+ (void)stopRecordVideoComplention:(void(^)(NSString *filePath))complention;

/// 获取单帧图像
+ (UIImage *)captureImage;

#pragma mark - renderWithInput
/**
 核心渲染接口，当贴纸、美颜、美型、美妆、3D场景与形象配置到 RenderKit之后，调用该接口会把效果作用于输出的结果中。
 支持输入单纹理、纹理+imageBuffer、纹理+pixelBuffer、单imageBuffer、单pixelBuffer；
 输出与输入相对应，也可以支持只输出纹理、或渲染到当前FBO。
 @param input 输入图像，类型为 FURenderInput
 @return 输出图像结果，类型为 FURenderOutput
 */
- (FURenderOutput *)renderWithInput:(FURenderInput *)input;

#pragma mark - Other API

/// 获取证书里面的模块权限
/// @return code get i-th code, currently available for 0 and 1
+ (int)getModuleCode:(int)code;

/// 获取错误码
/// @return 错误码
+ (int)getSystemError;

/// 获取错误信息
/// @return 错误信息
+(NSString *)getSystemErrorString;

+ (int)profileGetNumTimers;

+ (long long)profileGetTimerAverage:(int)index;

/// 设置缓存目录，提升加载模型速度
/// @param directory 可读写目录路径
+ (void)setCacheDirectory:(NSString *)directory;

/// 设备性能分级
+ (FUDevicePerformanceLevel)devicePerformanceLevel;


#pragma mark - frame time profile
/**
 * 开启/关闭算法耗时统计功能
 * 默认关闭
 */
+ (void)setFrameTimeProfileEnable:(BOOL)enable;

/**
 * 设置算法耗时输出到控制台
 */
+ (void)setFrameTimeProfileAutoReportToConsole;

/**
 * 设置算法耗时输出到文件
 * filePath 文件路径
 */
+ (void)setFrameTimeProfileAutoReportToFile:(NSString *_Nonnull)filePath;

/**
 * 设置算法耗时打印间隔
 * interval 默认300
 */
+ (void)setFrameTimeProfileReportInterval:(int)interval;

/**
 * 开启/关闭算法耗时统计详细信息
 * 默认关闭
 */
+ (void)setFrameTimeProfileReportDetailsEnable:(BOOL)enable;

@end

NS_ASSUME_NONNULL_END

