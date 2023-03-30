//
//  FUSegmentationViewController.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/8/16.
//

#import "FUSegmentationViewController.h"
#import "FUMediaPickerViewController.h"

#import "UIImage+FU.h"

static NSString * const kFUSegmentationCellIdentifier = @"FUSegmentationCell";

@interface FUSegmentationViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *itemsView;

@property (nonatomic, strong) UIView *versionSelectionView;

@property (nonatomic, strong, readonly) FUSegmentationViewModel *viewModel;

@end

@implementation FUSegmentationViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureSubviews];
    [self refreshSubviews];
    
    [FURenderKitManager loadFaceAIModel];
    
    if ([FURenderKitManager sharedManager].devicePerformanceLevel == FUDevicePerformanceLevelHigh) {
        // 高端机需要选择分割版本
        [self.view addSubview:self.versionSelectionView];
        [self.view bringSubviewToFront:self.headButtonView];
    } else {
        // 设置分割模式为CPU普通模式
        [FURenderKitManager loadHumanAIModel:FUHumanSegmentationModeCPUCommon];
        // 默认选中
        if (self.viewModel.customized) {
            [self.viewModel selectSegmentationAtIndex:3 completionHandler:nil];
        } else {
            [self.viewModel selectSegmentationAtIndex:2 completionHandler:nil];
        }
        [self refreshSubviews];
    }
}

#pragma mark - UI

- (void)configureSubviews {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - FUHeightIncludeBottomSafeArea(84), CGRectGetWidth(self.view.bounds), FUHeightIncludeBottomSafeArea(84))];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.height.mas_offset(FUHeightIncludeBottomSafeArea(84));
    }];
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, CGRectGetWidth(bottomView.frame), CGRectGetHeight(bottomView.frame));
    [bottomView addSubview:effectView];
    
    [bottomView addSubview:self.itemsView];
    [self.itemsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(bottomView);
        make.height.mas_offset(84);
    }];
}

- (void)refreshSubviews {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.itemsView reloadData];
        if (self.viewModel.selectedIndex >= 0) {
            [self.itemsView selectItemAtIndexPath:[NSIndexPath indexPathForItem:self.viewModel.selectedIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
    });
}

#pragma mark - Event response

- (void)genericAction:(UIButton *)sender {
    [FURenderKitManager loadHumanAIModel:FUHumanSegmentationModeGPUCommon];
    [UIView animateWithDuration:0.3 animations:^{
        self.versionSelectionView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.versionSelectionView removeFromSuperview];
    }];
    // 默认选中
    if (self.viewModel.customized) {
        [self.viewModel selectSegmentationAtIndex:3 completionHandler:nil];
    } else {
        [self.viewModel selectSegmentationAtIndex:2 completionHandler:nil];
    }
    [self refreshSubviews];
}

- (void)videoConferenceAction:(UIButton *)sender {
    [FURenderKitManager loadHumanAIModel:FUHumanSegmentationModeGPUMeeting];
    [UIView animateWithDuration:0.3 animations:^{
        self.versionSelectionView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.versionSelectionView removeFromSuperview];
    }];
    // 默认选中
    if (self.viewModel.customized) {
        [self.viewModel selectSegmentationAtIndex:3 completionHandler:nil];
    } else {
        [self.viewModel selectSegmentationAtIndex:2 completionHandler:nil];
    }
    [self refreshSubviews];
}

- (void)renderShouldCheckDetectingStatus:(FUDetectingParts)parts {
    if (self.viewModel.selectedIndex == 0) {
        return;
    }
    [super renderShouldCheckDetectingStatus:parts];
}

- (void)dismissTipLabel {
    self.tipLabel.hidden = YES;
}


#pragma mark - Private methods

- (void)selectMedia:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // 图片处理
        image = [image fu_processedImage];
        if ([self.viewModel saveCustomImage:image]) {
            [self.viewModel reloadSegmentationData];
            if (self.viewModel.customized) {
                [self.viewModel selectSegmentationAtIndex:2 completionHandler:nil];
            }
            [self refreshSubviews];
        }
    } else {
        // 获取视频地址
        [FUUtility requestVideoURLFromInfo:info resultHandler:^(NSURL * _Nonnull videoURL) {
            if ([self.viewModel saveCustomVideo:videoURL]) {
                [self.viewModel reloadSegmentationData];
                if (self.viewModel.customized) {
                    [self.viewModel selectSegmentationAtIndex:2 completionHandler:nil];
                }
                [self refreshSubviews];
            }
        }];
    }
}

