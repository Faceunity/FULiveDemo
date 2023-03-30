//
//  FUInternalCameraSetting.h
//  FURenderKit
//
//  Created by ly-Mac on 2021/3/2.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface FUInternalCameraSetting : NSObject

/// 相机采集格式
/// 默认为kCVPixelFormatType_32BGRA
@property (nonatomic, assign) int format;

/// 相机分辨率
/// 默认为AVCaptureSessionPreset1280x720
@property (nonatomic, copy)  AVCaptureSessionPreset sessionPreset;

/// 相机前后置摄像头
/// 默认为AVCaptureDevicePositionFront
@property (nonatomic, assign) AVCaptureDevicePosition position;

/// 默认为30
@property (nonatomic, assign) int fps;

/// 是否打开内部虚拟相机
/// 需要注意的是，在打开内部虚拟相机时，用户如果使用Scene相关需要真实相机的功能，内部会自动开启真实相机
/// 并且当用户关闭相关Scene功能时，内部会自动关闭
/// 默认为 NO
@property (nonatomic, assign) BOOL useVirtualCamera; //

/// 如果使用内部相机时，SDK会自动判断当前是否需要使用系统相机，如果不需相机，内部会模拟一个相机并循环输出图像。
/// 该属性可以设置输出图像的宽高，默认宽高为：720x1280，如果设置为CGSizeZero,则会使用 sessionPreset 的宽高。
@property (nonatomic, assign) CGSize virtualCameraResolution;

/// 相机是否需要音频，默认为NO
@property (nonatomic, assign) BOOL needsAudioTrack;

@end

NS_ASSUME_NONNULL_END
