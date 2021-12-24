//
//  FULvMuView.m
//  FULiveDemo
//
//  Created by 孙慕 on 2020/8/13.
//  Copyright © 2020 FaceUnity. All rights reserved.
//

#import "FULvMuView.h"
#import "UIColor+FUAPIDemoBar.h"
#import "FUSegmentBarView.h"
#import "FUBaseViewController.h"
#import "FUSquareButton.h"
#import "FUMakeupSlider.h"
#import "FUBgCollectionView.h"
#import "FUSafeAreaCollectionView.h"
#import "FULiveDefine.h"
#import "FUTipHUD.h"

#import "UIView+FU.h"
#import "UIImage+FU.h"

#import <MobileCoreServices/MobileCoreServices.h>

typedef NS_ENUM(NSUInteger, FULvMuState) {
    FULvMukeying,
    FULvMubackground
};
@implementation FULvMuCell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        self.imageView.layer.masksToBounds = YES ;
        self.imageView.layer.cornerRadius = frame.size.width / 2.0 ;
        [self addSubview:self.imageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(-10, frame.size.width + 7, frame.size.width + 20, frame.size.height - frame.size.width - 2)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter ;
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont systemFontOfSize:10];
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        
        [self addSubview:self.titleLabel];
    }
    return self ;
}
@end


@implementation FULvMuColorCell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, frame.size.width -2, frame.size.width-2)];
        _bgImageView.image = [UIImage imageNamed:@"demo_bg_transparent"];
        _bgImageView.layer.cornerRadius = _bgImageView.frame.size.width / 2.0 ;
        [self addSubview:_bgImageView];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        self.imageView.layer.masksToBounds = YES ;
        self.imageView.layer.cornerRadius = frame.size.width / 2.0 ;
        self.contentView.layer.borderWidth = 0;
        self.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
        
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius = frame.size.width / 2.0 ;
        
        [self addSubview:self.imageView];
        
    }
    return self ;
}

-(void)setColorItemSelected:(BOOL)selecte{
    if (selecte) {
        self.imageView.transform = CGAffineTransformIdentity;
        self.bgImageView.transform = CGAffineTransformIdentity;
        self.contentView.layer.borderWidth = 2;
        [UIView animateWithDuration:0.25 animations:^{
            self.imageView.transform = CGAffineTransformMakeScale(0.7, 0.7);
            self.bgImageView.transform = CGAffineTransformMakeScale(0.7, 0.7);
        }];
    }else{
        self.contentView.layer.borderWidth = 0;
        //        [UIView animateWithDuration:0.25 animations:^{
        self.imageView.transform = CGAffineTransformIdentity;
        self.bgImageView.transform = CGAffineTransformIdentity;
        //        }];
    }
}
@end


static NSString * const LvMuCellID = @"FULvMuCellID";
static NSString * const colorCellID = @"FULvMuColorCellID";

@interface FULvMuView()<UICollectionViewDelegate,UICollectionViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate,  FUSafeAreaCollectionViewDelegate, FUBgCollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *mColorCollectionView;

@property (nonatomic, strong) UICollectionView *mItemCollectionView;

/// 安全区域
@property (nonatomic, strong) FUSafeAreaCollectionView *safeAreaCollectionView;

@property (strong, nonatomic) FUSegmentBarView *segmentBarView;

@property (strong, nonatomic) FUMakeupSlider *slider;
@property (strong, nonatomic) UIView *sqLine;

@property (strong, nonatomic) FUSquareButton *restBtn;

@property (assign, nonatomic) FULvMuState state;

/// 是否显示安全区域视图
@property (assign, nonatomic) BOOL isShowingSafeArea;

@property (strong, nonatomic) NSMutableArray <UIColor *>* colors;

@property (strong, nonatomic) FUBgCollectionView *mBgCollectionView;


@property (assign, nonatomic) FUTakeColorState colorEditState;

@property (nonatomic, strong) NSMutableArray <FUGreenScreenModel *>*dataArray;

@end

@implementation FULvMuView
- (void)setTakeColor:(UIColor *)color {
    self.mTakeColorView.perView.backgroundColor = color;
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
    FULvMuColorCell *cell = (FULvMuColorCell *)[self.mColorCollectionView cellForItemAtIndexPath:indexpath];
    cell.imageView.backgroundColor = color;
    [self.colors replaceObjectAtIndex:0 withObject:color];
}

