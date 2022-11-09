//
//  FUSegmentationViewModel.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/8/16.
//

#import "FUSegmentationViewModel.h"

static NSString * const kFUCustomSegmentationImage = @"custom_segmentation.png";
static NSString * const kFUCustomSegmentationVideoURL = @"FUCustomSegmentationVideoURL";

@interface FUSegmentationViewModel ()

@property (nonatomic, strong) NSMutableArray<FUSegmentationModel *> *segmentationItems;

@property (nonatomic, copy) NSDictionary<NSString *, NSString *> *segmentationTips;

@property (nonatomic, assign) BOOL customized;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) dispatch_queue_t segmentationLoadingQueue;

@end

@implementation FUSegmentationViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.segmentationLoadingQueue = dispatch_queue_create("com.faceunity.FULiveDemo.SegmentationLoadingQueue", DISPATCH_QUEUE_SERIAL);
        [self reloadSegmentationData];
    }
    return self;
}

#pragma mark - Instance methods

- (void)selectSegmentationAtIndex:(NSInteger)index completionHandler:(void (^)(void))completion {
    if (index < 0 || index >= self.segmentationItems.count) {
        return;
    }
    _selectedIndex = index;
    if (index == 0) {
        dispatch_async(self.segmentationLoadingQueue, ^{
            if ([FURenderKit shareRenderKit].segmentation) {
                [[FURenderKit shareRenderKit].segmentation stopVideoDecode];
                [FURenderKit shareRenderKit].segmentation = nil;
            }
            !completion ?: completion();
        });
    } else {
        FUSegmentationModel *model = self.segmentationItems[index];
        dispatch_async(self.segmentationLoadingQueue, ^{
            if (model.isCustom) {
                NSString *path = [[NSBundle mainBundle] pathForResource:@"bg_segment" ofType:@"bundle"];
                FUAISegment *segmentation = [[FUAISegment alloc] initWithPath:path name:@"segment"];
                [FURenderKit shareRenderKit].segmentation = segmentation;
                if (model.type == FUSegmentationTypeImage) {
                    segmentation.backgroundImage = model.image;
                } else {
                    segmentation.videoPath = model.videoURL;
                }
                !completion ?: completion();
            } else {
                NSString *path = [[NSBundle mainBundle] pathForResource:model.name ofType:@"bundle"];
                FUAISegment *segmentation = [[FUAISegment alloc] initWithPath:path name:@"segment"];
                if ([model.name isEqualToString:@"human_outline_740"]) {
                    // 特殊分割道具
                    segmentation.lineGap = 2.8;
                    segmentation.lineSize = 2.8;
                    segmentation.lineColor = FUColorMake(255/255.0, 180/255.0, 0.0, 0.0);
                }
                [FURenderKit shareRenderKit].segmentation = segmentation;
                !completion ?: completion();
            }
        });
    }
}

- (void)reloadSegmentationData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"segmentation" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    self.segmentationItems = [[FUSegmentationModel mj_objectArrayWithKeyValuesArray:jsonArray] mutableCopy];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kFUCustomSegmentationVideoURL]) {
        // 存在自定义视频
        FUSegmentationModel *model = [[FUSegmentationModel alloc] init];
        model.type = FUSegmentationTypeVideo;
        model.isCustom = YES;
        model.videoURL = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:kFUCustomSegmentationVideoURL]];
        model.image = [FUImageHelper getPreviewImageWithVideoURL:model.videoURL];
        if (model.videoURL && model.image) {
            [self.segmentationItems insertObject:model atIndex:2];
            self.customized = YES;
        }
    } else if ([[NSFileManager defaultManager] fileExistsAtPath:[FUDocumentPath stringByAppendingPathComponent:kFUCustomSegmentationImage]]) {
        // 存在自定义图片
        FUSegmentationModel *model = [[FUSegmentationModel alloc] init];
        model.type = FUSegmentationTypeImage;
        model.isCustom = YES;
        model.image = [UIImage imageWithContentsOfFile:[FUDocumentPath stringByAppendingPathComponent:kFUCustomSegmentationImage]];
        if (model.image) {
            [self.segmentationItems insertObject:model atIndex:2];
            self.customized = YES;
        }
    }
}

- (BOOL)saveCustomImage:(UIImage *)image {
    if (!image) {
        return NO;
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kFUCustomSegmentationVideoURL]) {
        // 先删除自定义视频
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kFUCustomSegmentationVideoURL];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    NSData *data = UIImagePNGRepresentation(image);
    NSString *savedImagePath = [FUDocumentPath stringByAppendingPathComponent:kFUCustomSegmentationImage];
    return [data writeToFile:savedImagePath atomically:YES];
}

- (BOOL)saveCustomVideo:(NSURL *)videoURL {
    if (!videoURL) {
        return NO;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:[FUDocumentPath stringByAppendingPathComponent:kFUCustomSegmentationImage]]) {
        // 先删除自定义图片
        [[NSFileManager defaultManager] removeItemAtPath:[FUDocumentPath stringByAppendingPathComponent:kFUCustomSegmentationImage] error:nil];
    }
    // 保存视频链接
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:videoURL];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kFUCustomSegmentationVideoURL];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (selectedIndex < 0 || selectedIndex >= self.segmentationItems.count) {
        return;
    }
    _selectedIndex = selectedIndex;
    if (selectedIndex == 0) {
        [[FURenderKit shareRenderKit].segmentation stopVideoDecode];
        [FURenderKit shareRenderKit].segmentation = nil;
    } else {
        FUSegmentationModel *model = self.segmentationItems[selectedIndex];
        if (model.isCustom) {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"bg_segment" ofType:@"bundle"];
            FUAISegment *segmentation = [[FUAISegment alloc] initWithPath:path name:@"segment"];
            [FURenderKit shareRenderKit].segmentation = segmentation;
            if (model.type == FUSegmentationTypeImage) {
                segmentation.backgroundImage = model.image;
            } else {
                segmentation.videoPath = model.videoURL;
            }
        } else {
            NSString *path = [[NSBundle mainBundle] pathForResource:model.name ofType:@"bundle"];
            FUAISegment *segmentation = [[FUAISegment alloc] initWithPath:path name:@"segment"];
            [FURenderKit shareRenderKit].segmentation = segmentation;
            if ([model.name isEqualToString:@"human_outline_740"]) {
                // 特殊分割道具
                segmentation.lineGap = 2.8;
                segmentation.lineSize = 2.8;
                segmentation.lineColor = FUColorMake(255/255.0, 180/255.0, 0.0, 0.0);
            }
        }
    }
}

#pragma mark - Getters

- (NSDictionary<NSString *,NSString *> *)segmentationTips {
    if (!_segmentationTips) {
        _segmentationTips = @{
            @"hez_ztt_fu" : @"张嘴试试"
        };
    }
    return _segmentationTips;
}

#pragma mark - Overriding

- (FUModule)module {
    return FUModuleSegmentation;
}

- (FUAIModelType)necessaryAIModelTypes {
    return FUAIModelTypeFace | FUAIModelTypeHuman;
}

- (FUDetectingParts)detectingParts {
    return FUDetectingPartsHuman;
}

@end
