//
//  FUStyleListView.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/11/7.
//

#import "FUStyleListView.h"

static NSString * const kFUStyleCellIdentifierKey = @"FUStyleCellIdentifier";

@interface FUStyleListView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) FUSlider *slider;
@property (nonatomic, strong) FUStyleFunctionButton *filterButton;
@property (nonatomic, strong) FUStyleFunctionButton *makeupButton;
@property (nonatomic, strong) UICollectionView *stylesCollectionView;

@property (nonatomic, strong) FUStyleListViewModel *viewModel;

@end

@implementation FUStyleListView

#pragma mark - Initializer

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame viewModel:[[FUStyleListViewModel alloc] init]];
}

- (instancetype)initWithFrame:(CGRect)frame viewModel:(FUStyleListViewModel *)viewModel {
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
    // 毛玻璃效果
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    [self addSubview:effectView];
    
    [self addSubview:self.filterButton];
    [self.filterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading).mas_offset(12);
        make.top.equalTo(self.mas_top).mas_offset(12);
        make.size.mas_offset(CGSizeMake(40, 32));
    }];
    
    [self addSubview:self.makeupButton];
    [self.makeupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.filterButton.mas_trailing).mas_offset(8);
        make.top.equalTo(self.mas_top).mas_offset(12);
        make.size.mas_offset(CGSizeMake(40, 32));
    }];
    
    [self addSubview:self.slider];
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading).mas_offset(112);
        make.trailing.equalTo(self.mas_trailing).mas_offset(-16);
        make.top.equalTo(self.mas_top).mas_offset(13);
        make.height.mas_offset(30);
    }];
    
    [self addSubview:self.stylesCollectionView];
    [self.stylesCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.top.equalTo(self.mas_top).mas_offset(56);
        make.height.mas_offset(86);
    }];
}

#pragma mark - Instance methods

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

- (void)refreshSubviews {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.viewModel.selectedIndex == 0) {
            [self hideFunctionViews];
        } else {
            [self showFunctionViews];
        }
        if (self.viewModel.selectedStyleFunction == FUStyleFunctionFilter) {
            self.filterButton.selected = YES;
            self.makeupButton.selected = NO;
        } else {
            self.filterButton.selected = NO;
            self.makeupButton.selected = YES;
        }
        [self.stylesCollectionView reloadData];
        [self.stylesCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:self.viewModel.selectedIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    });
}

#pragma mark - Action

- (void)sliderValueChanged {
    if (self.viewModel.selectedStyleFunction == FUStyleFunctionMakeup) {
        self.viewModel.selectedMakeupValue = self.slider.value;
    } else {
        self.viewModel.selectedMakeupFilterValue = self.slider.value;
    }
}

- (void)sliderChangeEnded {
    if (self.delegate && [self.delegate respondsToSelector:@selector(styleListViewFunctionValueDidChanged)]) {
        [self.delegate styleListViewFunctionValueDidChanged];
    }
}

- (void)filterAction {
    if (!self.filterButton.selected) {
        self.makeupButton.selected = NO;
        self.filterButton.selected = YES;
        self.viewModel.selectedStyleFunction = FUStyleFunctionFilter;
        [self updateSliderValue];
    }
}

- (void)makeupAction {
    if (!self.makeupButton.selected) {
        self.makeupButton.selected = YES;
        self.filterButton.selected = NO;
        self.viewModel.selectedStyleFunction = FUStyleFunctionMakeup;
        [self updateSliderValue];
    }
}

#pragma mark - Private methods

- (void)showFunctionViews {
    self.makeupButton.hidden = NO;
    self.filterButton.hidden = NO;
    self.slider.hidden = NO;
    [self updateSliderValue];
}

- (void)hideFunctionViews {
    self.makeupButton.hidden = YES;
    self.filterButton.hidden = YES;
    self.slider.hidden = YES;
}

- (void)updateSliderValue {
    self.slider.value = self.viewModel.selectedStyleFunction == FUStyleFunctionFilter ? self.viewModel.selectedMakeupFilterValue : self.viewModel.selectedMakeupValue;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.styles.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FUStyleListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFUStyleCellIdentifierKey forIndexPath:indexPath];
    cell.textLabel.text = FULocalizedString([self.viewModel styleNameAtIndex:indexPath.item]);
    cell.imageView.image = [UIImage imageNamed:[self.viewModel styleNameAtIndex:indexPath.item]];
    cell.cancelStyle = indexPath.item == 0;
    cell.customizeHandler = ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(styleListViewDidClickCustomizingAtIndex:)]) {
            [self.delegate styleListViewDidClickCustomizingAtIndex:indexPath.item];
        }
    };
    cell.selected = indexPath.item == self.viewModel.selectedIndex;
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == self.viewModel.selectedIndex) {
        return;
    }
    self.userInteractionEnabled = NO;
    FUStyleListCell *cell = (FUStyleListCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell.indicatorView startAnimating];
    [self.viewModel selectStyleAtIndex:indexPath.item completion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.userInteractionEnabled = YES;
            [cell.indicatorView stopAnimating];
            if (indexPath.item == 0) {
                [self hideFunctionViews];
            } else {
                [self showFunctionViews];
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(styleListViewDisSelectStyleAtIndex:)]) {
                [self.delegate styleListViewDisSelectStyleAtIndex:indexPath.item];
            }
        });
    }];
}

#pragma mark - Getters

- (FUSlider *)slider {
    if (!_slider) {
        _slider = [[FUSlider alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame) - 128, 30)];
        _slider.hidden = YES;
        [_slider addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];
        [_slider addTarget:self action:@selector(sliderChangeEnded) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    }
    return _slider;
}

