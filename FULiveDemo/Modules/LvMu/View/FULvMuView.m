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
#import "FUTakeColorView.h"


typedef NS_ENUM(NSUInteger, FULvMuState) {
    FULvMukeying,
    FULvMubackground,
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
        self.contentView.layer.borderWidth = 2;
        [UIView animateWithDuration:0.25 animations:^{
            self.imageView.transform = CGAffineTransformMakeScale(0.7, 0.7);
        }];
    }else{
        self.contentView.layer.borderWidth = 0;
//        [UIView animateWithDuration:0.25 animations:^{
        self.imageView.transform = CGAffineTransformIdentity;
//        }];
    }
}
@end

static NSString *LvMuCellID = @"FULvMuCellID";
static NSString *colorCellID = @"FULvMuColorCellID";

@interface FULvMuView()<UICollectionViewDelegate,UICollectionViewDataSource,FUBgCollectionViewDelegate>

@property(nonatomic,strong) UICollectionView *mColorCollectionView;

@property(nonatomic,strong) UICollectionView *mItemCollectionView;

@property (strong, nonatomic) FUSegmentBarView *segmentBarView;

@property (strong, nonatomic) FUMakeupSlider *slider;
@property (strong, nonatomic) UIView *sqLine;

@property (strong, nonatomic) FUSquareButton *restBtn;

@property (assign, nonatomic) FULvMuState state;

@property (strong, nonatomic) NSMutableArray <UIColor *>* colors;

@property (strong, nonatomic) FUBgCollectionView *mBgCollectionView;

@property (strong, nonatomic) FUTakeColorView *mTakeColorView;

@end

@implementation FULvMuView

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
            CGFloat r,g,b,a;
            [color getRed:&r green:&g blue:&b alpha:&a];

            if ([weakSelf.mDelegate respondsToSelector:@selector(colorDidSelectedR:G:B:A:)]) {
                [weakSelf.mDelegate colorDidSelectedR:r G:g B:b A:a];
            }
        }];
        _mTakeColorView.hidden = YES;
        _mTakeColorView.backgroundColor = [UIColor clearColor];
        _mTakeColorView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
        [_mTakeColorView actionRect:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 180)];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:_mTakeColorView];
    }
    
    return _mTakeColorView;
}



-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _colorSelectedIndex = 1;
        _selectedIndex = 0;
        
        [self setupSubView];
        [self setupData];
        self.clipsToBounds = YES;
    }
    return self;
}

-(void)setMDelegate:(id<FULvMuViewDelegate>)mDelegate{
    _mDelegate = mDelegate;
    [self setupDefault];
}

-(void)setupDefault{
    /* 设置回调一遍默认 */
    if ([self.mDelegate respondsToSelector:@selector(colorDidSelectedR:G:B:A:)]) {
        [self.mDelegate colorDidSelectedR:0 G:1.0 B:0.0 A:1.0];
    }
     for (int i = 1 ; i < _dataArray.count; i ++) {
         FUBeautyParam *param = _dataArray[i];
         if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(beautyCollectionView:didSelectedParam:)]) {
             [self.mDelegate beautyCollectionView:self didSelectedParam:param];
         }
     }
}

