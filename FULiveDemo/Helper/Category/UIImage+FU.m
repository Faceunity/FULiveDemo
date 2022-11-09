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

- (UIImage *)fu_processedImage {
    CGFloat imagePixel = self.size.width * self.size.height;
    UIImage *resultImage = self;
    // 超过限制像素需要压缩
    if (imagePixel > FUPicturePixelMaxSize) {
        CGFloat ratio = FUPicturePixelMaxSize / imagePixel * 1.0;
        resultImage = [resultImage fu_compress:ratio];
    }
    // 图片转正
    if (resultImage.imageOrientation != UIImageOrientationUp && resultImage.imageOrientation != UIImageOrientationUpMirrored) {
        resultImage = [resultImage fu_resetImageOrientationToUp];
    }
    return resultImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

@end
