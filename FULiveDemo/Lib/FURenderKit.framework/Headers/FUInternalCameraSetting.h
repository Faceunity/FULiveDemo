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
@property (nonatomic, assign) int format; //default kCVPixelFormatType_32BGRA
@property (nonatomic, copy)  AVCaptureSessionPreset sessionPreset; // default AVCaptureSessionPreset1280x720
@property (nonatomic, assign) AVCaptureDevicePosition position; // default AVCaptureDevicePositionFront
@property (nonatomic, assign) int fps; // default 30

@property (nonatomic, assign) BOOL useVirtualCamera; // default NO, 需要注意的是，在打开内部虚拟相机时，用户如果使用Scene相关需要真实相机的功能，内部会自动开启真实相机，并且当用户关闭相关Scene功能时，内部会自动关闭。

/// 如果使用内部相机时，SDK会自动判断当前是否需要使用系统相机，如果不需相机，内部会模拟一个相机并循环输出图像。
/// 该属性可以设置输出图像的宽高，默认宽高为：720x1280，如果设置为CGSizeZero,则会使用 sessionPreset 的宽高。
@property (nonatomic, assign) CGSize virtualCameraResolution;
@end

NS_ASSUME_NONNULL_END
