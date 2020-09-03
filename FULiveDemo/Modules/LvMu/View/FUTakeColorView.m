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

@property(nonatomic,strong)UIView *perView;

@property(nonatomic,strong)UIImageView *imageView;

@property(nonatomic,assign)CGRect actionRect;
@end
@implementation FUTakeColorView

-(instancetype)initWithFrame:(CGRect)frame didChangeBlock:(nonnull FUTakeColorChange)block{
    if (self = [super initWithFrame:frame]) {
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanAction:)];
        [self addGestureRecognizer:panGestureRecognizer];
        [self setupTakeColorView];
        _didChange = block;
        _actionRect = [UIScreen mainScreen].bounds;
    }
    
    return self;
}

-(void)actionRect:(CGRect )rect{
    _actionRect = rect;
}


-(void)setupTakeColorView{
    self.perView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    [self addSubview:self.perView];
    self.perView.layer.masksToBounds = YES ;
    self.perView.layer.cornerRadius = self.frame.size.width / 2.0 ;
    self.perView.layer.borderWidth = 2;
    self.perView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.perView.layer.backgroundColor = [UIColor colorWithRed:237/255.0 green:104/255.0 blue:95/255.0 alpha:1.0].CGColor;
    
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
- (void)handlePanAction:(UIPanGestureRecognizer *)sender {
    CGPoint point = [sender translationInView:[sender.view superview]];

    __block CGPoint viewCenter = CGPointMake(sender.view.center.x + point.x, sender.view.center.y + point.y);
    
    __block CGPoint imageCenter =  [self convertPoint:_imageView.center toView:[sender.view superview]];

    // 拖拽状态结束
    if (sender.state == UIGestureRecognizerStateBegan) {
        CGRect frame = self.frame;
        frame.origin = CGPointMake(frame.origin.x, frame.origin.y - 50);
        self.frame = frame;
    }else if (sender.state == UIGestureRecognizerStateEnded) {
        self.perView.backgroundColor = [FUImageHelper getPixelColorScreenWindowAtLocation:imageCenter];
        if (_didChange) {
            _didChange(self.perView.backgroundColor);
        }
        self.hidden = YES;
    } else {
        if (!CGRectContainsPoint(_actionRect, viewCenter)) {
            return;
        }
        sender.view.center = viewCenter;
        [sender setTranslation:CGPointMake(0, 0) inView:[sender.view superview]];
        self.perView.backgroundColor = [FUImageHelper getPixelColorScreenWindowAtLocation:imageCenter];
    }
}

-(void)dealloc{
    NSLog(@"takeColor ---- dealloc");
}

@end
