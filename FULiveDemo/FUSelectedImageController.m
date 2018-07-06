//
//  FUSelectedImageController.m
//  FULiveDemo
//
//  Created by L on 2018/7/2.
//  Copyright © 2018年 L. All rights reserved.
//

#import "FUSelectedImageController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "FURenderImageViewController.h"

@interface FUSelectedImageController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation FUSelectedImageController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)selectedImage:(UIButton *)sender {
    [self showImagePickerWithMediaType:(NSString *)kUTTypeImage];
}

- (IBAction)selectedVideo:(UIButton *)sender {
    
    [self showImagePickerWithMediaType:(NSString *)kUTTypeMovie];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // 关闭相册
    [picker dismissViewControllerAnimated:NO completion:nil];
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]){  //视频
        NSURL *videoURL = info[UIImagePickerControllerMediaURL];
        
        [self performSegueWithIdentifier:@"renderImage" sender:videoURL];
        
    }else if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) { //照片
        
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        // 图片转正
        if (image.imageOrientation != UIImageOrientationUp || image.imageOrientation != UIImageOrientationUpMirrored) {
            
//            if (image.size.height > 3000 || image.size.width > 3000) {
            
                UIGraphicsBeginImageContext(CGSizeMake(image.size.width * 0.5, image.size.height * 0.5));
                
                [image drawInRect:CGRectMake(0, 0, image.size.width * 0.5, image.size.height * 0.5)];
                
                image = UIGraphicsGetImageFromCurrentImageContext();
                
                UIGraphicsEndImageContext();
//            }
        }
        
        [self performSegueWithIdentifier:@"renderImage" sender:image];
    }
}

- (void)showImagePickerWithMediaType:(NSString *)mediaType {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.allowsEditing = NO;
    picker.mediaTypes = @[mediaType] ;
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender   {
    if ([segue.identifier isEqualToString:@"renderImage"]) {
        
        FURenderImageViewController *renderView = (FURenderImageViewController *)segue.destinationViewController;
        
        if ([sender isKindOfClass:[NSURL class]]) {
            
            renderView.videoURL = (NSURL *)sender ;
        }else if ([sender isKindOfClass:[UIImage class]]) {
            
            renderView.image = (UIImage *)sender ;
        }
    }
}


// 返回
- (IBAction)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