-(FUTakeColorView *)mTakeColorView{
    if (!_mTakeColorView) {
        __weak typeof(self)weakSelf  = self ;
        _mTakeColorView = [[FUTakeColorView alloc] initWithFrame:CGRectMake(100, 100, 36, 60) didChangeBlock:^(UIColor * _Nonnull color) {
            if (!weakSelf.mColorCollectionView) {
                return ;
            }
            
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
            FULvMuColorCell *cell = (FULvMuColorCell *)[weakSelf.mColorCollectionView cellForItemAtIndexPath:indexpath];
            cell.imageView.backgroundColor = color;
            [weakSelf.colors replaceObjectAtIndex:0 withObject:color];
            
        }complete:^{
            UIColor *color = weakSelf.colors[0];
            if ([weakSelf.mDelegate respondsToSelector:@selector(colorDidSelected:)]) {
                [weakSelf.mDelegate colorDidSelected:color];
            }
            
            /* 开始渲染 */
            [weakSelf changeTakeColorState:FUTakeColorStateStop];
        }];
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
        FULvMuColorCell *cell = (FULvMuColorCell *)[weakSelf.mColorCollectionView cellForItemAtIndexPath:indexpath];
        _mTakeColorView.hidden = YES;
        _mTakeColorView.backgroundColor = [UIColor clearColor];
        _mTakeColorView.perView.backgroundColor = cell.imageView.backgroundColor;
        _mTakeColorView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
        
        UIView *bgView = nil;
        if ([self.mDelegate respondsToSelector:@selector(takeColorBgView)]) {
            bgView = [self.mDelegate takeColorBgView];
            [_mTakeColorView actionRect:bgView.bounds];
        } else {
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            bgView = window;
            [_mTakeColorView actionRect:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 180)];
        }

        [bgView addSubview:_mTakeColorView];
        
        __weak typeof(self) weak = self;
        _mTakeColorView.BlockPointer = ^(CGPoint point) {
            if ([weak.mDelegate respondsToSelector:@selector(getPoint:)]) {
                [weak.mDelegate getPoint:point];
            }
        };
    }
    
    return _mTakeColorView;
}


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _colorSelectedIndex = 1;
        _selectedIndex = 0;
        _colorEditState = FUTakeColorStateStop;
        
        [self setupSubView];
        [self setupData];
        self.clipsToBounds = YES;
        self.isHidenTop = NO;
    }
    return self;
}

-(void)setMDelegate:(id<FULvMuViewDelegate>)mDelegate{
    _mDelegate = mDelegate;
    [self setupDefault];
}

- (void)reloadDataSoure:(NSArray <FUGreenScreenModel *> *)dataSource {
    _dataArray = [NSMutableArray arrayWithArray:dataSource];
    [self.mColorCollectionView reloadData];
    [self.safeAreaCollectionView reloadSafeAreas];
}

//刷新绿慕背景collection数据
- (void)reloadBgDataSource:(NSArray <FUGreenScreenBgModel *> *)dataSource {
    _mBgCollectionView.filters = dataSource;
}

-(void)setupDefault{
    /* 设置回调一遍默认 */
    if ([self.mDelegate respondsToSelector:@selector(colorDidSelected:)]) {
        [self.mDelegate colorDidSelected:[UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0]];
    }
    
    for (int i = 1 ; i < _dataArray.count; i ++) {
        FUGreenScreenModel *param = _dataArray[i];
        if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(beautyCollectionView:didSelectedParam:)]) {
            [self.mDelegate beautyCollectionView:self didSelectedParam:param];
        }
    }
}

-(void)setupData{
    _colors = [NSMutableArray array];
    UIColor *color0 = [UIColor clearColor];
    UIColor *color1 = [UIColor colorWithRed:0 green:1.0 blue:0 alpha:1.0];
    UIColor *color2 = [UIColor colorWithRed:0 green:0.0 blue:1 alpha:1.0];
    [_colors addObject:color0];
    [_colors addObject:color1];
    [_colors addObject:color2];
}


