//
//  FUBeautyStyleView.m
//  FUBeautyComponent
//
//  Created by 项林平 on 2022/6/21.
//

#import "FUBeautyStyleView.h"

#import "FUBeautyDefine.h"

static NSString * const kFUBeautyStyleCellIdentifier = @"FUBeautyStyleCell";

@interface FUBeautyStyleView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *styleCollectionView;

@property (nonatomic, strong) FUBeautyStyleViewModel *viewModel;

@end

@implementation FUBeautyStyleView

#pragma mark - Initializer

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame viewModel:[[FUBeautyStyleViewModel alloc] init]];
}

- (instancetype)initWithFrame:(CGRect)frame viewModel:(FUBeautyStyleViewModel *)viewModel {
    self = [super initWithFrame:frame];
    if (self) {
        self.viewModel = viewModel;
        [self configureUI];
    }
    return self;
}

#pragma mark - UI

- (void)configureUI {
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    [self addSubview:effectView];
    
    [self addSubview:self.styleCollectionView];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.styleCollectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:self.styleCollectionView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:self.styleCollectionView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.styleCollectionView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:98];
    [self addConstraints:@[bottom, leading, trailing]];
    [self.styleCollectionView addConstraint:height];
    
    // 默认选中
    [self.styleCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:self.viewModel.selectedIndex inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
}

#pragma mark - Collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.beautyStyles.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FUBeautyStyleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFUBeautyStyleCellIdentifier forIndexPath:indexPath];
    FUBeautyStyleModel *style = self.viewModel.beautyStyles[indexPath.item];
    cell.imageName = style.name;
    cell.textLabel.text = FUBeautyStringWithKey(style.name);
    cell.selected = indexPath.item == self.viewModel.selectedIndex;
    return cell;
}

#pragma mark - Collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.viewModel.selectedIndex == indexPath.item) {
        return;
    }
    if (self.viewModel.selectedIndex == 0) {
        // 从未选择风格到选择风格
        self.viewModel.selectedIndex = indexPath.item;
        if (self.delegate && [self.delegate respondsToSelector:@selector(beautyStyleViewDidSelectStyle)]) {
            [self.delegate beautyStyleViewDidSelectStyle];
        }
    } else if (indexPath.item == 0) {
        // 取消选择
        self.viewModel.selectedIndex = 0;
        if (self.delegate && [self.delegate respondsToSelector:@selector(beautyStyleViewDidCancelStyle)]) {
            [self.delegate beautyStyleViewDidCancelStyle];
        }
    } else {
        self.viewModel.selectedIndex = indexPath.item;
    }
}


#pragma mark - Getters

- (UICollectionView *)styleCollectionView {
    if (!_styleCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(54, 70);
        layout.minimumLineSpacing = 16;
        layout.minimumInteritemSpacing = 50;
        layout.sectionInset = UIEdgeInsetsMake(16, 18, 10, 18);
        _styleCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _styleCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
        _styleCollectionView.backgroundColor = [UIColor clearColor];
        _styleCollectionView.showsHorizontalScrollIndicator = NO;
        _styleCollectionView.dataSource = self;
        _styleCollectionView.delegate = self;
        [_styleCollectionView registerClass:[FUBeautyStyleCell class] forCellWithReuseIdentifier:kFUBeautyStyleCellIdentifier];
    }
    return _styleCollectionView;
}

@end

@interface FUBeautyStyleCell ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation FUBeautyStyleCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
        NSLayoutConstraint *imageTop = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        NSLayoutConstraint *imageLeading = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
        NSLayoutConstraint *imageTrailing = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
        NSLayoutConstraint *imageHeight = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
        [self.contentView addConstraints:@[imageTop, imageLeading, imageTrailing]];
        [self.imageView addConstraint:imageHeight];
        
        [self.contentView addSubview:self.textLabel];
        NSLayoutConstraint *textTop = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute:NSLayoutAttributeBottom multiplier:1 constant:2];
        NSLayoutConstraint *textLeading = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
        NSLayoutConstraint *textTrailing = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
        [self.contentView addConstraints:@[textTop, textLeading, textTrailing]];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.imageView.image = selected ? FUBeautyImageNamed([NSString stringWithFormat:@"%@-2", self.imageName]) : FUBeautyImageNamed([NSString stringWithFormat:@"%@-0", self.imageName]);
    self.textLabel.textColor = selected ? [UIColor colorWithRed:94/255.0 green:199/255.0 blue:254/255.0 alpha:1] : [UIColor whiteColor];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _imageView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.font = [UIFont systemFontOfSize:10];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _textLabel;
}

@end
