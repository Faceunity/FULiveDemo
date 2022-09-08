//
//  FUBGSaveModel.m
//  FULiveDemo
//
//  Created by 孙慕 on 2021/2/23.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUBGSaveModel.h"
@implementation FUBGSaveModel
//序列化
- (void)encodeWithCoder:(NSCoder *)coder {
    [self mj_encode:coder];
}

//反序列化
- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        [self mj_decode:coder];
    }
    return self;
}

@end
