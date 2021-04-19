//
//  FUStickerSegmentsView.m
//  FULiveDemo
//
//  Created by 项林平 on 2021/3/19.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUStickerSegmentsView.h"

@interface FUStickerSegmentsView ()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, copy) NSArray<NSString *> *titlesArray;
@property (nonatomic, strong) FUStickerSegmentsConfigurations *configurations;
@property (nonatomic, strong) NSMutableArray<UIButton *> *titleButtons;
@property (nonatomic, assign) CGFloat contentWidth;
@property (nonatomic, strong) UIButton *selectedButton;

@end

@implementation FUStickerSegmentsConfigurations

@end

@implementation FUStickerSegmentsView

#pragma mark - Initializer
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *> *)titles configuration:(FUStickerSegmentsConfigurations *)configuration {
    self = [super initWithFrame:frame];
    if (self) {
        self.titlesArray = [titles copy];
        if (configuration) {
            [self refreshConfigurations:configuration];
        }
        [self setupContentView];
    }
    return self;
}

#pragma mark - UI
- (void)setupContentView {
    CGFloat frameWidth = CGRectGetWidth(self.frame);
    CGFloat frameHeight = CGRectGetHeight(self.frame);
    _contentWidth = 0;
    _contentWidth = self.configurations.itemWidth * self.titlesArray.count;
    if (_contentWidth < frameWidth) {
        self.scrollView.frame = CGRectMake((frameWidth - _contentWidth) / 2.0, 0, _contentWidth, frameHeight);
    } else {
        self.scrollView.frame = CGRectMake(0, 0, frameWidth, frameHeight);
    }
    self.scrollView.contentSize = CGSizeMake(_contentWidth, 0);
    
    [self addSubview:self.scrollView];
    
    __block CGFloat positionX = 0;
    [self.titlesArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        titleButton.tag = 1000 + idx;
        titleButton.frame = CGRectMake(positionX, 0, self.configurations.itemWidth, frameHeight);
        NSString *titleString = obj;
        // 处理多语言
        if ([obj componentsSeparatedByString:@"/"].count > 1) {
            NSArray *titles = [obj componentsSeparatedByString:@"/"];
            NSString *languageString = [[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"];
            titleString = [languageString isEqualToString:@"zh-Hans"] ? titles[0] : titles[1];
        }
        
        [titleButton setTitle:titleString forState:UIControlStateNormal];
        titleButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [titleButton addTarget:self action:@selector(titleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        if (idx == 0) {
            [titleButton setTitleColor:self.configurations.selectedColor forState:UIControlStateNormal];
            self.selectedButton = titleButton;
        } else {
            [titleButton setTitleColor:self.configurations.normalColor forState:UIControlStateNormal];
        }
        [self.titleButtons addObject:titleButton];
        [self.scrollView addSubview:titleButton];
        positionX += self.configurations.itemWidth;
    }];
}

#pragma mark - Instance method
- (void)selectSegmentItemWithIndex:(NSInteger)index {
    UIButton *targetButton = self.titleButtons[index];
    [self selectButton:targetButton];
}

#pragma mark - Private methods
- (void)refreshConfigurations:(FUStickerSegmentsConfigurations *)configuration {
    if (configuration.normalColor && configuration.normalColor != self.configurations.normalColor) {
        self.configurations.normalColor = configuration.normalColor;
    }
    if (configuration.selectedColor && configuration.selectedColor != self.configurations.selectedColor) {
        self.configurations.selectedColor = configuration.selectedColor;
    }
    if (configuration.itemWidth && configuration.itemWidth != self.configurations.itemWidth) {
        self.configurations.itemWidth = configuration.itemWidth;
    }
}

- (void)selectButton:(UIButton *)button {
    if (button == self.selectedButton) {
        return;
    }
    [self refreshButtonStatus:NO button:self.selectedButton];
    [self refreshButtonStatus:YES button:button];
    self.selectedButton = button;
}

- (void)refreshButtonStatus:(BOOL)isSelected button:(UIButton *)button {
    if (isSelected) {
        [button setTitleColor:self.configurations.selectedColor forState:UIControlStateNormal];
        [self setupSelectedButtonCenter:button];
    } else {
        [button setTitleColor:self.configurations.normalColor forState:UIControlStateNormal];
    }
}

/// 选中按钮居中显示
- (void)setupSelectedButtonCenter:(UIButton *)button {
    if (_contentWidth > CGRectGetWidth(self.frame)) {
        //偏移量
        CGFloat offsetX = button.center.x - CGRectGetWidth(self.frame) * 0.5;
        if (offsetX < 0) {
            offsetX = 0;
        }
        //最大滚动范围
        CGFloat maxOffsetX = self.scrollView.contentSize.width - CGRectGetWidth(self.frame);
        if (offsetX > maxOffsetX) {
            offsetX = maxOffsetX;
        }
        [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
}

#pragma mark - Event response
- (void)titleButtonAction:(UIButton *)button {
    [self selectButton:button];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(stickerSegmentsView:didSelectItemAtIndex:)]) {
        [self.delegate stickerSegmentsView:self didSelectItemAtIndex:button.tag - 1000];
    }
}

#pragma mark - Getters
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}
- (NSMutableArray<UIButton *> *)titleButtons {
    if (!_titleButtons) {
        _titleButtons = [[NSMutableArray alloc] init];
    }
    return _titleButtons;
}
- (FUStickerSegmentsConfigurations *)configurations {
    if (!_configurations) {
        _configurations = [[FUStickerSegmentsConfigurations alloc] init];
        _configurations.normalColor = [UIColor whiteColor];
        _configurations.selectedColor = [UIColor colorWithRed:94/255.0f green:199/255.0f blue:254/255.0f alpha:1.0];
        _configurations.itemWidth = 100;
    }
    return _configurations;
}


@end
