//
//  FUStyleSelView.m
//  FULiveDemo
//
//  Created by 孙慕 on 2021/2/19.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUStyleSelView.h"

@interface FUStyleSelView()

@property (strong, nonatomic) NSArray *titles;
@end


@implementation FUStyleSelView


- (void)setDataTitles:(NSArray *)titles{
    _titles = titles;
    [self.collection reloadData];
}

-(NSInteger)collectionViewCellNumber{
    return _titles.count;
}

-(void)registerCellClass{
    [self.collection registerClass:[FUStyleViewCell class] forCellWithReuseIdentifier:@"styleViewCell"];
}

-(UICollectionViewCell *)dequeueReusableCellIndexPath:(NSIndexPath *)indexPath{
    FUStyleViewCell *cell = [self.collection dequeueReusableCellWithReuseIdentifier:@"styleViewCell" forIndexPath:indexPath];

    cell.titleLabel.text = _titles[indexPath.row];
    return cell;
}


@end


@implementation FUStyleViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.layer.cornerRadius = frame.size.width / 2;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor blackColor];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:self.bounds];

        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:24];
        self.titleLabel.textColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.titleLabel];
        
        _indicator = [[UIActivityIndicatorView alloc] initWithFrame:frame];
        [self.contentView addSubview:_indicator];
        
    }
    
    return self;
}


@end
