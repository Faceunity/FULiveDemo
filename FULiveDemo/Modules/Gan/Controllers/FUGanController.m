//
//  FUGanController.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/2/1.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import "FUGanController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "FUGanEditController.h"
#import "FUSaveViewController.h"

@interface FUGanController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation FUGanController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

-(void)setupView{
    self.headButtonView.selectedImageBtn.hidden = NO;
    [self.headButtonView.mHomeBtn setImage:[UIImage imageNamed:@"save_nav_back_n"] forState:UIControlStateNormal];
    
    [self.photoBtn setType:FUPhotoButtonTypeTakePhoto];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"face_contour"]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.frame = self.view.bounds;
    [self.view addSubview:imageView];
    [self.view insertSubview:imageView atIndex:1];
    
    self.tipLabel.text = NSLocalizedString(@"对准线框 正脸拍摄", nil);
    self.tipLabel.font = [UIFont systemFontOfSize:13];
    self.tipLabel.hidden = NO;
    
    [self.tipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.noTrackLabel.mas_bottom).offset(100);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(22);
    }];
    
}

/* gan拍照后不急保存，重载父方法 */
-(void)takePhotoToSave:(UIImage *)image{
    FUSaveViewController *vc = [[FUSaveViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.type = self.model.type;
    vc.mImage = image;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)didOutputVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer{
    [super didOutputVideoSampleBuffer:sampleBuffer];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![[FUManager shareManager] isGoodFace:0] || ![[FUManager shareManager] isTracking]) {
             self.tipLabel.text = NSLocalizedString(@"对准线框，正脸拍摄",nil);
        }else{
            if (![[FUManager shareManager] isExaggeration:0]) {
                self.tipLabel.text = @"nice";
            }else{
                self.tipLabel.text = NSLocalizedString(@"请保持面部无夸张表情",nil);
            }
        }
    });
 

}



#pragma  mark - 选择照片
-(void)didClickSelPhoto{
    
    [self showImagePickerWithMediaType:(NSString *)kUTTypeImage];
    
}

- (void)showImagePickerWithMediaType:(NSString *)mediaType {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.allowsEditing = NO;
    picker.mediaTypes = @[mediaType] ;
    [self presentViewController:picker animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // 关闭相册
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    // 图片转正
    if(image.size.width  > 1500 ||  image.size.height > 1500 ){// 图片转正 + 超大取缩略,这里有点随意，不知道sdk算法
        int scalew = image.size.width  / 1000;
        int scaleH = image.size.height  / 1000;
        
        int scale = scalew > scaleH ? scalew + 1: scaleH + 1;
        
        UIGraphicsBeginImageContext(CGSizeMake(image.size.width / scale, image.size.height / scale));
        
        [image drawInRect:CGRectMake(0, 0, image.size.width/scale, image.size.height/scale)];
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }else{
        
        UIGraphicsBeginImageContext(CGSizeMake(image.size.width , image.size.height));
        
        [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
    FUGanEditController *vc = [[FUGanEditController alloc] init];
    vc.pushFrom = FUGanEditImagePushFromAlbum;
    vc.view.backgroundColor = [UIColor blackColor];
    vc.originalImage = image;
    [self.navigationController pushViewController:vc animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
