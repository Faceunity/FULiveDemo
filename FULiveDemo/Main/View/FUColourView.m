//
//  FUColourView.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/5/31.
//  Copyright © 2019 FaceUnity. All rights reserved.
//

#import "FUColourView.h"
#import "FUColourFlowLayout.h"

static const float cellW = 40;
@interface FUColourView()<UICollectionViewDelegate,UICollectionViewDataSource>
/** UICollectionView */
@property (strong, nonatomic) UICollectionView *collection;

@property (strong, nonatomic) NSArray <NSArray *>*colors;
@end


@implementation FUColourView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
//    self.backgroundColor = [UIColor colorWithRed:5/255.0 green:15/255.0 blue:20/255.0 alpha:0.74];
    
    /* 颜色collection */
    FUColourFlowLayout *layout = [[FUColourFlowLayout alloc] init];
    _collection = [[UICollectionView alloc] initWithFrame:CGRectMake((self.frame.size.width - cellW)/2, 0, cellW, self.frame.size.height) collectionViewLayout:layout];
    _collection.backgroundColor = [UIColor clearColor];
    _collection.delegate = self;
    _collection.dataSource = self;
    _collection.showsVerticalScrollIndicator = NO;

    CGFloat collectionViewHeight = CGRectGetHeight(_collection.bounds);
    [_collection setContentInset:UIEdgeInsetsMake(collectionViewHeight/2, 0, collectionViewHeight/2,0)];
    [self addSubview:_collection];
    [_collection registerClass:[FUColourViewCell class] forCellWithReuseIdentifier:@"colourViewCell"];
    
    [self setSelCell:4];
    
    /* 中间指示圈 */
    CAShapeLayer *layer = [CAShapeLayer new];
    layer.lineWidth = 4;
    layer.strokeColor = [UIColor whiteColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    CGFloat radius = cellW/2 + 2;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.collection.center radius:radius startAngle:0 endAngle:2.0f*M_PI clockwise:NO];
    layer.path = [path CGPath];
    [self.layer addSublayer:layer];
}

- (void)setDataColors:(NSArray <NSArray*>*)colors{
    _colors = colors;
    [_collection reloadData];
}

-(void)setSelCell:(int)index{
    float y = index * (cellW + 10) + cellW / 2 - self.collection.frame.size.height / 2;
    CGPoint offset = CGPointMake(0,y);
    [self.collection setContentOffset:offset animated:YES];
}

#pragma mark --- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _colors.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FUColourViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"colourViewCell" forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor greenColor];
//    NSString *imageName = self.dataArray[indexPath.row].imageName ;
//
//    cell.topImage.image = [UIImage imageNamed:imageName] ;
//    cell.botlabel.text = self.dataArray[indexPath.row].title;
    [cell setColors:_colors[indexPath.row]];
    
    return cell;
}

#pragma mark --- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(cellW, cellW) ;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat collectionViewHeight = CGRectGetHeight(self.collection.frame);
    [collectionView setContentInset:UIEdgeInsetsMake(collectionViewHeight / 2, 0, collectionViewHeight / 2, 0)];
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    CGPoint offset = CGPointMake(0,  cell.center.y - collectionViewHeight / 2);
    [collectionView setContentOffset:offset animated:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(colourViewDidSelIndex:)]) {
        [self.delegate colourViewDidSelIndex:(int)indexPath.row];
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // 选中\点击对应的按钮
    NSUInteger index = (scrollView.contentOffset.y + self.collection.frame.size.height / 2 - cellW / 2) / (cellW + 10);
    if (self.delegate && [self.delegate respondsToSelector:@selector(colourViewDidSelIndex:)]) {
        [self.delegate colourViewDidSelIndex:(int)index];
    }
}

@end


@implementation FUColourViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupAllBgColorView];
        self.layer.cornerRadius = frame.size.width / 2;
        self.layer.masksToBounds = YES;

    }
    
    return self;
}

-(void)setupAllBgColorView{
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

/* 设置背景颜色 */
-(void)setColors:(NSArray *)array{
    
    for (UIView *view in self.contentView.subviews) {
        view.hidden = YES;
    }
    self.contentView.backgroundColor = [UIColor clearColor];
    
    NSMutableArray *mutArray = [NSMutableArray array];
    int colorNum = (int)array.count / 4;

    for (int i = 0; i < colorNum; i ++) {
        if([array[i * 4 + 3] intValue] == 1){
            [mutArray addObject:array[i * 4]];
            [mutArray addObject:array[i * 4 + 1]];
            [mutArray addObject:array[i * 4 + 2]];
            [mutArray addObject:array[i * 4 + 3]];
        }
    }
    
    int alphaNum = (int)mutArray.count / 4;
    if (alphaNum == 4) {
        for (int i = 0; i < 4; i ++) {
            float R = [array[i * 4 ] floatValue];
            float G = [array[i * 4 + 1] floatValue];
            float B = [array[i * 4 + 2] floatValue];
            float A = [array[i * 4 + 3] floatValue];
    
            UIView *view = [self.contentView viewWithTag:400 + i];
            view.hidden = NO;
            view.backgroundColor = [UIColor colorWithRed:R green:G blue:B alpha:A];
            [self.contentView bringSubviewToFront:view];
        }
    }
    
    
    if (alphaNum == 3) {
        for (int i = 0; i < 3; i ++) {
            float R = [array[i * 4 ] floatValue];
            float G = [array[i * 4 + 1] floatValue];
            float B = [array[i * 4 + 2] floatValue];
            float A = [array[i * 4 + 3] floatValue];
            
            UIView *view = [self.contentView viewWithTag:300 + i];
            view.hidden = NO;
            view.backgroundColor = [UIColor colorWithRed:R green:G blue:B alpha:A];
            [self.contentView bringSubviewToFront:view];
        }
    }
    
    if (alphaNum == 2) {
        for (int i = 0; i < 3; i ++) {
            float R = [array[i * 4 ] floatValue];
            float G = [array[i * 4 + 1] floatValue];
            float B = [array[i * 4 + 2] floatValue];
            float A = [array[i * 4 + 3] floatValue];
            
            UIView *view = [self.contentView viewWithTag:200 + i];
            view.hidden = NO;
            view.backgroundColor = [UIColor colorWithRed:R green:G blue:B alpha:A];
            [self.contentView bringSubviewToFront:view];
        }
    }
    
    if (alphaNum == 1) {
        float R = [array[0] floatValue];
        float G = [array[1] floatValue];
        float B = [array[2] floatValue];
        float A = [array[3] floatValue];
        
        self.contentView.backgroundColor = [UIColor colorWithRed:R green:G blue:B alpha:A];
    }
    
}

@end
