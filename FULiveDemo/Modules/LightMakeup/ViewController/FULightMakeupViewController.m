//
//  FULightMakeupViewController.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/10/17.
//  Copyright © 2019 FaceUnity. All rights reserved.
//

#import "FULightMakeupViewController.h"
#import "FULightMakeupCell.h"

static NSString * const kFULightMakeupCellIdentifier = @"FULightMakeupCell";

@interface FULightMakeupViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) FUSlider *slider;

@property (nonatomic, strong, readonly) FULightMakeupViewModel *viewModel;

@end

@implementation FULightMakeupViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - FUHeightIncludeBottomSafeArea(134), CGRectGetWidth(self.view.bounds), FUHeightIncludeBottomSafeArea(134))];
    [self.view addSubview:bottomView];
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = bottomView.bounds;
    [bottomView addSubview:effectView];
    
    [bottomView addSubview:self.slider];
    
    [bottomView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(bottomView);
        make.top.equalTo(bottomView.mas_top).mas_offset(36);
        make.height.mas_offset(98);
    }];
    
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:self.viewModel.selectedIndex inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    self.slider.hidden = self.viewModel.selectedIndex == 0;
    
    [self updateBottomConstraintsOfCaptureButton:FUHeightIncludeBottomSafeArea(134) + 10 animated:NO];
}

#pragma mark - Event response

- (void)sliderValueChanged {
    [self.viewModel setLightMakeupValue:self.slider.value];
}

#pragma mark - Collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.lightMakeups.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FULightMakeupCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFULightMakeupCellIdentifier forIndexPath:indexPath];
    FULightMakeupModel *lightMakeupModel = self.viewModel.lightMakeups[indexPath.item];
    cell.fuImageView.image = [UIImage imageNamed:lightMakeupModel.imageStr];
    cell.fuTitleLabel.text = FULocalizedString(lightMakeupModel.name);
    return cell;
}

#pragma mark - Collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.slider.hidden = indexPath.item == 0;
    if (!self.slider.hidden) {
        self.slider.value = self.viewModel.lightMakeups[indexPath.item].value;
    }
    self.viewModel.selectedIndex = indexPath.item;
}

#pragma mark - Getters

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(54, 70);
        layout.minimumLineSpacing = 16;
        layout.minimumInteritemSpacing = 50;
        layout.sectionInset = UIEdgeInsetsMake(16, 18, 10, 18);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[FULightMakeupCell class] forCellWithReuseIdentifier:kFULightMakeupCellIdentifier];
    }
    return _collectionView;
}

- (FUSlider *)slider {
    if (!_slider) {
        _slider = [[FUSlider alloc] initWithFrame:CGRectMake(56, 16, CGRectGetWidth(self.view.bounds) - 112, 30)];
        _slider.bidirection = NO;
        [_slider addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];
    }
    return _slider;
}

@end
