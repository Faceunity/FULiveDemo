//
//  FUQSTickersViewController.m
//  FULiveDemo
//
//  Created by 孙慕 on 2021/2/3.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUQSTickersViewController.h"
#import "FUStickersPageController.h"

#import "FUStickerSegmentsView.h"

#import "FUStickerModel.h"

#import "FUStickerHelper.h"
#import "FUManager.h"
#import "FUNetworkingHelper.h"
#import "FUQualityStickerManager.h"

#import "NSObject+economizer.h"

static NSString * const kFUStickerTagsKey = @"FUStickerTags";
static NSString * const kFUStickerContentCollectionCellIdentifier = @"FUStickerContentCollectionCell";

@interface FUQSTickersViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, FUStickersPageControllerDelegate, FUStickerSegmentsViewDelegate>

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UICollectionView *contentCollectionView;
@property (nonatomic, strong) UIView *bottom;
/// 取消效果按钮
@property (nonatomic, strong) UIButton *cancelStickerButton;
@property (nonatomic, strong) FUStickerSegmentsView *stickerSegmentView;

@property (nonatomic, copy) NSArray<NSString *> *tags;
@property (nonatomic, strong) NSMutableArray<FUStickersPageController *> *stickerControllers;

//当前
@property (nonatomic, strong) FUStickersPageController *selectedStickerController;
/// 当前选中贴纸分组索引
@property (nonatomic, assign) NSInteger selectedIndex;
/// 是否正在显示贴纸 默认为YES
@property (nonatomic, assign) BOOL isShowingStickers;

@property (nonatomic, strong) FUQualityStickerManager *qualityStickerManager;
/// 选中的贴纸
@property (nonatomic, strong) FUStickerModel *selectedSticker;

@end

@implementation FUQSTickersViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.qualityStickerManager = [[FUQualityStickerManager alloc] init];
    
    // 默认选中第一组
    self.selectedIndex = 0;
    _isShowingStickers = YES;
    
    self.headButtonView.selectedImageBtn.hidden = NO;
    self.canPushImageSelView = NO;
    
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.height.mas_offset(iPhoneXStyle ? 265 : 231);
    }];
    
    
    [self.photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.size.mas_offset(CGSizeMake(85, 85));
        make.bottom.equalTo(self.bottomView.mas_top).mas_offset(-10);
    }];
    
    if ([[FUNetworkingHelper sharedInstance] currentNetworkStatus] == FUNetworkStatusReachable) {
        // 有网络时请求接口
        [self requestTags];
    } else {
        // 无网络时查看本地数据
        [self loadLocalTags];
    }
    
    // 网络变化
    [[FUNetworkingHelper sharedInstance] networkStatusHandler:^(FUNetworkStatus status) {
        if (self.tags.count == 0 && status == FUNetworkStatusReachable) {
            [self requestTags];
        }
    }];
}

-(void)headButtonViewBackAction:(UIButton *)btn {
    [self.qualityStickerManager releaseItem];
    [super headButtonViewBackAction:btn];
}

- (void)dealloc {
    [FUStickerHelper cancelStickerHTTPTasks];
}

#pragma mark - UI
- (void)setupContentView {
    [self.bottomView addSubview:self.bottom];
    [self.bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.bottomView);
        make.height.mas_offset(iPhoneXStyle ? 83 : 49);
    }];
    
    [self.bottomView addSubview:self.contentCollectionView];
    [self.contentCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(self.bottomView);
        make.bottom.equalTo(self.bottom.mas_top);
    }];
}

#pragma mark - Private methods
- (void)requestTags {
    [FUStickerHelper itemTagsCompletion:^(BOOL isSuccess, NSArray * _Nullable tags) {
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
        make.height.mas_offset(isShow ? (iPhoneXStyle ? 265 : 231) : (iPhoneXStyle ? 83 : 49));
    }];
    [UIView animateWithDuration:0.1 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        _isShowingStickers = isShow;
    }];
    [UIView animateWithDuration:0.35 animations:^{
        self.photoBtn.transform = isShow ? CGAffineTransformIdentity : CGAffineTransformMakeScale(0.9, 0.9);
    }];
}

