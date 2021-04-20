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
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.url forKey:@"url"];
    [aCoder encodeInteger:self.type forKey:@"type"];
    [aCoder encodeObject:self.pathName forKey:@"pathName"];
    [aCoder encodeObject:self.iconImage forKey:@"iconImage"];
}

//反序列化
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
   self = [super init];
   if (!self) { return nil; }
   self.url = [aDecoder decodeObjectForKey:@"url"];
   self.type = [aDecoder decodeIntegerForKey:@"type"];
   self.pathName = [aDecoder decodeObjectForKey:@"pathName"];
   self.iconImage = [aDecoder decodeObjectForKey:@"iconImage"];
   return self;
}
@end
