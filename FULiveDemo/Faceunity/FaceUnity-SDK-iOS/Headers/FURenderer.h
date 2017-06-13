//
//  FURenderer.h
//  FULiveDemo
//
//  Created by ly on 16/11/2.
//  Copyright © 2016年 liuyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "funama.h"

typedef struct{
    CVPixelBufferRef pixelBuffer;
    GLuint bgraTextureHandle;
}FUOutput;

@interface FURenderer : NSObject

+ (FURenderer *)shareRenderer;

/**
 \brief Initialize and authenticate your SDK instance to the FaceUnity server, must be called exactly once before all other functions.
	The buffers should NEVER be freed while the other functions are still being called.
	You can call this function multiple times to "switch pointers".
 \param data should point to contents of the "v2.bin" we provide
 \param ardata should point to contents of the "ar.bin" we provide
 \param package is the pointer to the authentication data pack we provide. You must avoid storing the data in a file.
	Normally you can just `#include "authpack.h"` and put `g_auth_package` here.
 */
- (void)setupWithData:(void *)data ardata:(void *)ardata authPackage:(void *)package authSize:(int)size;

/**
 \brief Initialize and authenticate your SDK instance to the FaceUnity server, must be called exactly once before all other functions.
	The buffers should NEVER be freed while the other functions are still being called.
	You can call this function multiple times to "switch pointers".
 \param data should point to contents of the "v2.bin" we provide
 \param ardata should point to contents of the "ar.bin" we provide
 \param package is the pointer to the authentication data pack we provide. You must avoid storing the data in a file.
	Normally you can just `#include "authpack.h"` and put `g_auth_package` here.
 \param create if shouldCreateContext is YES we will create on context in our SDK
 */
- (void)setupWithData:(void *)data ardata:(void *)ardata authPackage:(void *)package authSize:(int)size shouldCreateContext:(BOOL)create;

/**
 \brief Generalized interface for rendering a list of items.
	This function needs a GLES 2.0+ context.
 \param pixelBuffer is the input buffer
 \param frameid specifies the current frame id.
	To get animated effects, please increase frame_id by 1 whenever you call this.
 \param items points to the list of items
 \param itemCount is the number of items
 \return a buffer
 */
- (CVPixelBufferRef)renderPixelBuffer:(CVPixelBufferRef)pixelBuffer withFrameId:(int)frameid items:(int*)items itemCount:(int)itemCount;

/**
 \brief Generalized interface for rendering a list of items.
	This function needs a GLES 2.0+ context.
 \param pixelBuffer is the input buffer
 \param frameid specifies the current frame id.
	To get animated effects, please increase frame_id by 1 whenever you call this.
 \param items points to the list of items
 \param itemCount is the number of items
 \return a buffer
 */
- (CVPixelBufferRef)beautifyPixelBuffer:(CVPixelBufferRef)pixelBuffer withFrameId:(int)frameid items:(int*)items itemCount:(int)itemCount;

/**
 \brief Generalized interface for rendering a list of items.
	This function needs a GLES 2.0+ context.
 \param pixelBuffer is the input buffer
 \param textureHandle is the input texture,only support BGRA format
 \param frameid specifies the current frame id.
	To get animated effects, please increase frame_id by 1 whenever you call this.
 \param items points to the list of items
 \param itemCount is the number of items
 \return a paramsData include pixelBuffer and textureHandle
 */
- (FUOutput)renderPixelBuffer:(CVPixelBufferRef)pixelBuffer bgraTexture:(GLuint)textureHandle withFrameId:(int)frameid items:(int *)items itemCount:(int)itemCount;

/**
 \brief Generalized interface for rendering a list of items.
	This function needs a GLES 2.0+ context.
 \param pixelBuffer is the input buffer
 \param frameid specifies the current frame id.
	To get animated effects, please increase frame_id by 1 whenever you call this.
 \param items points to the list of items
 \param itemCount is the number of items
 \param flip is the enable to flipx stickers
 \return a buffer
 */
- (CVPixelBufferRef)renderPixelBuffer:(CVPixelBufferRef)pixelBuffer withFrameId:(int)frameid items:(int*)items itemCount:(int)itemCount flipx:(BOOL)flip;

/**
 YUV420P Support
 */
- (void)renderFrame:(uint8_t*)y u:(uint8_t*)u v:(uint8_t*)v ystride:(int)ystride ustride:(int)ustride vstride:(int)vstride width:(int)width height:(int)height frameId:(int)frameid items:(int *)items itemCount:(int)itemCount;

/**
 此接口会返回一个和原来不同的CVPixelBufferRef
 */
- (CVPixelBufferRef)renderToInternalPixelBuffer:(CVPixelBufferRef)pixelBuffer withFrameId:(int)frameid items:(int*)items itemCount:(int)itemCount;

/**
 切换摄像头时调用
 */
+ (void)onCameraChange;

/**
创建道具
 */
+ (int)createItemFromPackage:(void*)data size:(int)size;

/**
销毁单个道具
 */
+ (void)destroyItem:(int)item;

/**
销毁所有道具
 */
+ (void)destroyAllItems;

/**
 人脸信息跟踪
 */
+ (int)trackFace:(int)inputFormat inputData:(void*)inputData width:(int)width height:(int)height;

/**
 为道具设置参数
 
 value 只支持 NSString NSNumber两种数据类型
 
 */
+ (int)itemSetParam:(int)item withName:(NSString *)name value:(id)value;

/**
 从道具中获取double值
 */
+ (double)itemGetDoubleParam:(int)item withName:(NSString *)name;

/**
 从道具中获取string值
 */
+ (void)itemGetStringParam:(int)item withName:(NSString *)name buf:(char *)buf size:(int)size;

/**
 判断是否识别到人脸，返回值为人脸个数
 */
+ (int)isTracking;

/**
 设置多人，最多设置8个
 */
+ (int)setMaxFaces:(int)maxFaces;

/**
 获取人脸信息
 */
+ (int)getFaceInfo:(int)faceId name:(NSString *)name pret:(float *)pret number:(int)number;

/**
 将普通道具绑定到avatar道具
 */
+ (int)avatarBindItems:(int)avatarItem items:(int *)items itemsCount:(int)itemsCount contracts:(int *)contracts contractsCount:(int)contractsCount;

/**
 将普通道具从avatar道具上解绑
 */
+ (int)avatarUnbindItems:(int)avatarItem items:(int *)items itemsCount:(int)itemsCount;

/**
 绑定道具
 */
+ (int)bindItems:(int)item items:(int*)items itemsCount:(int)itemsCount;

/**
 解绑道具
 */
+ (int)unbindAllItems:(int)item;

/**
获取版本信息
 */
+ (NSString *)getVersion;

@end