-(void)setupSubView{
    _slider = [[FUMakeupSlider alloc] init];
    _slider.hidden = YES;
    [_slider addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
    [_slider addTarget:self action:@selector(didChangeValueEnd:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_slider];
    
    _restBtn = [[FUSquareButton alloc] init];
    [self addSubview:_restBtn];
    [_restBtn setImage:[UIImage imageNamed:@"恢复-0"] forState:UIControlStateNormal];
    _restBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    _restBtn.alpha = 0.7;
    [_restBtn addTarget:self action:@selector(resetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_restBtn setTitle:FUNSLocalizedString(@"恢复", nil) forState:UIControlStateNormal];
    
    _sqLine = [[UIView alloc] init];
    _sqLine.frame = CGRectMake(73,663,0.5,20);
    _sqLine.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.2].CGColor;
    [self addSubview:_sqLine];
    
    
    UICollectionViewFlowLayout *layout1 = [[UICollectionViewFlowLayout alloc] init];
    layout1.minimumInteritemSpacing = 0;
    layout1.minimumLineSpacing = 16;
    layout1.itemSize = CGSizeMake(28, 28);
    layout1.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
    layout1.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _mColorCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout1];
    _mColorCollectionView.backgroundColor = [UIColor clearColor];
    _mColorCollectionView.delegate = self;
    _mColorCollectionView.dataSource = self;
    [self addSubview:_mColorCollectionView];
    [_mColorCollectionView registerClass:[FULvMuColorCell class] forCellWithReuseIdentifier:colorCellID];
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.alpha = 1.0;
    [self insertSubview:effectview atIndex:0];
    
    /* 磨玻璃 */
    [effectview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
    }];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 30;
    layout.itemSize = CGSizeMake(44, 60);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 15);
    
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 80);
    _mItemCollectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    _mItemCollectionView.backgroundColor = [UIColor clearColor];
    _mItemCollectionView.showsHorizontalScrollIndicator = NO;
    _mItemCollectionView.delegate = self;
    _mItemCollectionView.dataSource = self;
    [self addSubview:_mItemCollectionView];
    [_mItemCollectionView registerClass:[FULvMuCell class] forCellWithReuseIdentifier:LvMuCellID];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 15;
    flowLayout.minimumLineSpacing = 15;
    flowLayout.itemSize = CGSizeMake(54, 70);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 16, 0, 16);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _safeAreaCollectionView = [[FUSafeAreaCollectionView alloc] initWithFrame:CGRectMake(0, 56, CGRectGetWidth(self.bounds), 84) collectionViewLayout:flowLayout];
    _safeAreaCollectionView.hidden = YES;
    _safeAreaCollectionView.safeAreaDelegate = self;
    [self addSubview:_safeAreaCollectionView];
    
    __weak typeof(self)weakSelf  = self ;
    _segmentBarView = [[FUSegmentBarView alloc] initWithFrame:CGRectMake(0, 200,[UIScreen mainScreen].bounds.size.width, 49) titleArray:@[FUNSLocalizedString(@"抠像",nil),FUNSLocalizedString(@"背景",nil)] selBlock:^(int index) {
        FULvMuState tepState = index==0? FULvMukeying:FULvMubackground;
        if (weakSelf.state == tepState) {
            weakSelf.state = tepState;
            [weakSelf hidenTop:YES];
        }else{
            weakSelf.state = tepState;
            [weakSelf segmentBarClickUpdateView:weakSelf.state];
            [weakSelf hidenTop:NO];
        }
        
    }];
    _segmentBarView.backgroundColor = [UIColor colorWithRed:5/255.f green:15/255.f blue:20/255.f alpha:0.74];
    //    [_segmentBarView setUINormal];
    [self addSubview:_segmentBarView];
    
    _mBgCollectionView = [[FUBgCollectionView alloc] init];
    _mBgCollectionView.mDelegate = self;
    _mBgCollectionView.hidden = YES;
    [_mBgCollectionView setSelectedIndex:3];
    [self addSubview:_mBgCollectionView];
    
    [_segmentBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.right.equalTo(self);
        if (iPhoneXStyle) {
            make.height.mas_equalTo(49 + 34);
        }else{
            make.height.mas_equalTo(49);
        }
    }];
    
    [_mItemCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(_segmentBarView.mas_top).offset(-6);
        make.left.equalTo(_sqLine.mas_right).offset(12);
        make.right.equalTo(self);
        make.height.mas_equalTo(84);
    }];
    
    [_safeAreaCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_segmentBarView.mas_top).offset(-6);
        make.leading.trailing.equalTo(self);
        make.height.mas_equalTo(84);
    }];
    
    [_mBgCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_segmentBarView.mas_top).offset(-6);
        make.right.left.equalTo(self);
        make.height.mas_equalTo(84);
    }];
    
    
    [_restBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_mItemCollectionView);
        make.left.equalTo(self).offset(16);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(44);
    }];
    
    [_sqLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_restBtn);
        make.left.equalTo(_restBtn.mas_right).offset(12);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(0.5);
    }];
    
    [_mColorCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_mItemCollectionView.mas_top);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(36);
    }];
    
    [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_mColorCollectionView);
        make.left.equalTo(self).offset(54);
        make.right.equalTo(self).offset(-54);
        make.height.mas_equalTo(20);
    }];
    
}


