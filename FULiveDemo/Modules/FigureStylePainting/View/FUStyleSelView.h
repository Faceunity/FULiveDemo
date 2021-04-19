//
//  FUStyleSelView.h
//  FULiveDemo
//
//  Created by 孙慕 on 2021/2/19.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUSwipeSelView.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUStyleSelView : FUSwipeSelView

- (void)setDataTitles:(NSArray *)titles;

@end

@interface FUStyleViewCell : UICollectionViewCell

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIActivityIndicatorView *indicator;

@end


NS_ASSUME_NONNULL_END
