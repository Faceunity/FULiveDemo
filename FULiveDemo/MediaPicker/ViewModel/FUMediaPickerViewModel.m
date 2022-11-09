//
//  FUMediaPickerViewModel.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/8/8.
//

#import "FUMediaPickerViewModel.h"

@interface FUMediaPickerViewModel ()

@property (nonatomic, assign) FUModule module;

@end

@implementation FUMediaPickerViewModel

- (instancetype)initWithModule:(FUModule)module {
    self = [super init];
    if (self) {
        self.module = module;
    }
    return self;
}

@end
