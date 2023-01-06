//
//  FUGreenScreenSafeAreaViewModel.m
//  FUGreenScreenComponent
//
//  Created by 项林平 on 2022/8/1.
//

#import "FUGreenScreenSafeAreaViewModel.h"
#import "FUGreenScreenSafeAreaModel.h"
#import "FUGreenScreenDefine.h"

#import <FURenderKit/FURenderKit.h>

@interface FUGreenScreenSafeAreaViewModel ()

@property (nonatomic, copy) NSArray<FUGreenScreenSafeAreaModel *> *safeAreaArray;

@property (nonatomic, strong) UIImage *localSafeAreaImage;

@end

@implementation FUGreenScreenSafeAreaViewModel

#pragma mark - Initializer

- (instancetype)init {
    self = [super init];
    if (self) {
        [self realoadSafeAreaData];
        self.selectedIndex = 1;
    }
    return self;
}

#pragma mark - Instance methods

- (void)realoadSafeAreaData {
    NSMutableArray<FUGreenScreenSafeAreaModel *> *models = [[NSMutableArray alloc] init];
    
    // 返回
    FUGreenScreenSafeAreaModel *backModel = [[FUGreenScreenSafeAreaModel alloc] init];
    backModel.iconName = @"demo_icon_returns";
    [models addObject:backModel];
    
    // 取消选中
    FUGreenScreenSafeAreaModel *cancelModel = [[FUGreenScreenSafeAreaModel alloc] init];
    cancelModel.iconName = @"demo_icon_cancel";
    [models addObject:cancelModel];
    
    // 增加本地自定义
    FUGreenScreenSafeAreaModel *addModel = [[FUGreenScreenSafeAreaModel alloc] init];
    addModel.iconName = @"demo_icon_add";
    [models addObject:addModel];
    
    if (self.localSafeAreaImage) {
        // 存在本地自定义
        FUGreenScreenSafeAreaModel *model = [[FUGreenScreenSafeAreaModel alloc] init];
        model.isLocal = YES;
        model.iconName = @"safeArea.png";
        model.imageName = model.iconName;
        [models addObject:model];
    }
    
    // 固定两个安全区域图片
    FUGreenScreenSafeAreaModel *model1 = [[FUGreenScreenSafeAreaModel alloc] init];
    model1.iconName = @"demo_icon_safe_area_1";
    model1.imageName = @"safe_area_1";
    [models addObject:model1];
    
    FUGreenScreenSafeAreaModel *model2 = [[FUGreenScreenSafeAreaModel alloc] init];
    model2.iconName = @"demo_icon_safe_area_2";
    model2.imageName = @"safe_area_2";
    [models addObject:model2];
    self.safeAreaArray = [models copy];
}

- (void)updateSafeAreaImage:(UIImage *)image {
    [FURenderKit shareRenderKit].greenScreen.safeAreaImage = image;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (selectedIndex < 1 || selectedIndex == 2 || selectedIndex >= self.safeAreaArray.count) {
        // 返回和添加项无法选中
        return;
    }
    _selectedIndex = selectedIndex;
    if (selectedIndex == 1) {
        // cancel
        [self updateSafeAreaImage:nil];
    } else if (selectedIndex > 2) {
        FUGreenScreenSafeAreaModel *safeArea = self.safeAreaArray[selectedIndex];
        if (safeArea.isLocal && self.localSafeAreaImage) {
            // 本地自定义安全区域
            [self updateSafeAreaImage:self.localSafeAreaImage];
        } else {
            UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:safeArea.imageName ofType:@"jpg"]];
            [self updateSafeAreaImage:image];
        }
    }
}

- (BOOL)saveLocalSafeAreaImage:(UIImage *)image {
    if (!image) {
        return NO;
    }
    NSString *localPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"safeArea.png"];
    return [UIImagePNGRepresentation(image) writeToFile:localPath atomically:YES];
}

- (UIImage *)localSafeAreaImage {
    NSString *localPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"safeArea.png"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:localPath]) {
        return nil;
    }
    return [UIImage imageWithContentsOfFile:localPath];
}

- (UIImage *)safeAreaIconAtIndex:(NSInteger)index {
    FUGreenScreenSafeAreaModel *safeArea = self.safeAreaArray[index];
    if (safeArea.isLocal && self.localSafeAreaImage) {
        return self.localSafeAreaImage;
    } else {
        return [UIImage imageNamed:safeArea.iconName];
    }
}

@end
