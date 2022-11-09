//
//  FUFaceFusionCell.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/8/17.
//

#import "FUFaceFusionCell.h"

@interface FUFaceFusionCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation FUFaceFusionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

@end
