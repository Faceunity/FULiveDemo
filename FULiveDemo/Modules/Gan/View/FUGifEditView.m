//
//  FUGifEditView.m
//  FULiveDemo
//
//  Created by 孙慕 on 2018/12/25.
//  Copyright © 2018年 FaceUnity. All rights reserved.
//

#import "FUGifEditView.h"
#import <Masonry.h>
#import "FUGanButton.h"
#import<AssetsLibrary/AssetsLibrary.h>

#define tagType 1000
#define imageViewCount 5

@interface FUGifEditView()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIGestureRecognizer *tapGesture;
@property (nonatomic, strong) UILongPressGestureRecognizer *longGesture;
@property (nonatomic,strong) NSMutableArray *imageArr;//当前图片数
@property (nonatomic,strong) UIButton *delBtn;//当前图片数
@property (assign, nonatomic) int willDelIndex;

@end

@implementation FUGifEditView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupView];
        
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setupView];
}

-(void)setupView{
    
    
    
    float margin = [UIScreen mainScreen].bounds.size.width > 320?10 : 5 ;
    float imageW = [UIScreen mainScreen].bounds.size.width > 320?39 : 36;
    float imageH = [UIScreen mainScreen].bounds.size.width > 320?44 : 42;
    
    for (int i = 0; i < imageViewCount; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(margin * (i + 1) + imageW * i  , 49 + 17, imageW, imageH)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.tag = tagType + i;
        imageView.layer.cornerRadius = 3.0;
       // imageView.backgroundColor = [UIColor grayColor];
        
        CAShapeLayer *dottedLineBorder  = [[CAShapeLayer alloc] init];
        dottedLineBorder.frame = self.bounds;
        [dottedLineBorder setLineWidth:2];
        [dottedLineBorder setStrokeColor:[UIColor clearColor].CGColor];
        [dottedLineBorder setFillColor:[UIColor clearColor].CGColor];
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:imageView.bounds cornerRadius:3];
        dottedLineBorder.path = path.CGPath;
        [imageView.layer addSublayer:dottedLineBorder];
        if (i == 0) {
            [dottedLineBorder setStrokeColor:[UIColor colorWithRed:94/255.0 green:199/255.0 blue:254/255.0 alpha:1.0].CGColor];
            imageView.image = [UIImage imageNamed:@"icon_gan_increase"];
            imageView.contentMode = UIViewContentModeCenter;
            imageView.alpha = 1.0;
        }else{
            imageView.image = [UIImage imageNamed:@"icon_gan_dotted"];
        }
        [self addGesturesTo:imageView];
        [self addSubview:imageView];
        
    }
   
    _playBtn = [[FUGanButton alloc] initWithFrame:CGRectMake(0, 0, 49, 49)];
    [_playBtn setImage:[UIImage imageNamed:@"icon_gan_play_nor"] forState:UIControlStateNormal];
    [_playBtn setImage:[UIImage imageNamed:@"icon_gan_play_sel"] forState:UIControlStateHighlighted];
    [_playBtn setImage:[UIImage imageNamed:@"icon_gan_play_sel"] forState:UIControlStateSelected];
    NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"播放",nil) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
    [_playBtn setTitle:NSLocalizedString(@"播放",nil) forState:UIControlStateNormal];
    [_playBtn addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    _playBtn.titleLabel.attributedText = string1;
    [self addSubview:_playBtn];
    
    _quickenBtn = [[FUGanButton alloc] initWithFrame:CGRectMake(0, 0, 49, 49)];
    [_quickenBtn setImage:[UIImage imageNamed:@"icon_gan_accelerate"] forState:UIControlStateNormal];
     [_quickenBtn setImage:[UIImage imageNamed:@"icon_gan_accelerate_sel"] forState:UIControlStateHighlighted];
     [_quickenBtn setImage:[UIImage imageNamed:@"icon_gan_accelerate_sel"] forState:UIControlStateSelected];
    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"加速",nil)  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
    _quickenBtn.titleLabel.attributedText = string2;
    [_quickenBtn addTarget:self action:@selector(quickenPlay:) forControlEvents:UIControlEventTouchUpInside];
    [_quickenBtn setTitle:NSLocalizedString(@"加速",nil) forState:UIControlStateNormal];
    [self addSubview:_quickenBtn];
    
    _delBtn = [[UIButton alloc] init];
    _delBtn.backgroundColor = [UIColor colorWithRed:94/255.0 green:199/255.0 blue:254/255.0 alpha:1.0];
    [_delBtn setImage:[UIImage imageNamed:@"icon_gan_delete"] forState:UIControlStateNormal];
    [_delBtn addTarget:self action:@selector(delImage:) forControlEvents:UIControlEventTouchUpInside];
    _delBtn.layer.cornerRadius = 3;
    [self addSubview:_delBtn];
    
    [self addLayoutConstraint];
    self.imageArr = [NSMutableArray array];
}

