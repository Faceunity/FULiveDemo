//
//  FUQualityStickerViewController.m
//  FULiveDemo
//
//  Created by 孙慕 on 2021/2/3.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUQualityStickerViewController.h"
#import "FUQualityStickerPageController.h"

#import "FUQualityStickerModel.h"

#import "FUQualityStickerHelper.h"
#import "FUNetworkingHelper.h"


static NSString * const kFUStickerTagsKey = @"FUStickerTags";
static NSString * const kFUStickerContentCollectionCellIdentifier = @"FUStickerContentCollectionCell";

@interface FUQualityStickerViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, FUQualityStickerPageControllerDelegate, FUSegmentBarDelegate>

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UICollectionView *contentCollectionView;
@property (nonatomic, strong) UIView *bottom;
/// 取消效果按钮
@property (nonatomic, strong) UIButton *cancelStickerButton;
@property (nonatomic, strong) FUSegmentBar *segmentsView;

@property (nonatomic, copy) NSArray<NSString *> *tags;
@property (nonatomic, strong) NSMutableArray<FUQualityStickerPageController *> *stickerControllers;

/// 当前选中贴纸分组索引
@property (nonatomic, assign) NSInteger selectedIndex;
/// 是否正在显示贴纸 默认为YES
@property (nonatomic, assign) BOOL isShowingStickers;

@property (nonatomic, strong, readonly) FUQualityStickerViewModel *viewModel;
/// 选中的贴纸
@property (nonatomic, strong) FUQualityStickerModel *selectedSticker;
/// 即将选择的贴纸
@property (nonatomic, strong) FUQualityStickerModel *toBeSelectedSticker;

@end

@implementation FUQualityStickerViewController

@dynamic viewModel;

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 默认选中第一组
    self.selectedIndex = 0;

    if ([FUNetworkingHelper currentNetworkStatus] == FUNetworkStatusReachable) {
        // 有网络时请求接口
        [self requestTags];
    } else {
        // 无网络时查看本地数据
        [self loadLocalTags];
    }

    // 网络变化
    __weak typeof(self) weakSelf = self;
    [FUNetworkingHelper networkStatusHandler:^(FUNetworkStatus status) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.tags.count == 0 && status == FUNetworkStatusReachable) {
             [strongSelf requestTags];
        }
    }];
}

- (void)dealloc {
    [FUQualityStickerHelper cancelStickerHTTPTasks];
    [self.viewModel cancelDownloadingTasks];
}

#pragma mark - UI

- (void)setupContentView {
    
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.height.mas_offset(FUHeightIncludeBottomSafeArea(231));
    }];
    
    [self.bottomView addSubview:self.bottom];
    [self.bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.bottomView);
        make.height.mas_offset(FUHeightIncludeBottomSafeArea(49));
    }];
    
    [self.bottomView addSubview:self.contentCollectionView];
    [self.contentCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(self.bottomView);
        make.bottom.equalTo(self.bottom.mas_top);
    }];
    
    [self.segmentsView selectItemAtIndex:_selectedIndex];
    
    [self updateBottomConstraintsOfCaptureButton:FUHeightIncludeBottomSafeArea(231)];
}

#pragma mark - Private methods

- (void)requestTags {
    [FUQualityStickerHelper itemTagsCompletion:^(BOOL isSuccess, NSArray * _Nullable tags) {
        if (isSuccess && tags) {
            self.tags = [tags copy];
            [[NSUserDefaults standardUserDefaults] setObject:self.tags forKey:kFUStickerTagsKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setupContentView];
            });
        } else {
            // 请求失败
            [self loadLocalTags];
        }
    }];
}

- (void)loadLocalTags {
    // 无网络时查看本地数据
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kFUStickerTagsKey]) {
        self.tags = [[NSUserDefaults standardUserDefaults] arrayForKey:kFUStickerTagsKey];
        [self setupContentView];
    }
}

