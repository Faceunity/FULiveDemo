//
//  FUAnimojiViewModel.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/8/4.
//

#import "FUAnimojiViewModel.h"
#import "FUComicFilterModel.h"

@interface FUAnimojiViewModel ()

@property (nonatomic, copy) NSArray<NSString *> *animojiItems;

@property (nonatomic, copy) NSArray<FUComicFilterModel *> *comicFilterItems;

@property (nonatomic, copy) NSArray<NSString *> *comicFilterIcons;

@property (nonatomic, strong) FUAnimoji *currentAnimoji;

@end

@implementation FUAnimojiViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        // 默认加载抗锯齿道具
        NSString *path = [[NSBundle mainBundle] pathForResource:@"fxaa" ofType:@"bundle"];
        [FURenderKit shareRenderKit].antiAliasing = [[FUItem alloc] initWithPath:path name:@"antiAliasing"];
        _currentIndex = -1;
    }
    return self;
}

- (void)loadAnimojiAtIndex:(NSInteger)index completion:(void (^)(void))completion {
    if (index < 0 || index >= self.animojiItems.count) {
        return;
    }
    _selectedAnimojiIndex = index;
    if (index == 0) {
        // 取消
        [[FURenderKit shareRenderKit].stickerContainer removeAllSticks];
        self.currentAnimoji = nil;
        !completion ?: completion();
    } else {
        NSString *path = [[NSBundle mainBundle] pathForResource:self.animojiItems[index] ofType:@"bundle"];
        FUAnimoji *animoji = [[FUAnimoji alloc] initWithPath:path name:@"animoji"];
        if (self.currentAnimoji) {
            [[FURenderKit shareRenderKit].stickerContainer replaceSticker:self.currentAnimoji withSticker:animoji completion:^{
                !completion ?: completion();
                self.currentAnimoji = animoji;
            }];
        } else {
            [[FURenderKit shareRenderKit].stickerContainer addSticker:animoji completion:^{
                !completion ?: completion();
                self.currentAnimoji = animoji;
            }];
        }
    }
}

- (void)loadComicFilterAtIndex:(NSInteger)index completion:(void (^)(void))complection {
    if (index < 0 || index >= self.comicFilterItems.count) {
        return;
    }
    _selectedComicFilterIndex = index;
    if (index == 0) {
        [FURenderKit shareRenderKit].comicFilter = nil;
        !complection ?: complection();
    } else {
        if (![FURenderKit shareRenderKit].comicFilter) {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"fuzzytoonfilter" ofType:@"bundle"];
            FUComicFilter *comicFilter = [[FUComicFilter alloc] initWithPath:path name:@"fuzzytoonfilter"];
            [FURenderKit shareRenderKit].comicFilter = comicFilter;
        }
        [FURenderKit shareRenderKit].comicFilter.style = self.comicFilterItems[index].style;
        !complection ?: complection();
    }
}

- (NSArray<NSString *> *)animojiItems {
    if (!_animojiItems) {
        _animojiItems = @[
            @"reset_item",
            @"cartoon_princess_Animoji",
            @"qgirl_Animoji",
            @"kaola_Animoji",
            @"wuxia_Animoji",
            @"baihu_Animoji",
            @"frog_Animoji",
            @"huangya_Animoji",
            @"hetun_Animoji",
            @"douniuquan_Animoji",
            @"hashiqi_Animoji",
            @"baimao_Animoji",
            @"kuloutou_Animoji"
        ];
    }
    return _animojiItems;
}

- (NSArray<FUComicFilterModel *> *)comicFilterItems {
    if (!_comicFilterItems) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"comic_filter" ofType:@"json"];
        _comicFilterItems = [FUComicFilterModel modelArrayWithJSON:[NSData dataWithContentsOfFile:path]];
    }
    return _comicFilterItems;
}

- (NSArray<NSString *> *)comicFilterIcons {
    if (!_comicFilterIcons) {
        NSMutableArray *temp = [NSMutableArray array];
        for (FUComicFilterModel *model in self.comicFilterItems) {
            [temp addObject:model.icon];
        }
        _comicFilterIcons = [temp copy];
    }
    return _comicFilterIcons;
}

#pragma mark - Overriding

- (FUModule)module {
    return FUModuleAnimoji;
}

- (CGFloat)captureButtonBottomConstant {
    return FUHeightIncludeBottomSafeArea(133);
}

@end
