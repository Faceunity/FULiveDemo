//
//  FUNomalItemRenderMediaViewController.m
//  FULiveDemo
//
//  Created by 项林平 on 2021/12/9.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUNomalItemRenderMediaViewController.h"
#import "FUItemsView.h"

#import "FUStickerManager.h"
#import "FUManager.h"

@interface FUNomalItemRenderMediaViewController ()<FUItemsViewDelegate>

@property (nonatomic, strong) FUItemsView *normalItemsView;

@property (nonatomic, strong) FUStickerManager *stickerManager;

@end

@implementation FUNomalItemRenderMediaViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.normalItemsView];
    [self.normalItemsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.leading.trailing.equalTo(self.view);
        if (iPhoneXStyle) {
            make.height.mas_equalTo(118);
        }else{
            make.height.mas_equalTo(84);
        }
    }];
    
    [self refreshDownloadButtonTransformWithHeight:38 show:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.stickerManager releaseItem];
}

#pragma mark - FURenderMediaProtocol

- (BOOL)isNeedTrack {
    return YES;
}

- (FUTrackType)trackType {
    return FUTrackTypeFace;
}

#pragma mark - FUItemsViewDelegate

- (void)itemsViewDidSelectedItem:(NSString *)item indexPath:(NSIndexPath *)indexPath {
    [self.normalItemsView startAnimation];
    __weak typeof(self) weakSelf = self;
    [self.stickerManager loadItem:item completion:^(BOOL finished) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf.normalItemsView stopAnimation];
    }];
}

#pragma mark - Getters

- (FUItemsView *)normalItemsView {
    if (!_normalItemsView) {
        _normalItemsView = [[FUItemsView alloc] init];
        _normalItemsView.delegate = self;
        [_normalItemsView updateCollectionArray:[FUManager shareManager].currentModel.items];
        if ([FUManager shareManager].currentModel.items.count > 1) {
            _normalItemsView.selectedItem = [FUManager shareManager].currentModel.items[1];
            [self itemsViewDidSelectedItem:_normalItemsView.selectedItem indexPath:nil];
        }
    }
    return _normalItemsView;
}

- (FUStickerManager *)stickerManager {
    if (!_stickerManager) {
        _stickerManager = [[FUStickerManager alloc] init];
        switch ([FUManager shareManager].currentModel.type) {
            case FULiveModelTypeItems: {
                _stickerManager.type = FUStickerPropType;
            }
                break;
            case FULiveModelTypeGestureRecognition: {
                _stickerManager.type = FUGestureType;
            }
                break;
            default:
                break;
        }
    }
    return _stickerManager;
}

@end