- (void)selectSegmentBarWithIndex:(NSInteger)index {
    if (index < 0 || index >= self.tags.count) {
        NSLog(@"switchTabDidSelectedAtIndex invalid index: %@", @(index));
        return;
    }
    if (index == _selectedIndex) {
        [self changeStickerViewStatus:!_isShowingStickers];
    } else {
        if (_isShowingStickers) {
            [self.contentCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        } else {
            [self changeStickerViewStatus:YES];
            [self.contentCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        }
        _selectedIndex = index;
    }
}

/// 贴纸区域隐藏/显示
- (void)changeStickerViewStatus:(BOOL)isShow {
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(isShow ? FUHeightIncludeBottomSafeArea(231) : FUHeightIncludeBottomSafeArea(49));
    }];
    [UIView animateWithDuration:0.1 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self->_isShowingStickers = isShow;
    }];
    [self updateBottomConstraintsOfCaptureButton:isShow ? FUHeightIncludeBottomSafeArea(231) : FUHeightIncludeBottomSafeArea(49)];
}

- (void)showToast:(NSString *)toastString {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tipLabel.hidden = NO;
        self.tipLabel.text = toastString;
        [FUQualityStickerViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissTipLabel) object:nil];
        [self performSelector:@selector(dismissTipLabel) withObject:nil afterDelay:3];
    });
}

#pragma mark - Overriding

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    // 隐藏贴纸视图
    [self changeStickerViewStatus:NO];
    
    if (self.selectedSticker.isNeedClick) {
        [self.viewModel clickCurrentItem];
    }
}

#pragma mark - Event response

- (void)cancelStickerAction {
    self.selectedSticker = nil;
    self.viewModel.detectingParts = FUDetectingPartsFace;
    [[NSNotificationCenter defaultCenter] postNotificationName:FUSelectedStickerDidChangeNotification object:nil];

    // 释放贴纸
    [self.viewModel releaseItem];
}

- (void)dismissTipLabel {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tipLabel.hidden = YES;
    });
}

#pragma mark - FUSegmentBarDelegate

- (void)segmentBar:(FUSegmentBar *)segmentsView didSelectItemAtIndex:(NSUInteger)index {
    [self selectSegmentBarWithIndex:index];
}

#pragma mark - FUQualityStickerPageControllerDelegate

- (void)stickerPageController:(FUQualityStickerPageController *)controller willSelectSticker:(FUQualityStickerModel *)sticker {
    self.toBeSelectedSticker = sticker;
}

- (void)stickerPageController:(FUQualityStickerPageController *)controller didDownloadSticker:(FUQualityStickerModel *)sticker {
    if ([sticker.tag isEqualToString:self.toBeSelectedSticker.tag] && [sticker.itemId isEqualToString:self.toBeSelectedSticker.itemId]) {
        // 即将选择的贴纸下载完毕，需要直接加载
        [self stickerPageController:controller didSelectSticker:sticker];
    }
}

- (void)stickerPageController:(FUQualityStickerPageController *)controller didSelectSticker:(FUQualityStickerModel *)sticker {
    [self.viewModel releaseItem];
    self.selectedSticker = sticker;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:FUSelectedStickerDidChangeNotification object:sticker];
    
    // 追踪部位判断
    self.viewModel.detectingParts = self.selectedSticker.type == FUQualityStickerTypeAvatar ? FUDetectingPartsHuman : FUDetectingPartsFace;
    
    // 只有当前选中的贴纸和需要加载的贴纸一致时执行加载
    if (sticker.isSingle) {
        // 设置精品贴纸只对一个人脸有效
        self.viewModel.maxFaceNumber = 1;
    } else {
        // 最多四个人脸
        self.viewModel.maxFaceNumber = 4;
    }
    [self.viewModel loadItem:sticker];
    if (sticker.type == FUQualityStickerTypeAvatar) {
        // 自动隐藏选择视图
        [self changeStickerViewStatus:NO];
    }
    NSString *language = [[NSLocale preferredLanguages] firstObject];
    if (sticker.toast && [language hasPrefix:@"zh-Hans"]) {
        // 中文提示
        [self showToast:sticker.toast];
    } else if (sticker.toastEn && ![language hasPrefix:@"zh-Hans"]) {
        // 英文提示
        [self showToast:sticker.toastEn];
    } else {
        if (!self.tipLabel.hidden) {
            [self dismissTipLabel];
        }
    }
}

#pragma mark - Collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tags.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFUStickerContentCollectionCellIdentifier forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    FUQualityStickerPageController *controller = self.stickerControllers[indexPath.item];
    controller.view.frame = cell.contentView.frame;
    [cell.contentView addSubview:controller.view];
    return cell;
}