- (FUStyleFunctionButton *)filterButton {
    if (!_filterButton) {
        _filterButton = [[FUStyleFunctionButton alloc] initWithFrame:CGRectMake(0, 0, 40, 32)];
        [_filterButton setTitle:FULocalizedString(@"滤镜") forState:UIControlStateNormal];
        [_filterButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.6] forState:UIControlStateNormal];
        [_filterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        _filterButton.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        _filterButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _filterButton.hidden = YES;
        [_filterButton addTarget:self action:@selector(filterAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _filterButton;
}

- (FUStyleFunctionButton *)makeupButton {
    if (!_makeupButton) {
        _makeupButton = [[FUStyleFunctionButton alloc] initWithFrame:CGRectMake(0, 0, 40, 32)];
        [_makeupButton setTitle:FULocalizedString(@"妆容") forState:UIControlStateNormal];
        [_makeupButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.6] forState:UIControlStateNormal];
        [_makeupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        _makeupButton.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        _makeupButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _makeupButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        _makeupButton.hidden = YES;
        [_makeupButton addTarget:self action:@selector(makeupAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _makeupButton;
}

- (UICollectionView *)stylesCollectionView {
    if (!_stylesCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(54, 86);
        layout.minimumInteritemSpacing = 12;
        layout.sectionInset = UIEdgeInsetsMake(0, 16, 0, 16);
        _stylesCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _stylesCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
        _stylesCollectionView.backgroundColor = [UIColor clearColor];
        _stylesCollectionView.showsHorizontalScrollIndicator = NO;
        _stylesCollectionView.dataSource = self;
        _stylesCollectionView.delegate = self;
        [_stylesCollectionView registerClass:[FUStyleListCell class] forCellWithReuseIdentifier:kFUStyleCellIdentifierKey];
    }
    return _stylesCollectionView;
}

@end

@interface FUStyleListCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
/// 自定义按钮
@property (nonatomic, strong) UIButton *customButton;

@end

@implementation FUStyleListCell

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
        NSLayoutConstraint *textTop = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute:NSLayoutAttributeBottom multiplier:1 constant:4];
        NSLayoutConstraint *textLeading = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
        NSLayoutConstraint *textTrailing = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
        NSLayoutConstraint *textHeight = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:20];
        [self.textLabel addConstraint:textHeight];
        [self.contentView addConstraints:@[textTop, textLeading, textTrailing]];
        
        [self.contentView addSubview:self.customButton];
        NSLayoutConstraint *customWidth = [NSLayoutConstraint constraintWithItem:self.customButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute:NSLayoutAttributeWidth multiplier:1 constant:-5];
        NSLayoutConstraint *customHeight = [NSLayoutConstraint constraintWithItem:self.customButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute:NSLayoutAttributeHeight multiplier:1 constant:-5];
        NSLayoutConstraint *customCenterX = [NSLayoutConstraint constraintWithItem:self.customButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        NSLayoutConstraint *customCenterY = [NSLayoutConstraint constraintWithItem:self.customButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
        [self.contentView addConstraints:@[customWidth, customHeight, customCenterX, customCenterY]];
        
        [self.contentView addSubview:self.indicatorView];
        NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:self.indicatorView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
        NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:self.indicatorView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        [self.contentView addConstraints:@[centerXConstraint, centerYConstraint]];
    }
    return self;
}

- (void)customizeAction {
    if (self.customizeHandler) {
        self.customizeHandler();
    }
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    self.imageView.layer.borderWidth = selected ? 2.5 : 0;
    self.imageView.layer.borderColor = selected ? [UIColor colorWithRed:94/255.0 green:199/255.0 blue:254/255.0 alpha:1].CGColor : [UIColor clearColor].CGColor;
    self.textLabel.textColor = selected ? [UIColor colorWithRed:94/255.0 green:199/255.0 blue:254/255.0 alpha:1] : [UIColor whiteColor];
    self.customButton.hidden = self.cancelStyle ? YES : !selected;
    
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius = 2.5f;
    }
    return _imageView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightMedium];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.adjustsFontSizeToFitWidth = YES;
        _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _textLabel;
}

- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _indicatorView.hidden = YES;
        _indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _indicatorView;
}

- (UIButton *)customButton {
    if (!_customButton) {
        _customButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _customButton.translatesAutoresizingMaskIntoConstraints = NO;
        _customButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [_customButton setImage:[UIImage imageNamed:@"style_edit"] forState:UIControlStateNormal];
        _customButton.hidden = YES;
        [_customButton addTarget:self action:@selector(customizeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _customButton;
}

@end

@interface FUStyleFunctionButton ()

@property (nonatomic, strong) UIView *selectedTipView;

@end

@implementation FUStyleFunctionButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.selectedTipView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect titleLabelFrame =  self.titleLabel.frame;
    titleLabelFrame.origin.x = titleLabelFrame.origin.x + 4;
    self.titleLabel.frame = titleLabelFrame;
    
    CGPoint titleCenter = self.titleLabel.center;
    CGRect tipViewFrame = self.selectedTipView.frame;
    tipViewFrame.origin.x = titleLabelFrame.origin.x - 8;
    tipViewFrame.origin.y = titleCenter.y - 2;
    self.selectedTipView.frame = tipViewFrame;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    self.selectedTipView.hidden = !selected;
}

- (UIView *)selectedTipView {
    if (!_selectedTipView) {
        _selectedTipView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 4)];
        _selectedTipView.backgroundColor = FUColorFromHex(0x5EC7FE);
        _selectedTipView.layer.masksToBounds = YES;
        _selectedTipView.layer.cornerRadius = 2;
        _selectedTipView.hidden = YES;
    }
    return _selectedTipView;
}

@end
