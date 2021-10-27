//
//  FUAIKit.h
//  FURenderKit
//
//  Created by liuyang on 2021/3/2.
//

#import <Foundation/Foundation.h>
#import "CNamaSDK.h"
#import "FURenderIO.h"

@class FUTrackFaceInput;

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    FUFaceProcessorDetectModeImage,
    FUFaceProcessorDetectModeVideo,
} FUFaceProcessorDetectMode;

typedef enum : NSUInteger {
    FUFaceProcessorFaceLandmarkQualityLow,
    FUFaceProcessorFaceLandmarkQualityMedium,
    FUFaceProcessorFaceLandmarkQualityHigh
} FUFaceProcessorFaceLandmarkQuality;

@interface FUAIKit : NSObject

@property (nonatomic, assign) int maxTrackFaces; // 设置最大的人脸跟踪个数 default is 1

@property (nonatomic, assign, readonly) int trackedFacesCount; // 跟踪到的人脸个数

@property (nonatomic, assign) int maxTrackBodies; // 设置最大的人体跟踪个数 default is 1

@property (nonatomic, assign) FUFaceProcessorDetectMode faceProcessorDetectMode; // 图像加载模式 default is FUFaceProcessorDetectModeVideo

@property (nonatomic, assign) BOOL asyncTrackFace; //设置是否进行异步人脸跟踪

@property (nonatomic, assign) FUFaceProcessorFaceLandmarkQuality faceProcessorFaceLandmarkQuality;  // 人脸算法质量

+ (instancetype)shareKit;

+ (void)loadAIModeWithAIType:(FUAITYPE)type dataPath:(NSString *)dataPath;

+ (void)unloadAIModeForAIType:(FUAITYPE)type;

+ (void)unloadAllAIMode;

+ (BOOL)loadedAIType:(FUAITYPE)type;

+ (void)loadTongueMode:(NSString *)modePath;

+ (void)setTrackFaceAIType:(FUAITYPE)type;

+ (int)trackFaceWithInput:(FUTrackFaceInput *)trackFaceInput;

+ (void)resetHumanProcessor;

+ (int)aiHumanProcessorNums;

+ (int)aiFaceProcessorNums;

//人脸检测置信度
+ (float)fuFaceProcessorGetConfidenceScore:(int)index;

//ai手势识别
+ (int)aiHandDistinguishNums;

//handIndex 检测到手的索引
+ (FUAIGESTURETYPE)fuHandDetectorGetResultGestureType:(int)handIndex;

//动作识别： actionId index of fuHumanProcessorGetNumResults
+ (int)fuHumanProcessorGetResultActionType:(int)actionId;


//设置面部参数
+ (void)setFaceTrackParam:(NSString *)param value:(int)value;

/**
 获取人脸信息：
     - 在程序中需要先运行过视频处理接口( 视频处理接口8 除外)或 人脸信息跟踪接口
 后才能使用该接口来获取人脸信息；
     -
 该接口能获取到的人脸信息与我司颁发的证书有关，普通证书无法通过该接口获取到人脸信息；
     - 具体参数及证书要求如下：

         landmarks: 2D人脸特征点，返回值为75个二维坐标，长度75*2
         证书要求: LANDMARK证书、AVATAR证书

         landmarks_ar: 3D人脸特征点，返回值为75个三维坐标，长度75*3
         证书要求: AVATAR证书

         rotation: 人脸三维旋转，返回值为旋转四元数，长度4
         证书要求: LANDMARK证书、AVATAR证书

         translation: 人脸三维位移，返回值一个三维向量，长度3
         证书要求: LANDMARK证书、AVATAR证书

         eye_rotation: 眼球旋转，返回值为旋转四元数,长度4
         证书要求: LANDMARK证书、AVATAR证书

         rotation_raw: 人脸三维旋转（不考虑屏幕方向），返回值为旋转四元数，长度4
         证书要求: LANDMARK证书、AVATAR证书

         expression: 表情系数，长度46
         证书要求: AVATAR证书

         projection_matrix: 投影矩阵，长度16
         证书要求: AVATAR证书

         face_rect: 人脸矩形框，返回值为(xmin,ymin,xmax,ymax)，长度4
         证书要求: LANDMARK证书、AVATAR证书

         rotation_mode: 人脸朝向，0-3分别对应手机四种朝向，长度1
         证书要求: LANDMARK证书、AVATAR证书

 @param faceId 被检测的人脸 ID ，未开启多人检测时传 0
 ，表示检测第一个人的人脸信息；当开启多人检测时，其取值范围为 [0 ~ maxFaces-1]
 ，取其中第几个值就代表检测第几个人的人脸信息
 @param name 人脸信息参数名： "landmarks" , "eye_rotation" , "translation" ,
 "rotation" ....
 @param pret 作为容器使用的 float 数组指针，获取到的人脸信息会被直接写入该 float
 数组。
 @param number float 数组的长度
 @return 返回 1 代表获取成功，返回 0 代表获取失败
 */
+ (int)getFaceInfo:(int)faceId
              name:(NSString *)name
              pret:(float *)pret
            number:(int)number;

/// 设置了InputCameraMatrix之后获取获取人脸信息
+ (int)getRotatedFaceInfo:(int)faceId
                     name:(NSString *)name
                     pret:(float *)pret
                   number:(int)number;

/// 图像明显发生改变时调用该接口重置内部检测结果
+ (void)resetTrackedResult;
@end


@interface FUAIKit (Test)

@property (nonatomic, assign) float use_new_cnn_detection;
@property (nonatomic, assign) float other_face_detection_frame_step_new;
@property (nonatomic, assign) float min_facesize_big;
@property (nonatomic, assign) float small_face_frame_step;
@property (nonatomic, assign) float min_facesize_small;

@property (nonatomic, assign) float other_face_detection_frame_step;
@property (nonatomic, assign) float size_min;

@end


#pragma mark - FUTrackFaceInput

@interface FUTrackFaceConfig : NSObject
/// 是否进行舌头的检测，默认不对舌头进行检测。
@property (nonatomic, assign) BOOL trackTongue;

@property (nonatomic, assign) FUImageOrientation imageOrientation; // 设置人物在原始图像中的方向，默认为 FUImageOrientationUP。

@property (nonatomic, assign) BOOL gravityEnable; // 重力开关，开启此功能可以根据已设置的 trackOrientation 自动适配AI检测的方向。


/// 当前图片是否来源于前置摄像头，默认为 NO
@property (nonatomic, assign) BOOL isFromFrontCamera;

/// 当前图片是否来源于镜像摄像头，默认为 NO
@property (nonatomic, assign) BOOL isFromMirroredCamera;
@end

/// trackFaceWithInput 接口的输入，CVPixelBufferRef、FUImageBuffer只需要传入一个就好，如果传入多个，将按优先级使用其中一种，优先级为：CVPixelBufferRef > FUImageBuffer;
@interface FUTrackFaceInput : NSObject
/// 输入的 pixelBuffer
@property (nonatomic, assign) CVPixelBufferRef pixelBuffer;

/// 输入的 imageBuffer
@property (nonatomic, assign) FUImageBuffer imageBuffer;

/// 设置 trackFace 相关的输入配置，详细参数请查看 FUTrackFaceConfig 类的接口注释。
@property (nonatomic, strong) FUTrackFaceConfig *trackFaceConfig;
@end


NS_ASSUME_NONNULL_END
