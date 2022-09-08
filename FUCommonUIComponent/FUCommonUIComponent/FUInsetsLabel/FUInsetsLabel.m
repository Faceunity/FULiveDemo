//
//  FUInsetsLabel.m
//  FUCommonUIComponent
//
//  Created by 项林平 on 2022/6/20.
//

#import "FUInsetsLabel.h"

@interface FUInsetsLabel ()

@property (nonatomic) UIEdgeInsets insets;

@end

@implementation FUInsetsLabel

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame insets:UIEdgeInsetsMake(8, 8, 8, 8)];
}

- (instancetype)initWithFrame:(CGRect)frame insets:(UIEdgeInsets)insets {
    self = [super initWithFrame:frame];
    if (self) {
        self.insets = insets;
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.insets)];
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize fitSize = [super sizeThatFits:size];
    fitSize.width += self.insets.left + self.insets.right;
    fitSize.height += self.insets.top + self.insets.bottom;
    return fitSize;
}

- (CGSize)intrinsicContentSize {
    CGSize contentSize = [super intrinsicContentSize];
    contentSize.width += self.insets.left + self.insets.right;
    contentSize.height += self.insets.top + self.insets.bottom;
    return contentSize;
}

@end
