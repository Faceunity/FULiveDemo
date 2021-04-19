//
//  FUActionRecogManager.m
//  FULiveDemo
//
//  Created by Chen on 2021/3/5.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUActionRecogManager.h"

@implementation FUActionRecogManager

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"actiongame_ai" ofType:@"bundle"];
        self.actionRecogn = [[FUActionRecognition alloc] initWithPath:filePath name:@"actiongame_ai"];
        [self loadItem];
    }
    return self;
}


- (void)loadItem {
    [FURenderKit shareRenderKit].actionRecognition = self.actionRecogn;
}

- (void)releaseItem {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [FURenderKit shareRenderKit].actionRecognition = nil;
        self.actionRecogn = nil;
    });
}
@end
