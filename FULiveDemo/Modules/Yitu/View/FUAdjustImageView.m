//
//  FUAdjustImageView.m
//  FULiveDemo
//
//  Created by 孙慕 on 2018/12/17.
//  Copyright © 2018年 FaceUnity. All rights reserved.

#import "FUAdjustImageView.h"
#import <AVFoundation/AVFoundation.h>
#define btnWH 44
#define space 40



@interface FUAdjustImageView() <UIGestureRecognizerDelegate>{
    CAShapeLayer *lineLayer;
    float totleScale;
    BOOL enableRS;
}
@property (nonatomic, strong) UIGestureRecognizer *panGesture;
@property (nonatomic, strong) UIGestureRecognizer *pinchGesture;
@property (nonatomic, strong) UIRotationGestureRecognizer *rotationGesture;
@property (nonatomic, strong) UILongPressGestureRecognizer *longGesture;

@property (nonatomic,strong) UIButton *rotateBtn;
@property (nonatomic, strong) UIButton* clearBtn;

@property (nonatomic, assign) double zoomSpeed;

@property (nonatomic, strong) NSArray *points;
/* 精细调整对应的位置视图 */
@property (nonatomic, strong) NSMutableArray <CAShapeLayer *>*pointsLayer;
/* 精细调整 “+” */
@property (nonatomic, strong) UIImageView *adjustImageView;

@end
@implementation FUAdjustImageView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initMovementGestures];
        [self setupView];
 
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self initMovementGestures];
    [self setupView];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    NSLog(@"layoutSubviews");
}

#pragma mark - Private Methods

-(void)initMovementGestures
{
    self.userInteractionEnabled = YES;
    self.zoomSpeed = 1.0;
    self.minZoom = .2;
    self.maxZoom = 5;
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    self.panGesture.delegate = self;
    [self addGestureRecognizer:self.panGesture];
//
    self.pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    self.pinchGesture.delegate = self;
    [self addGestureRecognizer:self.pinchGesture];
    
//    self.longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongGesture:)];
//    self.longGesture.delegate = self;
//    self.longGesture.minimumPressDuration = 1.0;
//    [self addGestureRecognizer:self.longGesture];
    
    self.rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotateGesture:)];
    self.rotationGesture.delegate = self;
    [self addGestureRecognizer:self.rotationGesture];
}
#pragma  mark ----  初始化UI  -----
-(void)setupView{
    self.pointsLayer = [NSMutableArray array];
    
    CGRect frame = self.frame;
    CGRect sqFrame = CGRectMake(btnWH/2, btnWH/2, frame.size.width - btnWH, frame.size.height - btnWH);
    self.imageview = [[UIImageView alloc] init];
    self.imageview.image = [UIImage imageNamed:@"icon_yitu_leye"];
    self.imageview.frame = sqFrame;//CGRectMake(sqFrame.origin.x + space, sqFrame.origin.y + space, sqFrame.size.width - 2 * space, sqFrame.size.height - 2 * space);
 //   self.imageview.layer.shouldRasterize = YES;
    [self addSubview:self.imageview];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:sqFrame];
    lineLayer = [CAShapeLayer layer];
    lineLayer.path = path.CGPath;
    lineLayer.strokeColor = [UIColor whiteColor].CGColor;
    lineLayer.fillColor = [UIColor clearColor].CGColor;
    lineLayer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8].CGColor;
    lineLayer.shadowOffset = CGSizeMake(0,0);
    lineLayer.shadowOpacity = 1;
    lineLayer.shadowRadius = 1.5;
    lineLayer.borderWidth = 1.;
    lineLayer.borderColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    [self.layer addSublayer:lineLayer];
    
    _clearBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,0, btnWH, btnWH)];
    _clearBtn.center = sqFrame.origin;
    [_clearBtn setImage:[UIImage imageNamed:@"icon_yitu_close"] forState:UIControlStateNormal];
    _clearBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    _clearBtn.layer.shadowOffset = CGSizeMake(0, 0);
    _clearBtn.layer.shadowOpacity = 0.5;
    _clearBtn.layer.shadowRadius  = 2;
    [_clearBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_clearBtn];

    _addOneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,0, btnWH, btnWH)];
    _addOneBtn.center = CGPointMake(CGRectGetMaxX(sqFrame), sqFrame.origin.y);
    [_addOneBtn setImage:[UIImage imageNamed:@"icon_yitu_increase"] forState:UIControlStateNormal];
    _addOneBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    _addOneBtn.layer.shadowOffset = CGSizeMake(0, 0);
    _addOneBtn.layer.shadowOpacity = 0.5;
    _addOneBtn.layer.shadowRadius  = 2;
    [_addOneBtn addTarget:self action:@selector(addOneClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_addOneBtn];
    
    
    _rotateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rotateBtn.frame = CGRectMake(0,0, btnWH, btnWH);
    _rotateBtn.adjustsImageWhenHighlighted=NO;
    _rotateBtn.center = CGPointMake(CGRectGetMaxX(sqFrame), CGRectGetMaxY(sqFrame)) ;
    [_rotateBtn setImage:[UIImage imageNamed:@"icon_yitu_rotate"] forState:UIControlStateNormal];
    _rotateBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    _rotateBtn.layer.shadowOffset = CGSizeMake(0, 0);
    _rotateBtn.layer.shadowOpacity = 0.5;
    _rotateBtn.layer.shadowRadius  = 2;
    [_rotateBtn addTarget:self action:@selector(rotateBtnTouch:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:_rotateBtn];
    
//    self.adjustImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_yitu_adjusting"]];
//   // self.adjustImageView.hidden = YES;
//    [self addSubview:self.adjustImageView];
    
    totleScale = 1;

}

#pragma  mark ----  按钮点击事件  -----
-(void)click:(UIButton *)btn{
  //  [self removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(adjustImageViewRemove:)]) {
        [self.delegate adjustImageViewRemove:self];
    }
}

