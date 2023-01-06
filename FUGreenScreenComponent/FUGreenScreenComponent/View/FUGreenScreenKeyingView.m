//
//  FUGreenScreenKeyingView.m
//  FUGreenScreenComponent
//
//  Created by 项林平 on 2022/8/1.
//

#import "FUGreenScreenKeyingView.h"
#import "FUGreenScreenDefine.h"

#import <FUCommonUIComponent/FUCommonUIComponent.h>

@interface FUGreenScreenKeyingView ()<UICollectionViewDataSource, UICollectionViewDelegate>

/// 关键颜色选择列表
@property (nonatomic, strong) UICollectionView *colorCollectionView;
/// 抠像功能列表
@property (nonatomic, strong) UICollectionView *keyingCollectionView;
/// 抠像功能程度调节
@property (nonatomic, strong) FUSlider *slider;
/// 恢复默认按钮
@property (nonatomic, strong) FUSquareButton *recoverButton;

@property (nonatomic, strong) FUGreenScreenKeyingViewModel *viewModel;

@end

static NSString * const kFUGreenScreenKeyingCellIdentifier = @"FUGreenScreenKeyingCell";
static NSString * const kFUGreenScreenColorCellIdentifier = @"FUGreenScreenColorCell";

@implementation FUGreenScreenKeyingView

- (instancetype)initWithFrame:(CGRect)frame viewModel:(FUGreenScreenKeyingViewModel *)viewModel {
    self = [super initWithFrame:frame];
    if (self) {
        self.viewModel = viewModel;
        
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        [self addSubview:effectView];
        
        [self addSubview:self.slider];
        [self addSubview:self.recoverButton];
        NSLayoutConstraint *recoverLeadingConstraint = [NSLayoutConstraint constraintWithItem:self.recoverButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:17];
        NSLayoutConstraint *recoverBottomConstraint = [NSLayoutConstraint constraintWithItem:self.recoverButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-6];
        NSLayoutConstraint *recoverWidthConstraint = [NSLayoutConstraint constraintWithItem:self.recoverButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44];
        NSLayoutConstraint *recoverHeightConstraint = [NSLayoutConstraint constraintWithItem:self.recoverButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:74];
        
        [self addConstraints:@[recoverLeadingConstraint, recoverBottomConstraint]];
        [self.recoverButton addConstraints:@[recoverWidthConstraint, recoverHeightConstraint]];
        
        // 分割线
        UIView *verticalLine = [[UIView alloc] init];
        verticalLine.backgroundColor = [UIColor colorWithRed:229/255.f green:229/255.f blue:229/255.f alpha:0.2];
        verticalLine.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:verticalLine];
        NSLayoutConstraint *lineLeadingConstraint = [NSLayoutConstraint constraintWithItem:verticalLine attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.recoverButton attribute:NSLayoutAttributeTrailing multiplier:1 constant:14];
        NSLayoutConstraint *lineCenterYConstraint = [NSLayoutConstraint constraintWithItem:verticalLine attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.recoverButton attribute:NSLayoutAttributeCenterY multiplier:1 constant:-15];
        NSLayoutConstraint *lineWidthConstraint = [NSLayoutConstraint constraintWithItem:verticalLine attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:1];
        NSLayoutConstraint *lineHeightConstraint = [NSLayoutConstraint constraintWithItem:verticalLine attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:24];
        [self addConstraints:@[lineLeadingConstraint, lineCenterYConstraint]];
        [verticalLine addConstraints:@[lineWidthConstraint, lineHeightConstraint]];
        
        [self addSubview:self.keyingCollectionView];
        NSLayoutConstraint *collectionLeadingConstraint = [NSLayoutConstraint constraintWithItem:self.keyingCollectionView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:76];
        NSLayoutConstraint *collectionTrailingConstraint = [NSLayoutConstraint constraintWithItem:self.keyingCollectionView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
        NSLayoutConstraint *collectionBottomConstraint = [NSLayoutConstraint constraintWithItem:self.keyingCollectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        NSLayoutConstraint *collectionHeightConstraint = [NSLayoutConstraint constraintWithItem:self.keyingCollectionView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:98];
        [self addConstraints:@[collectionLeadingConstraint, collectionTrailingConstraint, collectionBottomConstraint]];
        [self.keyingCollectionView addConstraint:collectionHeightConstraint];
        
        [self addSubview:self.colorCollectionView];
        NSLayoutConstraint *colorCollectionLeadingConstraint = [NSLayoutConstraint constraintWithItem:self.colorCollectionView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
        NSLayoutConstraint *colorCollectionTrailingConstraint = [NSLayoutConstraint constraintWithItem:self.colorCollectionView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
        NSLayoutConstraint *colorCollectionBottomConstraint = [NSLayoutConstraint constraintWithItem:self.colorCollectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.keyingCollectionView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        NSLayoutConstraint *colorCollectionHeightConstraint = [NSLayoutConstraint constraintWithItem:self.colorCollectionView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:36];
        [self addConstraints:@[colorCollectionLeadingConstraint, colorCollectionTrailingConstraint, colorCollectionBottomConstraint]];
        [self.colorCollectionView addConstraint:colorCollectionHeightConstraint];
        
        [self refreshSubviews];
    }
    return self;
}

- (void)refreshSubviews {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self refreshRecoverButtonState];
        if (self.viewModel.selectedIndex == FUGreenScreenKeyingTypeColor) {
            self.colorCollectionView.hidden = NO;
            self.slider.hidden = YES;
        } else if (self.viewModel.selectedIndex >= FUGreenScreenKeyingTypeChromaThres && self.viewModel.selectedIndex < FUGreenScreenKeyingTypeSafeArea) {
            self.colorCollectionView.hidden = YES;
            self.slider.hidden = NO;
            self.slider.value = self.viewModel.selectedValue;
        }
        [self refreshKeyingCollectionView];
        if (self.viewModel.selectedColorIndex >= 0) {
            // 关键颜色视图更新
            [self.colorCollectionView reloadData];
            [self.colorCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:self.viewModel.selectedColorIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
    });
}

- (void)refreshKeyingCollectionView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.keyingCollectionView reloadData];
        if (self.viewModel.selectedIndex >= FUGreenScreenKeyingTypeColor && self.viewModel.selectedIndex < FUGreenScreenKeyingTypeSafeArea) {
            // 抠像视图更新
            [self.keyingCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:self.viewModel.selectedIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
    });
}

- (void)refreshRecoverButtonState {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.viewModel.isDefaultValue) {
            self.recoverButton.alpha = 0.6;
            self.recoverButton.userInteractionEnabled = NO;
        } else {
            self.recoverButton.alpha = 1;
            self.recoverButton.userInteractionEnabled = YES;
        }
    });
}

