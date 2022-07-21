//
//  FUHairManager.m
//  FULiveDemo
//
//  Created by lsh726 on 2021/3/4.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUHairManager.h"
#import <FURenderKit/FUAIKit.h>
@implementation FUHairManager
- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"hair_gradient" ofType:@"bundle"];
        self.hair = [[FUHairBeauty alloc] initWithPath:path name:@"hair"];
        self.hair.index = 0;
        self.hair.strength = 0.5;
        [self loadItem];
        self.curMode = FUHairModelModelGradient;
    }
    return self;
}

- (void)loadItem {
    [FURenderKit shareRenderKit].hairBeauty = self.hair;
}

- (void)loadItemWithPath:(NSString *)path {
    self.hair = [[FUHairBeauty alloc] initWithPath:path name:@"hair"];
    [self loadItem];
}

@end