-(void)setupData{
    _colors = [NSMutableArray array];
    UIColor *color0 = [UIColor whiteColor];
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
//    restBtn.alpha = 0.7;
    [_restBtn addTarget:self action:@selector(resetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_restBtn setTitle:@"恢复" forState:UIControlStateNormal];
    
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
    
    NSArray *prams = @[@"key_color",@"chroma_thres",@"chroma_thres_T",@"alpha_L"];
    NSDictionary *titelDic = @{@"key_color":@"关键颜色",@"chroma_thres":@"相似度",@"chroma_thres_T":@"平滑",@"alpha_L":@"透明度"};
    NSDictionary *imageDic = @{@"key_color":@"demo_icon_key_color",@"chroma_thres":@"demo_icon_similarityr",@"chroma_thres_T":@"demo_icon_smooth",@"alpha_L":@"demo_icon_transparency"};
    
    NSDictionary *defaultValueDic = @{@"key_color":@(0),@"chroma_thres":@(0.38),@"chroma_thres_T":@(0.77),@"alpha_L":@(0.80)};
    
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    
    for (NSString *str in prams) {
        FUBeautyParam *modle = [[FUBeautyParam alloc] init];
        modle.mParam = str;
        modle.mTitle = [titelDic valueForKey:str];
        modle.mImageStr = [imageDic valueForKey:str];
        modle.mValue = [[defaultValueDic valueForKey:str] floatValue];
        modle.defaultValue = modle.mValue;
        [_dataArray addObject:modle];
    }

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 30;
    layout.itemSize = CGSizeMake(44, 60);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 80);
    _mItemCollectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    _mItemCollectionView.backgroundColor = [UIColor clearColor];
    _mItemCollectionView.delegate = self;
    _mItemCollectionView.dataSource = self;
    [self addSubview:_mItemCollectionView];
    [_mItemCollectionView registerClass:[FULvMuCell class] forCellWithReuseIdentifier:LvMuCellID];
    
    __weak typeof(self)weakSelf  = self ;
    _segmentBarView = [[FUSegmentBarView alloc] initWithFrame:CGRectMake(0, 200,[UIScreen mainScreen].bounds.size.width, 49) titleArray:@[@"抠像",NSLocalizedString(@"背景",nil)] selBlock:^(int index) {
        
        weakSelf.state = index==0? FULvMukeying:FULvMubackground;
        [weakSelf segmentBarClickUpdateView:weakSelf.state];
        [weakSelf hidenTop:NO];
    }];
    _segmentBarView.backgroundColor = [UIColor clearColor];
    [_segmentBarView setUINormal];
    [self addSubview:_segmentBarView];
    
    _mBgCollectionView = [[FUBgCollectionView alloc] init];
    FUBeautyParam *param1 = [[FUBeautyParam alloc] init];
    param1.mTitle = @"沙滩";
    param1.mParam = @"beach";
    param1.mImageStr = @"demo_bg_beach";
    FUBeautyParam *param2 = [[FUBeautyParam alloc] init];
    param2.mTitle = @"教师";
    param2.mParam = @"classroom";
    param2.mImageStr = @"demo_bg_classroom";
    FUBeautyParam *param3 = [[FUBeautyParam alloc] init];
    param3.mTitle = @"科技";
    param3.mParam = @"science";
    param3.mImageStr = @"demo_bg_science";
    NSArray *params = @[param1,param2,param3];
    _mBgCollectionView.filters = params;
    _mBgCollectionView.mDelegate = self;
    _mBgCollectionView.hidden = YES;
    [_mBgCollectionView setSelectedIndex:0];
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
    }else{
        return 3;
    }
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == _mItemCollectionView) {
         FULvMuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LvMuCellID forIndexPath:indexPath];
           
           if (indexPath.row < self.dataArray.count){
               FUBeautyParam *modle = self.dataArray[indexPath.row] ;
               NSString *imageName ;
               
                BOOL opened = YES;
               if (modle.iSStyle101) {
                   opened = fabs(modle.mValue - 0.5) > 0.01 ? YES : NO;
               }else{
                   opened = fabsf(modle.mValue - 0) > 0.01 ? YES : NO;
               }

                BOOL selected = _selectedIndex == indexPath.row ;
                if (selected) {
                    imageName = opened ? [modle.mImageStr stringByAppendingString:@"_sel_open.png"] : [modle.mImageStr stringByAppendingString:@"_sel.png"] ;
                }else {
                    imageName = opened ? [modle.mImageStr stringByAppendingString:@"_nor_open.png"] : [modle.mImageStr stringByAppendingString:@"_nor.png"] ;
                }

               cell.imageView.image = [UIImage imageNamed:imageName];
               cell.titleLabel.text = NSLocalizedString(modle.mTitle,nil);
               cell.titleLabel.textColor = _selectedIndex == indexPath.row ? [UIColor colorWithHexColorString:@"5EC7FE"] : [UIColor whiteColor];
           }
           return cell ;
    }else{
        FULvMuColorCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:colorCellID forIndexPath:indexPath];
        [cell setColorItemSelected:_colorSelectedIndex == indexPath.row ?YES:NO];
        if(indexPath.row == 0){
            cell.imageView.image = [UIImage imageNamed:@"demo_icon_straw"];
        }else{
            cell.imageView.image = [UIImage imageNamed:@""];
        }
        
        cell.imageView.backgroundColor = _colors[indexPath.row];
        
        return cell;
    }
    
   
}

