//
//  FUWholeAvatarModel.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/3/22.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import "FUWholeAvatarModel.h"

@implementation FUWholeAvatarModel
- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_image forKey:@"image"];
    [coder encodeObject:_avatarModels forKey:@"avatarModel"];
}
    
- (instancetype)initWithCoder:(NSCoder *)coder  {
    self = [super init];
    if (self) {
        _image = [coder decodeObjectForKey:@"image"];
        _avatarModels = [coder decodeObjectForKey:@"avatarModel"];
    }
    return self;
}
    
    
@end
