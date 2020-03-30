//
//  FURenderRotate.h
//
//  Created by ly on 16/11/2.
//  Copyright © 2016年 liuyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>



@interface FURenderRotate : NSObject

/**
 获取 FURenderRotate 单例
 
 @return FURenderRotate 单例
 */
//+ (FURenderRotate *)shareRenderer;

- (void)setup;

- (void)rotateBufferType:(int)aa;


- (CVPixelBufferRef)renderPixelBuffer:(CVPixelBufferRef)pixelBuffer  withLandmarks:(float *)landmarks count:(int)count MAX:(BOOL)max;

@end
