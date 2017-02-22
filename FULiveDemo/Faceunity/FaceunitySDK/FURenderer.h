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
 \param v2data should point to contents of the "v2.bin" we provide
 \param ardata should point to contents of the "ar.bin" we provide
 \param package is the pointer to the authentication data pack we provide. You must avoid storing the data in a file.
	Normally you can just `#include "authpack.h"` and put `g_auth_package` here.
 */
- (void)setupWithData:(void *)v2data ardata:(void *)ardata authPackage:(void *)package authSize:(int)size;

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
 \param textureHandle is the input texture,only support BGRA format
 \param frameid specifies the current frame id.
	To get animated effects, please increase frame_id by 1 whenever you call this.
 \param items points to the list of items
 \param itemCount is the number of items
 \return a paramsData include pixelBuffer and textureHandle
 */
- (FUOutput)renderPixelBuffer:(CVPixelBufferRef)pixelBuffer bgraTexture:(GLuint)textureHandle withFrameId:(int)frameid items:(int *)items itemCount:(int)itemCount;

@end
