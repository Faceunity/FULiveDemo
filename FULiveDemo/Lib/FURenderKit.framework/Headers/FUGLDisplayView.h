//
//  FUSceneView.h
//  FULiveDemo
//
//  Created by 刘洋 on 2017/8/15.
//  Copyright © 2017年 刘洋. All rights reserved.
//

#import <GLKit/GLKit.h>

typedef NS_ENUM(NSInteger, FUGLDisplayViewOrientation) {
    FUGLDisplayViewOrientationPortrait              = 0,
    FUGLDisplayViewOrientationLandscapeRight        = 1,
    FUGLDisplayViewOrientationPortraitUpsideDown    = 2,
    FUGLDisplayViewOrientationLandscapeLeft         = 3,
};

typedef NS_ENUM(NSInteger, FUGLDisplayViewContentMode) {
    /* 等比例短边充满 */
    FUGLDisplayViewContentModeScaleAspectFill       = 0,
    /* 拉伸铺满 */
    FUGLDisplayViewContentModeScaleToFill           = 1,
     /* 等比例长边充满 */
    FUGLDisplayViewContentModeScaleAspectFit        = 2,

};

@class FUGLDisplayView;
@protocol FUGLDisplayViewGestureDelegate <NSObject>

- (void)displayView:(FUGLDisplayView *)displayView panMovedWithTranslation:(CGPoint)translation translationDelta:(CGPoint)translationDelta gestureState:(UIGestureRecognizerState)gestureState;

- (void)displayView:(FUGLDisplayView *)displayView pinchMovedWithScale:(CGFloat)scale scaleDelta:(CGFloat)scaleDelta gestureState:(UIGestureRecognizerState)gestureState;

@end

@interface FUGLDisplayView : UIView

@property (nonatomic, assign) FUGLDisplayViewContentMode contentMode;
// 设置视频朝向，保证视频总是竖屏播放
@property (nonatomic, assign) FUGLDisplayViewOrientation origintation;

@property (nonatomic, weak) id<FUGLDisplayViewGestureDelegate> gestureDelegate;

@property (nonatomic, assign) NSInteger disapplePointIndex ;
@property (nonatomic,assign,readonly)  CGSize boundsSizeAtFrameBufferEpoch;

@property (nonatomic, assign) BOOL alphaEnable;

- (void)setDisplayFramebuffer;
- (void)displayPixelBuffer:(CVPixelBufferRef)pixelBuffer;
- (void)displayImageData:(void *)imageData withSize:(CGSize)size;

- (void)displayPixelBuffer:(CVPixelBufferRef)pixelBuffer withLandmarks:(float *)landmarks count:(int)count;
- (void)presentFramebuffer;

- (void)displayTexture:(int)texture withTextureSize:(CGSize)textureSize;

@end