#pragma mark - Instance methods

- (void)refreshPickerColor:(UIColor *)color {
    FUGreenScreenColorCell *cell = (FUGreenScreenColorCell *)[self.colorCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    cell.imageView.backgroundColor = color;
}

#pragma mark - Event response

- (void)recoverAction {
    [FUAlertManager showAlertWithTitle:nil message:FUGreenScreenStringWithKey(@"是否将所有参数恢复到默认值") cancel:FUGreenScreenStringWithKey(@"取消") confirm:FUGreenScreenStringWithKey(@"确定") inController:nil confirmHandler:^{
        [self.viewModel recoverToDefault];
        [self refreshSubviews];
        if (self.delegate && [self.delegate respondsToSelector:@selector(keyingViewDidRecoverToDefault)]) {
            [self.delegate keyingViewDidRecoverToDefault];
        }
    } cancelHandler:nil];
}

- (void)sliderValueChanged {
    self.viewModel.selectedValue = self.slider.value;
}

- (void)sliderChangeEnded {
    [self refreshSubviews];
}

#pragma mark - Collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.keyingCollectionView) {
        return self.viewModel.keyingArray.count;
    } else {
        return self.viewModel.keyColorArray.count;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.keyingCollectionView) {
        FUGreenScreenKeyingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFUGreenScreenKeyingCellIdentifier forIndexPath:indexPath];
        cell.textLabel.text = [self.viewModel keyingNameAtIndex:indexPath.item];
        cell.imageName = [self.viewModel keyingImageNameAtIndex:indexPath.item];
        cell.defaultValue = [self.viewModel keyingDefaultValueAtIndex:indexPath.item];
        cell.currentValue = [self.viewModel keyingCurrentValueAtIndex:indexPath.item];
        cell.selected = indexPath.item == self.viewModel.selectedIndex;
        return cell;
    } else {
        FUGreenScreenColorCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFUGreenScreenColorCellIdentifier forIndexPath:indexPath];
        cell.imageView.backgroundColor = self.viewModel.keyColorArray[indexPath.item];
        cell.backgroundImageView.hidden = indexPath.item != 0;
        // 处理自定义取色cell未选中时展示取色icon，选中时隐藏取色icon的情况
        cell.pickerColorImage = indexPath.item == 0 ? [UIImage imageNamed:@"demo_icon_straw"] : nil;
        BOOL cellSelected = indexPath.item == self.viewModel.selectedColorIndex;
        if (indexPath.item == 0 && !cellSelected) {
            cell.imageView.image = [UIImage imageNamed:@"demo_icon_straw"];
        } else {
            cell.imageView.image = nil;
        }
        cell.selected = cellSelected;
        return cell;
    }
}

