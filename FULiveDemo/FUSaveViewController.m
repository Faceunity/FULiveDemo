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

@interface FUSaveViewController ()

@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@end

@implementation FUSaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self prefersStatusBarHidden];
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
}

-(void)setMImage:(UIImage *)mImage{
    _mImageView.image = mImage;
    _mImage = mImage;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

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

#pragma  mark ----  重载系统方法  -----
- (BOOL)prefersStatusBarHidden
{
    return YES;//隐藏为YES，显示为NO
}



@end
