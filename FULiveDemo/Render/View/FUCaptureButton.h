//
//  FUCaptureButton.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/8/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FUCaptureButtonDelegate <NSObject>

- (void)captureButtonDidTakePhoto;
- (void)captureButtonDidStartRecording;
- (void)captureButtonDidFinishRecording;

@end

@interface FUCaptureButton : UIView

/// 是否可以录制视频，默认为YES
@property (nonatomic, assign) BOOL recordVideo;

@property (nonatomic, weak) id<FUCaptureButtonDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