#pragma mark - Collection view delegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.keyingCollectionView && indexPath.item == FUGreenScreenKeyingTypeSafeArea) {
        // 安全区域需要切换视图
        [FUTipHUD showTips:FUGreenScreenStringWithKey(@"白色区域为安全区域，不参与绿幕抠像")];
        if (self.delegate && [self.delegate respondsToSelector:@selector(keyingViewDidSelectSafeArea)]) {
            [self.delegate keyingViewDidSelectSafeArea];
        }
        return NO;
    }
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.keyingCollectionView) {
        if (indexPath.item == self.viewModel.selectedIndex) {
            return;
        }
        self.viewModel.selectedIndex = indexPath.item;
        if (self.viewModel.selectedIndex > FUGreenScreenKeyingTypeColor) {
            self.colorCollectionView.hidden = YES;
            self.slider.hidden = NO;
            self.slider.value = self.viewModel.selectedValue;
        } else {
            self.colorCollectionView.hidden = NO;
            self.slider.hidden = YES;
        }
    } else {
        [self.viewModel recoverCustomizedKeyColor];
        self.viewModel.selectedColorIndex = indexPath.item;
        if (indexPath.item == 0) {
            // 锚点取色
            if (self.delegate && [self.delegate respondsToSelector:@selector(keyingViewRequiresPickColor:)]) {
                [self.delegate keyingViewRequiresPickColor:YES];
            }
        } else {
            // 选择固定颜色
            if (self.delegate && [self.delegate respondsToSelector:@selector(keyingViewRequiresPickColor:)]) {
                [self.delegate keyingViewRequiresPickColor:NO];
            }
        }
        [self refreshSubviews];
        [self refreshRecoverButtonState];
    }
}

#pragma mark - Getters

- (UICollectionView *)keyingCollectionView {
    if (!_keyingCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(44, 74);
        layout.minimumLineSpacing = 22;
        layout.minimumInteritemSpacing = 22;
        layout.sectionInset = UIEdgeInsetsMake(16, 16, 6, 16);
        _keyingCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _keyingCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
        _keyingCollectionView.backgroundColor = [UIColor clearColor];
        _keyingCollectionView.showsVerticalScrollIndicator = NO;
        _keyingCollectionView.showsHorizontalScrollIndicator = NO;
        _keyingCollectionView.dataSource = self;
        _keyingCollectionView.delegate = self;
        [_keyingCollectionView registerClass:[FUGreenScreenKeyingCell class] forCellWithReuseIdentifier:kFUGreenScreenKeyingCellIdentifier];
    }
    return _keyingCollectionView;
}

- (UICollectionView *)colorCollectionView {
    if (!_colorCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 16;
        layout.itemSize = CGSizeMake(28, 28);
        layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
        _colorCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _colorCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
        _colorCollectionView.backgroundColor = [UIColor clearColor];
        _colorCollectionView.showsVerticalScrollIndicator = NO;
        _colorCollectionView.showsHorizontalScrollIndicator = NO;
        _colorCollectionView.dataSource = self;
        _colorCollectionView.delegate = self;
        [_colorCollectionView registerClass:[FUGreenScreenColorCell class] forCellWithReuseIdentifier:kFUGreenScreenColorCellIdentifier];
        _colorCollectionView.hidden = YES;
    }
    return _colorCollectionView;
}

