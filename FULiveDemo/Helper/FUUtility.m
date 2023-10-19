//
//  FUUtility.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/8/16.
//

#import "FUUtility.h"
#import <Photos/Photos.h>

@implementation FUUtility

+ (void)requestPhotoLibraryAuthorization:(void (^)(PHAuthorizationStatus))handler {
    if (@available(iOS 14, *)) {
        [PHPhotoLibrary requestAuthorizationForAccessLevel:PHAccessLevelReadWrite handler:^(PHAuthorizationStatus status) {
            !handler ?: handler(status);
        }];
    } else {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            !handler ?: handler(status);
        }];
    }
}

+ (void)requestVideoURLFromInfo:(NSDictionary<NSString *,id> *)info resultHandler:(void (^)(NSURL * _Nonnull))handler {
    if (info[UIImagePickerControllerReferenceURL]) {
        NSURL *refrenceURL = info[UIImagePickerControllerReferenceURL];
        PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsWithALAssetURLs:@[refrenceURL] options:nil];
        [[PHImageManager defaultManager] requestAVAssetForVideo:assets.firstObject options:nil resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            AVURLAsset *urlAsset = (AVURLAsset *)asset;
            !handler ?: handler(urlAsset.URL);
        }];
    } else if (info[UIImagePickerControllerMediaURL]) {
        !handler ?: handler(info[UIImagePickerControllerMediaURL]);
    } else {
        if (@available(iOS 11.0, *)) {
            PHAsset *asset = info[UIImagePickerControllerPHAsset];
            [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:nil resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                AVURLAsset *urlAsset = (AVURLAsset *)asset;
                !handler ?: handler(urlAsset.URL);
            }];
        }
    }
}

+ (UIImage *)previewImageFromVideoURL:(NSURL *)videoURL preferredTrackTransform:(BOOL)preferred {
    if (!videoURL) {
        return nil;
    }
    AVURLAsset *asset = [AVURLAsset assetWithURL:videoURL];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = preferred;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [imageGenerator copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
}

+ (UIImage *)lastFrameImageFromVideoURL:(NSURL *)videoURL preferredTrackTransform:(BOOL)preferred {
    if (!videoURL) {
        return nil;
    }
    AVURLAsset *asset = [AVURLAsset assetWithURL:videoURL];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = preferred;
    Float64 lastFrameTime = CMTimeGetSeconds(asset.duration);
    CMTime time = CMTimeMakeWithSeconds(lastFrameTime, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [imageGenerator copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
}

@end
