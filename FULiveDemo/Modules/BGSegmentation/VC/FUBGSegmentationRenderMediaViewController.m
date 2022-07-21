//
//  FUBGSegmentationRenderMediaViewController.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/5/17.
//  Copyright © 2022 FaceUnity. All rights reserved.
//

#import "FUBGSegmentationRenderMediaViewController.h"
#import "FUItemsView.h"
#import "FUBGSegmentManager.h"

@interface FUBGSegmentationRenderMediaViewController ()<FUItemsViewDelegate>

@property (strong, nonatomic) FUItemsView *itemsView;
@property (strong, nonatomic) FUBGSegmentManager *segmentManager;
@property (copy, nonatomic) NSArray *list;

@end

@implementation FUBGSegmentationRenderMediaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.baseManager setMaxFaces:4];
    [self.baseManager setMaxBodies:4];
    
    self.segmentManager = [[FUBGSegmentManager alloc] init];
    
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
    
    [self.itemsView updateCollectionArray:self.list];
    self.itemsView.selectedItem = self.list[2];
    [self itemsViewDidSelectedItem:self.list[2] indexPath:nil];
    self.segmentManager.selectedItem = self.list[2];
    
    [self refreshDownloadButtonTransformWithHeight:38 show:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.segmentManager releaseItem];
}

#pragma mark - FURenderMediaProtocol

- (BOOL)isNeedTrack {
    return YES;
}

- (FUTrackType)trackType {
    return FUTrackTypeBody;
}

#pragma mark - FUItemsViewDelegate

- (void)itemsViewDidSelectedItem:(NSString *)item indexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    if ([item isEqualToString:HUMANOUTLINE]) {
        [self.itemsView startAnimation];
        [self.segmentManager loadItem:item completion:^(BOOL finished) {
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf.itemsView stopAnimation];
            strongSelf.segmentManager.segment.lineGap = 2.8;
            strongSelf.segmentManager.segment.lineSize = 2.8;
            strongSelf.segmentManager.segment.lineColor = FUColorMake(255/255.0, 180/255.0, 0.0, 0.0);
            [strongSelf.itemsView stopAnimation];
        }];
    } else {
        [self.itemsView startAnimation];
        [self.segmentManager loadItem:item completion:^(BOOL finished) {
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf.itemsView stopAnimation];
        }];
    }
}

- (NSArray *)list {
    if (!_list) {
        NSMutableArray *temp = [NSMutableArray arrayWithObject:@"resetItem"];
        [temp addObjectsFromArray:@[@"human_outline_740", @"boyfriend1_740", @"boyfriend2_740", @"boyfriend3_740", @"hez_ztt_fu", @"gufeng_zh_fu", @"xiandai_ztt_fu", @"sea_lm_fu", @"ice_lm_fu"]];
        _list = [temp copy];
    }
    return _list;
}

@end
