//
//  FUFacepupController.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/3/20.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import "FUFacepupController.h"
#import "FUAvatarCollectionView.h"
#import "FUAvatarEditController.h"
#import "FUManager.h"
#import "FUAvatarsController.h"
#import "FUAvatarPresenter.h"

@interface FUFacepupController ()<FUAvatarsControllerDelegate,FUAvatarCollectionViewDelegate>
@property(strong,nonatomic) FUAvatarCollectionView *avatarCollectionView;

@end

@implementation FUFacepupController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[FUManager shareManager] loadAvatarBundel];
    /* 进入捏脸 */
    [[FUManager shareManager] enterAvatar];
    
    [self setupView];
    
    NSLog(@"-------------wqwq");
}

-(void)setupView{
    self.photoBtn.transform = CGAffineTransformMakeTranslation(0, -50);
    
    /* 删除按钮 */
    UIButton *deletBtn = [[UIButton alloc] init];
    deletBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [deletBtn setTitle:NSLocalizedString(@"删除模型", nil)  forState:UIControlStateNormal];
    [deletBtn setTitleColor:[UIColor colorWithRed:44/255.0 green:46/255.0 blue:48/255.0 alpha:1.0] forState:UIControlStateNormal];
    [deletBtn addTarget:self action:@selector(pushDeletView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deletBtn];
    deletBtn.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    deletBtn.layer.cornerRadius = 16;
    deletBtn.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.15].CGColor;
    deletBtn.layer.shadowOffset = CGSizeMake(0,0);
    deletBtn.layer.shadowOpacity = 1;
    deletBtn.layer.shadowRadius = 4;
    
    /* 新建捏脸 */
    UIButton *nieBtn = [[UIButton alloc] init];
    nieBtn.layer.backgroundColor = [UIColor colorWithRed:31/255.0 green:178/255.0 blue:255/255.0 alpha:1.0].CGColor;
    nieBtn.layer.cornerRadius = 16;
    nieBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [nieBtn setTitle:NSLocalizedString(@"新建模型", nil) forState:UIControlStateNormal];
    [nieBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    [nieBtn addTarget:self action:@selector(pushFaceEditView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nieBtn];
    
    
    /* collectionView */
    _avatarCollectionView = [[FUAvatarCollectionView alloc] init];
    _avatarCollectionView.backgroundColor = [UIColor colorWithRed:5/255.0 green:15/255.0 blue:20/255.0 alpha:0.74];
    _avatarCollectionView.delegate = self;
    [_avatarCollectionView updataCurrentSel:1];
    [self.view addSubview:_avatarCollectionView];
    
    
    [_avatarCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view.mas_bottom);
        }
        make.right.left.equalTo(self.view);
        make.height.mas_equalTo(84);
    }];
    
    [deletBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(_avatarCollectionView.mas_top).offset(-18);
        } else {
            make.bottom.equalTo(_avatarCollectionView.mas_top).offset(-18);
        }
        make.left.equalTo(self.view).offset(17);
        make.height.mas_equalTo(32);
        make.width.mas_equalTo(84);
    }];
    
    [nieBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(_avatarCollectionView.mas_top).offset(-18);
        } else {
            make.bottom.equalTo(_avatarCollectionView.mas_top).offset(-18);
        }
        make.right.equalTo(self.view).offset(-17);
        make.height.mas_equalTo(32);
        make.width.mas_equalTo(84);
    }];
}

-(void)pushDeletView{
    dispatch_async(dispatch_get_main_queue(), ^{
        FUAvatarsController *vc = [[FUAvatarsController alloc] init];
        vc.mDelegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    });
}

-(void)pushFaceEditView{
    [[FUManager shareManager] avatarBundleAddRender:YES];
    if (![[FUManager shareManager] avatarBundleIsload]) {
        return;
    }
    
    FUAvatarEditController *vc = [[FUAvatarEditController alloc] init];
    __weak typeof(self)weakSelf  = self ;

    vc.returnBlock = ^(BOOL isAdd) {
        if (isAdd) {
            /* 刷新选中最后一个 */
            [weakSelf.avatarCollectionView updataCurrentSel:(int)[FUAvatarPresenter shareManager].wholeAvatarArray.count];
        }else{
            [weakSelf.avatarCollectionView updataCurrentSel:(int)weakSelf.avatarCollectionView.selIndex];
        }

    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma  mark -  FUAvatarsControllerDelegate
-(void)myItemViewDidDelete{
    /* 刷新选中最后一个 */
    [self.avatarCollectionView updataCurrentSel:(int)[FUAvatarPresenter shareManager].wholeAvatarArray.count];
}


-(void)avatarCollectionViewDidSel:(int)index{
    if (index == 0) {
//        [[FUManager shareManager] destoryItemAboutType:FUNamaHandleTypeAvtarHead];
        [[FUManager shareManager] avatarBundleAddRender:NO];
        [[FUManager shareManager] destoryItemAboutType:FUNamaHandleTypeAvtarHiar];
        return;
    }
    [[FUManager shareManager] avatarBundleAddRender:YES];
    [[FUManager shareManager] enterAvatar];
    [[FUManager shareManager] clearAvatar];
    FUWholeAvatarModel *model = [FUAvatarPresenter shareManager].wholeAvatarArray[index - 1];
    [[FUAvatarPresenter shareManager] showAProp:model];
    
    [[FUManager shareManager] recomputeAvatar];
//    [[FUManager shareManager] quitAvatar];
}


-(void)dealloc{
    [[FUManager shareManager] destoryItems];
    /* 退捏脸出 */
    [[FUManager shareManager] recomputeAvatar];
    [[FUManager shareManager] quitAvatar];
}


@end
