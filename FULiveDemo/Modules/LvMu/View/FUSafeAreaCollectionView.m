//
//  FUSafeAreaCollectionView.m
//  FULiveDemo
//
//  Created by 项林平 on 2021/8/10.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUSafeAreaCollectionView.h"
#import "UIColor+FU.h"
#import "FUGreenScreenSafeAreaModel.h"

@implementation FUSafeAreaCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 54, 54)];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.layer.masksToBounds = YES ;
        self.imageView.layer.cornerRadius = 3.0;
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.imageView.layer.borderWidth = 2;
        self.imageView.layer.borderColor = [UIColor colorWithHexColorString:@"5EC7FE"].CGColor;
    } else {
        self.imageView.layer.borderWidth = 0.0;
        self.imageView.layer.borderColor = [UIColor clearColor].CGColor;
    }
}

@end

@interface FUSafeAreaCollectionView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, copy) NSArray<FUGreenScreenSafeAreaModel *> *safeAreas;

@end

static NSString * const kFUSafeAreaCellIdentifierKey = @"FUSafeAreaCellIdentifier";

@implementation FUSafeAreaCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.showsHorizontalScrollIndicator = NO;
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[FUSafeAreaCell class] forCellWithReuseIdentifier:kFUSafeAreaCellIdentifierKey];
        
        // 默认选中Cancel
        _selectedIndex = 1;
    }
    return self;
}

- (void)reloadSafeAreas {
    NSMutableArray<FUGreenScreenSafeAreaModel *> *models = [[NSMutableArray alloc] init];
    if ([FUGreenScreenManager localSafeAreaImage]) {
        // 存在本地自定义
        FUGreenScreenSafeAreaModel *model = [[FUGreenScreenSafeAreaModel alloc] init];
        model.iconImage = [FUGreenScreenManager localSafeAreaImage];
        model.effectImage = model.iconImage;
        [models addObject:model];
    }
    FUGreenScreenSafeAreaModel *model1 = [[FUGreenScreenSafeAreaModel alloc] init];
    model1.iconImage = [UIImage imageNamed:@"demo_icon_safe_area_1"];
    model1.effectImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"safe_area_1" ofType:@"jpg"]];
    [models addObject:model1];
    
    FUGreenScreenSafeAreaModel *model2 = [[FUGreenScreenSafeAreaModel alloc] init];
    model2.iconImage = [UIImage imageNamed:@"demo_icon_safe_area_2"];
    model2.effectImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"safe_area_2" ofType:@"jpg"]];
    [models addObject:model2];
    self.safeAreas = [models copy];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadData];
    });
}

#pragma mark - Collection view data source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.safeAreas.count + 3;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FUSafeAreaCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFUSafeAreaCellIdentifierKey forIndexPath:indexPath];
    switch (indexPath.item) {
        case 0:{
            // 返回
            cell.imageView.image = [UIImage imageNamed:@"demo_icon_returns"];
        }
            break;
        case 1:{
            cell.imageView.image = [UIImage imageNamed:@"demo_icon_cancel"];
        }
            break;
        case 2:{
            cell.imageView.image = [UIImage imageNamed:@"demo_icon_add"];
        }
            break;
        default:{
            cell.imageView.image = self.safeAreas[indexPath.item - 3].iconImage;
        }
            break;
    }
    cell.selected = indexPath.item == self.selectedIndex;
    return cell;
}

#pragma mark - Collection view delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == self.selectedIndex) {
        return;
    }
    switch (indexPath.item) {
        case 0:{
            // Back
            [collectionView deselectItemAtIndexPath:indexPath animated:NO];
            if (self.safeAreaDelegate && [self.safeAreaDelegate respondsToSelector:@selector(safeAreaCollectionViewDidClickBack:)]) {
                [self.safeAreaDelegate safeAreaCollectionViewDidClickBack:self];
            }
        }
            break;
        case 1:{
            // Cancel
            _selectedIndex = 1;
            if (self.safeAreaDelegate && [self.safeAreaDelegate respondsToSelector:@selector(safeAreaCollectionViewDidClickCancel:)]) {
                [self.safeAreaDelegate safeAreaCollectionViewDidClickCancel:self];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [collectionView reloadData];
                [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            });
        }
            break;
        case 2:{
            // Add
            [collectionView deselectItemAtIndexPath:indexPath animated:NO];
            if (self.safeAreaDelegate && [self.safeAreaDelegate respondsToSelector:@selector(safeAreaCollectionViewDidClickAdd:)]) {
                [self.safeAreaDelegate safeAreaCollectionViewDidClickAdd:self];
            }
        }
            break;
        default:{
            _selectedIndex = indexPath.item;
            if (self.safeAreaDelegate && [self.safeAreaDelegate respondsToSelector:@selector(safeAreaCollectionView:didSelectItemAtIndex:)]) {
                [self.safeAreaDelegate safeAreaCollectionView:self didSelectItemAtIndex:indexPath.item];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [collectionView reloadData];
                [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            });
        }
            break;
    }
}

@end
