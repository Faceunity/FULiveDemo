//
//  FUTakeColorView.m
//  FULiveDemo
//
//  Created by 孙慕 on 2020/8/18.
//  Copyright © 2020 FaceUnity. All rights reserved.
//

#import "FUTakeColorView.h"
#import "FUBaseViewController.h"
#import "FUImageHelper.h"
@interface FUTakeColorView()
@property(nonatomic,strong)FUTakeColorChange didChange;

@property(nonatomic,strong)FUTakeColorComplete complete;
@property(nonatomic,strong)UIImageView *imageView;

@property(nonatomic,assign)CGRect actionRect;
@end
@implementation FUTakeColorView

-(instancetype)initWithFrame:(CGRect)frame didChangeBlock:(nonnull FUTakeColorChange)block complete:(nonnull FUTakeColorComplete)complete{
    if (self = [super initWithFrame:frame]) {
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanAction:)];
        [self addGestureRecognizer:panGestureRecognizer];
        
        [self setupTakeColorView];
        _didChange = block;
        _complete = complete;
        _actionRect = [UIScreen mainScreen].bounds;
    }
    
    return self;
}

-(void)actionRect:(CGRect )rect{
    _actionRect = rect;
}


-(void)setupTakeColorView{
    self.perView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:self.perView.bounds];
    imageview.image = [UIImage imageNamed:@"demo_bg_transparent"];
    [self addSubview:imageview];
    [self addSubview:self.perView];
    self.perView.layer.masksToBounds = YES ;
    self.perView.layer.cornerRadius = self.frame.size.width / 2.0 ;
    self.perView.layer.borderWidth = 2;
    self.perView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.perView.layer.backgroundColor = [UIColor clearColor].CGColor;
    
    self.perView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.2].CGColor;
    self.perView.layer.shadowOffset = CGSizeMake(0,0);
    self.perView.layer.shadowOpacity = 1;
    self.perView.layer.shadowRadius = 3;
    
    self.backgroundColor = [FUImageHelper getPixelColorScreenWindowAtLocation:self.center];
    if (_didChange) {
        _didChange(self.backgroundColor);
    }
    
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"aiming_point"]];
    _imageView.frame = CGRectMake(self.bounds.size.width/2 - 10, self.bounds.size.height - 20, 20, 20);
    [self addSubview:_imageView];
    
}


#pragma  mark -  手势
static int cout = 0;
- (void)handlePanAction:(UIPanGestureRecognizer *)sender {
    
    CGPoint point = [sender translationInView:[sender.view superview]];
 
    CGPoint viewCenter = CGPointMake(sender.view.center.x + point.x, sender.view.center.y + point.y);
    
    CGPoint imageCenter =  [self convertPoint:_imageView.center toView:[sender.view superview]];

    // 拖拽状态结束
    if (sender.state == UIGestureRecognizerStateBegan) {
        CGRect frame = self.frame;
        frame.origin = CGPointMake(frame.origin.x, frame.origin.y - 50);
        self.frame = frame;
    }else if (sender.state == UIGestureRecognizerStateEnded) {
         [sender setTranslation:CGPointMake(0, 0) inView:[sender.view superview]];
        [self viweMovingEnd:imageCenter];
    } else {
        if (!CGRectContainsPoint(_actionRect, viewCenter)) {
            return;
        }
        cout ++;
        if (cout % 4 != 0) {//减少触发频率
             return;
         }

        [sender setTranslation:CGPointMake(0, 0) inView:[sender.view superview]];
        sender.view.center = viewCenter;
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(takeColorView:)]) {
            self.perView.backgroundColor = [self.dataSource takeColorView:imageCenter];
        }
        if (_didChange) {
            _didChange(self.perView.backgroundColor);
        }
        
    }
}


-(void)viweMovingEnd:(CGPoint)center{
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(takeColorView:)]) {
        self.perView.backgroundColor = [self.dataSource takeColorView:center];
    }
    if (_didChange) {
        _didChange(self.perView.backgroundColor);
    }
    
    if (_complete) {
        _complete();
    }
    self.center = center;
    self.hidden = YES;
}


-(void)toucheSetPoint:(CGPoint)point{
    self.perView.backgroundColor = [FUImageHelper getPixelColorScreenWindowAtLocation:point];
    if (_didChange) {
        _didChange(self.perView.backgroundColor);
    }
    
    if (_complete) {
        _complete();
    }
    
    [UIView animateWithDuration:0.05 animations:^{
        self.center = point;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}


-(void)dealloc{
    NSLog(@"takeColor ---- dealloc");
}

@end
