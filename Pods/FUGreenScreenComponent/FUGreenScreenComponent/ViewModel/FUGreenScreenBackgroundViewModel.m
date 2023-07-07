//
//  FUGreenScreenBackgroundViewModel.m
//  FUGreenScreenComponent
//
//  Created by 项林平 on 2022/8/1.
//

#import "FUGreenScreenBackgroundViewModel.h"
#import "FUGreenScreenBackgroundModel.h"
#import "FUGreenScreenDefine.h"

#import <FURenderKit/FURenderKit.h>

@interface FUGreenScreenBackgroundViewModel ()

@property (nonatomic, copy) NSArray<FUGreenScreenBackgroundModel *> *backgroundArray;

@end

@implementation FUGreenScreenBackgroundViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.selectedIndex = 3;
    }
    return self;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (![FURenderKit shareRenderKit].greenScreen || selectedIndex < 0 || selectedIndex >= self.backgroundArray.count) {
        return;
    }
    FUGreenScreen *greenScreen = [FURenderKit shareRenderKit].greenScreen;
    if (selectedIndex == 0) {
        // 取消选中背景视频
        greenScreen.videoPath = nil;
    } else {
        FUGreenScreenBackgroundModel *backgroundModel = self.backgroundArray[selectedIndex];
        NSString *URLString = [[NSBundle mainBundle] pathForResource:backgroundModel.videoName ofType:@"mp4"];
        greenScreen.videoPath = URLString;
    }
    _selectedIndex = selectedIndex;
}

- (UIImage *)backgroundIconAtIndex:(NSInteger)index {
    FUGreenScreenBackgroundModel *model = self.backgroundArray[index];
    return [UIImage imageNamed:model.icon];
}

- (NSString *)backgroundNameAtIndex:(NSInteger)index {
    FUGreenScreenBackgroundModel *model = self.backgroundArray[index];
    return FUGreenScreenStringWithKey(model.name);
}

- (NSArray<FUGreenScreenBackgroundModel *> *)backgroundArray {
    if (!_backgroundArray) {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSString *path = [bundle pathForResource:@"green_screen_background" ofType:@"json"];
        NSArray<NSDictionary *> *data = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *backgrounds = [[NSMutableArray alloc] init];
        for (NSDictionary *dictionary in data) {
            FUGreenScreenBackgroundModel *model = [[FUGreenScreenBackgroundModel alloc] init];
            [model setValuesForKeysWithDictionary:dictionary];
            [backgrounds addObject:model];
        }
        _backgroundArray = [backgrounds copy];
    }
    return _backgroundArray;
}

@end
