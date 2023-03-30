//
//  FUCustomizeShapeView.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/7/8.
//

#import "FUCustomizeShapeView.h"

static NSString * const kFUCustomizeShapeCellIdentifier = @"FUCustomizeShapeCell";

@interface FUCustomizeShapeView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *shapeCollectionView;
/// 程度调节
@property (nonatomic, strong) FUSlider *slider;
/// 恢复按钮
@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UISwitch *effectSwitch;

@property (nonatomic, strong) UILabel *effectTipLabel;

@property (nonatomic, strong) FUCustomizeShapeViewModel *viewModel;

@end

@implementation FUCustomizeShapeView

#pragma mark - Initializer

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame viewModel:[[FUCustomizeShapeViewModel alloc] init]];
}

- (instancetype)initWithFrame:(CGRect)frame viewModel:(FUCustomizeShapeViewModel *)viewModel {
    self = [super initWithFrame:frame];
    if (self) {
        self.viewModel = viewModel;
        [self configureUI];
        [self refreshSubviews];
    }
    return self;
}

#pragma mark - UI

- (void)configureUI {
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    [self addSubview:effectView];
    
    [self addSubview:self.slider];
    
    [self addSubview:self.backButton];
    NSLayoutConstraint *backLeadingConstraint = [NSLayoutConstraint constraintWithItem:self.backButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:16];
    NSLayoutConstraint *backTopConstraint = [NSLayoutConstraint constraintWithItem:self.backButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:56];
    NSLayoutConstraint *backWidthConstraint = [NSLayoutConstraint constraintWithItem:self.backButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:24];
    NSLayoutConstraint *backHeightConstraint = [NSLayoutConstraint constraintWithItem:self.backButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:63];
    [self addConstraints:@[backLeadingConstraint, backTopConstraint]];
    [self.backButton addConstraints:@[backWidthConstraint, backHeightConstraint]];
    
    [self addSubview:self.effectSwitch];
    NSLayoutConstraint *effectLeadingConstraint = [NSLayoutConstraint constraintWithItem:self.effectSwitch attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.backButton attribute:NSLayoutAttributeTrailing multiplier:1 constant:25];
    NSLayoutConstraint *effectTopConstraint = [NSLayoutConstraint constraintWithItem:self.effectSwitch attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:62];
    [self addConstraints:@[effectLeadingConstraint, effectTopConstraint]];
    
    [self addSubview:self.effectTipLabel];
    NSLayoutConstraint *tipCenterXConstraint = [NSLayoutConstraint constraintWithItem:self.effectTipLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.effectSwitch attribute:NSLayoutAttributeCenterX multiplier:1 constant:2];
    NSLayoutConstraint *tipTopConstraint = [NSLayoutConstraint constraintWithItem:self.effectTipLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:104];
    NSLayoutConstraint *tipHeightConstraint = [NSLayoutConstraint constraintWithItem:self.effectTipLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:18];
    [self addConstraints:@[tipCenterXConstraint, tipTopConstraint]];
    [self.effectTipLabel addConstraint:tipHeightConstraint];
    
    // 分割线
    UIView *verticalLine = [[UIView alloc] init];
    verticalLine.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    verticalLine.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:verticalLine];
    NSLayoutConstraint *lineLeadingConstraint = [NSLayoutConstraint constraintWithItem:verticalLine attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.effectSwitch attribute:NSLayoutAttributeTrailing multiplier:1 constant:13];
    NSLayoutConstraint *lineTopConstraint = [NSLayoutConstraint constraintWithItem:verticalLine attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:68];
    NSLayoutConstraint *lineWidthConstraint = [NSLayoutConstraint constraintWithItem:verticalLine attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0.5];
    NSLayoutConstraint *lineHeightConstraint = [NSLayoutConstraint constraintWithItem:verticalLine attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:20];
    [self addConstraints:@[lineLeadingConstraint, lineTopConstraint]];
    [verticalLine addConstraints:@[lineWidthConstraint, lineHeightConstraint]];
    
    [self addSubview:self.shapeCollectionView];
    NSLayoutConstraint *collectionLeadingConstraint = [NSLayoutConstraint constraintWithItem:self.shapeCollectionView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:verticalLine attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    NSLayoutConstraint *collectionTrailingConstraint = [NSLayoutConstraint constraintWithItem:self.shapeCollectionView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    NSLayoutConstraint *collectionTopConstraint = [NSLayoutConstraint constraintWithItem:self.shapeCollectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:53];
    NSLayoutConstraint *collectionHeightConstraint = [NSLayoutConstraint constraintWithItem:self.shapeCollectionView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:78];
    [self addConstraints:@[collectionLeadingConstraint, collectionTrailingConstraint, collectionTopConstraint]];
    [self.shapeCollectionView addConstraint:collectionHeightConstraint];
}

- (void)refreshSubviews {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.slider.hidden = self.viewModel.selectedIndex < 0 || self.viewModel.isEffectDisabled;
        if (self.viewModel.selectedIndex >= 0) {
            self.slider.bidirection = [self.viewModel isDefaultValueInMiddleAtIndex:self.viewModel.selectedIndex];
            self.slider.value = [self.viewModel currentValueAtIndex:self.viewModel.selectedIndex];
        }
        self.effectSwitch.on = !self.viewModel.isEffectDisabled;
        self.effectTipLabel.text = self.viewModel.isEffectDisabled ? FULocalizedString(@"关闭") : FULocalizedString(@"开启");
        [self.shapeCollectionView reloadData];
        if (self.viewModel.selectedIndex >= 0) {
            [self.shapeCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:self.viewModel.selectedIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
    });
}

#pragma mark - Event response


- (void)sliderValueChanged {
    [self.viewModel setShapeValue:self.slider.value];
}

- (void)sliderChangeEnded {
    [self refreshSubviews];
}

- (void)backAction {
    if (self.backHandler) {
        self.backHandler();
    }
}

- (void)effectChanged {
    self.effectTipLabel.text = self.effectSwitch.isOn ? FULocalizedString(@"开启") : FULocalizedString(@"关闭");
    self.viewModel.effectDisabled = !self.effectSwitch.isOn;
    self.viewModel.selectedIndex = -1;
    !self.effectStatusChangeHander ?: self.effectStatusChangeHander(self.viewModel.effectDisabled);
    if (self.viewModel.effectDisabled) {
        [FUTipHUD showTips:FULocalizedString(@"turn_off_shape_effect_tips") dismissWithDelay:1.5];
    }
    [self refreshSubviews];
}

#pragma mark - Collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.shapes.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FUCustomizeShapeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFUCustomizeShapeCellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = FULocalizedString([self.viewModel nameAtIndex:indexPath.item]);
    cell.imageName = [self.viewModel nameAtIndex:indexPath.item];
    cell.defaultValue = [self.viewModel defaultValueAtIndex:indexPath.item];
    cell.currentValue = [self.viewModel currentValueAtIndex:indexPath.item];
    cell.defaultInMiddle = [self.viewModel isDefaultValueInMiddleAtIndex:indexPath.item];
    if (self.viewModel.isEffectDisabled) {
        // 直接禁用
        cell.disabled = YES;
    } else {
        // 处理低性能手机禁用特效
        if ([self.viewModel isDifferentiateDevicePerformanceAtIndex:indexPath.item]) {
            cell.disabled = self.viewModel.performanceLevel != FUDevicePerformanceLevelHigh;
        } else {
            cell.disabled = NO;
        }
    }
    cell.selected = indexPath.item == self.viewModel.selectedIndex;

    return cell;
}