#pragma mark ---- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(collectionView == _mItemCollectionView ){
        return self.dataArray.count ;
    } else {
        return 3;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == _mItemCollectionView) {
        FULvMuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LvMuCellID forIndexPath:indexPath];
        
        if (indexPath.row < self.dataArray.count){
            FUGreenScreenModel *modle = self.dataArray[indexPath.row] ;
            NSString *imageName ;
            
            BOOL opened = NO;
            if (modle.type == GREENSCREENTYPE_safeArea) {
                // 判断是否选择了安全区域
                opened = self.safeAreaCollectionView.selectedIndex > 1;
            } else {
                opened = [modle.value floatValue] > 0;
            }
            BOOL selected = _selectedIndex == indexPath.row;
            if (selected) {
                imageName = opened ? [modle.imageName stringByAppendingString:@"_sel_open.png"] : [modle.imageName stringByAppendingString:@"_sel.png"] ;
            }else {
                imageName = opened ? [modle.imageName stringByAppendingString:@"_nor_open.png"] : [modle.imageName stringByAppendingString:@"_nor.png"] ;
            }
            
            cell.imageView.image = [UIImage imageNamed:imageName];
            cell.titleLabel.text = FUNSLocalizedString(modle.title,nil);
            cell.titleLabel.textColor = _selectedIndex == indexPath.row ? [UIColor colorWithHexColorString:@"5EC7FE"] : [UIColor whiteColor];
        }
        return cell ;
    } else {
        FULvMuColorCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:colorCellID forIndexPath:indexPath];
        [cell setColorItemSelected:_colorSelectedIndex == indexPath.row ?YES:NO];
        
        cell.imageView.backgroundColor = _colors[indexPath.row];
        if(indexPath.row == 0){
            cell.imageView.backgroundColor = [UIColor clearColor];
            if(_colorSelectedIndex != 0){
                cell.imageView.image = [UIImage imageNamed:@"demo_icon_straw"];
                
            }else{
                cell.imageView.image = nil;
            }
            
        }else{
            cell.imageView.image = nil;
        }
        return cell;
    }
}

#pragma mark ---- UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //    [self changeTakeColorState:FUTakeColorStateStop];
    if (collectionView == _mItemCollectionView) {
        if (_selectedIndex == indexPath.row) {
            return ;
        }
        FUGreenScreenModel *model = _dataArray[indexPath.row];
        if (model.type == GREENSCREENTYPE_safeArea) {
            // 显示安全区域
            self.mItemCollectionView.hidden = YES;
            self.slider.hidden = YES;
            self.restBtn.hidden = YES;
            self.sqLine.hidden = YES;
            self.mColorCollectionView.hidden = YES;
            self.safeAreaCollectionView.hidden = NO;
            _isShowingSafeArea = YES;
            [FUTipHUD showTips:@"白色区域为安全区域，不参与绿幕抠像"];
        } else {
            _selectedIndex = indexPath.row ;
            [self hiddenSlideer:_selectedIndex == 0 ? YES : NO];
            _slider.value = [model.value floatValue];
            [self.mItemCollectionView reloadData];
        }
    } else {
        if(_colorSelectedIndex == indexPath.row && indexPath.row != 0){
            return;
        }
        self.mTakeColorView.hidden = indexPath.row == 0 ?NO:YES;
        
        if (indexPath.row == 0) {
            self.mTakeColorView.perView.backgroundColor = [UIColor clearColor];
            [self changeTakeColorState:FUTakeColorStateRunning];
        }else{
            [self changeTakeColorState:FUTakeColorStateStop];
        }
        _colorSelectedIndex = indexPath.row ;
        
        [self didSelColorWithIdnex:(int)indexPath.row];
        
        [self.mColorCollectionView reloadData];
    }
    [self changRestBtnUI];
}

#pragma  mark - update UI
-(void)hiddenSlideer:(BOOL)hidden
{
    self.slider.hidden = hidden;
    self.mColorCollectionView.hidden = !hidden;
}

