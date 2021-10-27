//
//  FUPopupMenu.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/10/11.
//  Copyright © 2019 FaceUnity. All rights reserved.
//

#import "FUPopupMenu.h"

#define FUScreenWidth [UIScreen mainScreen].bounds.size.width
#define FUScreenHeight [UIScreen mainScreen].bounds.size.height
#define FUMainWindow  [UIApplication sharedApplication].keyWindow
#define  LeftView 10.0f
#define  TopToView 10.0f
@interface FUPopupMenu()
@property (nonatomic, strong) UIView      * menuBackView;

@property (nonatomic) CGPoint               point;

@property (nonatomic,assign) int               onlyTop;

@property (nonatomic, copy) NSArray *dataSource;

@end
@implementation FUPopupMenu

- (instancetype)initWithFrame:(CGRect)frame onlyTop:(BOOL)onlyTop defaultSelectedAtIndex:(int)index dataSource:(nullable NSArray *)dataSource
{
    self = [super initWithFrame:frame];
    if (self) {
        _selIndex = index;
        _onlyTop = onlyTop;
        _dataSource = dataSource;
        [self setupView];
    }
    return self;
}


- (void)setupView{
    
    _menuBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FUScreenWidth, FUScreenHeight)];
    _menuBackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    _menuBackView.alpha = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(touchOutSide)];
    [_menuBackView addGestureRecognizer: tap];
    self.alpha = 0;
    self.backgroundColor = [UIColor clearColor];
    
    UIView *bageView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, self.frame.size.width, self.frame.size.height - 10)];
    bageView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    bageView.layer.cornerRadius = 5;
    [self addSubview:bageView];
    
    /* 分段控制器 */
    NSArray *array = self.dataSource.count > 0 ? self.dataSource : [NSArray arrayWithObjects:@"480×640",@"720×1280",@"1080×1920", nil];
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:array];
    segment.frame = CGRectMake(25, 28, self.frame.size.width-50, 32);
    segment.selectedSegmentIndex = _selIndex;
    segment.tintColor = [UIColor whiteColor];
    [segment addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:segment];
    
    if (!_onlyTop) {
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(25,80,self.frame.size.width-50,0.5);
        view.layer.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0].CGColor;
        [self addSubview:view];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(25, 81, self.frame.size.width-50, 50);
        [btn setImage:[UIImage imageNamed:@"demo_icon_add_to"] forState:UIControlStateNormal];
        [btn setTitle:FUNSLocalizedString(@"载入图片或视频", nil)  forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(didClickBtn) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        btn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        btn.imageEdgeInsets = UIEdgeInsetsMake(0, btn.frame.size.width - btn.imageView.frame.size.width , 0, 0);
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, - btn.frame.size.width - btn.imageView.frame.size.width + btn.titleLabel.frame.size.width, 0, 0);

        [self addSubview:btn];
    }

}


+ (FUPopupMenu *)showRelyOnView:(UIView *)view frame:(CGRect)frame defaultSelectedAtIndex:(int)index onlyTop:(BOOL)onlyTop delegate:(id<FUPopupMenuDelegate>)delegate{
    return [self showRelyOnView:view frame:frame defaultSelectedAtIndex:index onlyTop:onlyTop dataSource:nil delegate:delegate];
}

+ (FUPopupMenu *)showRelyOnView:(UIView *)view frame:(CGRect)frame defaultSelectedAtIndex:(int)index onlyTop:(BOOL)onlyTop dataSource:(NSArray *)dataSource delegate:(id<FUPopupMenuDelegate>)delegate {
    CGRect absoluteRect = [view convertRect:view.bounds toView:FUMainWindow];
    CGPoint relyPoint = CGPointMake(absoluteRect.origin.x + absoluteRect.size.width / 2, absoluteRect.origin.y + absoluteRect.size.height);
    FUPopupMenu *popupMenu = [[FUPopupMenu alloc] initWithFrame:frame  onlyTop:(BOOL)onlyTop defaultSelectedAtIndex:(int)index dataSource:dataSource];
    popupMenu.delegate = delegate;
    popupMenu.point  = relyPoint;
    CGFloat anchorPointX= (relyPoint.x - frame.origin.x) / frame.size.width * 1.0;
    popupMenu.layer.anchorPoint = CGPointMake(anchorPointX, 0);
    popupMenu.layer.frame = frame;
    [popupMenu show];
    return popupMenu;
}

#pragma mark - privates
- (void)show
{
    [FUMainWindow addSubview:_menuBackView];
    [FUMainWindow addSubview:self];
    self.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration: 0.25 animations:^{
        self.layer.affineTransform = CGAffineTransformMakeScale(1.0, 1.0);
        self.alpha = 1;
        _menuBackView.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}


- (void)dismiss{
    [UIView animateWithDuration: 0.25 animations:^{
        self.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
        self.alpha = 0;
        _menuBackView.alpha = 0;
    } completion:^(BOOL finished) {
        self.delegate = nil;
        [self removeFromSuperview];
        [_menuBackView removeFromSuperview];
    }];
}

-(void)dismissBtn{
    
}

- (void)touchOutSide{

    [self dismiss];

}

-(void)didClickBtn{
    if ([self.delegate respondsToSelector:@selector(fuPopupMenuDidSelectedImage)]) {
        [self.delegate fuPopupMenuDidSelectedImage];
        [self dismiss];
    }
}

- (void)selectItem:(UISegmentedControl *)sender {
    if ([self.delegate respondsToSelector:@selector(fuPopupMenuDidSelectedAtIndex:)]) {
        [self.delegate fuPopupMenuDidSelectedAtIndex:sender.selectedSegmentIndex];
    }
}

#pragma mark 绘制三角形
- (void)drawRect:(CGRect)rect
{
    //    [colors[serie] setFill];
    // 设置背景色
    [[UIColor whiteColor] set];
    //拿到当前视图准备好的画板
    CGContextRef  context = UIGraphicsGetCurrentContext();
    //利用path进行绘制三角形
    CGContextBeginPath(context);//标记
    CGContextMoveToPoint(context,
                         self.point.x - self.frame.origin.x, 0);//设置起点
    
    CGContextAddLineToPoint(context,
                            self.point.x  - self.frame.origin.x - 10 , 10);
    
    CGContextAddLineToPoint(context,
                            self.point.x  - self.frame.origin.x + 10, 10);
    
    CGContextClosePath(context);//路径结束标志，不写默认封闭
    
    [[UIColor colorWithWhite:0.0 alpha:0.6] setFill];  //设置填充色
    [[UIColor clearColor] setStroke];
    CGContextDrawPath(context,
                      kCGPathFillStroke);//绘制路径path
    
    //    [self setNeedsDisplay];
}

@end
