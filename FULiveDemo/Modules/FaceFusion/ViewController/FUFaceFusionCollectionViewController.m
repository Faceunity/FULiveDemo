//
//  FUFaceFusionCollectionViewController.m
//  FULiveDemo
//
//  Created by 项林平 on 2022/8/17.
//

#import "FUFaceFusionCollectionViewController.h"
#import "FUFaceFusionCaptureViewController.h"
#import "FUFaceFusionCell.h"
#import "FUFaceFusionManager.h"

@interface FUFaceFusionCollectionViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UIView *navigationView;

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation FUFaceFusionCollectionViewController

static NSString * const kFUFaceFusionCellIdentifier = @"FUFaceFusionCell";

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureUI];
}

- (void)dealloc {
    [FUFaceFusionManager destory];
}

#pragma mark - UI

- (void)configureUI {
    self.view.backgroundColor = [UIColor colorWithRed:9/255 green:0 blue:23/255 alpha:1.0];
    
    [self.view addSubview:self.navigationView];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom);
        make.leading.trailing.bottom.equalTo(self.view);
    }];
}

#pragma mark - Event response

- (void)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [FUFaceFusionManager sharedManager].listItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FUFaceFusionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFUFaceFusionCellIdentifier forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:[FUFaceFusionManager sharedManager].listItems[indexPath.item]];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [FUFaceFusionManager sharedManager].selectedIndex = indexPath.item;
    FUFaceFusionCaptureViewController *controller = [[FUFaceFusionCaptureViewController alloc] initWithViewModel:[[FUFaceFusionCaptureViewModel alloc] init]];
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - Getters

- (UIView *)navigationView {
    if (!_navigationView) {
        _navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 44 + FUStatusBarHeight)];
        _navigationView.backgroundColor = FUColorFromHex(0x030010);
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setImage:[UIImage imageNamed:@"back_item"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        [_navigationView addSubview:backButton];
        [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_navigationView);
            make.leading.equalTo(_navigationView);
            make.size.mas_offset(CGSizeMake(54, 44));
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = FULocalizedString(@"海报换脸");
        titleLabel.font = [UIFont boldSystemFontOfSize:17];
        titleLabel.textColor = [UIColor whiteColor];
        [_navigationView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_navigationView);
            make.bottom.equalTo(_navigationView);
            make.height.mas_offset(44);
        }];

        UIView *line = [[UIView alloc] init];
        line.backgroundColor = FUColorFromHex(0x302D33);
        [_navigationView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.equalTo(_navigationView);
            make.height.mas_offset(1);
        }];
    }
    return _navigationView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat width = (CGRectGetWidth(self.view.bounds) - 51) / 2.0;
        CGFloat height = width * 1.105;
        layout.itemSize = CGSizeMake(width, height);
        layout.sectionInset = UIEdgeInsetsMake(17, 17, 17, 17);
        layout.minimumLineSpacing = 17;
        layout.minimumInteritemSpacing = 10;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor colorWithRed:9/255 green:0 blue:23/255 alpha:1.0];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[FUFaceFusionCell class] forCellWithReuseIdentifier:kFUFaceFusionCellIdentifier];
    }
    return _collectionView;
}

#pragma mark - Overriding

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

@end
