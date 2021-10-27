//
//  UIImage+FU.m
//  FULiveDemo
//
//  Created by 项林平 on 2021/6/21.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "UIImage+FU.h"

@implementation UIImage (FU)

- (UIImage *)fu_compress:(CGFloat)ratio {
    CGSize resultSize = CGSizeMake(self.size.width * ratio, self.size.height * ratio);
    UIGraphicsBeginImageContext(resultSize);
    [self drawInRect:CGRectMake(0, 0, resultSize.width, resultSize.height)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

- (UIImage *)fu_resetImageOrientationToUp {
    UIGraphicsBeginImageContext(CGSizeMake(self.size.width, self.size.height));
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

@end
