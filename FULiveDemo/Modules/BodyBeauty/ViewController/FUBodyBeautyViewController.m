//
//  FUBodyBeautyViewController.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/8/10.
//

#import "FUBodyBeautyViewController.h"
#import "FUBodyBeautyCell.h"

static NSString * const kFUBodyBeautyCellIdentifier = @"FUBodyBeautyCell";

@interface FUBodyBeautyViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) FUSlider *slider;
@property (nonatomic, strong) FUSquareButton *recoverButton;

@property (nonatomic, strong, readonly) FUBodyBeautyViewModel *viewModel;

@end

@implementation FUBodyBeautyViewController

@dynamic viewModel;

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureSubviews];
    [self refreshSubviews];
    
    [self updateBottomConstraintsOfCaptureButton:FUHeightIncludeBottomSafeArea(141) + 10 animated:NO];
}

#pragma mark - UI

- (void)configureSubviews {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - FUHeightIncludeBottomSafeArea(141), CGRectGetWidth(self.view.bounds), FUHeightIncludeBottomSafeArea(141))];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.height.mas_offset(FUHeightIncludeBottomSafeArea(141));
    }];
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, CGRectGetWidth(bottomView.frame), CGRectGetHeight(bottomView.frame));
    [bottomView addSubview:effectView];
    
    [bottomView addSubview:self.slider];
    [bottomView addSubview:self.recoverButton];
    [self.recoverButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(bottomView.mas_leading).mas_offset(17);
        make.top.equalTo(bottomView.mas_top).mas_offset(55);
        make.size.mas_offset(CGSizeMake(44, 74));
    }];
    
    // 分割线
    UIView *verticalLine = [[UIView alloc] init];
    verticalLine.backgroundColor = [UIColor colorWithRed:229/255.f green:229/255.f blue:229/255.f alpha:0.2];
    [bottomView addSubview:verticalLine];
    [verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.recoverButton.mas_trailing).mas_offset(14);
        make.centerY.equalTo(self.recoverButton.mas_centerY).mas_offset(-15);
        make.size.mas_offset(CGSizeMake(1, 24));
    }];
    
    [bottomView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(bottomView.mas_leading).mas_offset(76);
        make.trailing.equalTo(bottomView);
        make.top.equalTo(bottomView.mas_top).mas_offset(43);
        make.height.mas_offset(98);
    }];
}

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
    [FUAlertManager showAlertWithTitle:nil message:FULocalizedString(@"是否将所有参数恢复到默认值") cancel:FULocalizedString(@"取消") confirm:FULocalizedString(@"确定") inController:self confirmHandler:^{
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

-(FUSlider *)slider {
    if (!_slider) {
        _slider = [[FUSlider alloc] initWithFrame:CGRectMake(56, 16, CGRectGetWidth(self.view.bounds) - 116, 30)];
        [_slider addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];
        [_slider addTarget:self action:@selector(sliderChangeEnded) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    }
    return _slider;
}

@end
