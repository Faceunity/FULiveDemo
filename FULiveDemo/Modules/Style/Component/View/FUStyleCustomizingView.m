//
//  FUStyleCustomizingView.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/11/7.
//

#import "FUStyleCustomizingView.h"
#import "FUCustomizeSkinView.h"
#import "FUCustomizeShapeView.h"

@interface FUStyleCustomizingView ()<FUSegmentBarDelegate>

@property (nonatomic, strong) FUSegmentBar *styleSegmentBar;
@property (nonatomic, strong) FUCustomizeSkinView *skinView;
@property (nonatomic, strong) FUCustomizeShapeView *shapeView;

@property (nonatomic, strong) FUStyleCustomizingViewModel *viewModel;

@end

@implementation FUStyleCustomizingView

#pragma mark - Initializer

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame viewModel:[[FUStyleCustomizingViewModel alloc] init]];
}

- (instancetype)initWithFrame:(CGRect)frame viewModel:(FUStyleCustomizingViewModel *)viewModel {
    self = [super initWithFrame:frame];
    if (self) {
        self.viewModel = viewModel;
        [self addSubview:self.styleSegmentBar];
        [self addSubview:self.skinView];
        [self addSubview:self.shapeView];
    }
    return self;
}

#pragma mark - Instance methods

- (void)refreshSubviews {
    [self.skinView refreshSubviews];
    [self.shapeView refreshSubviews];
}

- (void)show {
    self.hidden = NO;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.bounds));
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

#pragma mark - FUSegmentBarDelegate

- (void)segmentBar:(FUSegmentBar *)segmentBar didSelectItemAtIndex:(NSUInteger)index {
    if (index == 0) {
        self.skinView.hidden = NO;
        self.shapeView.hidden = YES;
    } else {
        self.skinView.hidden = YES;
        self.shapeView.hidden = NO;
    }
}

#pragma mark - Getters

- (FUSegmentBar *)styleSegmentBar {
    if (!_styleSegmentBar) {
        _styleSegmentBar = [[FUSegmentBar alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - FUHeightIncludeBottomSafeArea(49.f), CGRectGetWidth(self.frame), FUHeightIncludeBottomSafeArea(49.f)) titles:@[FULocalizedString(@"skin"), FULocalizedString(@"shape")] configuration:nil];
        _styleSegmentBar.delegate = self;
        [_styleSegmentBar selectItemAtIndex:self.viewModel.selectedSegmentIndex];
    }
    return _styleSegmentBar;
}

- (FUCustomizeSkinView *)skinView {
    if (!_skinView) {
        _skinView = [[FUCustomizeSkinView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 134) viewModel:self.viewModel.skinViewModel];
        _skinView.hidden = YES;
        @FUWeakify(self)
        _skinView.backHandler = ^{
            @FUStrongify(self)
            if (self.delegate && [self.delegate respondsToSelector:@selector(styleCustomizingViewDidClickBack)]) {
                [self.delegate styleCustomizingViewDidClickBack];
            }
        };
        _skinView.effectStatusChangeHander = ^(BOOL isDisabled) {
            @FUStrongify(self)
            self.viewModel.skinEffectDisabled = isDisabled;
        };
        _skinView.skinSegmentationStatusChangeHandler = ^(BOOL enabled) {
            @FUStrongify(self);
            self.viewModel.skinSegmentationEnabled = enabled;
        };
    }
    return _skinView;
}

- (FUCustomizeShapeView *)shapeView {
    if (!_shapeView) {
        _shapeView = [[FUCustomizeShapeView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 134) viewModel:self.viewModel.shapeViewModel];
        _shapeView.hidden = YES;
        @FUWeakify(self)
        _shapeView.backHandler = ^{
            @FUStrongify(self)
            if (self.delegate && [self.delegate respondsToSelector:@selector(styleCustomizingViewDidClickBack)]) {
                [self.delegate styleCustomizingViewDidClickBack];
            }
        };
        _shapeView.effectStatusChangeHander = ^(BOOL isDisabled) {
            @FUStrongify(self)
            self.viewModel.shapeEffectDisabled = isDisabled;
        };
    }
    return _shapeView;
}

@end
