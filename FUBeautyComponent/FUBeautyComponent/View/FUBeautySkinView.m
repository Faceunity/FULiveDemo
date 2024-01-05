//
//  FUBeautySkinView.m
//  FUBeautyComponent
//
//  Created by 项林平 on 2022/6/21.
//

#import "FUBeautySkinView.h"
#import "FUBeautyDefine.h"

#import <FUCommonUIComponent/FUCommonUIComponent.h>
#import <FURenderKit/UIDevice+FURenderKit.h>

static NSString * const kFUBeautySkinCellIdentifier = @"FUBeautySkinCell";

@interface FUBeautySkinView ()<UICollectionViewDataSource, UICollectionViewDelegate, FUSegmentedControlDelegate>

@property (nonatomic, strong) UICollectionView *skinCollectionView;
/// 程度调节
@property (nonatomic, strong) FUSlider *slider;
/// 皮肤分割控制
@property (nonatomic, strong) FUSegmentedControl *segmentedControl;
/// 恢复按钮
@property (nonatomic, strong) FUSquareButton *recoverButton;

@property (nonatomic, strong) FUBeautySkinViewModel *viewModel;

@end

@implementation FUBeautySkinView

#pragma mark - Initializer

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame viewModel:[[FUBeautySkinViewModel alloc] init]];
}