-(void)addGesturesTo:(UIImageView *)imageView{
    imageView.userInteractionEnabled = YES;
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    self.tapGesture.delegate = self;
    [imageView addGestureRecognizer:self.tapGesture];
    
    self.longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongGesture:)];
    self.longGesture.delegate = self;
    self.longGesture.minimumPressDuration = 1.0;
    [imageView addGestureRecognizer:self.longGesture];
}

-(void)addLayoutConstraint{
    [_playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.right.equalTo(self).offset(-7);
        make.height.width.mas_equalTo(49);
    }];

    [_quickenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.playBtn.mas_bottom).offset(9);
        make.right.equalTo(self).offset(-7);
        make.height.width.mas_equalTo(49);
    }];
}

#pragma  mark ----  UI 交互  -----
-(void)delImage:(UIButton *)btn{
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:nil message:@"确定删除所选中的图片？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [cancleAction setValue:[UIColor colorWithRed:44/255.f green:46/255.f blue:48/255.f alpha:1] forKey:@"titleTextColor"];
    
    UIAlertAction *certainAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImageView *imageView = [self viewWithTag:tagType + _willDelIndex];
        [_imageArr removeObjectAtIndex:_willDelIndex];
        if (imageView == _selImageView || !_selImageView) {
            [self changeCurrentSel:0];
        }else{
            int _curentSel = (int)_selImageView.tag - tagType;
            if (_curentSel > _willDelIndex) {
                [self changeCurrentSel: _curentSel - 1];
            }else{
                [self changeCurrentSel:_curentSel];
            }
            
        }
        
        btn.hidden = YES;
    }];
    [certainAction setValue:[UIColor colorWithRed:134/255.f green:157/255.f blue:255/255.f alpha:1] forKey:@"titleTextColor"];
    
    [alertCon addAction:cancleAction];
    [alertCon addAction:certainAction];
    
    UIViewController *vc = [self findViewController:self];
    [vc presentViewController:alertCon animated:YES completion:^{
    }];
}

-(void)play:(UIButton *)btn{

    btn.selected = !btn.selected;
    if (btn.selected) {
        _quickenBtn.selected = NO;
    }
    
    if ( [self.delegate respondsToSelector:@selector(ganGifDidPlay)]) {
        [self.delegate ganGifDidPlay];
    }
   
}
-(void)quickenPlay:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        _playBtn.selected = NO;
    }
    if ( [self.delegate respondsToSelector:@selector(ganGifDidQuickenPlay)]) {
        [self.delegate ganGifDidQuickenPlay];
    }
    
}


#pragma  mark ----  手势事件  -----
-(void)handleTapGesture:(UITapGestureRecognizer *) panGesture{
    UIImageView *imageView = (UIImageView *)panGesture.view;
    int selIndex = (int)imageView.tag - tagType;
    if (selIndex < _imageArr.count) {//点击到图片
        self.selImageView = imageView;
        _selIndex = selIndex;
        [self changeImageView];
        if ([self.delegate respondsToSelector:@selector(ganGifDidSelOneImage)]) {
            [self.delegate ganGifDidSelOneImage];
        }
    }else if (selIndex == _imageArr.count){//点击了 ”+“
        if ([self.delegate respondsToSelector:@selector(ganGifDidClickAddImage)]) {
            [self.delegate ganGifDidClickAddImage];
        }
    }
}