-(void)addOneClick:(UIButton *)btn{

    if ([self.delegate respondsToSelector:@selector(adjustImageViewAddOne:)]) {
        [self.delegate adjustImageViewAddOne:self];
    }
}

-(void)rotateBtnTouch:(UIButton *)btn{
    self.rotateBtn.alpha = 0.7;
    enableRS = YES;
}


#pragma  mark ----  手势事件  -----
-(void)handlePanGesture:(UIPanGestureRecognizer *) panGesture{
 //     CGPoint locationPoint = [panGesture locationInView:panGesture.view];

    if (!_editing) {
        self.editing = YES;
        if ([self.delegate respondsToSelector:@selector(adjustImageViewFocus:)]) {
            [self.delegate adjustImageViewFocus:self];
        }
    }
    if ([self.panGesture isEqual:panGesture]) {
        CGPoint translation = [panGesture translationInView:panGesture.view.superview];
//        NSLog(@"%@",NSStringFromCGPoint(translation))
        if (UIGestureRecognizerStateEnded == panGesture.state) {
            self.rotateBtn.alpha = 1.0;
            self.clearBtn.hidden = NO;
            self.addOneBtn.hidden = NO;
            enableRS = NO;
        }
        if (UIGestureRecognizerStateBegan == panGesture.state) {
            self.rotateBtn.alpha = 0.7;
            self.clearBtn.hidden = YES;
            self.addOneBtn.hidden = YES;
        }
        
        if (UIGestureRecognizerStateBegan == panGesture.state || UIGestureRecognizerStateChanged == panGesture.state) {
            if(enableRS){
                CGAffineTransform ort = CGAffineTransformMakeRotation(-M_PI/4);
                CGAffineTransform ooo = CGAffineTransformInvert(self.transform);
                CGAffineTransform tttt = CGAffineTransformConcat(ooo, ort);
                CGPoint newP = CGPointApplyAffineTransform(translation, tttt);
                float aaa =  newP.x / 100;//暂时调到这个比例
                [self zoomTransform:1 + aaa];
                float bbb =  newP.y / 100;
                [self rotateTransform:bbb];
            }else{
                panGesture.view.center = CGPointMake(panGesture.view.center.x + translation.x, panGesture.view.center.y + translation.y);
            
            }
           [panGesture setTranslation:CGPointZero inView:panGesture.view.superview];
        }
    }
}

