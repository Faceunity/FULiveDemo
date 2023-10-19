//
//  FUItemsView.m
//  FUCommonUIComponent
//
//  Created by 项林平 on 2022/6/24.
//

#import "FUItemsView.h"
#import "FUItemCell.h"

static NSString * const kFUItemCellIdentifier = @"FUItemCell";

@interface FUItemsView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) CGFloat collectionTopConstant;

@end

@implementation FUItemsView

#pragma mark - Initializer

- (instancetype)initWithFrame:(CGRect)frame topSpacing:(CGFloat)topSpacing {
    self = [super initWithFrame:frame];
    if (self) {
        self.collectionTopConstant = topSpacing;
        [self configureUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self configureUI];
    }
    return self;
}

#pragma mark - UI

- (void)configureUI {
    self.backgroundColor = [UIColor clearColor];
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:effectView];
    NSLayoutConstraint *effectLeading = [NSLayoutConstraint constraintWithItem:effectView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    NSLayoutConstraint *effectTrailing = [NSLayoutConstraint constraintWithItem:effectView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    NSLayoutConstraint *effectTop = [NSLayoutConstraint constraintWithItem:effectView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *effectBottom = [NSLayoutConstraint constraintWithItem:effectView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self addConstraints:@[effectLeading, effectTrailing, effectTop, effectBottom]];
    
    [self addSubview:self.collectionView];
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.collectionTopConstant];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:84];
    [self addConstraints:@[leading, trailing, top]];
    [self.collectionView addConstraint:height];
    
    _selectedIndex = -1;
}

#pragma mark - Instance methods

- (void)startAnimation {
    if (_selectedIndex < 0 && _selectedIndex >= self.items.count) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        FUItemCell *selectedCell = (FUItemCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex inSection:0]];
        if (selectedCell) {
            [selectedCell.indicatorView startAnimating];
            self.collectionView.userInteractionEnabled = NO;
        }
    });
}

- (void)stopAnimation {
    if (_selectedIndex < 0 && _selectedIndex >= self.items.count) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        FUItemCell *selectedCell = (FUItemCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex inSection:0]];
        if (selectedCell) {
            [selectedCell.indicatorView stopAnimating];
            self.collectionView.userInteractionEnabled = YES;
        }
    });
}

#pragma mark - Private methods

- (UIImage *)imageWithImageName:(NSString *)imageName {
    UIImage *resultImage = [UIImage imageNamed:imageName];
    if (!resultImage) {
        NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
        resultImage = [UIImage imageWithContentsOfFile:path];
    }
    if (!resultImage) {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", imageName]];
        resultImage = [UIImage imageWithContentsOfFile:path];
    }
    return resultImage;
}

#pragma mark - Collection view data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FUItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFUItemCellIdentifier forIndexPath:indexPath];
    NSString *item = self.items[indexPath.item];
    cell.imageView.image = [self imageWithImageName:item];
    return cell;
}

#pragma mark - Collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == _selectedIndex) {
        return;
    }
    _selectedIndex = indexPath.item;
    if (self.delegate && [self.delegate respondsToSelector:@selector(itemsView:didSelectItemAtIndex:)]) {
        [self.delegate itemsView:self didSelectItemAtIndex:indexPath.item];
    }
}

#pragma mark - Collection view delegate flow layout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(60, 60);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(12, 16, 12, 16);
}

#pragma mark - Setters

- (void)setItems:(NSArray<NSString *> *)items {
    _items = items;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (selectedIndex < 0 || selectedIndex >= self.items.count) {
        return;
    }
    _selectedIndex = selectedIndex;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:selectedIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        if (self.delegate && [self.delegate respondsToSelector:@selector(itemsView:didSelectItemAtIndex:)]) {
            [self.delegate itemsView:self didSelectItemAtIndex:selectedIndex];
        }
    });
}

#pragma mark - Getters

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[FUItemCell class] forCellWithReuseIdentifier:kFUItemCellIdentifier];
    }
    return _collectionView;
}

@end
