//
//  PhotoButton.m
//  FULiveDemo
//
//  Created by liuyang on 2016/12/27.
//  Copyright © 2016年 liuyang. All rights reserved.
//

#import "FUPhotoButton.h"
#import "FUCircleProgressView.h"
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "FUVolumeObserver.h"


@interface FUPhotoButton ()<FUVolumeObserverProtocol>
{
    NSTimer *timer;
    NSInteger time;
    CGAffineTransform originTransform ;

}
@property  (nonatomic, strong) FUCircleProgressView *circleProgress;
@property  (nonatomic, strong) UILongPressGestureRecognizer *longPress;
@end

@implementation FUPhotoButton


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        time = 0;
        _type = FUPhotoButtonTypeRecord | FUPhotoButtonTypeTakePhoto;
        _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
        _longPress.minimumPressDuration = 0; //定义按的时间
        [self addGestureRecognizer:_longPress];
        [self addSubview:self.circleProgress];
       // [FUVolumeObserver sharedInstance].delegate = self;
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    time = 0;
    _type = FUPhotoButtonTypeRecord | FUPhotoButtonTypeTakePhoto;
    _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
    _longPress.minimumPressDuration = 0; //定义按的时间
    [self addGestureRecognizer:_longPress];
    [self addSubview:self.circleProgress];
  //  [FUVolumeObserver sharedInstance].delegate = self;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.circleProgress.frame = CGRectMake(1, 1, self.bounds.size.width - 2, self.bounds.size.height - 2);
}

- (FUCircleProgressView *)circleProgress
{
    if(!_circleProgress)
    {
        _circleProgress = [[FUCircleProgressView alloc] initWithFrame:CGRectMake(1, 1, self.bounds.size.width - 2, self.bounds.size.height - 2)];
        _circleProgress.backgroundColor = [UIColor clearColor];
        _circleProgress.progressColor = [UIColor colorWithRed:92 / 255.0 green:181 / 255.0 blue:249 / 255.0 alpha:1];
        _circleProgress.progressWidth = 3;
        _circleProgress.progressBackgroundColor = [UIColor clearColor];
        _circleProgress.clockwise = 0;
        _circleProgress.percent = 0;
    }
    
    return _circleProgress;
}


-(void)btnLong:(UILongPressGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer.state == 1) {
        self.selected = YES;
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateTime) userInfo:NULL repeats:YES];
        [timer fire];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        
    }else if(gestureRecognizer.state == 3)
    {
        [self photoButtonFinishRecord];
    }
}

-(void)photoButtonFinishRecord{
    if (timer) {
        if (time <= 3) {
            [self takePhoto];
        }else
        {
            [self stopRecord];
        }
        [timer invalidate];
        timer = nil;
        time = 0;
        _circleProgress.percent = 0;
        self.selected = NO;
        NSLog(@"time invalidate");
    }
}


- (void)updateTime
{
    time ++;

    if (time - 4 >=0) {
        if (time - 4 == 0) {
            [self startRecord];
        }
        _circleProgress.percent += 0.01;
    }
    
    if (time - 4 >= 100 ) {
        [self stopRecord];
        [timer invalidate];
        timer = nil;
        time = 0;
        _circleProgress.percent = 0;
        self.selected = NO;
    }
}

-(void)takePhoto{
    if (!(_type & FUPhotoButtonTypeTakePhoto)) return;
    if ([self.delegate respondsToSelector:@selector(takePhoto)]) {
        [self.delegate takePhoto];
    }
}
-(void)startRecord{
    if (!(_type & FUPhotoButtonTypeRecord)) return;
    dispatch_async(dispatch_get_main_queue(), ^{
        originTransform = self.transform ;
        [UIView animateWithDuration:0.5 animations:^{
//            self.transform = CGAffineTransformMakeTranslation(0, -5);
            self.transform = CGAffineTransformScale(self.transform, 1.1, 1.1);
        }];
        if ([self.delegate respondsToSelector:@selector(startRecord)]) {
            [self.delegate startRecord];
        }
    });
}

-(void)stopRecord{
    if (!(_type & FUPhotoButtonTypeRecord)) return;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(stopRecord)]) {
            [self.delegate stopRecord];
        }
//        [UIView animateWithDuration:0.5 animations:^{
            self.transform = originTransform;
//        }];
    });
}


-(void)setType:(FUPhotoButtonType)type{
    _type = type;
    if (type & FUPhotoButtonTypeRecord){
        _circleProgress.hidden = NO;
         [self addGestureRecognizer:_longPress];
    }else{
        _circleProgress.hidden = YES;
         [self removeGestureRecognizer:_longPress];
        [self addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)dealloc{
    NSLog(@"FUPhotoButton dealloc-----");
}

@end
