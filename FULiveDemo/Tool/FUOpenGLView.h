//
//  FUOpenGLView.h
//  FULiveDemo
//
//  Created by 刘洋 on 2017/8/15.
//  Copyright © 2017年 刘洋. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface FUOpenGLView : UIView

typedef NS_ENUM(NSInteger,FUOpenGLViewContentMode) {
    FUOpenGLViewContentModeScaleAspectFit,      // contents scaled to fit with fixed aspect. remainder is transparent
    FUOpenGLViewContentModeScaleAspectFill,     // default mode,contents scaled to fill with fixed aspect. some portion of content may be clipped.
};

- (void)displayPixelBuffer:(CVPixelBufferRef)pixelBuffer;

- (void)displayPixelBuffer:(CVPixelBufferRef)pixelBuffer withLandmarks:(float *)landmarks count:(int)count;

@end
