//
//  FUPosterManager.m
//  FULiveDemo
//
//  Created by lsh726 on 2021/3/7.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUPosterManager.h"

@implementation FUPosterManager
- (instancetype)init {
    self = [super init];
    if (self) {
        [FUAIKit shareKit].maxTrackFaces = 4;
        [FUAIKit shareKit].faceProcessorDetectMode = FUFaceProcessorDetectModeImage;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"change_face" ofType:@"bundle"];
        self.poster = [[FUPoster alloc] initWithPath:path name:@"change_face"];
    }
    return self;
}

- (void)setOnCameraChange {
    [FUAIKit resetTrackedResult];
}


- (void)dealloc {
    
}
@end
