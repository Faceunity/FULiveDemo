//
//  FUBodyAvatarViewModel.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/8/16.
//

#import "FURenderViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUBodyAvatarViewModel : FURenderViewModel

@property (nonatomic, copy, readonly) NSArray<NSString *> *avatarItems;
/// 选中Avatar索引，默认为-1
@property (nonatomic, assign) NSInteger selectedIndex;
/// 是否全身效果，默认为YES
@property (nonatomic, assign) BOOL wholeBody;

@end

NS_ASSUME_NONNULL_END