#pragma mark ---- UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.mTakeColorView.hidden = YES;
    if (collectionView == _mItemCollectionView) {
        if (_selectedIndex == indexPath.row) {
            return ;
        }
        FUBeautyParam *model = _dataArray[indexPath.row];
        _selectedIndex = indexPath.row ;
        [self hiddenSlideer:_selectedIndex == 0?YES:NO];
        _slider.value = model.mValue;
        
        [self.mItemCollectionView reloadData];
        
    }else{
        
        self.mTakeColorView.hidden = indexPath.row == 0 ?NO:YES;

        _colorSelectedIndex = indexPath.row ;
        if(indexPath.row > 0){
            [self didSelColorWithIdnex:(int)indexPath.row];
        }
        
        [self.mColorCollectionView reloadData];
    }
}

#pragma  mark - update UI
-(void)hiddenSlideer:(BOOL)hidden
{
    self.slider.hidden = hidden;
    self.mColorCollectionView.hidden = !hidden;
}

-(void)segmentBarClickUpdateView:(FULvMuState)state{
    if (state == FULvMubackground) {
        _mBgCollectionView.hidden = NO;
        _mColorCollectionView.hidden = YES;
        _mItemCollectionView.hidden = YES;
        _slider.hidden = YES;
        
        _restBtn.hidden = YES;
        _sqLine.hidden = YES;
        
        self.slider.hidden = YES;
        self.mColorCollectionView.hidden = YES;
    }else{
        _mBgCollectionView.hidden = YES;
        _mItemCollectionView.hidden = NO;
        [self hiddenSlideer:_selectedIndex == 0?YES:NO];
        
        _restBtn.hidden = NO;
        _sqLine.hidden = NO;
    }
}

#pragma  mark -  UI Action
-(void)resetBtnClick:(UIButton *)btn{
    for (FUBeautyParam *param in _dataArray) {
        param.mValue = param.defaultValue;
    }
    
    _colorSelectedIndex = 1;
    _selectedIndex = 0;
    _slider.hidden = YES;
    [self setupDefault];
    
    [self.mItemCollectionView reloadData];
    [self.mColorCollectionView reloadData];

}

-(void)didSelColorWithIdnex:(int)index{
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:index inSection:0];
    FULvMuColorCell *cell = (FULvMuColorCell *)[_mColorCollectionView cellForItemAtIndexPath:indexpath];
    CGFloat r,g,b,a;
    [cell.imageView.backgroundColor getRed:&r green:&g blue:&b alpha:&a];
    if ([self.mDelegate respondsToSelector:@selector(colorDidSelectedR:G:B:A:)]) {
        [self.mDelegate colorDidSelectedR:r G:g B:b A:a];
    }
}

-(void)didChangeValue:(FUMakeupSlider *)slider{
    FUBeautyParam *param = _dataArray[_selectedIndex];
    param.mValue = slider.value;
    
    if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(beautyCollectionView:didSelectedParam:)]) {
        [self.mDelegate beautyCollectionView:self didSelectedParam:param];
    }
}
-(void)didChangeValueEnd:(FUMakeupSlider *)slider{
    [self.mItemCollectionView reloadData];
}

#pragma  mark -  bgdelegate
-(void)bgCollectionViewDidSelectedFilter:(FUBeautyParam *)param{
    if ([self.mDelegate respondsToSelector:@selector(didSelectedParam:)]) {
        [self.mDelegate didSelectedParam:param];
    }
}


#pragma  mark -  外部调用接口
-(void)hidenTop:(BOOL)isHiden{
    if (isHiden) {
         [_segmentBarView setUINormal];
        
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
                make.height.mas_equalTo(184 + 34);
            }else{
                make.height.mas_equalTo(184);
            }
        }];
    }
    
    if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(lvmuViewShowTopView:)]) {
        [self.mDelegate lvmuViewShowTopView:!isHiden];
    }
    
    self.mTakeColorView.hidden = YES;
}

-(void)destoryLvMuView{
    [self.mTakeColorView removeFromSuperview];
    _mTakeColorView  = nil;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _mTakeColorView.hidden = YES;
}
-(void)willRemoveSubview:(UIView *)subview{
    [_mTakeColorView removeFromSuperview];
}


-(void)restUI{
    [self resetBtnClick:nil];
}



-(void)dealloc{
    NSLog(@"lv ---- dealloc");
}



@end