- (instancetype)initWithFrame:(CGRect)frame viewModel:(FUBeautySkinViewModel *)viewModel {
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
    
    [self addSubview:self.segmentedControl];
    
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
    
    [self addSubview:self.skinCollectionView];
    NSLayoutConstraint *collectionLeadingConstraint = [NSLayoutConstraint constraintWithItem:self.skinCollectionView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:76];
    NSLayoutConstraint *collectionTrailingConstraint = [NSLayoutConstraint constraintWithItem:self.skinCollectionView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    NSLayoutConstraint *collectionBottomConstraint = [NSLayoutConstraint constraintWithItem:self.skinCollectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *collectionHeightConstraint = [NSLayoutConstraint constraintWithItem:self.skinCollectionView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:98];
    [self addConstraints:@[collectionLeadingConstraint, collectionTrailingConstraint, collectionBottomConstraint]];
    [self.skinCollectionView addConstraint:collectionHeightConstraint];
}

- (void)refreshSubviews {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.segmentedControl.selectedIndex = self.viewModel.skinSegmentationEnabled ? 1 : 0;
        if (self.viewModel.isDefaultValue) {
            self.recoverButton.alpha = 0.6;
            self.recoverButton.userInteractionEnabled = NO;
        } else {
            self.recoverButton.alpha = 1;
            self.recoverButton.userInteractionEnabled = YES;
        }
        if (!self.slider.hidden && self.viewModel.selectedIndex >= 0) {
            self.slider.bidirection = self.viewModel.beautySkins[self.viewModel.selectedIndex].defaultValueInMiddle;
            self.slider.value = self.viewModel.beautySkins[self.viewModel.selectedIndex].currentValue / self.viewModel.beautySkins[self.viewModel.selectedIndex].ratio;
        }
        [self.skinCollectionView reloadData];
        if (self.viewModel.selectedIndex >= 0) {
            [self.skinCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:self.viewModel.selectedIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
    });
}

#pragma mark - Event response

- (void)recoverAction {
    [FUAlertManager showAlertWithTitle:nil message:FUBeautyStringWithKey(@"是否将所有参数恢复到默认值") cancel:FUBeautyStringWithKey(@"取消") confirm:FUBeautyStringWithKey(@"确定") inController:nil confirmHandler:^{
        [self.viewModel recoverAllSkinValuesToDefault];
        [self refreshSubviews];
    } cancelHandler:nil];
}

- (void)sliderValueChanged {
    [self.viewModel setSkinValue:self.slider.value];
}

- (void)sliderChangeEnded {
    [self refreshSubviews];
}

#pragma mark - FUSegmentedControlDelegate

- (BOOL)segmentedControlShouldSelectItemAtIndex:(NSUInteger)index {
    // 美白皮肤分割仅支持高端机
    if ([FURenderKit devicePerformanceLevel] < FUDevicePerformanceLevelExcellent && index == 1) {
        [FUTipHUD showTips:[NSString stringWithFormat:FUBeautyStringWithKey(@"功能仅支持iPhone11及以上机型使用"), FUBeautyStringWithKey(@"皮肤美白")] dismissWithDelay:1];
        [self.segmentedControl refreshUI];
        return NO;
    }
    return YES;
}

- (void)segmentedControlDidSelectAtIndex:(NSUInteger)index {
    self.viewModel.skinSegmentationEnabled = index == 1;
    [self refreshSubviews];
}

#pragma mark - Collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.beautySkins.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FUBeautySkinCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFUBeautySkinCellIdentifier forIndexPath:indexPath];
    FUBeautySkinModel *skin = self.viewModel.beautySkins[indexPath.item];
    cell.textLabel.text = FUBeautyStringWithKey(skin.name);
    cell.imageName = skin.name;
    cell.defaultInMiddle = skin.defaultValueInMiddle;
    cell.defaultValue = skin.defaultValue;
    cell.currentValue = skin.currentValue;
    // 判断特效设备性能等级要求是否高于当前设备性能等级
    FUDevicePerformanceLevel level = [FURenderKit devicePerformanceLevel];
    cell.disabled = skin.performanceLevel > level;
    cell.selected = indexPath.item == self.viewModel.selectedIndex;
    return cell;
}

#pragma mark - Collection view delegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FUBeautySkinCell *cell = (FUBeautySkinCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.disabled) {
        FUBeautySkinModel *skin = self.viewModel.beautySkins[indexPath.item];
        if (skin.performanceLevel == FUDevicePerformanceLevelVeryHigh) {
            [FUTipHUD showTips:[NSString stringWithFormat:FUBeautyStringWithKey(@"功能仅支持iPhoneXR及以上机型使用"), FUBeautyStringWithKey(skin.name)] dismissWithDelay:1];
            [self.skinCollectionView reloadData];
            if (self.viewModel.selectedIndex >= 0) {
                [self.skinCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:self.viewModel.selectedIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            }
        } else if (skin.performanceLevel == FUDevicePerformanceLevelHigh) {
            [FUTipHUD showTips:[NSString stringWithFormat:FUBeautyStringWithKey(@"该功能只支持在高端机上使用"), FUBeautyStringWithKey(skin.name)] dismissWithDelay:1];
            [self.skinCollectionView reloadData];
            if (self.viewModel.selectedIndex >= 0) {
                [self.skinCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:self.viewModel.selectedIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            }
        }
        return NO;
    }
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == self.viewModel.selectedIndex) {
        return;
    }
    self.viewModel.selectedIndex = indexPath.item;
    FUBeautySkinModel *skin = self.viewModel.beautySkins[indexPath.item];
    if (skin.type == FUBeautySkinColorLevel) {
        // 美白需要加入皮肤分割功能
        self.slider.frame = CGRectMake(112, 16, CGRectGetWidth(self.frame) - 128, FUBeautyFunctionSliderHeight);
        self.segmentedControl.hidden = NO;
    } else {
        self.segmentedControl.hidden = YES;
        self.slider.frame = CGRectMake(56, 16, CGRectGetWidth(self.frame) - 116, FUBeautyFunctionSliderHeight);
    }
    if (self.slider.hidden) {
        self.slider.hidden = NO;
    }
    self.slider.bidirection = skin.defaultValueInMiddle;
    self.slider.value = skin.currentValue / skin.ratio;
}

#pragma mark - Getters

