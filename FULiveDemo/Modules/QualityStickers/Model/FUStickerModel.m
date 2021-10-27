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
        _type = [coder decodeIntegerForKey:@"type"];
        _tag = [coder decodeObjectForKey:@"tag"];
        _stickerId = [coder decodeObjectForKey:@"stickerId"];
        _iconId = [coder decodeObjectForKey:@"iconId"];
        _iconURLString = [coder decodeObjectForKey:@"iconURLString"];
        _itemId = [coder decodeObjectForKey:@"itemId"];
        _loading = [coder decodeBoolForKey:@"loading"];
        _keepPortrait = [coder decodeBoolForKey:@"keepPortrait"];
        _single = [coder decodeBoolForKey:@"single"];
        _makeupItem = [coder decodeBoolForKey:@"makeupItem"];
        _needClick = [coder decodeBoolForKey:@"needClick"];
        _is3DFlipH = [coder decodeBoolForKey:@"is3DFlipH"];
    }
    return self ;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeInteger:_type forKey:@"type"];
    [coder encodeObject:_tag forKey:@"tag"];
    [coder encodeObject:_stickerId forKey:@"stickerId"];
    [coder encodeObject:_iconId forKey:@"iconId"];
    [coder encodeObject:_iconURLString forKey:@"iconURLString"];
    [coder encodeObject:_itemId forKey:@"itemId"];
    [coder encodeBool:_loading forKey:@"loading"];
    [coder encodeBool:_keepPortrait forKey:@"keepPortrait"];
    [coder encodeBool:_single forKey:@"single"];
    [coder encodeBool:_makeupItem forKey:@"makeupItem"];
    [coder encodeBool:_needClick forKey:@"needClick"];
    [coder encodeBool:_is3DFlipH forKey:@"is3DFlipH"];
}

@end
