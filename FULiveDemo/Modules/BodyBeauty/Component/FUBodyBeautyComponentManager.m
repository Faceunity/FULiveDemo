//
//  FUBodyBeautyComponentManager.m
//  FULiveDemo
//
//  Created by Cursor on 2026/6/30.
//

#import "FUBodyBeautyComponentManager.h"
#import "FUBodyBeautyComponentViewModel.h"
#import "FUBodyBeautyCell.h"

static NSString * const kFUBodyBeautyCellIdentifier = @"FUBodyBeautyComponentCell";

static FUBodyBeautyComponentManager *bodyBeautyComponentManager = nil;
static dispatch_once_t onceToken;

@interface FUBodyBeautyComponentManager ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) UIView *targetView;
@property (nonatomic, strong) UIView *componentView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) FUSlider *slider;
@property (nonatomic, strong) FUSquareButton *recoverButton;
@property (nonatomic, strong) FUBodyBeautyComponentViewModel *viewModel;

@end

@implementation FUBodyBeautyComponentManager

#pragma mark - Class methods

+ (instancetype)sharedManager {
    dispatch_once(&onceToken, ^{
        bodyBeautyComponentManager = [[FUBodyBeautyComponentManager alloc] init];
    });
    return bodyBeautyComponentManager;
}

+ (void)destory {
    onceToken = 0;
    bodyBeautyComponentManager = nil;
}

#pragma mark - Instance methods

- (instancetype)init {
    self = [super init];
    if (self) {
        [self.viewModel loadBodyBeautyIfNeeded];
    }
    return self;
}

- (CGFloat)componentViewHeight {
    return FUHeightIncludeBottomSafeArea(141);
}

- (void)addComponentViewToView:(UIView *)view {
    NSAssert(view != nil, @"FUBodyBeautyComponentManager: view can not be nil!");
    self.targetView = view;
    [self removeComponentView];
    [self.viewModel loadBodyBeautyIfNeeded];
    [self.targetView addSubview:self.componentView];
    [self refreshSubviews];
}

- (void)removeComponentView {
    if (self.componentView.superview) {
        [self.componentView removeFromSuperview];
    }
}

- (void)loadBodyBeautyIfNeeded {
    [self.viewModel loadBodyBeautyIfNeeded];
}

#pragma mark - UI

- (void)refreshSubviews {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.viewModel.isDefaultValue) {
            self.recoverButton.alpha = 0.6;
            self.recoverButton.userInteractionEnabled = NO;
        } else {
            self.recoverButton.alpha = 1;
            self.recoverButton.userInteractionEnabled = YES;
        }
        if (!self.slider.hidden && self.viewModel.selectedIndex >= 0) {
            self.slider.bidirection = self.viewModel.bodyBeautyItems[self.viewModel.selectedIndex].defaultValueInMiddle;
            self.slider.value = self.viewModel.bodyBeautyItems[self.viewModel.selectedIndex].currentValue;
        }
        [self.collectionView reloadData];
        if (self.viewModel.selectedIndex >= 0) {
            [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:self.viewModel.selectedIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
    });
}

#pragma mark - Event response

- (void)recoverAction {
    [FUAlertManager showAlertWithTitle:nil message:FULocalizedString(@"是否将所有参数恢复到默认值") cancel:FULocalizedString(@"取消") confirm:FULocalizedString(@"确定") inController:nil confirmHandler:^{
        [self.viewModel recoverToDefault];
        [self refreshSubviews];
    } cancelHandler:nil];
}

- (void)sliderValueChanged {
    [self.viewModel setCurrentValue:self.slider.value];
}

- (void)sliderChangeEnded {
    [self refreshSubviews];
}

#pragma mark - Collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.bodyBeautyItems.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FUBodyBeautyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFUBodyBeautyCellIdentifier forIndexPath:indexPath];
    FUBodyBeautyModel *model = self.viewModel.bodyBeautyItems[indexPath.item];
    cell.textLabel.text = FULocalizedString(model.name);
    cell.imageName = model.name;
    cell.defaultInMiddle = model.defaultValueInMiddle;
    cell.currentValue = model.currentValue;
    cell.selected = indexPath.item == self.viewModel.selectedIndex;
    return cell;
}

#pragma mark - Collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == self.viewModel.selectedIndex) {
        return;
    }
    self.viewModel.selectedIndex = indexPath.item;
    FUBodyBeautyModel *bodyBeauty = self.viewModel.bodyBeautyItems[indexPath.item];
    if (self.slider.hidden) {
        self.slider.hidden = NO;
    }
    self.slider.bidirection = bodyBeauty.defaultValueInMiddle;
    self.slider.value = bodyBeauty.currentValue;
}

#pragma mark - Getters

- (UIView *)componentView {
    if (!_componentView) {
        _componentView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.targetView.bounds) - self.componentViewHeight, CGRectGetWidth(self.targetView.bounds), self.componentViewHeight)];
        
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = _componentView.bounds;
        effectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_componentView addSubview:effectView];
        
        [_componentView addSubview:self.slider];
        [_componentView addSubview:self.recoverButton];
        [self.recoverButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_componentView.mas_leading).mas_offset(17);
            make.top.equalTo(_componentView.mas_top).mas_offset(55);
            make.size.mas_offset(CGSizeMake(44, 74));
        }];
        
        UIView *verticalLine = [[UIView alloc] init];
        verticalLine.backgroundColor = [UIColor colorWithRed:229/255.f green:229/255.f blue:229/255.f alpha:0.2];
        [_componentView addSubview:verticalLine];
        [verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.recoverButton.mas_trailing).mas_offset(14);
            make.centerY.equalTo(self.recoverButton.mas_centerY).mas_offset(-15);
            make.size.mas_offset(CGSizeMake(1, 24));
        }];
        
        [_componentView addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_componentView.mas_leading).mas_offset(76);
            make.trailing.equalTo(_componentView);
            make.top.equalTo(_componentView.mas_top).mas_offset(43);
            make.height.mas_offset(98);
        }];
    }
    return _componentView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(44, 74);
        layout.minimumLineSpacing = 22;
        layout.minimumInteritemSpacing = 22;
        layout.sectionInset = UIEdgeInsetsMake(6, 16, 6, 16);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[FUBodyBeautyCell class] forCellWithReuseIdentifier:kFUBodyBeautyCellIdentifier];
    }
    return _collectionView;
}

- (FUSquareButton *)recoverButton {
    if (!_recoverButton) {
        _recoverButton = [[FUSquareButton alloc] initWithFrame:CGRectMake(0, 0, 44, 74)];
        [_recoverButton setTitle:FULocalizedString(@"恢复") forState:UIControlStateNormal];
        [_recoverButton setImage:[UIImage imageNamed:@"recover_item"] forState:UIControlStateNormal];
        _recoverButton.alpha = 0.6;
        _recoverButton.userInteractionEnabled = NO;
        [_recoverButton addTarget:self action:@selector(recoverAction) forControlEvents:UIControlEventTouchUpInside];
        _recoverButton.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _recoverButton;
}

- (FUSlider *)slider {
    if (!_slider) {
        _slider = [[FUSlider alloc] initWithFrame:CGRectMake(56, 16, CGRectGetWidth(self.targetView.bounds) - 116, 30)];
        [_slider addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];
        [_slider addTarget:self action:@selector(sliderChangeEnded) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    }
    return _slider;
}

- (FUBodyBeautyComponentViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[FUBodyBeautyComponentViewModel alloc] init];
    }
    return _viewModel;
}

@end