- (UICollectionView *)skinCollectionView {
    if (!_skinCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(44, 74);
        layout.minimumLineSpacing = 22;
        layout.minimumInteritemSpacing = 22;
        layout.sectionInset = UIEdgeInsetsMake(16, 16, 6, 16);
        _skinCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _skinCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
        _skinCollectionView.backgroundColor = [UIColor clearColor];
        _skinCollectionView.showsVerticalScrollIndicator = NO;
        _skinCollectionView.showsHorizontalScrollIndicator = NO;
        _skinCollectionView.dataSource = self;
        _skinCollectionView.delegate = self;
        [_skinCollectionView registerClass:[FUBeautySkinCell class] forCellWithReuseIdentifier:kFUBeautySkinCellIdentifier];
    }
    return _skinCollectionView;
}

- (FUSegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[FUSegmentedControl alloc] initWithFrame:CGRectMake(16, 19, 80, 24) items:@[FUBeautyStringWithKey(@"全局"), FUBeautyStringWithKey(@"仅皮肤")]];
        _segmentedControl.titleColor = [UIColor colorWithWhite:1 alpha:0.45];
        _segmentedControl.selectedTitleColor = [UIColor colorWithRed:44/255.0 green:46/255.0 blue:48/255.0 alpha:1];
        _segmentedControl.titleFont = [UIFont systemFontOfSize:10];
        _segmentedControl.layer.masksToBounds = YES;
        _segmentedControl.layer.cornerRadius = 12;
        _segmentedControl.layer.borderWidth = 1;
        _segmentedControl.layer.borderColor = [UIColor whiteColor].CGColor;
        _segmentedControl.hidden = YES;
        _segmentedControl.delegate = self;
    }
    return _segmentedControl;
}

- (FUSquareButton *)recoverButton {
    if (!_recoverButton) {
        _recoverButton = [[FUSquareButton alloc] initWithFrame:CGRectMake(0, 0, 44, 74)];
        [_recoverButton setTitle:FUBeautyStringWithKey(@"恢复") forState:UIControlStateNormal];
        [_recoverButton setImage:FUBeautyImageNamed(@"recover_item") forState:UIControlStateNormal];
        _recoverButton.alpha = 0.6;
        _recoverButton.userInteractionEnabled = NO;
        [_recoverButton addTarget:self action:@selector(recoverAction) forControlEvents:UIControlEventTouchUpInside];
        _recoverButton.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _recoverButton;
}

-(FUSlider *)slider {
    if (!_slider) {
        _slider = [[FUSlider alloc] initWithFrame:CGRectMake(56, 16, CGRectGetWidth(self.frame) - 116, FUBeautyFunctionSliderHeight)];
        _slider.hidden = YES;
        [_slider addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];
        [_slider addTarget:self action:@selector(sliderChangeEnded) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    }
    return _slider;
}

@end

@interface FUBeautySkinCell ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation FUBeautySkinCell

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
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (self.disabled) {
        self.imageView.image = FUBeautyImageNamed([NSString stringWithFormat:@"%@-0", self.imageName]);
        self.imageView.alpha = 0.7;
        self.textLabel.alpha = 0.7;
    } else {
        self.imageView.alpha = 1;
        self.textLabel.alpha = 1;
        BOOL changed = NO;
        if (self.defaultInMiddle) {
            changed = fabs(self.currentValue - 0.5) > 0.01;
        }else{
            changed = self.currentValue > 0.01;
        }
        if (selected) {
            self.imageView.image = changed ? FUBeautyImageNamed([NSString stringWithFormat:@"%@-3", self.imageName]) : FUBeautyImageNamed([NSString stringWithFormat:@"%@-2", self.imageName]);
            self.textLabel.textColor = [UIColor colorWithRed:94/255.f green:199/255.f blue:254/255.f alpha:1];
        } else {
            self.imageView.image = changed ? FUBeautyImageNamed([NSString stringWithFormat:@"%@-1", self.imageName]) : FUBeautyImageNamed([NSString stringWithFormat:@"%@-0", self.imageName]);
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
