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
#import "FUWholeAvatarModel.h"

@interface FUFacepupController ()<FUAvatarsControllerDelegate,FUAvatarCollectionViewDelegate>
@property(strong,nonatomic) FUAvatarCollectionView *avatarCollectionView;

@property(strong,nonatomic) UIButton *addBtn;

@end

@implementation FUFacepupController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[FUManager shareManager] loadAvatarBundel];
    /* 进入捏脸 */
    [[FUManager shareManager] enterAvatar];
    
    [self setupView];
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
    self.addBtn = [[UIButton alloc] init];
    _addBtn.layer.backgroundColor = [UIColor colorWithRed:31/255.0 green:178/255.0 blue:255/255.0 alpha:1.0].CGColor;
    _addBtn.layer.cornerRadius = 16;
    _addBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [_addBtn setTitle:NSLocalizedString(@"新建模型", nil) forState:UIControlStateNormal];
    [_addBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_addBtn addTarget:self action:@selector(pushFaceEditView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addBtn];
    
    /* collectionView */
    _avatarCollectionView = [[FUAvatarCollectionView alloc] init];
    _avatarCollectionView.backgroundColor = [UIColor colorWithRed:5/255.0 green:15/255.0 blue:20/255.0 alpha:0.74];
    _avatarCollectionView.delegate = self;
    [_avatarCollectionView updataCurrentSel:1];
    [self.view addSubview:_avatarCollectionView];
    
    /* 添加约束 */
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
    
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
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
    if (_avatarCollectionView.selIndex == 0 || _avatarCollectionView.selIndex == 1) {
        vc.state = FUAvatarEditStateNew;
        FUWholeAvatarModel *model = [FUAvatarPresenter shareManager].wholeAvatarArray[0];
        vc.avatarModel = model;
    }else{
        vc.state = FUAvatarEditStateUpdate;
        int index = (int)_avatarCollectionView.selIndex - 1;
        FUWholeAvatarModel *model = [FUAvatarPresenter shareManager].wholeAvatarArray[index];
        vc.avatarModel = model;
    }
 
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
        [_addBtn setTitle:NSLocalizedString(@"新建模型", nil) forState:UIControlStateNormal];
        _addBtn.hidden = YES;
        return;
    }
    _addBtn.hidden = NO;
    [[FUManager shareManager] avatarBundleAddRender:YES];
    [[FUManager shareManager] enterAvatar];
    [[FUManager shareManager] clearAvatar];
    FUWholeAvatarModel *model = nil;
    if (index == 0 || index == 1) {
        model = [FUAvatarPresenter shareManager].wholeAvatarArray[0];
        [_addBtn setTitle:NSLocalizedString(@"新建模型", nil) forState:UIControlStateNormal];
    }else{
        model = [FUAvatarPresenter shareManager].wholeAvatarArray[index - 1];
        [_addBtn setTitle:NSLocalizedString(@"编辑模型", nil) forState:UIControlStateNormal];
    }
    [[FUAvatarPresenter shareManager] showAProp:model];
    [[FUManager shareManager] recomputeAvatar];
}


-(void)dealloc{
    [[FUManager shareManager] destoryItems];
    /* 退捏脸出 */
    [[FUManager shareManager] recomputeAvatar];
    [[FUManager shareManager] quitAvatar];
}


@end
