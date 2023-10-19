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
        NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:self.segmentedCollection attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
        NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:self.segmentedCollection attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.segmentedCollection attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.segmentedCollection attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        [self addConstraints:@[leading, trailing, top, bottom]];
    }
    return self;
}

- (void)refreshUI {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.segmentedCollection reloadData];
        if (self.selectedIndex >= 0 && self.selectedIndex < self.items.count) {
            [self.segmentedCollection selectItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
    });
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

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentedControlShouldSelectItemAtIndex:)]) {
        return [self.delegate segmentedControlShouldSelectItemAtIndex:indexPath.item];
    }
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == self.selectedIndex) {
        return;
    }
    self.selectedIndex = indexPath.item;
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentedControlDidSelectAtIndex:)]) {
        [self.delegate segmentedControlDidSelectAtIndex:indexPath.item];
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
        _segmentedCollection.translatesAutoresizingMaskIntoConstraints = NO;
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
        
        NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
        NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
        [self addConstraints:@[centerX, centerY]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.textLabel.textColor = self.selectedTextColor ?: [UIColor colorWithRed:44/255.0 green:46/255.0 blue:48/255.0 alpha:1];
        self.backgroundColor = [UIColor whiteColor];
    } else {
        self.textLabel.textColor = self.textColor ?: [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
    }
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _textLabel;
}

@end