-(void)handlePinchGesture:(UIPinchGestureRecognizer *)pinchGesture{
    if (!_editing) {
        self.editing = YES;
        if ([self.delegate respondsToSelector:@selector(adjustImageViewFocus:)]) {
            [self.delegate adjustImageViewFocus:self];
        }
    }
    if ([self.pinchGesture isEqual:pinchGesture]) {
        if (UIGestureRecognizerStateBegan == pinchGesture.state || UIGestureRecognizerStateChanged == pinchGesture.state) {
            NSInteger numberPoint = pinchGesture.numberOfTouches;

            //容错处理
            if(numberPoint != 2)
                return;

          //  [self justPoint:pinchGesture];

          //  float currentScale = self.imageview.layer.contentsScale;
            float deltaScale = pinchGesture.scale;
            [self zoomTransform:deltaScale];
             pinchGesture.scale = 1;
        }
    }
}

//-(void)handleLongGesture:(UILongPressGestureRecognizer *)longGesture{
//    if (!_editing) {
//        self.editing = YES;
//        if ([self.delegate respondsToSelector:@selector(adjustImageViewFocus:)]) {
//            [self.delegate adjustImageViewFocus:self];
//        }
//    }
//    if ([self.longGesture isEqual:longGesture]) {
//        CGPoint point = [longGesture locationInView:self];
//        
//        self.adjustImageView.center = point;
//    }
//}


#pragma  mark ----  视图操作  -----

-(void)zoomTransform:(float)deltaScale{
    NSLog(@"--------%lf",totleScale);
    if(totleScale > _maxZoom && deltaScale > 1.0){
        return;
    }
    if (totleScale < _minZoom && deltaScale < 1.0) {
        return;
    }

    totleScale *= deltaScale;
    
    deltaScale = ((deltaScale - 1) * self.zoomSpeed) + 1;
    
    CGSize size = CGSizeApplyAffineTransform(self.frame.size, self.transform);
    
    NSLog(@"当前大小%@,原始%@",NSStringFromCGSize(size),NSStringFromCGSize(self.frame.size));
    
    CGAffineTransform zoomTransform = CGAffineTransformScale(self.transform, deltaScale, deltaScale);
    self.transform = zoomTransform;
    _clearBtn.transform = CGAffineTransformScale(_clearBtn.transform, 1/deltaScale, 1/deltaScale);
    _addOneBtn.transform = CGAffineTransformScale(_addOneBtn.transform, 1/deltaScale, 1/deltaScale);
    _rotateBtn.transform = CGAffineTransformScale(_rotateBtn.transform, 1/deltaScale, 1/deltaScale);
    lineLayer.lineWidth = 1 / totleScale;
//    lineLayer.shadowRadius = 1 /deltaScale;
//    lineLayer.borderWidth = 0.5/deltaScale;

    
}

-(void)rotateTransform:(float)rotate{
    CGAffineTransform transform = CGAffineTransformRotate(self.transform, rotate);
    self.transform = transform;
    
     CGPoint newPoint = [self.imageview convertPoint:CGPointMake(0, 0) toView:self.superview];
     CGPoint newPoint1 = [self.imageview convertPoint:CGPointMake(5, 0) toView:self.superview];
    if (fabs(newPoint.y - newPoint1.y) < 0.1 ) {//旋转角有点问题。so。。。
        lineLayer.strokeColor = [UIColor colorWithRed:94/255.f green:199/255.f blue:254/255.f alpha:1].CGColor;
    }else{
        lineLayer.strokeColor = [UIColor whiteColor].CGColor;
    }
}


- (CGPoint)locationOfTouch:(NSUInteger)touchIndex inView:(nullable UIView*)view
{
    
    return CGPointZero;
}

-(void)handleRotateGesture:(UIRotationGestureRecognizer *)rotateGesture{
    if (_editing) {
        self.editing = NO;
        if ([self.delegate respondsToSelector:@selector(adjustImageViewFocus:)]) {
            [self.delegate adjustImageViewFocus:self];
        }
    }
    if ([self.rotationGesture isEqual:rotateGesture]) {
        if (UIGestureRecognizerStateBegan == rotateGesture.state || UIGestureRecognizerStateChanged == rotateGesture.state) {
            CGFloat rotate = rotateGesture.rotation;
            [self rotateTransform:rotate];
            [rotateGesture setRotation:0];
        }
    }
}

