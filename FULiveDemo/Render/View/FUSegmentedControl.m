//
//  FUSegmentedControl.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/10/19.
//

#import "FUSegmentedControl.h"

static NSString * const kFUSegmentedCellIdentifierKey = @"FUSegmentedCellIdentifier";

@interface FUSegmentedControl ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *segmentedCollection;

@end

@implementation FUSegmentedControl

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame items:nil];
}

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray<NSString *> *)items {
    self = [super initWithFrame:frame];
    if (self) {
        _items = items;
        _titleColor = [UIColor whiteColor];
        _selectedTitleColor = [UIColor blackColor];
        _titleFont = [UIFont systemFontOfSize:11 weight:UIFontWeightMedium];
        
        [self addSubview:self.segmentedCollection];
        [self.segmentedCollection mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FUSegmentedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFUSegmentedCellIdentifierKey forIndexPath:indexPath];
    cell.textColor = self.titleColor;
    cell.selectedTextColor = self.selectedTitleColor;
    cell.textLabel.font = self.titleFont;
    cell.textLabel.text = self.items[indexPath.item];
    cell.selected = indexPath.item == self.selectedIndex;
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CGRectGetWidth(self.frame) / self.items.count, CGRectGetHeight(self.frame));
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == self.selectedIndex) {
        return;
    }
    self.selectedIndex = indexPath.item;
    if (self.selectHandler) {
        self.selectHandler(self.selectedIndex);
    }
}

#pragma mark - Setters

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    if (selectedIndex < 0 || selectedIndex >= self.items.count) {
        return;
    }
    _selectedIndex = selectedIndex;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.segmentedCollection reloadData];
        [self.segmentedCollection selectItemAtIndexPath:[NSIndexPath indexPathForItem:selectedIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    });
}

- (void)setItems:(NSArray<NSString *> *)items {
    if (items.count == 0) {
        return;
    }
    _items = items;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.segmentedCollection reloadData];
    });
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.segmentedCollection reloadData];
    });
}

- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor {
    _selectedTitleColor = selectedTitleColor;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.segmentedCollection reloadData];
    });
}

- (void)setTitleFont:(UIFont *)titleFont {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.segmentedCollection reloadData];
    });
}

#pragma mark - Getters

- (UICollectionView *)segmentedCollection {
    if (!_segmentedCollection) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _segmentedCollection = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _segmentedCollection.showsVerticalScrollIndicator = NO;
        _segmentedCollection.showsHorizontalScrollIndicator = NO;
        _segmentedCollection.backgroundColor = [UIColor clearColor];
        _segmentedCollection.dataSource = self;
        _segmentedCollection.delegate = self;
        [_segmentedCollection registerClass:[FUSegmentedCell class] forCellWithReuseIdentifier:kFUSegmentedCellIdentifierKey];
    }
    return _segmentedCollection;
}

@end


@interface FUSegmentedCell ()

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation FUSegmentedCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.textLabel];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.textLabel.textColor = self.selectedTextColor ?: FUColorFromHex(0x2C2E30);
        self.backgroundColor = [UIColor whiteColor];
    } else {
        self.textLabel.textColor = self.textColor ?: [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
    }
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
    }
    return _textLabel;
}

@end
