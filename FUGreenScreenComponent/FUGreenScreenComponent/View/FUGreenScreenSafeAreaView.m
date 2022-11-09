//
//  FUGreenScreenSafeAreaView.m
//  FUGreenScreenComponent
//
//  Created by 项林平 on 2021/8/10.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUGreenScreenSafeAreaView.h"
#import "FUGreenScreenDefine.h"

@interface FUGreenScreenSafeAreaView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) FUGreenScreenSafeAreaViewModel *viewModel;

@end

static NSString * const kFUGreenScreenSafeAreaCellIdentifierKey = @"FUGreenScreenSafeAreaCellIdentifier";

@implementation FUGreenScreenSafeAreaView

- (instancetype)initWithFrame:(CGRect)frame viewModel:(FUGreenScreenSafeAreaViewModel *)viewModel {
    self = [super initWithFrame:frame];
    if (self) {
        self.viewModel = viewModel;

        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        [self addSubview:effectView];
        
        [self addSubview:self.collectionView];
        
        [self refreshSafeAreas];
    }
    return self;
}

- (void)refreshSafeAreas {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:self.viewModel.selectedIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    });
}

#pragma mark - Collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.safeAreaArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FUGreenScreenSafeAreaCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFUGreenScreenSafeAreaCellIdentifierKey forIndexPath:indexPath];
    cell.imageView.image = [self.viewModel safeAreaIconAtIndex:indexPath.item];
    return cell;
}

#pragma mark - Collection view delegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 0) {
        // Back
        if (self.delegate && [self.delegate respondsToSelector:@selector(safeAreaCollectionViewDidClickBack)]) {
            [self.delegate safeAreaCollectionViewDidClickBack];
        }
        [self refreshSafeAreas];
        return NO;
    } else if (indexPath.item == 2) {
        // Add
        if (self.delegate && [self.delegate respondsToSelector:@selector(safeAreaCollectionViewDidClickAdd)]) {
            [self.delegate safeAreaCollectionViewDidClickAdd];
        }
        [self refreshSafeAreas];
        return NO;
    }
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == self.viewModel.selectedIndex) {
        return;
    }
    self.viewModel.selectedIndex = indexPath.item;
    switch (indexPath.item) {
        case 1:{
            // Cancel
            if (self.delegate && [self.delegate respondsToSelector:@selector(safeAreaCollectionViewDidClickCancel)]) {
                [self.delegate safeAreaCollectionViewDidClickCancel];
            }
        }
            break;
        default:{
            if (self.delegate && [self.delegate respondsToSelector:@selector(safeAreaCollectionViewDidSelectItemAtIndex:)]) {
                [self.delegate safeAreaCollectionViewDidSelectItemAtIndex:indexPath.item];
            }
        }
            break;
    }
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
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) collectionViewLayout:layout];
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[FUGreenScreenSafeAreaCell class] forCellWithReuseIdentifier:kFUGreenScreenSafeAreaCellIdentifierKey];
    }
    return _collectionView;
}

@end

@interface FUGreenScreenSafeAreaCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation FUGreenScreenSafeAreaCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 54, 54)];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.layer.masksToBounds = YES;
        self.imageView.layer.cornerRadius = 3.0;
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.imageView.layer.borderWidth = selected ? 2 : 0;
    self.imageView.layer.borderColor = selected ? [UIColor colorWithRed:94/255.0 green:199/255.0 blue:254/255.0 alpha:1].CGColor : [UIColor clearColor].CGColor;
}

@end