#pragma mark - Override methods
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    // 隐藏贴纸视图
    [self changeStickerViewStatus:NO];
    
    if (self.selectedSticker.isNeedClick) {
        [self.qualityStickerManager clickCurrentItem];
    }
}

#pragma mark - Event response
- (void)cancelStickerAction {
    self.selectedSticker = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:FUSelectedStickerDidChangeNotification object:nil];
    
    // 释放贴纸
    [self.qualityStickerManager releaseItem];
}


#pragma mark - FUStickerSegmentsViewDelegate
- (void)stickerSegmentsView:(FUStickerSegmentsView *)segmentsView didSelectItemAtIndex:(NSInteger)index {
    [self selectSegmentBarWithIndex:index];
}

#pragma mark - FUStickersPageControllerDelegate
- (void)stickerPageController:(FUStickersPageController *)controller didSelectSticker:(FUStickerModel *)sticker {
    self.selectedSticker = sticker;
    [[NSNotificationCenter defaultCenter] postNotificationName:FUSelectedStickerDidChangeNotification object:sticker];
    
    // 选中马上释放当前贴纸
    [self.qualityStickerManager releaseItem];
}
- (void)stickerPageController:(FUStickersPageController *)controller shouldLoadSticker:(FUStickerModel *)sticker {
    if ([sticker.tag isEqualToString:self.selectedSticker.tag] && [sticker.itemId isEqualToString:self.selectedSticker.itemId]) {
        // 只有当前选中的贴纸和需要加载的贴纸一致时执行加载
        if (sticker.isSingle) {
            // 设置精品贴纸只对一个人脸有效
            [self.baseManager setMaxFaces:1];
        } else {
            // 最多四个人脸
            [self.baseManager setMaxFaces:4];
        }
        [self.qualityStickerManager loadItemWithModel:sticker completion:^(BOOL finished) {
            if (finished) {
                NSLog(@"Load success");
            } else {
                NSLog(@"Load failed");
            }
        }];
    }
}

#pragma mark - Collection view data source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tags.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFUStickerContentCollectionCellIdentifier forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    FUStickersPageController *controller = self.stickerControllers[indexPath.item];
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
        [self.stickerSegmentView selectSegmentItemWithIndex:index];
        _selectedIndex = index;
    }
}

#pragma mark - Getters
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), iPhoneXStyle ? 265 : 231)];
        // 毛玻璃效果
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
        effectview.alpha = 1.0;
        effectview.frame = CGRectMake(0, 0, CGRectGetWidth(_bottomView.frame), CGRectGetHeight(_bottomView.frame));
        [_bottomView insertSubview:effectview atIndex:0];
    }
    return _bottomView;
}

- (UIView *)bottom {
    if (!_bottom) {
        _bottom = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), iPhoneXStyle ? 83 : 49)];
        _bottom.backgroundColor = [UIColor colorWithRed:5/255.0 green:15/255.0 blue:20/255.0 alpha:0.74];
        
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 0.5)];
        topLine.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
        [_bottom addSubview:topLine];
        [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.equalTo(_bottom);
            make.height.mas_offset(0.5);
        }];
        
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
        
        [_bottom addSubview:self.stickerSegmentView];
        [self.stickerSegmentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_bottom.mas_leading).mas_offset(57);
            make.top.trailing.equalTo(_bottom);
            make.height.mas_offset(49);
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

- (FUStickerSegmentsView *)stickerSegmentView {
    if (!_stickerSegmentView) {
        FUStickerSegmentsConfigurations *config = [[FUStickerSegmentsConfigurations alloc] init];
        _stickerSegmentView = [[FUStickerSegmentsView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame) - 57, 49) titles:[self.tags copy] configuration:config];
        _stickerSegmentView.delegate = self;
    }
    return _stickerSegmentView;
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
- (NSMutableArray<FUStickersPageController *> *)stickerControllers {
    if (!_stickerControllers) {
        _stickerControllers = [[NSMutableArray alloc] init];
        for (NSString *tag in self.tags) {
            FUStickersPageController *stickerController = [[FUStickersPageController alloc] initWithTag:tag];
            stickerController.delegate = self;
            [_stickerControllers addObject:stickerController];
        }
    }
    return _stickerControllers;
}

@end
