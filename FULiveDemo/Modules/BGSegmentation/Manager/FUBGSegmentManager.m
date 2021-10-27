//
//  FUBGSegmentManager.m
//  FULiveDemo
//
//  Created by Chen on 2021/2/25.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUBGSegmentManager.h"
#import "FUBGSaveModel.h"
@interface FUBGSegmentManager ()
@property (nonatomic, copy) void(^ComplentionBlock)(BOOL finished);
@end

@implementation FUBGSegmentManager
@synthesize selectedItem;
@synthesize type;

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

//是否有自定的数据要添加
- (NSArray *)additionalItems {
    NSMutableArray *arr = [NSMutableArray arrayWithObject:@"resetItem"];
    [arr addObject:@"icon_yitu_add"];
    if ([self isHaveCustItem]) {
        [arr addObject:CUSTOMBG];
    }
    return [NSArray arrayWithArray:arr];
}

-(NSString *)filePath {
    NSString *paths =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [paths stringByAppendingPathComponent:@"saveModel"];
    return path;
}

- (BOOL)saveModel:(FUBGSaveModel *)model {
    NSString *path = [self filePath];
    BOOL success =  [NSKeyedArchiver archiveRootObject:model toFile:path];
    return success;
}


- (BOOL)isHaveCustItem {
    FUBGSaveModel *model = [self getSaveModel];
    if (model) {
        return YES;
    }else{
        return NO;
    }
}

- (FUBGSaveModel *)getSaveModel {
    NSString *path = [self filePath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return nil;
    }
    FUBGSaveModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    return model;
}


- (void)setSegment:(FUAISegment *)segment {
    _segment = segment;
}

- (void)loadItem:(NSString *)itemName
      completion:(void (^ __nullable)(BOOL finished))completion {
    self.selectedItem = itemName;
    [self.segment stopVideoDecode];//内部会判断，存在视频解码就释放不存在不操作直接返回。
    self.ComplentionBlock = completion;
    if (itemName != nil && ![itemName isEqual: @"resetItem"])  {
        [self loadItem];
    } else {
        [self releaseItem];
    }
}

- (void)loadItem {
    NSString *itemName = self.selectedItem;
    NSString *path = [[NSBundle mainBundle] pathForResource:[itemName stringByAppendingString:@".bundle"] ofType:nil];
    FUAISegment *newItem = [[FUAISegment alloc] initWithPath:path name:@"segment"];
    [[FURenderKit shareRenderKit].stickerContainer replaceSticker:self.segment withSticker:newItem completion:^{
        if (self.ComplentionBlock) {
            self.ComplentionBlock(YES);
        }
    }];
    self.segment = newItem;
}

- (void)releaseItem {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[FURenderKit shareRenderKit].stickerContainer removeSticker:self.segment completion:^{
            if (self.ComplentionBlock) {
                self.ComplentionBlock(NO);
            }
        }];
        self.segment = nil;
    });
}

@end