#pragma mark - Scroll view delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.contentCollectionView) {
        NSInteger index = self.contentCollectionView.contentOffset.x / CGRectGetWidth(self.view.frame);
        if (index < 0 || index >= self.tags.count) {
            return;
        }
        [self.segmentsView selectItemAtIndex:index];
    }
}

#pragma mark - Getters

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - FUHeightIncludeBottomSafeArea(231), CGRectGetWidth(self.view.frame), FUHeightIncludeBottomSafeArea(231))];
        // 毛玻璃效果
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
        effectview.alpha = 1.0;
        effectview.frame = CGRectMake(0, 0, CGRectGetWidth(_bottomView.frame), 182);
        [_bottomView insertSubview:effectview atIndex:0];
    }
    return _bottomView;
}

- (UIView *)bottom {
    if (!_bottom) {
        _bottom = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetWidth(self.view.frame) - FUHeightIncludeTopSafeArea(49), CGRectGetWidth(self.view.frame), FUHeightIncludeBottomSafeArea(49))];
        _bottom.backgroundColor = [UIColor colorWithRed:5/255.0 green:15/255.0 blue:20/255.0 alpha:1];
        
        [_bottom addSubview:self.cancelStickerButton];
        [self.cancelStickerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_bottom.mas_leading).mas_offset(6);
            make.top.equalTo(_bottom.mas_top).mas_offset(4);
            make.size.mas_offset(CGSizeMake(40, 40));
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.2];
        [_bottom addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.cancelStickerButton.mas_trailing).mas_offset(10);
            make.top.equalTo(_bottom.mas_top).mas_offset(14);
            make.size.mas_offset(CGSizeMake(0.5, 20));
        }];
        
        [_bottom addSubview:self.segmentsView];
        [self.segmentsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_bottom.mas_leading).mas_offset(57);
            make.top.trailing.equalTo(_bottom);
            make.height.mas_offset(49);
        }];
        
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 0.5)];
        topLine.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
        [_bottom addSubview:topLine];
        [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.equalTo(_bottom);
            make.height.mas_offset(0.5);
        }];
    }
    return _bottom;
}

- (UIButton *)cancelStickerButton {
    if (!_cancelStickerButton) {
        _cancelStickerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelStickerButton.frame = CGRectMake(0, 0, 40, 40);
        [_cancelStickerButton setImage:[UIImage imageNamed:@"sticker_cancel"] forState:UIControlStateNormal];
        [_cancelStickerButton addTarget:self action:@selector(cancelStickerAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelStickerButton;
}

- (FUSegmentBar *)segmentsView {
    if (!_segmentsView) {
        NSMutableArray *segments = [[NSMutableArray alloc] init];
        for (NSString *tag in self.tags) {
            if ([tag componentsSeparatedByString:@"/"].count > 1) {
                NSArray *titles = [tag componentsSeparatedByString:@"/"];
                NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
                [segments addObject:[language hasPrefix:@"zh-Hans"] ? titles[0] : titles[1]];
            } else {
                [segments addObject:tag];
            }
        }
        _segmentsView = [[FUSegmentBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame) - 57, 49) titles:[segments copy] configuration:[FUSegmentBarConfigurations new]];
        _segmentsView.delegate = self;
    }
    return _segmentsView;
}

- (UICollectionView *)contentCollectionView {
    if (!_contentCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.itemSize = CGSizeMake(CGRectGetWidth(self.view.frame), 182);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _contentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 182) collectionViewLayout:flowLayout];
        _contentCollectionView.backgroundColor = [UIColor clearColor];
        _contentCollectionView.showsVerticalScrollIndicator = NO;
        _contentCollectionView.showsHorizontalScrollIndicator = NO;
        _contentCollectionView.pagingEnabled = YES;
        _contentCollectionView.dataSource = self;
        _contentCollectionView.delegate = self;
        [_contentCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kFUStickerContentCollectionCellIdentifier];
    }
    return _contentCollectionView;
}
- (NSMutableArray<FUQualityStickerPageController *> *)stickerControllers {
    if (!_stickerControllers) {
        _stickerControllers = [[NSMutableArray alloc] init];
        for (NSString *tag in self.tags) {
            FUQualityStickerPageController *stickerController = [[FUQualityStickerPageController alloc] initWithTag:tag];
            stickerController.qualityStickerViewModel = self.viewModel;
            stickerController.delegate = self;
            [_stickerControllers addObject:stickerController];
        }
    }
    return _stickerControllers;
}

@end
