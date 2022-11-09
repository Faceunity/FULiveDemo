//
//  FUCustomizedMakeupColorPicker.m
//  FUMakeupComponent
//
//  Created by 项林平 on 2022/9/14.
//

#import "FUCustomizedMakeupColorPicker.h"

static NSString * const kFUCustomizedMakeupColorCellIdentifier = @"FUCustomizedMakeupColorCell";

@interface FUCustomizedMakeupColorPicker ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation FUCustomizedMakeupColorPicker

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.collectionView];
        
        // 中间指示圈
        CAShapeLayer *layer = [CAShapeLayer new];
        layer.lineWidth = 4;
        layer.strokeColor = [UIColor whiteColor].CGColor;
        layer.fillColor = [UIColor clearColor].CGColor;
        CGFloat radius = 22;
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.collectionView.center radius:radius startAngle:0 endAngle:2.0f*M_PI clockwise:NO];
        layer.path = [path CGPath];
        [self.layer addSublayer:layer];
    }
    return self;
}

- (void)selectAtIndex:(NSUInteger)index {
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat y = index * 50 + 20 - CGRectGetHeight(self.collectionView.frame) / 2.0;
        CGPoint offset = CGPointMake(0, y);
        [self.collectionView setContentOffset:offset animated:YES];
    });
}

- (void)setColors:(NSArray<NSArray<NSNumber *> *> *)colors {
    _colors = colors;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.colors.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FUCustomizedMakeupColorCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFUCustomizedMakeupColorCellIdentifier forIndexPath:indexPath];
    cell.color = self.colors[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self selectAtIndex:indexPath.item];
    if (self.delegate && [self.delegate respondsToSelector:@selector(colorPickerDidSelectColorAtIndex:)]) {
        [self.delegate colorPickerDidSelectColorAtIndex:indexPath.item];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(40, 40);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSUInteger index = (scrollView.contentOffset.y + CGRectGetHeight(self.collectionView.frame)/2.0 - 20)/50.0;
    if (self.delegate && [self.delegate respondsToSelector:@selector(colorPickerDidSelectColorAtIndex:)]) {
        [self.delegate colorPickerDidSelectColorAtIndex:index];
    }
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - 40) / 2.0, 0, 40, CGRectGetHeight(self.frame)) collectionViewLayout:[[FUCustomizedMakeupColorFlowLayout alloc] init]];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView setContentInset:UIEdgeInsetsMake(CGRectGetHeight(_collectionView.bounds)/2.0, 0, CGRectGetHeight(_collectionView.bounds)/2.0, 0)];
        [_collectionView registerClass:[FUCustomizedMakeupColorCell class] forCellWithReuseIdentifier:kFUCustomizedMakeupColorCellIdentifier];
    }
    return _collectionView;
}

@end

@implementation FUCustomizedMakeupColorCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = frame.size.width / 2;
        self.layer.masksToBounds = YES;
        [self setupSubviews];
    }
    return self;
}

-(void)setupSubviews {
    float h1 = self.frame.size.width;
    float h2 = self.frame.size.width / 2;
    float h3 = self.frame.size.width / 3;

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0 * h2, 0 * h2, h2, h2)];
    view.tag = 400;
    [self.contentView addSubview:view];
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0 * h2, 1 * h2, h2, h2)];
    view1.tag = 401;
    [self.contentView addSubview:view1];
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(1 * h2, 0 * h2, h2, h2)];
    view2.tag = 402;
    [self.contentView addSubview:view2];
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(1 * h2, 1 * h2, h2, h2)];
    view3.tag = 403;
    [self.contentView addSubview:view3];

    UIView *view4 = [[UIView alloc] initWithFrame:CGRectMake(0 ,0 * h3, h1, h3)];
    view4.tag = 300;
    [self.contentView addSubview:view4];
    UIView *view5 = [[UIView alloc] initWithFrame:CGRectMake(0, 1 * h3, h1, h3)];
    view5.tag = 301;
    [self.contentView addSubview:view5];
    UIView *view6 = [[UIView alloc] initWithFrame:CGRectMake(0, 2 * h3, h1, h3)];
    view6.tag = 302;
    [self.contentView addSubview:view6];
    
    UIView *view7 = [[UIView alloc] initWithFrame:CGRectMake(0 ,0 * h2, h1, h2)];
    view7.tag = 200;
    [self.contentView addSubview:view7];
    UIView *view8 = [[UIView alloc] initWithFrame:CGRectMake(0, 1 * h2, h1, h2)];
    view8.tag = 201;
    [self.contentView addSubview:view8];
}

