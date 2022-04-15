//
//  FUStickerModel.m
//  FULive
//
//  Created by L on 2018/9/12.
//  Copyright © 2018年 faceUnity. All rights reserved.
//

#import "FUStickerModel.h"

@implementation FUStickerModel

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        [self mj_decode:coder];
    }
    return self ;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [self mj_encode:coder];
}

@end