#pragma mark - Collection view delegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BOOL should = YES;
    if (self.viewModel.isEffectDisabled) {
        should = NO;
    } else {
        if ([self.viewModel isDifferentiateDevicePerformanceAtIndex:indexPath.item]) {
            if (self.viewModel.performanceLevel != FUDevicePerformanceLevelHigh) {
                [FUTipHUD showTips:[NSString stringWithFormat:FULocalizedString(@"该功能只支持在高端机上使用"), FULocalizedString([self.viewModel nameAtIndex:indexPath.item])] dismissWithDelay:1];
                should = NO;
            }
        }
    }
    if (!should) {
        // 刷新视图
        [self.shapeCollectionView reloadData];
        if (self.viewModel.selectedIndex >= 0) {
            [self.shapeCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:self.viewModel.selectedIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
    }
    return should;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == self.viewModel.selectedIndex) {
        return;
    }
    self.viewModel.selectedIndex = indexPath.item;
    if (self.slider.hidden) {
        self.slider.hidden = NO;
    }
    self.slider.bidirection = [self.viewModel isDefaultValueInMiddleAtIndex:indexPath.item];
    self.slider.value = [self.viewModel currentValueAtIndex:indexPath.item];
}

#pragma mark - Getters

- (UICollectionView *)shapeCollectionView {
    if (!_shapeCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(44, 74);
        layout.minimumLineSpacing = 22;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(2, 12, 2, 12);
        _shapeCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _shapeCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
        _shapeCollectionView.backgroundColor = [UIColor clearColor];
        _shapeCollectionView.showsVerticalScrollIndicator = NO;
        _shapeCollectionView.showsHorizontalScrollIndicator = NO;
        _shapeCollectionView.dataSource = self;
        _shapeCollectionView.delegate = self;
        [_shapeCollectionView registerClass:[FUCustomizeShapeCell class] forCellWithReuseIdentifier:kFUCustomizeShapeCellIdentifier];
    }
    return _shapeCollectionView;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 63)];
        _backButton.layer.masksToBounds = YES;
        _backButton.layer.cornerRadius = 4.f;
        [_backButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:1 alpha:0.16]] forState:UIControlStateNormal];
        [_backButton setImage:[UIImage imageNamed:@"style_customizing_back"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        _backButton.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _backButton;
}

- (UISwitch *)effectSwitch {
    if (!_effectSwitch) {
        _effectSwitch = [[UISwitch alloc] init];
        _effectSwitch.thumbTintColor = [UIColor whiteColor];
        _effectSwitch.onTintColor = FUColorFromHex(0x5EC7FE);
        _effectSwitch.backgroundColor = [UIColor colorWithWhite:0 alpha:0.56];
        _effectSwitch.layer.cornerRadius = CGRectGetHeight(_effectSwitch.frame) / 2.f;
        _effectSwitch.transform = CGAffineTransformMakeScale(0.8, 0.8);
        _effectSwitch.translatesAutoresizingMaskIntoConstraints = NO;
        [_effectSwitch addTarget:self action:@selector(effectChanged) forControlEvents:UIControlEventValueChanged];
    }
    return _effectSwitch;
}

- (UILabel *)effectTipLabel {
    if (!_effectTipLabel) {
        _effectTipLabel = [[UILabel alloc] init];
        _effectTipLabel.textColor = [UIColor whiteColor];
        _effectTipLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightMedium];
        _effectTipLabel.text = FULocalizedString(@"开启");
        _effectTipLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _effectTipLabel;
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

@interface FUCustomizeShapeCell ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation FUCustomizeShapeCell

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
        NSLayoutConstraint *textLeading = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
        NSLayoutConstraint *textTrailing = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
        [self.contentView addConstraints:@[textTop, textLeading, textTrailing]];
        NSLayoutConstraint *textHeight = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:18];
        [self.contentView addConstraints:@[textTop, textLeading, textTrailing]];
    }
    return self;
}

