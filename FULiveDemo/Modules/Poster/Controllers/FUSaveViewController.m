//
//  FUSaveViewController.m
//  FULiveDemo
//
//  Created by 孙慕 on 2018/10/8.
//  Copyright © 2018年 L. All rights reserved.
//

#import "FUSaveViewController.h"
#import "FUEditImageViewController.h"
#import "FURenderer.h"
#import "FUGanEditController.h"
#import "FUTipView.h"

@interface FUSaveViewController ()

@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@property(strong ,nonatomic) FUTipView *tipView;

@end

@implementation FUSaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* 图片模式 */
    fuSetFaceProcessorDetectMode(0);
    // Do any additional setup after loading the view from its nib.
    [self prefersStatusBarHidden];
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    
    _tipView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([FUTipView class]) owner:self options:nil].lastObject;
    _tipView.frame = CGRectMake(0, 0, 245, 225);
    _tipView.center = self.view.center;
    _tipView.hidden = YES;
    __weak typeof(self)weakSelf = self ;
    _tipView.didClick = ^(int index) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    [self.view addSubview:_tipView];
}

-(void)setMImage:(UIImage *)mImage{
    _mImageView.image = mImage;
    _mImage = mImage;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}
-(void)viewDidLayoutSubviews{
     _tipView.center = self.view.center;
}

#pragma  mark ----  UI Action  -----

- (IBAction)closeAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)doneAction:(id)sender {
//    if (_type ==  FULiveModelTypeGan) {
//        if ([self setupPhotoMake]) {
//            FUGanEditController *vc = [[FUGanEditController alloc] init];
//            vc.pushFrom = FUGanEditImagePushFromPhoto;
//            vc.view.backgroundColor = [UIColor blackColor];
//            vc.originalImage = self.mImageView.image;
//            [self.navigationController pushViewController:vc animated:YES];
//            if (self.mImageView.image) {
//                UIImageWriteToSavedPhotosAlbum(self.mImageView.image, self, nil, NULL);
//            }
//        };
//    }else{
        FUEditImageViewController *vc = [[FUEditImageViewController alloc] initWithNibName:@"FUEditImageViewController" bundle:nil];
        vc.view.backgroundColor = [UIColor blackColor];
        vc.PushFrom = FUEditImagePushFromPhoto;
        [self.navigationController pushViewController:vc animated:YES];
        vc.mPhotoImage = self.mImageView.image;
        if (self.mImageView.image) {
            UIImageWriteToSavedPhotosAlbum(self.mImageView.image, self, nil, NULL);
        }
//    }
}


#pragma  mark ----  图片校验  -----
-(BOOL)setupPhotoMake{
    NSData *imageData = UIImageJPEGRepresentation(_mImage, 1.0);
    UIImage *image = [UIImage imageWithData:imageData];    
    int photoWidth = (int)CGImageGetWidth(image.CGImage);
    int photoHeight = (int)CGImageGetHeight(image.CGImage);
    
    CFDataRef photoDataFromImageDataProvider = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
    GLubyte *photoData = (GLubyte *)CFDataGetBytePtr(photoDataFromImageDataProvider);
    
    fuOnCameraChange();
    int endI = 0;
    for (int i = 0; i<50; i++) {//校验出人脸再trsckFace 10次
        [FURenderer trackFace:FU_FORMAT_BGRA_BUFFER inputData:photoData width:photoWidth height:photoHeight];
        if ([FURenderer isTracking] > 0) {
            if (endI == 0) {
                endI = i;
            }
            if (i > endI + 10) {
                break;
            }
        }
    }
    
    if ([FURenderer isTracking] > 0) {
        if (![self isGoodFace:0]) {
            _tipView.mTextLabel.text = FUNSLocalizedString(@"人脸偏转角度过大，请重新拍摄",nil);
            _tipView.hidden = NO;
            CFRelease(photoDataFromImageDataProvider);
            return NO;
        }
    }else{
       
        _tipView.mTextLabel.text = FUNSLocalizedString(@"未检测出人脸，请重新拍摄",nil);
        _tipView.hidden = NO;
        CFRelease(photoDataFromImageDataProvider);
        return NO;
    }
    CFRelease(photoDataFromImageDataProvider);
    return YES;
    
}

//保证正脸
-(BOOL)isGoodFace:(int)index{
    // 保证正脸
    float rotation[4] ;
    float DetectionAngle = 15.0 ;
    [FURenderer getFaceInfo:index name:@"rotation" pret:rotation number:4];
    
    float q0 = rotation[0];
    float q1 = rotation[1];
    float q2 = rotation[2];
    float q3 = rotation[3];
    
    float z =  atan2(2*(q0*q1 + q2 * q3), 1 - 2*(q1 * q1 + q2 * q2)) * 180 / M_PI;
    float y =  asin(2 *(q0*q2 - q1*q3)) * 180 / M_PI;
    float x = atan(2*(q0*q3 + q1*q2)/(1 - 2*(q2*q2 + q3*q3))) * 180 / M_PI;
    NSLog(@"x=%lf  y=%lf z=%lf",x,y,z);
    if (x > DetectionAngle || x < - 5 || fabs(y) > DetectionAngle || fabs(z) > DetectionAngle) {//抬头低头角度限制：仰角不大于5°，俯角不大于15°
        return NO;
    }
    
    return YES;
}

/* 是否夸张 */
-(BOOL)isExaggeration{
    float expression[46] ;
    [FURenderer getFaceInfo:0 name:@"expression" pret:expression number:46];
    
    for (int i = 0 ; i < 46; i ++) {
        
        if (expression[i] > 0.50) {
            
            return YES;
        }
    }
    return NO;
}




#pragma  mark ----  重载系统方法  -----
- (BOOL)prefersStatusBarHidden
{
    return YES;//隐藏为YES，显示为NO
}



@end
