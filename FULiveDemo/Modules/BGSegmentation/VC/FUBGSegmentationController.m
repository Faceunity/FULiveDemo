//
//  FUBGSegmentationController.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/6/25.
//  Copyright © 2019 FaceUnity. All rights reserved.
//

#import "FUBGSegmentationController.h"
#import "FUItemsView.h"
#import "FUSelectedImageController.h"
#import <CoreMotion/CoreMotion.h>
#import "FUBGSegmentManager.h"
#import "FUBGSaveModel.h"
#import "UIImage+FU.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface FUBGSegmentationController ()<FUItemsViewDelegate, FUImagePickerDataDelegate>
@property (strong, nonatomic) FUItemsView *itemsView;
@property (strong, nonatomic) FUBGSegmentManager *segmentManager;

@property (strong, nonatomic) NSMutableArray *list;
@end

@implementation FUBGSegmentationController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.baseManager setMaxFaces:4];
    [self.baseManager setMaxBodies:4];
    
    self.segmentManager = [[FUBGSegmentManager alloc] init];
    [self setupView];
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[self.segmentManager additionalItems]];
    [arr addObjectsFromArray:self.model.items];
    _list = [NSMutableArray arrayWithArray:arr];
    [self.itemsView updateCollectionArray:_list];
    
    /* 初始状态 */
    NSString *selectItem = _list.count > 0 ? _list[2]:@"resetItem";
    if ([self.segmentManager isHaveCustItem]) {
        selectItem = _list[3];//人像描边
    }
    self.itemsView.selectedItem = selectItem ;
    [self itemsViewDidSelectedItem:selectItem indexPath:nil];
    
    self.segmentManager.selectedItem = selectItem;

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    /* 返回当前界面的时候，重新加载 */
    if (!self.itemsView.selectedItem) {
        self.itemsView.selectedItem = self.segmentManager.selectedItem;
    }else {
        //自定义背景并且背景
        if ([self.itemsView.selectedItem isEqualToString:CUSTOMBG]) {
            FUBGSaveModel *model = [self.segmentManager getSaveModel];
            if (model && model.type == FUBGSaveModelTypeVideo) {
                [self.segmentManager.segment startVideoDecode];
            }
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void)setupView {
    self.itemsView = [[FUItemsView alloc] init];
    self.itemsView.delegate = self;
    [self.view addSubview:self.itemsView];
    [self.itemsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.right.equalTo(self.view);
        if (iPhoneXStyle) {
            make.height.mas_equalTo(84 + 34);
        }else{
            make.height.mas_equalTo(84);
        }
    }];
    
    self.photoBtn.transform = CGAffineTransformMakeTranslation(0, -36) ;
}


-(void)headButtonViewBackAction:(UIButton *)btn {
    [self.segmentManager releaseItem];
    [super headButtonViewBackAction:btn];
}

#pragma mark -  FUItemsViewDelegate
- (void)itemsViewDidSelectedItem:(NSString *)item indexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weak = self;
    if (indexPath.row == 1) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.segmentManager.segment stopVideoDecode];
            [self didClickSelPhoto];
        });
    } else if ([item isEqualToString:CUSTOMBG]) {
        [self.itemsView startAnimation];
        [self.segmentManager loadItem:item completion:^(BOOL finished) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weak.itemsView stopAnimation];
                if (finished) {
                    FUBGSaveModel *model = [weak.segmentManager getSaveModel];
                    if (model.type == FUBGSaveModelTypeVideo) {
                        weak.segmentManager.segment.videoPath = model.url;
                        UIImage *image = model.iconImage; //先从本地取，没有在解析视频第一帧
                        if (!image) {
                            image = [weak.segmentManager.segment readFirstFrame];
                        }
                        if (image) {
                            [weak saveImg:image withName:CUSTOMBG];
                        } else {
                            //未获取当前录像的第一帧，移除自定义背景
                            [_list removeObject:CUSTOMBG];
                            weak.itemsView.selectedItem = _list[2];
                            [weak.itemsView updateCollectionArray:_list];
                            //移除缓存的第一帧图片
                            [weak removeCacheImage: CUSTOMBG];
                            //刷新默认的outline 效果
                            [weak itemsViewDidSelectedItem:weak.itemsView.selectedItem  indexPath:nil];
                        }
                        [weak.itemsView reloadData];
                    } else {
                        UIImage *image = [weak loadImageWithName:CUSTOMBG];
                        if (image) {
                            weak.segmentManager.segment.backgroundImage = image;
                        }
                    }
                }
            });
        }];
    } else if ([item isEqualToString:HUMANOUTLINE]) {
        [self.itemsView startAnimation];
        [self.segmentManager loadItem:item completion:^(BOOL finished) {
            [weak.itemsView stopAnimation];
            weak.segmentManager.segment.lineGap = 2.8;
            weak.segmentManager.segment.lineSize = 2.8;
            weak.segmentManager.segment.lineColor = FUColorMake(255/255.0, 180/255.0, 0.0, 0.0);
            [weak.itemsView stopAnimation];
        }];
    } else {
        [self.itemsView startAnimation];
        [self.segmentManager loadItem:item completion:^(BOOL finished) {
            [weak.itemsView stopAnimation];
        }];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *hint = [self.segmentManager getStickTipsWithItemName:item];
        self.tipLabel.hidden = hint == nil;
        if (hint && hint.length != 0) {
            self.tipLabel.text = FUNSLocalizedString(hint, nil);
        }
        [FUBGSegmentationController cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissTipLabel) object:nil];
        [self performSelector:@selector(dismissTipLabel) withObject:nil afterDelay:1];
    });
}

