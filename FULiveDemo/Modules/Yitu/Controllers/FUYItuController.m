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

@property (strong,nonatomic) UIImage *photoImage;
@property (nonatomic,assign) int currentIndex;

@property (strong,nonatomic) UIButton *delBtn;
@property (strong,nonatomic) UIButton *reEditBt;
@end

@implementation FUYItuController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    [self setupView];
    
    for (UIGestureRecognizer *gr in self.renderView.gestureRecognizers) {
        [self.renderView removeGestureRecognizer:gr];
    }
    
}

-(void)setupView{
    _yituItemsView = [[FUYituItemsView alloc] init];
    _yituItemsView.delegate = self;
    [_yituItemsView updateCollectionAndSel:0];
    [self.view addSubview:_yituItemsView];
    [self showMessage:FUNSLocalizedString(@"动动你的五官", nil)];
    [_yituItemsView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view.mas_bottom);
        }
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(80);
    }];
    
    /* 删除按钮 */
    self.delBtn = [[UIButton alloc] init];
    self.delBtn.frame = CGRectMake(17,534,84,32);
    self.delBtn.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    self.delBtn.layer.cornerRadius = 16;
    self.delBtn.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3].CGColor;
    self.delBtn.layer.shadowOffset = CGSizeMake(0,0);
    self.delBtn.layer.shadowOpacity = 1;
    self.delBtn.layer.shadowRadius = 2;
    [self.delBtn setTitle:FUNSLocalizedString(@"删除道具", nil)  forState:UIControlStateNormal];
    [self.delBtn addTarget:self action:@selector(delYituModel) forControlEvents:UIControlEventTouchUpInside];
    [self.delBtn setTitleColor:[UIColor colorWithRed:44/255.0 green:46/255.0 blue:48/255.0 alpha:1.0] forState:UIControlStateNormal];
//    [delBtn setTitleColor:[UIColor colorWithRed:31/255.0 green:178/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    self.delBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    self.delBtn.hidden = YES;
    [self.view addSubview:self.delBtn];
    [self.delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_yituItemsView.mas_top).offset(-26);
        make.left.equalTo(self.view).offset(17);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(32);
    }];
    
    /* 重新编辑 */
    self.reEditBt = [[UIButton alloc] init];
    self.reEditBt.layer.backgroundColor = [UIColor colorWithRed:31/255.0 green:178/255.0 blue:255/255.0 alpha:1.0].CGColor;
    self.reEditBt.layer.cornerRadius = 16;
    [self.reEditBt setTitle:FUNSLocalizedString(@"重新编辑", nil) forState:UIControlStateNormal];
    [self.reEditBt addTarget:self action:@selector(reEditBtClick) forControlEvents:UIControlEventTouchUpInside];
    [self.reEditBt setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    //    [delBtn setTitleColor:[UIColor colorWithRed:31/255.0 green:178/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    self.reEditBt.titleLabel.font = [UIFont systemFontOfSize:11];
    self.reEditBt.hidden = YES;
    [self.view addSubview:self.reEditBt];
    [self.reEditBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_yituItemsView.mas_top).offset(-26);
        make.right.equalTo(self.view).offset(-17);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(32);
    }];
    
    self.photoBtn.transform = CGAffineTransformMakeTranslation(0,-36);
    
    /* iphone x 刘海齐黑 */
    [self.renderView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.equalTo(self.view.mas_top);
        }
        make.left.right.height.equalTo(self.view);
    }];

}

#pragma  mark - 异图ItemDelagate
-(void)yituDidSelectedItemsIndex:(int)index{
    __weak typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
       if (index < [FUYItuSaveManager shareManager].dataDataArray.count) {
           self.delBtn.hidden = index < defaultYiTuNum? YES:NO;
           self.reEditBt.hidden = index < defaultYiTuNum? YES:NO;
           
            FUYituModel *model = [FUYItuSaveManager shareManager].dataDataArray[index];
            UIImage *image = [FUYItuSaveManager loadImageWithVideoMid:model.imagePathMid];
//            [[FUManager shareManager] setEspeciallyItemParamImage:image group_points:model.group_points group_type:model.group_type];
            
            weakSelf.photoImage = image;
            weakSelf.currentIndex = index;
       }else if (index == [FUYItuSaveManager shareManager].dataDataArray.count){
            [self didClickSelPhoto];

       }else{

        FUMyItemsViewController *vc = [[FUMyItemsViewController alloc] init];
        vc.mDelegate = self;
        [self.navigationController pushViewController:vc animated:YES];

       }
    });
        
}