-(void)handleLongGesture:(UILongPressGestureRecognizer *)longGesture{
    UIImageView *imageView = (UIImageView *)longGesture.view;
    _willDelIndex = (int)imageView.tag - tagType;
    
    if(_willDelIndex >= _imageArr.count || _imageArr.count == 1){
        return;
    }
    _delBtn.frame = CGRectMake(0, 0, imageView.bounds.size.width + 4, imageView.bounds.size.height + 4);
    _delBtn.center = imageView.center;
    _delBtn.hidden = NO;
}


-(void)dealloc{
    for (UIView *subView in self.subviews) {//移除所有手势
        if ([subView isKindOfClass:[UIImageView class]]) {
            for (UIGestureRecognizer *ges in subView.gestureRecognizers) {
                    [subView removeGestureRecognizer:ges];
            }
        }
    }
}

-(void)remGifImage:(UIImage *)image{

}

#pragma  mark ----  pulic  -----

-(void)addGifImage:(UIImage *)image{
    [_imageArr addObject:image];
    [self changeCurrentSel:(int)_imageArr.count - 1];
}

-(void)updataSelImage:(UIImage *)image{
    [_imageArr replaceObjectAtIndex:_selIndex withObject:image];
    self.selImageView.image = image;
}



-(void)changeImageView{
    for (int i = 0; i  < _imageArr.count; i++) {
        UIImageView *imageView = [self viewWithTag:tagType + i];
        imageView.image = _imageArr[i];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.alpha = 1.0;
        CAShapeLayer *bordLayer = [self getShapeLayerImageView:imageView];
        if (imageView == self.selImageView) {
            [bordLayer setStrokeColor:[UIColor colorWithRed:94/255.0 green:199/255.0 blue:254/255.0 alpha:1.0].CGColor];
        }else{
            [bordLayer setStrokeColor:[UIColor whiteColor].CGColor];
        }
    }
    for (int i = (int)_imageArr.count; i  < imageViewCount; i++) {
        UIImageView *imageView = [self viewWithTag:tagType + i];
        imageView.contentMode = UIViewContentModeCenter;
        if (i == (int)_imageArr.count) {
            imageView.image = [UIImage imageNamed:@"icon_gan_increase"];
            imageView.alpha = 1.0;
            CAShapeLayer *bordLayer = [self getShapeLayerImageView:imageView];
            [bordLayer setStrokeColor:[UIColor whiteColor].CGColor];
        }else{
            imageView.image = [UIImage imageNamed:@"icon_gan_dotted"];
            imageView.alpha = 0.4;
            CAShapeLayer *bordLayer = [self getShapeLayerImageView:imageView];
            [bordLayer setStrokeColor:[UIColor clearColor].CGColor];
        }
    }
}


-(void)changeCurrentSel:(int)index{
     UIImageView *imageView = [self viewWithTag:tagType + index];
    _selImageView = imageView;
    _selIndex = index;
    [self changeImageView];
    if ([self.delegate respondsToSelector:@selector(ganGifDidSelOneImage)]) {
        [self.delegate ganGifDidSelOneImage];
    }
}


-(CAShapeLayer *)getShapeLayerImageView:(UIImageView *)imageView{
    if (!imageView) {
        return nil;
    }
    for (CALayer *layer in imageView.layer.sublayers) {
        if ([layer isKindOfClass:[CAShapeLayer class]]) {
            return (CAShapeLayer *)layer;
        }
    }
    return nil;
}


-(void)setSelIndex:(int)selIndex{
    if (selIndex < _imageArr.count) {//点击到图片
        UIImageView *imageView = [self viewWithTag:tagType + selIndex];
        self.selImageView = imageView;
        _selIndex = selIndex;
        [self changeImageView];
        if ([self.delegate respondsToSelector:@selector(ganGifDidSelOneImage)]) {
            [self.delegate ganGifDidSelOneImage];
        }
    }
}

-(UIViewController *)findViewController:(UIView*)view{
    id responder = view;
    while (responder){
        if ([responder isKindOfClass:[UIViewController class]]){
            return responder;
        }
        responder = [responder nextResponder];
        
    }
    return nil;
    
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _delBtn.hidden = YES;
}


@end
