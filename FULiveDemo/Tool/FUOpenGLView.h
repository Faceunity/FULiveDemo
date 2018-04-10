//
//  FUOpenGLView.h
//  FULiveDemo
//
//  Created by 刘洋 on 2017/8/15.
//  Copyright © 2017年 刘洋. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface FUOpenGLView : UIView

- (void)displayPixelBuffer:(CVPixelBufferRef)pixelBuffer;

- (void)displayPixelBuffer:(CVPixelBufferRef)pixelBuffer withLandmarks:(float *)landmarks count:(int)count;

@end
