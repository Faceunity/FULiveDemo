//
//  FUGreenScreenColorPicker.m
//  FUGreenScreenComponent
//
//  Created by 项林平 on 2022/8/1.
//

#import "FUGreenScreenColorPicker.h"
#import "FUGreenScreenDefine.h"

@interface FUGreenScreenColorPicker ()

@property (nonatomic, strong) UIView *preview;
@property (nonatomic, strong) UIImageView *anchorImageView;

@end

@implementation FUGreenScreenColorPicker {
    // 拖动次数
    NSInteger panCount;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 固定图片
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.preview.frame];
        imageView.image = FUGreenScreenImageNamed(@"demo_bg_transparent");
        [self addSubview:imageView];
        
        // 预览颜色视图
        [self addSubview:self.preview];
        
        // 取色锚点
        [self addSubview:self.anchorImageView];
        
        // 拖动手势
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

- (void)refreshPickerColor:(UIColor *)color {
    self.preview.backgroundColor = color;
}

- (void)panAction:(UIPanGestureRecognizer *)pan {
    UIView *superView = pan.view.superview;
    // 在父视图中的偏移量
    CGPoint translationPoint = [pan translationInView:superView];
    // 拖动后的中心点
    CGPoint center = CGPointMake(pan.view.center.x + translationPoint.x, pan.view.center.y + translationPoint.y);
    // 锚点相对于父视图的位置
    CGPoint anchorCenter = [self convertPoint:self.anchorImageView.center toView:superView];
    if (pan.state == UIGestureRecognizerStateBegan) {
        // 为了方便，拖动开始默认往上移动40
        CGRect rect = self.frame;
        rect.origin.y -= 40;
        self.frame = rect;
    } else if (pan.state == UIGestureRecognizerStateEnded) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(colorPickerDidEndPickingAtPoint:)]) {
            [self.delegate colorPickerDidEndPickingAtPoint:anchorCenter];
        }
    } else {
        if (!CGRectContainsPoint(superView.bounds, center)) {
            // 拖动到父视图外忽略
            return;
        }
        // 更新视图位置
        [pan setTranslation:CGPointZero inView:superView];
        pan.view.center = center;
        panCount += 1;
        if (panCount % 4 == 0) {
            // 减少触发频率
            if (self.delegate && [self.delegate respondsToSelector:@selector(colorPickerDidChangePoint:)]) {
                [self.delegate colorPickerDidChangePoint:anchorCenter];
            }
        }
    }
}

- (UIView *)preview {
    if (!_preview) {
        _preview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
        _preview.layer.masksToBounds = YES;
        _preview.layer.cornerRadius = 18.f;
        _preview.layer.borderWidth = 2;
        _preview.layer.borderColor = [UIColor whiteColor].CGColor;
        _preview.layer.backgroundColor = [UIColor clearColor].CGColor;
        _preview.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.2].CGColor;
        _preview.layer.shadowOffset = CGSizeMake(0,0);
        _preview.layer.shadowOpacity = 1;
        _preview.layer.shadowRadius = 3;
    }
    return _preview;
}

- (UIImageView *)anchorImageView {
    if (!_anchorImageView) {
        _anchorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, CGRectGetHeight(self.frame) - 20, 20, 20)];
        _anchorImageView.image = FUGreenScreenImageNamed(@"aiming_point");
    }
    return _anchorImageView;
}

@end
