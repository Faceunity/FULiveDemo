//
//  FUFaceFusionCaptureResultViewController.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/9/2.
//

#import "FUFaceFusionCaptureResultViewController.h"
#import "FUFaceFusionEffectViewController.h"
#import "FUFaceFusionManager.h"

@interface FUFaceFusionCaptureResultViewController ()

@end

@implementation FUFaceFusionCaptureResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [FUFaceFusionManager sharedManager].image;
    [self.view addSubview:imageView];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setImage:[UIImage imageNamed:@"face_fusion_save_close"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).mas_offset(-86);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).mas_offset(-33);
        } else {
            make.bottom.equalTo(self.view.mas_bottom).mas_offset(-33);
        }
        make.size.mas_offset(CGSizeMake(67, 67));
    }];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setImage:[UIImage imageNamed:@"face_fusion_save_done"] forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmButton];
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).mas_offset(86);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).mas_offset(-33);
        } else {
            make.bottom.equalTo(self.view.mas_bottom).mas_offset(-33);
        }
        make.size.mas_offset(CGSizeMake(67, 67));
    }];
}

#pragma mark - Event response

- (void)cancelAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)confirmAction:(UIButton *)sender {
    [FUFaceFusionManager sharedManager].imageSource = FUFaceFusionImageSourceCamera;
    FUFaceFusionEffectViewController *effectController = [[FUFaceFusionEffectViewController alloc] init];
    [self.navigationController pushViewController:effectController animated:YES];
    // 保存到相册
    UIImageWriteToSavedPhotosAlbum([FUFaceFusionManager sharedManager].image, self, nil, NULL);
}

@end