#pragma mark - Collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.segmentationItems.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FUItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFUSegmentationCellIdentifier forIndexPath:indexPath];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    FUSegmentationModel *model = self.viewModel.segmentationItems[indexPath.item];
    if (model.isCustom && model.image) {
        // 自定义
        cell.imageView.image = model.image;
    } else {
        cell.imageView.image = [UIImage imageNamed:model.name];
    }
    return cell;
}

#pragma mark - Collection view delegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 1) {
        // Add
        FUMediaPickerViewController *picker = [[FUMediaPickerViewController alloc] initWithViewModel:[[FUMediaPickerViewModel alloc] initWithModule:self.viewModel.module] selectedMediaHandler:^(NSDictionary<UIImagePickerControllerInfoKey,id> * _Nonnull info) {
            [self selectMedia:info];
        }];
        [self.navigationController pushViewController:picker animated:YES];
        return NO;
    }
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    collectionView.userInteractionEnabled = NO;
    FUItemCell *cell = (FUItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell.indicatorView startAnimating];
    [self.viewModel selectSegmentationAtIndex:indexPath.item completionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell.indicatorView stopAnimating];
            collectionView.userInteractionEnabled = YES;
        });
    }];
    // 道具提示处理
    if (self.viewModel.segmentationTips[self.viewModel.segmentationItems[indexPath.item].name]) {
        NSString *hint = self.viewModel.segmentationTips[self.viewModel.segmentationItems[indexPath.item].name];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tipLabel.hidden = NO;
            self.tipLabel.text = FULocalizedString(hint);
            [FUSegmentationViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissTipLabel) object:nil];
            [self performSelector:@selector(dismissTipLabel) withObject:nil afterDelay:1];
        });
    }
}

#pragma mark - Getters

- (UICollectionView *)itemsView {
    if (!_itemsView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(60, 60);
        flowLayout.sectionInset = UIEdgeInsetsMake(12, 16, 12, 16);
        _itemsView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _itemsView.backgroundColor = [UIColor clearColor];
        _itemsView.showsHorizontalScrollIndicator = NO;
        _itemsView.translatesAutoresizingMaskIntoConstraints = NO;
        _itemsView.dataSource = self;
        _itemsView.delegate = self;
        [_itemsView registerClass:[FUItemCell class] forCellWithReuseIdentifier:kFUSegmentationCellIdentifier];
    }
    return _itemsView;
}

- (UIView *)versionSelectionView {
    if (!_versionSelectionView) {
        _versionSelectionView = [[UIView alloc] initWithFrame:self.view.bounds];
        _versionSelectionView.backgroundColor = FUColorFromHexWithAlpha(0x000000, 0.5);
        UIButton *genericButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [genericButton setTitle:FULocalizedString(@"通用分割版") forState:UIControlStateNormal];
        genericButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        [genericButton setTitleColor:FUColorFromHex(0x2C2E30) forState:UIControlStateNormal];
        [genericButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        genericButton.layer.masksToBounds = YES;
        genericButton.layer.cornerRadius = 24.f;
        [genericButton addTarget:self action:@selector(genericAction:) forControlEvents:UIControlEventTouchUpInside];
        [_versionSelectionView addSubview:genericButton];
        [genericButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_versionSelectionView);
            make.centerY.equalTo(_versionSelectionView.mas_centerY).mas_offset(-42);
            make.size.mas_offset(CGSizeMake(235, 48));
        }];
        
        UIButton *videoConferenceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [videoConferenceButton setTitle:FULocalizedString(@"视频会议版") forState:UIControlStateNormal];
        videoConferenceButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        [videoConferenceButton setTitleColor:FUColorFromHex(0x2C2E30) forState:UIControlStateNormal];
        [videoConferenceButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        videoConferenceButton.layer.masksToBounds = YES;
        videoConferenceButton.layer.cornerRadius = 24.f;
        [videoConferenceButton addTarget:self action:@selector(videoConferenceAction:) forControlEvents:UIControlEventTouchUpInside];
        [_versionSelectionView addSubview:videoConferenceButton];
        [videoConferenceButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_versionSelectionView);
            make.centerY.equalTo(_versionSelectionView.mas_centerY).mas_offset(42);
            make.size.mas_offset(CGSizeMake(235, 48));
        }];
    }
    return _versionSelectionView;
}

@end
