//
//  FUBeautyFilterView.m
//  FUBeautyComponent
//
//  Created by 项林平 on 2022/6/21.
//

#import "FUBeautyFilterView.h"
#import "FUBeautyDefine.h"

#import <FUCommonUIComponent/FUSlider.h>

static NSString * const kFUBeautyFilterCellIdentifier = @"FUBeautyFilterCell";

@interface FUBeautyFilterView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) FUSlider *filterSlider;

@property (nonatomic, strong) UICollectionView *filterCollectionView;

@property (nonatomic, strong) FUBeautyFilterViewModel *viewModel;

@end

@implementation FUBeautyFilterView

#pragma mark - Initializer

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame viewModel:[[FUBeautyFilterViewModel alloc] init]];
}

- (instancetype)initWithFrame:(CGRect)frame viewModel:(FUBeautyFilterViewModel *)viewModel {
    self = [super initWithFrame:frame];
    if (self) {
        self.viewModel = viewModel;
        [self configureUI];
    }
    return self;
}

#pragma mark - UI

- (void)configureUI {
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    [self addSubview:effectView];
    
    [self addSubview:self.filterSlider];
    [self addSubview:self.filterCollectionView];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.filterCollectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:self.filterCollectionView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:self.filterCollectionView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.filterCollectionView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:98];
    [self addConstraints:@[bottom, leading, trailing]];
    [self.filterCollectionView addConstraint:height];
    // 默认选中
    [self.filterCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:self.viewModel.selectedIndex inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    self.filterSlider.hidden = self.viewModel.selectedIndex < 1;
    if (!self.filterSlider.hidden) {
        self.filterSlider.value = self.viewModel.beautyFilters[self.viewModel.selectedIndex].filterLevel;
    }
}

#pragma mark - Event response

- (void)sliderValueChanged {
    [self.viewModel setFilterValue:self.filterSlider.value];
}

#pragma mark - Collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.beautyFilters.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FUBeautyFilterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFUBeautyFilterCellIdentifier forIndexPath:indexPath];
    FUBeautyFilterModel *filter = self.viewModel.beautyFilters[indexPath.item];
    cell.imageView.image = FUBeautyImageNamed(filter.filterName);
    cell.textLabel.text = FUBeautyStringWithKey(filter.filterName);
    return cell;
}

#pragma mark - Collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.viewModel.selectedIndex == indexPath.item) {
        return;
    }
    self.filterSlider.hidden = indexPath.item < 1;
    if (!self.filterSlider.hidden) {
        self.filterSlider.value = self.viewModel.beautyFilters[indexPath.item].filterLevel;
    }
    self.viewModel.selectedIndex = indexPath.item;
    if (self.delegate && [self.delegate respondsToSelector:@selector(beautyFilterViewDidChangeFilter:)]) {
        [self.delegate beautyFilterViewDidChangeFilter:FUBeautyStringWithKey(self.viewModel.beautyFilters[indexPath.item].filterName)];
    }
}

#pragma mark - Getters

- (FUSlider *)filterSlider {
    if (!_filterSlider) {
        _filterSlider = [[FUSlider alloc] initWithFrame:CGRectMake(56, 16, CGRectGetWidth(self.frame) - 112, 30)];
        _filterSlider.bidirection = NO;
        _filterSlider.hidden = YES;
        [_filterSlider addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];
    }
    return _filterSlider;
}

- (UICollectionView *)filterCollectionView {
    if (!_filterCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(54, 70);
        layout.minimumLineSpacing = 16;
        layout.minimumInteritemSpacing = 50;
        layout.sectionInset = UIEdgeInsetsMake(16, 18, 10, 18);
        _filterCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _filterCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
        _filterCollectionView.backgroundColor = [UIColor clearColor];
        _filterCollectionView.showsHorizontalScrollIndicator = NO;
        _filterCollectionView.dataSource = self;
        _filterCollectionView.delegate = self;
        [_filterCollectionView registerClass:[FUBeautyFilterCell class] forCellWithReuseIdentifier:kFUBeautyFilterCellIdentifier];
    }
    return _filterCollectionView;
}

- (FUBeautyFilterViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[FUBeautyFilterViewModel alloc] init];
    }
    return _viewModel;
}

@end

@interface FUBeautyFilterCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation FUBeautyFilterCell

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
        NSLayoutConstraint *textTop = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute:NSLayoutAttributeBottom multiplier:1 constant:2];
        NSLayoutConstraint *textLeading = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
        NSLayoutConstraint *textTrailing = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
        [self.contentView addConstraints:@[textTop, textLeading, textTrailing]];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.imageView.layer.borderWidth = selected ? 2 : 0;
    self.imageView.layer.borderColor = selected ? [UIColor colorWithRed:94/255.0 green:199/255.0 blue:254/255.0 alpha:1].CGColor : [UIColor clearColor].CGColor;
    self.textLabel.textColor = selected ? [UIColor colorWithRed:94/255.0 green:199/255.0 blue:254/255.0 alpha:1] : [UIColor whiteColor];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius = 3.f;
    }
    return _imageView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.font = [UIFont systemFontOfSize:10];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.adjustsFontSizeToFitWidth = YES;
        _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _textLabel;
}

@end