- (FUSquareButton *)recoverButton {
    if (!_recoverButton) {
        _recoverButton = [[FUSquareButton alloc] initWithFrame:CGRectMake(0, 0, 44, 74)];
        [_recoverButton setTitle:FUGreenScreenStringWithKey(@"恢复") forState:UIControlStateNormal];
        [_recoverButton setImage:[UIImage imageNamed:@"demo_icon_recover"] forState:UIControlStateNormal];
        _recoverButton.alpha = 0.6;
        _recoverButton.userInteractionEnabled = NO;
        [_recoverButton addTarget:self action:@selector(recoverAction) forControlEvents:UIControlEventTouchUpInside];
        _recoverButton.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _recoverButton;
}

-(FUSlider *)slider {
    if (!_slider) {
        _slider = [[FUSlider alloc] initWithFrame:CGRectMake(56, 16, CGRectGetWidth(self.frame) - 116, 30)];
        _slider.hidden = YES;
        [_slider addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];
        [_slider addTarget:self action:@selector(sliderChangeEnded) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    }
    return _slider;
}

@end

@interface FUGreenScreenKeyingCell ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation FUGreenScreenKeyingCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
        NSLayoutConstraint *imageTop = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        NSLayoutConstraint *imageLeading = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
        NSLayoutConstraint *imageTrailing = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
        NSLayoutConstraint *imageHeight = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
        [self.contentView addConstraints:@[imageTop, imageLeading, imageTrailing]];
        [self.imageView addConstraint:imageHeight];
        
        [self.contentView addSubview:self.textLabel];
        NSLayoutConstraint *textTop = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute:NSLayoutAttributeBottom multiplier:1 constant:7];
        
        NSLayoutConstraint *textCenterX = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        [self.contentView addConstraints:@[textTop, textCenterX]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    BOOL changed = self.currentValue > 0.01;
    if (selected) {
        self.imageView.image = changed ? [UIImage imageNamed:[NSString stringWithFormat:@"%@_sel_open", self.imageName]] : [UIImage imageNamed:[NSString stringWithFormat:@"%@_sel", self.imageName]];
        self.textLabel.textColor = [UIColor colorWithRed:94/255.f green:199/255.f blue:254/255.f alpha:1];
    } else {
        self.imageView.image = changed ? [UIImage imageNamed:[NSString stringWithFormat:@"%@_nor_open", self.imageName]] : [UIImage imageNamed:[NSString stringWithFormat:@"%@_nor", self.imageName]];
        self.textLabel.textColor = [UIColor whiteColor];
    }
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _imageView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:10];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _textLabel;
}

@end

@interface FUGreenScreenColorCell ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation FUGreenScreenColorCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.backgroundImageView];
        [self.contentView addSubview:self.imageView];
        
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius = CGRectGetWidth(frame) / 2.0;
        self.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.imageView.image = nil;
        self.contentView.layer.borderWidth = 2;
        [UIView animateWithDuration:0.25 animations:^{
            self.imageView.transform = CGAffineTransformMakeScale(0.7, 0.7);
            if (!self.backgroundImageView.hidden) {
                self.backgroundImageView.transform = CGAffineTransformMakeScale(0.7, 0.7);
            }
        }];
    } else {
        if (self.pickerColorImage) {
            self.imageView.image = self.pickerColorImage;
        }
        self.contentView.layer.borderWidth = 0;
        self.imageView.transform = CGAffineTransformIdentity;
        if (!self.backgroundImageView.hidden) {
            self.backgroundImageView.transform = CGAffineTransformIdentity;
        }
    }
}

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, CGRectGetWidth(self.frame) - 2, CGRectGetHeight(self.frame) - 2)];
        _backgroundImageView.image = [UIImage imageNamed:@"demo_bg_transparent"];
        _backgroundImageView.layer.cornerRadius = CGRectGetWidth(_backgroundImageView.frame) / 2.0;
    }
    return _backgroundImageView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius = CGRectGetWidth(_imageView.frame) / 2.0;
    }
    return _imageView;
}

@end