-(void)segmentBarClickUpdateView:(FULvMuState)state{
    if (state == FULvMubackground) {
        // 显示背景相关内容
        _mColorCollectionView.hidden = YES;
        _mItemCollectionView.hidden = YES;
        _slider.hidden = YES;
        _restBtn.hidden = YES;
        _sqLine.hidden = YES;
        _mColorCollectionView.hidden = YES;
        _safeAreaCollectionView.hidden = YES;
        _mBgCollectionView.hidden = NO;
    } else {
        _mBgCollectionView.hidden = YES;
        if (_isShowingSafeArea) {
            // 安全区域已经显示的情况
            _mColorCollectionView.hidden = YES;
            _mItemCollectionView.hidden = YES;
            _slider.hidden = YES;
            _restBtn.hidden = YES;
            _sqLine.hidden = YES;
            _mColorCollectionView.hidden = YES;
            _safeAreaCollectionView.hidden = NO;
        } else {
            _safeAreaCollectionView.hidden = YES;
            _mItemCollectionView.hidden = NO;
            [self hiddenSlideer:_selectedIndex == 0?YES:NO];
            _restBtn.hidden = NO;
            _sqLine.hidden = NO;
        }
    }
}


-(void)restAllSate {
    [self changeTakeColorState:FUTakeColorStateStop];
    
    for (FUGreenScreenModel *param in _dataArray) {
        param.value = param.defaultValue;
    }
    
    [self.colors replaceObjectAtIndex:0 withObject:[UIColor clearColor]];
    
    _colorSelectedIndex = 1;
    _selectedIndex = 0;
    _slider.hidden = YES;
    _mColorCollectionView.hidden = NO;
    
    [self setupDefault];
    
    [self.mItemCollectionView reloadData];
    [self.mColorCollectionView reloadData];
    
    self.safeAreaCollectionView.selectedIndex = 1;
    [self.safeAreaCollectionView reloadData];
    [self safeAreaCollectionViewDidClickCancel:self.safeAreaCollectionView];
    
    _restBtn.alpha = 0.7;
}

#pragma  mark -  UI Action
-(void)resetBtnClick:(UIButton *)btn{
    if (_restBtn.alpha != 1) {
        return;
    }
    
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:nil message:FUNSLocalizedString(@"是否将所有参数恢复到默认值",nil) preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:FUNSLocalizedString(@"取消",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [cancleAction setValue:[UIColor colorWithRed:44/255.0 green:46/255.0 blue:48/255.0 alpha:1.0] forKey:@"titleTextColor"];
    
    UIAlertAction *certainAction = [UIAlertAction actionWithTitle:FUNSLocalizedString(@"确定",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self restAllSate];
    }];
    [certainAction setValue:[UIColor colorWithRed:31/255.0 green:178/255.0 blue:255/255.0 alpha:1.0] forKey:@"titleTextColor"];
    
    [alertCon addAction:cancleAction];
    [alertCon addAction:certainAction];
    
    [[self fu_targetViewController]  presentViewController:alertCon animated:YES completion:^{
    }];
}

-(void)didSelColorWithIdnex:(int)index{
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:index inSection:0];
    FULvMuColorCell *cell = (FULvMuColorCell *)[_mColorCollectionView cellForItemAtIndexPath:indexpath];
    if ([self.mDelegate respondsToSelector:@selector(colorDidSelected:)]) {
        [self.mDelegate colorDidSelected:cell.imageView.backgroundColor];
    }
}

-(void)didChangeValue:(FUMakeupSlider *)slider{
    FUGreenScreenModel *param = _dataArray[_selectedIndex];
    param.value = [NSNumber numberWithFloat:slider.value];
    
    if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(beautyCollectionView:didSelectedParam:)]) {
        [self.mDelegate beautyCollectionView:self didSelectedParam:param];
    }
}
-(void)didChangeValueEnd:(FUMakeupSlider *)slider{
    [self.mItemCollectionView reloadData];
    [self changRestBtnUI];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (!image) {
            return;
        }
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
        // 保存自定义安全区域图片
        if ([FUGreenScreenManager saveLocalSafeAreaImage:image]) {
            // 设置选中自定义，重新加载安全区域数据
            self.safeAreaCollectionView.selectedIndex = 3;
            [self.safeAreaCollectionView reloadSafeAreas];
            if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(lvmuViewDidSelectSafeArea:)] && self.safeAreaCollectionView.safeAreas.count == 3) {
                [self.mDelegate lvmuViewDidSelectSafeArea:self.safeAreaCollectionView.safeAreas[0]];
            }
        }
    }];
}