-(void)myItemViewDidDelete{
    [self.yituItemsView updateCollectionAndSel:0];
}


#pragma  mark -  UI 事件

-(void)delYituModel{
    if (_yituItemsView.selIndex < 4) {
        [self showMessage:@"模板图不能删除"];
        return;
    }
    
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:nil message:FUNSLocalizedString(@"确定删除所选中的道具？",nil) preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:FUNSLocalizedString(@"取消",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [cancleAction setValue:[self colorWithHexColorString:@"2C2E30"] forKey:@"titleTextColor"];
    
    __weak typeof(self)weakSelf = self ;
    UIAlertAction *certainAction = [UIAlertAction actionWithTitle:FUNSLocalizedString(@"确定",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[FUYItuSaveManager shareManager].dataDataArray removeObjectAtIndex:_yituItemsView.selIndex];
        /* 更新存储 */
        [FUYItuSaveManager dataWriteToFile];
        [weakSelf.yituItemsView updateCollectionAndSel:0];
    }];
    [certainAction setValue:[self colorWithHexColorString:@"869DFF"] forKey:@"titleTextColor"];
    
    [alertCon addAction:cancleAction];
    [alertCon addAction:certainAction];
    
    [self presentViewController:alertCon animated:YES completion:^{
    }];
}

-(void)reEditBtClick{
    if (self.currentIndex < defaultYiTuNum) {
        [self showMessage:@"模板不能重新编辑"];
        return;
    }
    
    FUFaceAdjustController *vc = [[FUFaceAdjustController alloc] init];
    vc.view.backgroundColor = [UIColor blackColor];
    [self.navigationController pushViewController:vc animated:YES];
    vc.imageView.image = self.photoImage;
    FUYituModel *model = [FUYItuSaveManager shareManager].dataDataArray[self.currentIndex];
    [vc addAllFaceItems:model.itemModels];
    vc.editType = FUFaceEditModleTypeReEdit;
    __weak typeof(self)weakSelf = self;
    vc.saveSuccessBlock = ^(FUYituModel * model) {
        [[FUYItuSaveManager shareManager].dataDataArray replaceObjectAtIndex:weakSelf.currentIndex withObject:model];
        [_yituItemsView updateCollectionAndSel:weakSelf.currentIndex];
    };
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
    vc.editType = FUFaceEditModleTypeNew;
    vc.saveSuccessBlock = ^(FUYituModel * model) {
        [[FUYItuSaveManager shareManager].dataDataArray addObject:model];
        [_yituItemsView updateCollectionAndSel:(int)[FUYItuSaveManager shareManager].dataDataArray.count -1];
    };
}


- (void)showMessage:(NSString *)string{
    //[SVProgressHUD showWithStatus:string]; //设置需要显示的文字
    [SVProgressHUD showImage:[UIImage imageNamed:@"wrt424erte2342rx"] status:string];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom]; //设置HUD背景图层的样式
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.74]];
    [SVProgressHUD setBackgroundLayerColor:[UIColor clearColor]];
    [SVProgressHUD setCornerRadius:5];
    [SVProgressHUD dismissWithDelay:2];
    
}


#pragma mark  十六进制颜色
-(UIColor *)colorWithHexColorString:(NSString *)hexColorString{
    return [self colorWithHexColorString:hexColorString alpha:1.0f];
}

#pragma mark  十六进制颜色
- (UIColor *)colorWithHexColorString:(NSString *)hexColorString alpha:(float)alpha{
    
    unsigned int red, green, blue;
    
    NSRange range;
    
    range.length =2;
    
    range.location =0;
    
    [[NSScanner scannerWithString:[hexColorString substringWithRange:range]]scanHexInt:&red];
    
    range.location =2;
    
    [[NSScanner scannerWithString:[hexColorString substringWithRange:range]]scanHexInt:&green];
    
    range.location =4;
    
    [[NSScanner scannerWithString:[hexColorString substringWithRange:range]]scanHexInt:&blue];
    
    UIColor *color = [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green/255.0f)blue:(float)(blue/255.0f)alpha:alpha];
    
    return color;
}


-(void)dealloc{
//        [[FUManager shareManager] destoryItemAboutType:FUNamaHandleTypePhotolive];
}

@end