- (void)setColor:(NSArray<NSNumber *> *)color {
    for (UIView *view in self.contentView.subviews) {
        view.hidden = YES;
    }
    self.contentView.backgroundColor = [UIColor clearColor];
    
    NSMutableArray *mutArray = [NSMutableArray array];
    int colorNum = (int)color.count / 4;

    for (int i = 0; i < colorNum; i ++) {
        if([color[i * 4 + 3] intValue] == 1){
            [mutArray addObject:color[i * 4]];
            [mutArray addObject:color[i * 4 + 1]];
            [mutArray addObject:color[i * 4 + 2]];
            [mutArray addObject:color[i * 4 + 3]];
        }
    }
    
    int alphaNum = (int)mutArray.count / 4;
    if (alphaNum == 4) {
        for (int i = 0; i < 4; i ++) {
            float R = [color[i * 4 ] floatValue];
            float G = [color[i * 4 + 1] floatValue];
            float B = [color[i * 4 + 2] floatValue];
            float A = [color[i * 4 + 3] floatValue];
    
            UIView *view = [self.contentView viewWithTag:400 + i];
            view.hidden = NO;
            view.backgroundColor = [UIColor colorWithRed:R green:G blue:B alpha:A];
            [self.contentView bringSubviewToFront:view];
        }
    }
    
    
    if (alphaNum == 3) {
        for (int i = 0; i < 3; i ++) {
            float R = [color[i * 4 ] floatValue];
            float G = [color[i * 4 + 1] floatValue];
            float B = [color[i * 4 + 2] floatValue];
            float A = [color[i * 4 + 3] floatValue];
            
            UIView *view = [self.contentView viewWithTag:300 + i];
            view.hidden = NO;
            view.backgroundColor = [UIColor colorWithRed:R green:G blue:B alpha:A];
            [self.contentView bringSubviewToFront:view];
        }
    }
    
    if (alphaNum == 2) {
        for (int i = 0; i < 3; i ++) {
            float R = [color[i * 4 ] floatValue];
            float G = [color[i * 4 + 1] floatValue];
            float B = [color[i * 4 + 2] floatValue];
            float A = [color[i * 4 + 3] floatValue];
            
            UIView *view = [self.contentView viewWithTag:200 + i];
            view.hidden = NO;
            view.backgroundColor = [UIColor colorWithRed:R green:G blue:B alpha:A];
            [self.contentView bringSubviewToFront:view];
        }
    }
    
    if (alphaNum == 1) {
        float R = [color[0] floatValue];
        float G = [color[1] floatValue];
        float B = [color[2] floatValue];
        float A = [color[3] floatValue];
        
        self.contentView.backgroundColor = [UIColor colorWithRed:R green:G blue:B alpha:A];
    }
}

@end

@implementation FUCustomizedMakeupColorFlowLayout

//当布局刷新的时候会自动调用这个方法
-(void)prepareLayout{
    [super prepareLayout];
    //修改滚动方向 为水平方向来滚动
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    //获取对应UICollectionView的Size
    CGSize collectionSize = self.collectionView.frame.size;
    
    //定义显示ITEM的 宽 高
    CGFloat itemWidth = collectionSize.width*0.6;
    CGFloat itemHeight = collectionSize.width*0.6;
    
    //修改ITEM大小
    self.itemSize = CGSizeMake(itemWidth, itemHeight);
}

//返回所的有的Item对应的属性设置
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    //取出所有的Item对应的属性
    NSArray *superAttributesArray = [[NSArray alloc] initWithArray:[super layoutAttributesForElementsInRect:rect] copyItems:YES];
    
    //计算中心点
    CGFloat screenCenter = self.collectionView.contentOffset.y+self.collectionView.frame.size.height/2;
    //循环设置Item 的属性
    
    for (UICollectionViewLayoutAttributes  *attributes in superAttributesArray) {
        //计算 差值
        CGFloat deltaMargin = ABS(screenCenter - attributes.center.y);
        //计算放大比例
        CGFloat scale = 1 - deltaMargin/(self.collectionView.frame.size.height/2+attributes.size.height) * 0.9;
        //设置
        attributes.transform = CGAffineTransformMakeScale(scale, scale);
    }
    return superAttributesArray;
}

//当手指离开屏幕时会调用此方法
-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    //取出屏幕的中心点
    CGFloat screenCenter = proposedContentOffset.y +self.collectionView.frame.size.height/2;
    //取出可见范围内的Cell
    CGRect visibleRect = CGRectZero;
    visibleRect.size = self.collectionView.frame.size;
    visibleRect.origin = proposedContentOffset;
    
    NSArray *visibleArray = [[NSArray alloc] initWithArray:[super layoutAttributesForElementsInRect:visibleRect] copyItems:YES];
    
    CGFloat minMargin = MAXFLOAT;
    
    for (UICollectionViewLayoutAttributes *attributes in visibleArray) {
        CGFloat deltaMargin = attributes.center.y - screenCenter;
        if (ABS(minMargin)>ABS(deltaMargin)) {
            minMargin = deltaMargin;
        }
    }
    return CGPointMake(proposedContentOffset.x, proposedContentOffset.y + minMargin);
}

//当屏幕的可见范围发生变化 的时候
//重新刷新视图
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

@end
