//
//  FUCaptureButton.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/8/10.
//

#import "FUCaptureButton.h"
#import "FUCircleProgressView.h"

#import "UIButton+FU.h"

@interface FUCaptureButton ()

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) FUCircleProgressView *circleProgress;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation FUCaptureButton {
    NSInteger timeCount;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.button];
        [self addSubview:self.circleProgress];
        
        // 点击拍照
        __weak typeof(self) weakSelf = self;
        [self.button addCommonActionWithDelay:0.1 actionHandler:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(captureButtonDidTakePhoto)]) {
                [strongSelf.delegate captureButtonDidTakePhoto];
            }
        }];
        
        // 长按录制视频
        self.longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        self.longPress.minimumPressDuration = 0.3;
        [self addGestureRecognizer:self.longPress];
        
        _recordVideo = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.circleProgress.frame = CGRectMake(1, 1, CGRectGetWidth(self.frame) - 2, CGRectGetHeight(self.frame) - 2);
}

#pragma mark - Private methods

- (void)startRecording {
    [UIView animateWithDuration:0.5 animations:^{
        self.transform = CGAffineTransformMakeScale(1.1, 1.1);
    }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(captureButtonDidStartRecording)]) {
        [self.delegate captureButtonDidStartRecording];
    }
}

- (void)stopRecording {
    self.transform = CGAffineTransformIdentity;
    if (self.delegate && [self.delegate respondsToSelector:@selector(captureButtonDidFinishRecording)]) {
        [self.delegate captureButtonDidFinishRecording];
    }
}

- (void)invalidateTimer {
    [self.timer invalidate];
    self.timer = nil;
    timeCount = 0;
    self.circleProgress.percent = 0;
}

#pragma mark - Event response

- (void)longPressAction:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateTimeAction) userInfo:nil repeats:YES];
        [self.timer fire];
        [self startRecording];
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        [self stopRecording];
        [self invalidateTimer];
    }
}

- (void)updateTimeAction {
    timeCount += 1;
    self.circleProgress.percent += 0.01;
    if (timeCount > 100) {
        // 自动结束录制
        [self stopRecording];
        [self invalidateTimer];
    }
}

#pragma mark - Setters

- (void)setRecordVideo:(BOOL)recordVideo {
    _recordVideo = recordVideo;
    self.longPress.enabled = recordVideo;
}

#pragma mark - Getters

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = self.bounds;
        [_button setImage:[UIImage imageNamed:@"render_camera_capture"] forState:UIControlStateNormal];
        _button.adjustsImageWhenHighlighted = NO;
        _button.adjustsImageWhenDisabled = NO;
    }
    return _button;
}

- (FUCircleProgressView *)circleProgress {
    if (!_circleProgress) {
        _circleProgress = [[FUCircleProgressView alloc] initWithFrame:CGRectMake(1, 1, CGRectGetWidth(self.frame) - 2, CGRectGetHeight(self.frame) - 2)];
        _circleProgress.progressColor = [UIColor colorWithRed:92 / 255.0 green:181 / 255.0 blue:249 / 255.0 alpha:1];
        _circleProgress.backgroundColor = [UIColor clearColor];
        _circleProgress.progressBackgroundColor = [UIColor clearColor];
        _circleProgress.userInteractionEnabled = NO;
    }
    return _circleProgress;
}

@end
