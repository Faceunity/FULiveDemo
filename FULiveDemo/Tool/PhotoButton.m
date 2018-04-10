//
//  PhotoButton.m
//  FULiveDemo
//
//  Created by liuyang on 2016/12/27.
//  Copyright © 2016年 liuyang. All rights reserved.
//

#import "PhotoButton.h"
#import "CircleProgressView.h"

@interface PhotoButton ()
{
    NSTimer *timer;
    NSInteger time;
    
    CGAffineTransform originTransform ;
}
@property  (nonatomic, strong) CircleProgressView *circleProgress;
@end

@implementation PhotoButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    time = 0;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
    longPress.minimumPressDuration = 0; //定义按的时间
    [self addGestureRecognizer:longPress];
    [self addSubview:self.circleProgress];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.circleProgress.frame = CGRectMake(1, 1, self.bounds.size.width - 2, self.bounds.size.height - 2);
}

- (CircleProgressView *)circleProgress
{
    if(!_circleProgress)
    {
        _circleProgress = [[CircleProgressView alloc] initWithFrame:CGRectMake(1, 1, self.bounds.size.width - 2, self.bounds.size.height - 2)];
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
        }
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
    if ([self.delegate respondsToSelector:@selector(takePhoto)]) {
        [self.delegate takePhoto];
    }
}
-(void)startRecord{
    
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
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(stopRecord)]) {
            [self.delegate stopRecord];
        }
//        [UIView animateWithDuration:0.5 animations:^{
            self.transform = originTransform;
//        }];
    });
}
@end