#pragma mark - FUSafeAreaCollectionViewDelegate
- (void)safeAreaCollectionViewDidClickBack:(FUSafeAreaCollectionView *)safeAreaView {
    _safeAreaCollectionView.hidden = YES;
    _isShowingSafeArea = NO;
    _mItemCollectionView.hidden = NO;
    [self hiddenSlideer:_selectedIndex == 0?YES:NO];
    _restBtn.hidden = NO;
    _sqLine.hidden = NO;
}
- (void)safeAreaCollectionViewDidClickCancel:(FUSafeAreaCollectionView *)safeAreaView {
    [self.mItemCollectionView reloadData];
    [self changRestBtnUI];
    if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(lvmuViewDidCancelSafeArea)]) {
        [self.mDelegate lvmuViewDidCancelSafeArea];
    }
}
- (void)safeAreaCollectionViewDidClickAdd:(FUSafeAreaCollectionView *)safeAreaView {
    // 调用系统相册选择图片
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.allowsEditing = NO;
    picker.mediaTypes = @[(NSString *)kUTTypeImage];
    [self.fu_targetViewController presentViewController:picker animated:YES completion:nil];
}
- (void)safeAreaCollectionView:(FUSafeAreaCollectionView *)safeAreaView didSelectItemAtIndex:(NSInteger)index {
    if (index < 3) {
        return;
    }
    if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(lvmuViewDidSelectSafeArea:)]) {
        [self.mDelegate lvmuViewDidSelectSafeArea:safeAreaView.safeAreas[index - 3]];
    }
    [self.mItemCollectionView reloadData];
    [self changRestBtnUI];
}

#pragma mark -  bgdelegate
-(void)bgCollectionViewDidSelectedFilter:(FUGreenScreenModel *)param{
    if ([self.mDelegate respondsToSelector:@selector(didSelectedParam:)]) {
        [self.mDelegate didSelectedParam:param];
    }
}


#pragma  mark -  外部调用接口
-(void)hidenTop:(BOOL)isHiden{
    _isHidenTop = isHiden;
    if (isHiden) {
        [_segmentBarView setUINormal];
        self.state = 3;
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            if (iPhoneXStyle) {
                make.height.mas_equalTo(49 + 34);
            }else{
                make.height.mas_equalTo(49);
            }
        }];
    }else{
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            if (iPhoneXStyle) {
                make.height.mas_equalTo(195 + 34);
            }else{
                make.height.mas_equalTo(195);
            }
        }];
    }
    
    if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(lvmuViewShowTopView:)]) {
        [self.mDelegate lvmuViewShowTopView:!isHiden];
    }
}

-(void)destoryLvMuView {
    if ([_mTakeColorView.superview isKindOfClass:[UIWindow class]]) {
        [_mTakeColorView removeFromSuperview];
        _mTakeColorView  = nil;
    } else {
        //无需处理
    }
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self changeTakeColorState:FUTakeColorStateStop];
}

-(void)willRemoveSubview:(UIView *)subview{
    [_mTakeColorView removeFromSuperview];
}


-(void)restUI{
    [self restAllSate];
}

-(void)changeTakeColorState:(FUTakeColorState )state{
    if (state != self.colorEditState) {
        self.colorEditState = state;
    }else{
        return;
    }
    if (state == FUTakeColorStateStop) {
        _mTakeColorView.hidden = YES;
    }
    
    if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(takeColorState:)]) {
        [self.mDelegate takeColorState:state];
    }
    
}



-(void)changRestBtnUI{
    
    BOOL isDefaultValue = YES;
    for (FUGreenScreenModel *param in _dataArray) {
        if (fabs([(NSNumber *)param.value doubleValue] - [(NSNumber *)param.defaultValue doubleValue        ]) > 0.01)  {
            isDefaultValue = NO;
        }
    }
    if(_colorSelectedIndex != 1 || _selectedIndex != 0){
        isDefaultValue = NO;
    }
    if (self.safeAreaCollectionView.selectedIndex > 1) {
        isDefaultValue = NO;
    }
    if(isDefaultValue){
        self.restBtn.alpha = 0.7;
    }else{
        self.restBtn.alpha = 1.0;
    }
    
}


#pragma mark - Dealloc
-(void)dealloc {
    NSLog(@"lv ---- dealloc");
    if (_mTakeColorView) {
        [self destoryLvMuView];
    }
}



@end