- (void)dismissTipLabel
{
    self.tipLabel.hidden = YES;
}

/* 切换前后置 */
-(void)headButtonViewSwitchAction:(UIButton *)btn{
    [super headButtonViewSwitchAction:btn];
    
    self.segmentManager.segment.cameraMode = btn.selected?1:0;
 }

#pragma  mark -  按钮点击
-(void)didClickSelPhoto{
    FUSelectedImageController *vc = [[FUSelectedImageController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
    
    vc.didCancel = ^{
        _itemsView.selectedItem = self.segmentManager.selectedItem;
        [_itemsView stopAnimation];
        [_itemsView.collection reloadData];
    };
}

-(void)displayPromptText{
    if ([self.segmentManager.selectedItem isEqualToString:@"resetItem"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.noTrackLabel.hidden = YES;
        });
    } else {
        BOOL result = [self.baseManager bodyTrace];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.noTrackLabel.text = FUNSLocalizedString(@"未检测到人体",nil);
            self.noTrackLabel.hidden = result;
        }) ;
    }
}

#pragma  mark -  FUImagePickerDataDelegate
-(void)imagePicker:(UIImagePickerController *)picker didFinishWithInfo:(NSDictionary<NSString *,id> *)info {
    if ([self.segmentManager isHaveCustItem]) {
        [_list removeObject:CUSTOMBG];
    }
    [self.segmentManager.segment stopVideoDecode];
    
    FUBGSaveModel *model = [[FUBGSaveModel alloc] init];
    model.pathName = CUSTOMBG;
    [picker dismissViewControllerAnimated:NO completion:^{
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        
        if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]){  //视频
            NSURL *videoURL = info[UIImagePickerControllerMediaURL];
            model.type = FUBGSaveModelTypeVideo;
            model.url = videoURL;

//            [self.itemsView startAnimation];
//            __weak typeof(self) weak = self;
//            [self.segmentManager loadItem:CUSTOMBG completion:^(BOOL finished) {
//                [weak.itemsView stopAnimation];
//                weak.segmentManager.segment.videoPath = model.url;
//                UIImage *image = [weak.segmentManager.segment readFirstFrame];
//                if (image) {
//                    [weak saveImg:image withName:CUSTOMBG];
//                    model.iconImage = image;
//                    [weak.segmentManager saveModel: model];
//                    [weak.itemsView reloadData];
//                }
//            }];
        } else if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) { //照片
            
            UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
            
            CGFloat imagePixel = image.size.width * image.size.height;
            // 超过限制像素需要压缩
            if (imagePixel > FUPicturePixelMaxSize) {
                CGFloat ratio = FUPicturePixelMaxSize / imagePixel * 1.0;
                image = [image fu_compress:ratio];
            }
            
            // 图片转正
            if (image.imageOrientation != UIImageOrientationUp && image.imageOrientation != UIImageOrientationUpMirrored) {
                image = [image fu_resetImageOrientationToUp];
            }
            
            [self saveImg:image withName:CUSTOMBG];
            
            model.type = FUBGSaveModelTypeImage;
        }
        [self.segmentManager saveModel: model];
        [_list insertObject:CUSTOMBG atIndex:2];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.itemsView updateCollectionArray:_list];
            self.itemsView.selectedItem = _list[2];
            [self itemsViewDidSelectedItem:self.itemsView.selectedItem indexPath:nil];
        });
    }];
}

// 保存
- (NSString *)saveImg:(UIImage *)image withName:(NSString *)imgName {
    
    if (!image) {
        return nil;
    }
    if (!imgName) {
        return nil;
    }
    NSData *imagedata=UIImagePNGRepresentation(image);
    NSString *savedImagePath = [FUDocumentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", imgName]];
    [imagedata writeToFile:savedImagePath atomically:YES];
    return savedImagePath;
}

- (UIImage *)loadImageWithName:(NSString *)imgName {
    NSString *imagePath = [FUDocumentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", imgName]];
    
    UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
    return img;
}


- (void)removeCacheImage:(NSString *)imgName {
    NSString *imagePath = [FUDocumentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", imgName]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
    }
}


- (void)willResignActive {
    [self.segmentManager.segment stopVideoDecode];
}


- (void)didBecomeActive {
    [self.segmentManager.segment startVideoDecode];
}

-(void)dealloc{
    NSLog(@"dealloc--------");
}

@end
