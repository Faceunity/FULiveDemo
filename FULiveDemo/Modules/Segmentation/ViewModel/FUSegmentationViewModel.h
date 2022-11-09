//
//  FUSegmentationViewModel.h
//  FULiveDemo
//
//  Created by 项林平 on 2022/8/16.
//

#import "FURenderViewModel.h"
#import "FUSegmentationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUSegmentationViewModel : FURenderViewModel

@property (nonatomic, strong, readonly) NSMutableArray<FUSegmentationModel *> *segmentationItems;

@property (nonatomic, copy, readonly) NSDictionary<NSString *, NSString *> *segmentationTips;

@property (nonatomic, assign, readonly) NSInteger selectedIndex;
/// 是否存在自定义分割
@property (nonatomic, assign, readonly) BOOL customized;

- (void)selectSegmentationAtIndex:(NSInteger)index completionHandler:(nullable void (^)(void))completion;

- (BOOL)saveCustomImage:(UIImage *)image;

- (BOOL)saveCustomVideo:(NSURL *)videoURL;

- (void)reloadSegmentationData;

@end

NS_ASSUME_NONNULL_END
