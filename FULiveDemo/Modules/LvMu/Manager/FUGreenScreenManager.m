//
//  FULVMuManager.m
//  FULiveDemo
//
//  Created by Chen on 2021/3/4.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUGreenScreenManager.h"
#import "FUGreenScreenModel.h"
#import "FUGreenScreenBgModel.h"

@interface FUGreenScreenManager ()
@property (nonatomic, strong) NSArray <FUGreenScreenModel *> *dataArray;
@property (nonatomic, strong) NSArray <FUGreenScreenBgModel *> *bgDataArray;
@end

@implementation FUGreenScreenManager

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"green_screen" ofType:@"bundle"];
        self.greenScreen = [[FUGreenScreen alloc] initWithPath:path name:@"green_screen"];
        self.greenScreen.chromaThres = 0.45;
        self.greenScreen.chromaThrest = 0.30;
        self.greenScreen.alphal = 0.2;
        [self loadItem];
        
        self.dataArray = [self createUIData];
        self.bgDataArray = [self createBgData];
    }
    return self;
}

- (NSArray *)createUIData {
//    NSArray *list = @{@[@"key_color"]}
    NSArray *prams = @[@(GREENSCREENTYPE_keyColor),@(GREENSCREENTYPE_chromaThres),@(GREENSCREENTYPE_chromaThresT),@(GREENSCREENTYPE_alphaL), @(GREENSCREENTYPE_safeArea)];
    NSArray *titelArr = @[@"关键颜色", @"相似度", @"平滑", @"透明度", @"安全区域"];
    NSArray *imageArr = @[@"demo_icon_key_color", @"demo_icon_similarityr", @"demo_icon_smooth", @"demo_icon_transparency", @"demo_icon_safe_area"];
    
    NSArray *defaultValueArr = @[@(0), @(0.45), @(0.30), @(0.20), @0];
    
    NSMutableArray *tempArr = [NSMutableArray array];
    for (int i = 0; i < GREENSCREENTYPE_Max; i ++) {
        FUGreenScreenModel *model = [[FUGreenScreenModel alloc] init];
        model.type = [[prams objectAtIndex:i] unsignedIntValue];
        model.title = [titelArr objectAtIndex: i];
        model.imageName = [imageArr objectAtIndex:i];
        model.value = [defaultValueArr objectAtIndex:i];
        model.defaultValue = model.value;
        [tempArr addObject:model];
    }
    return [tempArr copy];
}


- (NSArray <FUGreenScreenBgModel *> *)createBgData {
    FUGreenScreenBgModel *param0 = [[FUGreenScreenBgModel alloc] init];
    param0.title = @"取消";
    param0.imageName = @"makeup_noitem";
    
    FUGreenScreenBgModel *param1 = [[FUGreenScreenBgModel alloc] init];
    param1.title = @"沙滩";
    param1.videoPath = @"beach";
    param1.imageName = @"demo_bg_beach";
    
    FUGreenScreenBgModel *param2 = [[FUGreenScreenBgModel alloc] init];
    param2.title = @"教室";
    param2.videoPath = @"classroom";
    param2.imageName = @"demo_bg_classroom";
    FUGreenScreenBgModel *param3 = [[FUGreenScreenBgModel alloc] init];
    param3.title = @"森林";
    param3.videoPath = @"springForest";
    param3.imageName = @"demo_bg_forest";
    
    FUGreenScreenBgModel *param4 = [[FUGreenScreenBgModel alloc] init];
    param4.title = @"水墨画";
    param4.videoPath = @"inkPainting";
    param4.imageName = @"demo_bg_ink painting";

    FUGreenScreenBgModel *param5 = [[FUGreenScreenBgModel alloc] init];
    param5.title = @"科技";
    param5.videoPath = @"science";
    param5.imageName = @"demo_bg_science";

    NSArray <FUGreenScreenBgModel *> *params = @[param0,param5,param1,param2,param4,param3];
    return params;
}

- (void)setGreenScreenModel:(FUGreenScreenModel *)model {
    switch (model.type) {
        case GREENSCREENTYPE_keyColor:
            [self setGreenScreenWithColor:model.value];
            break;
        case GREENSCREENTYPE_chromaThres:
            self.greenScreen.chromaThres = [model.value floatValue];
            break;
        case GREENSCREENTYPE_chromaThresT:
            self.greenScreen.chromaThrest = [model.value floatValue];
            break;
        case GREENSCREENTYPE_alphaL:
            self.greenScreen.alphal = [model.value floatValue];
            break;
        default:
            break;
    }
}

//设置颜色值
- (void)setGreenScreenWithColor:(UIColor *)color {
    if ([color isKindOfClass:[UIColor class]]) {
        CGFloat r,g,b,a;
        [color getRed:&r green:&g blue:&b alpha:&a];
        self.greenScreen.keyColor = FUColorMake(round(r * 255), round(g * 255), round(b * 255), round(a * 255));
    }
}

- (void)updateSafeAreaImage:(UIImage *)image {
    self.greenScreen.safeAreaImage = image;
}

- (void)loadItem {
    [FURenderKit shareRenderKit].greenScreen = self.greenScreen;
}

- (void)releaseItem {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.greenScreen = nil;
        [FURenderKit shareRenderKit].greenScreen = nil;
    });
}

#pragma mark - Class methods
+ (BOOL)safeLocalSafeAreaImage:(UIImage *)image {
    if (!image) {
        return NO;
    }
    NSString *localPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"safeArea.png"];
    return [UIImagePNGRepresentation(image) writeToFile:localPath atomically:YES];
}

+ (UIImage *)localSafeAreaImage {
    NSString *localPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"safeArea.png"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:localPath]) {
        return nil;
    }
    return [UIImage imageWithContentsOfFile:localPath];
}

@end