- (void)setDisabled:(BOOL)disabled {
    _disabled = disabled;
    self.imageView.alpha = disabled ? 0.6 : 1;
    self.textLabel.alpha = disabled ? 0.6 : 1;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (self.disabled) {
        self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-0", self.imageName]];
        self.textLabel.textColor = [UIColor whiteColor];
    } else {
        BOOL changed = NO;
        if (self.defaultInMiddle) {
            changed = fabs(self.currentValue - 0.5) > 0.01;
        }else{
            changed = self.currentValue > 0.01;
        }
        if (selected) {
            self.imageView.image = changed ? [UIImage imageNamed:[NSString stringWithFormat:@"%@-3", self.imageName]] : [UIImage imageNamed:[NSString stringWithFormat:@"%@-2", self.imageName]];
            self.textLabel.textColor = [UIColor colorWithRed:94/255.f green:199/255.f blue:254/255.f alpha:1];
        } else {
            self.imageView.image = changed ? [UIImage imageNamed:[NSString stringWithFormat:@"%@-1", self.imageName]] : [UIImage imageNamed:[NSString stringWithFormat:@"%@-0", self.imageName]];
            self.textLabel.textColor = [UIColor whiteColor];
        }
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
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.adjustsFontSizeToFitWidth = YES;
        _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _textLabel;
}

@end