- (CGAffineTransform)getTransform{
    return self.transform;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"\n-----------------------------\n|%lf,%lf,0|\n|%lf,%lf,0|\n|%lf,%lf,0|\n-------------------------------",
          self.transform.a,self.transform.b,self.transform.c,self.transform.d,self.transform.tx,self.transform.ty);
    if (!_editing) {
        self.editing = YES;
        if ([self.delegate respondsToSelector:@selector(adjustImageViewFocus:)]) {
            [self.delegate adjustImageViewFocus:self];
        }
    }
}

//测试定位用
-(void)createDot:(CGPoint)ponint{
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:ponint radius:1 startAngle:0 endAngle:2*M_PI clockwise:YES];
    layer.path = path.CGPath;
    layer.strokeColor = [UIColor redColor].CGColor;
    layer.fillColor = [UIColor redColor].CGColor;
    [self.layer addSublayer:layer];
    
    [self.pointsLayer addObject:layer];
}


#pragma  mark ----  pulic  -----
-(NSArray *)getConvertPointsToView:(UIView *)view{
    CGPoint point = CGPointMake(0, 0);
    NSMutableArray *mutArray = [NSMutableArray array];
    for (int i = 0; i < _points.count; i++) {
        double xy = [_points[i] floatValue]/500 * self.imageview.frame.size.width;
        if (i % 2 && i != 0) {
            point.y = xy;
            CGPoint newPoint = [self.imageview convertPoint:point toView:view];
            [mutArray addObject:@(newPoint.x)];
            [mutArray addObject:@(newPoint.y)];
        }else{
            point.x = xy;
        }
    }
    
    return mutArray;
}


-(CGPoint )getConvertCenterImage:(UIView *)view{
    CGPoint newPoint = [self.imageview convertPoint:CGPointMake(self.imageview.frame.size.width/2, self.imageview.frame.size.height/2) toView:view];
    return newPoint;
}


/**
 根据五官类型，初始化默认点位数组

 @param type 五官类型
 */
-(void)setType:(FUFacialFeaturesType)type{
    _type = type;
    NSString *titleStr = nil;
    switch (type) {
        case FUFacialFeaturesLeye://图片和人物有镜像关系
            self.imageview.image = [UIImage imageNamed:@"icon_yitu_leye"];
            titleStr = @"reye";
            break;
        case FUFacialFeaturesReye:
            self.imageview.image = [UIImage imageNamed:@"icon_yitu_reye"];
            titleStr = @"leye";
            break;
        case FUFacialFeaturesNose:
            self.imageview.image = [UIImage imageNamed:@"icon_yitu_nose_add"];
            titleStr = @"nose";
            break;
        case FUFacialFeaturesMouth:
            self.imageview.image = [UIImage imageNamed:@"icon_yitu_mouth_add"];
            titleStr = @"mouth";
            break;
        case FUFacialFeatureLbrow:
            self.imageview.image = [UIImage imageNamed:@"icon_yitu_lbrow"];
            titleStr = @"lbrow";
            break;
        case FUFacialFeaturesRbrow:
            self.imageview.image = [UIImage imageNamed:@"icon_yitu_rbrow"];
            titleStr = @"rbrow";
            break;
        default:
            break;
    }
    _points = [self jsonToLipRgbaArrayResName:titleStr];
    [self getConvertPointsToView:self];
}

/* 拿默认点位数组 */
-(NSArray *)jsonToLipRgbaArrayResName:(NSString *)titleStr{
    NSString *path=[[NSBundle mainBundle] pathForResource:@"points" ofType:@"json"];
    NSData *data=[[NSData alloc] initWithContentsOfFile:path];
    if (!data) return nil;
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *points = [dic objectForKey:titleStr];
    return points;
}

-(void)setEditing:(BOOL)editing{
    _editing = editing;
    if (editing) {
        [self.superview bringSubviewToFront:self];
    }
    _clearBtn.hidden =  !editing;
    _addOneBtn.hidden = !editing;
    _rotateBtn.hidden = !editing;
    lineLayer.hidden =  !editing;
}


-(void)dealloc{
    NSLog(@"FUAdjustImageView<dealloc>");
    [self removeGestureRecognizer:self.panGesture];
    [self removeGestureRecognizer:self.pinchGesture];
    [self removeGestureRecognizer:self.rotationGesture];
    [self removeGestureRecognizer:self.longGesture];
}


@end
