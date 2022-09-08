//
//  FUStickersPageController.m
//  FULiveDemo
//
//  Created by 项林平 on 2021/3/16.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUStickersPageController.h"

#import "FUStickerCell.h"

#import "FUStickerModel.h"
#import "FUStickerHelper.h"
#import "FUQualityStickerManager.h"
#import "FUNetworkingHelper.h"

#import <SVProgressHUD.h>

static NSString * const kFUReuseIdentifier = @"FUStickerCell";

NSString * const FUSelectedStickerDidChangeNotification = @"FUSelectedStickerDidChangeNotification";

@interface FUStickersPageController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, copy) NSString *tag;

@property (nonatomic, copy) NSArray<FUStickerModel *> *stickers;

/// 选中贴纸
@property (nonatomic, strong) FUStickerModel *selectedSticker;

@end

@implementation FUStickersPageController

- (instancetype)initWithTag:(NSString *)tag {
    self = [super init];
    if (self) {
        self.tag = tag;
    }
    return self;
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    if ([FUNetworkingHelper currentNetworkStatus] == FUNetworkStatusReachable) {
        [self requestStickers];
    } else {
        [self loadLocalStickers];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedStickerChanged:) name:FUSelectedStickerDidChangeNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FUSelectedStickerDidChangeNotification object:nil];
}

#pragma mark - Instance methods

- (void)reloadData {
    [self.collectionView reloadData];
}

#pragma mark - Private methods

- (void)requestStickers {
    [FUStickerHelper itemListWithTag:self.tag completion:^(NSArray<FUStickerModel *> * _Nullable dataArray, NSError * _Nullable error) {
        if (!error) {
            self.stickers = [dataArray copy];
            [FUStickerHelper updateLocalStickersWithStickers:self.stickers tag:self.tag];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        } else {
            [self loadLocalStickers];
        }
    }];
}

- (void)loadLocalStickers {
    self.stickers = [FUStickerHelper localStickersWithTag:self.tag];
    [self.collectionView reloadData];
}

- (void)selectSticker:(FUStickerModel *)sticker {
    if (self.delegate && [self.delegate respondsToSelector:@selector(stickerPageController:didSelectSticker:)]) {
        [self.delegate stickerPageController:self didSelectSticker:sticker];
    }
}


#pragma mark - Event response

- (void)selectedStickerChanged:(NSNotification *)notification {
    if (!notification.object) {
        // 取消贴纸效果
        if (self.selectedSticker) {
            self.selectedSticker.selected = NO;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    } else {
        // 改变选中贴纸
        FUStickerModel *sticker = (FUStickerModel *)notification.object;
        if ([self.selectedSticker.tag isEqualToString:sticker.tag] && [self.selectedSticker.itemId isEqualToString:sticker.itemId]) {
            // 已经选中的情况
            return;
        }
        // 其他页面需要取消当前选择
        if (self.selectedSticker) {
            self.selectedSticker.selected = NO;
        }
        sticker.selected = YES;
        self.selectedSticker = sticker;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }
}

#pragma mark - Collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.stickers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    FUStickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFUReuseIdentifier forIndexPath:indexPath];
    FUStickerModel *model = self.stickers[indexPath.row] ;
    cell.model = model;
    cell.selected = model.isSelected;
    return cell;
}

#pragma mark - Collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FUStickerModel *sticker = self.stickers[indexPath.item];
    if (sticker.isSelected && [FUStickerHelper downloadStatusOfSticker:sticker]) {
        return;
    }
    // 直接选中新道具
    [self selectSticker:sticker];
    if (![FUStickerHelper downloadStatusOfSticker:sticker]) {
        if ([FUNetworkingHelper currentNetworkStatus] != FUNetworkStatusReachable) {
            [FUTipHUD showTips:FUNSLocalizedString(@"下载失败", nil)];
            return;
        }
        // 开始下载
        sticker.loading = YES;
        FUStickerCell *cell = (FUStickerCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [cell setModel:sticker];
        
        [self.qualityStickerManager downloadItem:sticker completion:^(NSError * _Nullable error) {
            sticker.loading = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                [collectionView reloadData];
            });
            if (!error) {
                // 下载完成以后加载贴纸
                if (self.delegate && [self.delegate respondsToSelector:@selector(stickerPageController:shouldLoadSticker:)]) {
                    [self.delegate stickerPageController:self shouldLoadSticker:sticker];
                }
            } else {
                NSLog(@"download fail");
                [FUTipHUD showTips:FUNSLocalizedString(@"下载失败", nil)];
            }
        }];
        
    } else {
        // 直接加载贴纸
        if (self.delegate && [self.delegate respondsToSelector:@selector(stickerPageController:shouldLoadSticker:)]) {
            [self.delegate stickerPageController:self shouldLoadSticker:sticker];
        }
    }
}

#pragma mark - Getters

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 22;
        flowLayout.minimumInteritemSpacing = (CGRectGetWidth(self.view.frame) - 287) / 4.f - 1;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.sectionInset = UIEdgeInsetsMake(16, 16, 5, 16);
        flowLayout.itemSize = CGSizeMake(51, 51);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        [self.collectionView registerNib:[UINib nibWithNibName:@"FUStickerCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kFUReuseIdentifier];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.allowsMultipleSelection = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}

@end
