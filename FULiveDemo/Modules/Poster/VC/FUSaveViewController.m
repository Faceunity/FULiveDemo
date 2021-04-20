//
//  FUSaveViewController.m
//  FULiveDemo
//
//  Created by 孙慕 on 2018/10/8.
//  Copyright © 2018年 L. All rights reserved.
//

#import "FUSaveViewController.h"
#import "FUEditImageViewController.h"
#import <FURenderKit/FUAIKit.h>
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
    [FUAIKit shareKit].faceProcessorDetectMode = FUFaceProcessorDetectModeImage;
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
    FUEditImageViewController *vc = [[FUEditImageViewController alloc] initWithNibName:@"FUEditImageViewController" bundle:nil];
    vc.view.backgroundColor = [UIColor blackColor];
    vc.PushFrom = FUEditImagePushFromPhoto;
    [self.navigationController pushViewController:vc animated:YES];
    vc.mPhotoImage = self.mImageView.image;
    if (self.mImageView.image) {
        UIImageWriteToSavedPhotosAlbum(self.mImageView.image, self, nil, NULL);
    }

}

/* 是否夸张 */
//-(BOOL)isExaggeration{
//    float expression[46] ;
//    [FURenderer getFaceInfo:0 name:@"expression" pret:expression number:46];
//    
//    for (int i = 0 ; i < 46; i ++) {
//        
//        if (expression[i] > 0.50) {
//            
//            return YES;
//        }
//    }
//    return NO;
//}




#pragma  mark ----  重载系统方法  -----
- (BOOL)prefersStatusBarHidden
{
    return YES;//隐藏为YES，显示为NO
}



@end
