//
//  FUStickerModel.m
//  FULive
//
//  Created by L on 2018/9/12.
//  Copyright © 2018年 faceUnity. All rights reserved.
//

#import "FUStickerModel.h"

@implementation FUStickerModel

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _tag = [aDecoder decodeObjectForKey:@"tag"];
        _stickerId = [aDecoder decodeObjectForKey:@"stickerId"];
        _iconId = [aDecoder decodeObjectForKey:@"iconId"];
        _iconURLString = [aDecoder decodeObjectForKey:@"iconURLString"];
        _itemId = [aDecoder decodeObjectForKey:@"itemId"];
        _loading = [aDecoder decodeBoolForKey:@"loading"];
        _keepPortrait = [aDecoder decodeBoolForKey:@"keepPortrait"];
        _single = [aDecoder decodeBoolForKey:@"single"];
        _makeupItem = [aDecoder decodeBoolForKey:@"makeupItem"];
        _needClick = [aDecoder decodeBoolForKey:@"needClick"];
        _is3DFlipH = [aDecoder decodeBoolForKey:@"is3DFlipH"];
    }
    return self ;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_tag forKey:@"tag"];
    [aCoder encodeObject:_stickerId forKey:@"stickerId"];
    [aCoder encodeObject:_iconId forKey:@"iconId"];
    [aCoder encodeObject:_iconURLString forKey:@"iconURLString"];
    [aCoder encodeObject:_itemId forKey:@"itemId"];
    [aCoder encodeBool:_loading forKey:@"loading"];
    [aCoder encodeBool:_keepPortrait forKey:@"keepPortrait"];
    [aCoder encodeBool:_single forKey:@"single"];
    [aCoder encodeBool:_makeupItem forKey:@"makeupItem"];
    [aCoder encodeBool:_needClick forKey:@"needClick"];
    [aCoder encodeBool:_is3DFlipH forKey:@"is3DFlipH"];
}

@end
