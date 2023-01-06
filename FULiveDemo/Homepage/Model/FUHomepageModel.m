//
//  FUHomepageModel.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/7/4.
//  Copyright © 2022 FaceUnity. All rights reserved.
//

#import "FUHomepageModel.h"

@implementation FUHomepageModule

@end

@implementation FUHomepageGroup

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"modules" : [FUHomepageModule class]};
}

@end


