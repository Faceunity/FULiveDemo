//
//  FUBeautyFilterViewModel.m
//  FUBeautyComponent
//
//  Created by 项林平 on 2022/7/7.
//

#import "FUBeautyFilterViewModel.h"
#import "FUBeautyDefine.h"

#import <FURenderKit/FURenderKit.h>

@interface FUBeautyFilterViewModel ()

@property (nonatomic, copy) NSArray<FUBeautyFilterModel *> *beautyFilters;
/// 需要根据高低端机适配
@property (nonatomic, assign) FUDevicePerformanceLevel performanceLevel;

@end

@implementation FUBeautyFilterViewModel

#pragma mark - Initializer

- (instancetype)init {
    self = [super init];
    if (self) {
        self.performanceLevel = [FURenderKit devicePerformanceLevel];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:FUPersistentBeautyFilterKey]) {
            // 获取本地滤镜数据
            self.beautyFilters = [self localFilters];
        } else {
            // 获取默认滤镜数据
            self.beautyFilters = [self defaultFilters];
        }
        if ([[NSUserDefaults standardUserDefaults] objectForKey:FUPersistentBeautySelectedFilterIndexKey]) {
            // 获取本地保存选中的索引
            _selectedIndex = [[NSUserDefaults standardUserDefaults] integerForKey:FUPersistentBeautySelectedFilterIndexKey];
        } else {
            // 低端机默认关闭滤镜，高端机默认 2
            _selectedIndex = self.performanceLevel == FUDevicePerformanceLevelLow_1 ? 0 : 2;
        }
    }
    return self;
}

#pragma mark - Instance methods

- (void)saveFitersPersistently {
    if (self.beautyFilters.count == 0) {
        return;
    }
    NSMutableArray *filters = [[NSMutableArray alloc] init];
    for (FUBeautyFilterModel *model in self.beautyFilters) {
        NSDictionary *dictionary = [model dictionaryWithValuesForKeys:@[@"filterIndex", @"filterName", @"filterLevel"]];
        [filters addObject:dictionary];
    }
    [[NSUserDefaults standardUserDefaults] setObject:filters forKey:FUPersistentBeautyFilterKey];
    [[NSUserDefaults standardUserDefaults] setInteger:self.selectedIndex forKey:FUPersistentBeautySelectedFilterIndexKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (selectedIndex < 0 || selectedIndex >= self.beautyFilters.count) {
        return;
    }
    [self setFilter:self.beautyFilters[selectedIndex].filterName level:self.beautyFilters[selectedIndex].filterLevel];
    _selectedIndex = selectedIndex;
}

- (void)setCurrentFilter {
    if (self.selectedIndex < 0 || self.selectedIndex >= self.beautyFilters.count) {
        return;
    }
    [self setFilter:self.beautyFilters[self.selectedIndex].filterName level:self.beautyFilters[self.selectedIndex].filterLevel];
}

- (void)setFilterValue:(double)value {
    if (self.selectedIndex < 0 || self.selectedIndex >= self.beautyFilters.count) {
        return;
    }
    FUBeautyFilterModel *model = self.beautyFilters[self.selectedIndex];
    model.filterLevel = value;
    [FURenderKit shareRenderKit].beauty.filterLevel = model.filterLevel;
}

#pragma mark - Private methods

- (void)setFilter:(NSString *)filterName level:(double)filterLevel {
    [FURenderKit shareRenderKit].beauty.filterName = filterName;
    [FURenderKit shareRenderKit].beauty.filterLevel = filterLevel;
}

- (NSArray<FUBeautyFilterModel *> *)localFilters {
    NSArray *filters = [[NSUserDefaults standardUserDefaults] objectForKey:FUPersistentBeautyFilterKey];
    NSMutableArray *mutableFilters = [[NSMutableArray alloc] init];
    for (NSDictionary *filter in filters) {
        FUBeautyFilterModel *model = [[FUBeautyFilterModel alloc] init];
        [model setValuesForKeysWithDictionary:filter];
        [mutableFilters addObject:model];
    }
    return [mutableFilters copy];
}

- (NSArray<FUBeautyFilterModel *> *)defaultFilters {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *filterPath = [bundle pathForResource:@"beauty_filter" ofType:@"json"];
    NSArray<NSDictionary *> *filterData = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:filterPath] options:NSJSONReadingMutableContainers error:nil];
    NSMutableArray *filters = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in filterData) {
        FUBeautyFilterModel *model = [[FUBeautyFilterModel alloc] init];
        [model setValuesForKeysWithDictionary:dictionary];
        [filters addObject:model];
    }
    return [filters copy];
}

@end
