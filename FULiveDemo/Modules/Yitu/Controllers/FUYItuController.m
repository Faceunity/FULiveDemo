//
//  FUYItuController.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/1/31.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import "FUYItuController.h"
#import "FUYituItemsView.h"
#import "FUFaceAdjustController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "FUYituModel.h"
#import "FUYItuSaveManager.h"
#import "FUMyItemsViewController.h"


#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface FUYItuController ()<FUYituItemsDelegate,FUMyItemsViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong,nonatomic) FUYituItemsView *yituItemsView;
@end

@implementation FUYItuController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    [self setupView];
}

-(void)setupView{
     self.headButtonView.selectedImageBtn.hidden = NO;
    
    _yituItemsView = [[FUYituItemsView alloc] init];
    _yituItemsView.delegate = self;
    [_yituItemsView updateCollectionAndSel:0];
    [self.view addSubview:_yituItemsView];
    [self showMessage:NSLocalizedString(@"动动你的五官", nil)];
    [_yituItemsView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view.mas_bottom);
        }
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(80);
    }];
    
    self.photoBtn.transform = CGAffineTransformMakeTranslation(0,-36);

}

#pragma  mark - 异图ItemDelagate
-(void)yituDidSelectedItemsIndex:(int)index{
    if (index < [FUYItuSaveManager shareManager].dataDataArray.count) {
        dispatch_async(dispatch_get_main_queue(), ^{
            FUYituModel *model = [FUYItuSaveManager shareManager].dataDataArray[index];
            UIImage *image = [FUYItuSaveManager loadImageWithVideoMid:model.imagePathMid];
            [[FUManager shareManager] setEspeciallyItemParamImage:image group_points:model.group_points group_type:model.group_type];
        });
    }else if (index == [FUYItuSaveManager shareManager].dataDataArray.count){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self didClickSelPhoto];
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            FUMyItemsViewController *vc = [[FUMyItemsViewController alloc] init];
            vc.mDelegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        });
        
    }
}

-(void)myItemViewDidDelete{
    [self.yituItemsView updateCollectionAndSel:0];
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
    FUFaceAdjustController *vc = [[FUFaceAdjustController alloc] init];
    vc.view.backgroundColor = [UIColor blackColor];
    [self.navigationController pushViewController:vc animated:YES];
    vc.imageView.image = image;
    vc.returnBlock = ^(int index) {
        [_yituItemsView updateCollectionAndSel:index];
    };
}


- (void)showMessage:(NSString *)string{
    //[SVProgressHUD showWithStatus:string]; //设置需要显示的文字
    [SVProgressHUD showImage:[UIImage imageNamed:@"wrt424erte2342rx"] status:string];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom]; //设置HUD背景图层的样式
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
    [SVProgressHUD setBackgroundLayerColor:[UIColor clearColor]];
    [SVProgressHUD setCornerRadius:5];
    [SVProgressHUD dismissWithDelay:2];
    
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
