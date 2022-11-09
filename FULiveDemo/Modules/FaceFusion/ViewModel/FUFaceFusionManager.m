//
//  FUFaceFusionManager.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/9/2.
//

#import "FUFaceFusionManager.h"

static dispatch_once_t onceToken;
static FUFaceFusionManager *instance = nil;

@interface FUFaceFusionManager ()

@property (nonatomic, copy) NSArray<NSString *> *listItems;

@property (nonatomic, copy) NSArray<NSString *> *iconItems;

@property (nonatomic, copy) NSArray<NSString *> *items;

@end

@implementation FUFaceFusionManager

+ (instancetype)sharedManager {
    dispatch_once(&onceToken, ^{
        instance = [[FUFaceFusionManager alloc] init];
    });
    return instance;
}

+ (void)destory {
    onceToken = 0;
    instance = nil;
}

- (void)setImage:(UIImage *)image {
    _image = [UIImage imageWithData:UIImageJPEGRepresentation(image, 1)];
}

#pragma mark - Getters

- (NSArray<NSString *> *)items {
    if (!_items) {
        _items = @[@"poster1", @"poster2", @"poster3", @"poster4", @"poster5", @"poster6", @"poster7", @"poster8"];
    }
    return _items;
}

- (NSArray<NSString *> *)listItems {
    if (!_listItems) {
        _listItems = @[@"poster1_list", @"poster2_list", @"poster3_list", @"poster4_list", @"poster5_list", @"poster6_list", @"poster7_list", @"poster8_list"];
    }
    return _listItems;
}

- (NSArray<NSString *> *)iconItems {
    if (!_iconItems) {
        _iconItems = @[@"poster1_icon", @"poster2_icon", @"poster3_icon", @"poster4_icon", @"poster5_icon", @"poster6_icon", @"poster7_icon", @"poster8_icon"];
    }
    return _iconItems;
}

@end
