//
//  FUDemoBar.m
//  FUAPIDemoBar
//
//  Created by L on 2018/6/26.
//  Copyright © 2018年 L. All rights reserved.
//

#import "FUAPIDemoBar.h"
#import "FUFilterView.h"
#import "FUSlider.h"
#import "FUBeautyView.h"
#import "FUSquareButton.h"
#import "FUManager.h"
#import "SVProgressHUD.h"

#import "UIView+FU.h"


@interface FUAPIDemoBar ()<FUFilterViewDelegate, FUBeautyViewDelegate>


@property (weak, nonatomic) IBOutlet UIButton *skinBtn;
@property (weak, nonatomic) IBOutlet UIButton *shapeBtn;
@property (weak, nonatomic) IBOutlet UIButton *beautyFilterBtn;
@property (weak, nonatomic) IBOutlet UIButton *mStyleBtn;

// 滤镜页
@property (weak, nonatomic) IBOutlet FUFilterView *filterView;
// 美颜滤镜页
@property (weak, nonatomic) IBOutlet FUFilterView *beautyFilterView;

@property (weak, nonatomic) IBOutlet FUSlider *beautySlider;
// 美型页
@property (weak, nonatomic) IBOutlet FUBeautyView *shapeView;
// 美肤页
@property (weak, nonatomic) IBOutlet FUBeautyView *skinView;
/* 格式 */
@property (weak, nonatomic) IBOutlet FUBeautyView *mStyleView;

@property (weak, nonatomic) IBOutlet FUSquareButton *recoverButton;

@property (weak, nonatomic) IBOutlet UIView *sqLine;

/* 当前选中参数 */
@property (strong, nonatomic) FUBeautyModel *seletedParam;

@property (assign, nonatomic) BOOL isEnble;

@end

@implementation FUAPIDemoBar

#pragma mark - Life cycle
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:5/255.0 green:15/255.0 blue:20/255.0 alpha:0.74];
        NSBundle *bundle = [NSBundle bundleForClass:[FUAPIDemoBar class]];
        self = (FUAPIDemoBar *)[bundle loadNibNamed:@"FUAPIDemoBar" owner:self options:nil].firstObject;
    }
    return self ;
}

-(void)awakeFromNib {
    [super awakeFromNib];

    self.filterView.type = FUFilterViewTypeFilter ;
    self.filterView.mDelegate = self ;
    
    self.beautyFilterView.type = FUFilterViewTypeBeautyFilter ;
    self.beautyFilterView.mDelegate = self ;
    
    self.shapeView.mDelegate = self;
    
    self.skinView.mDelegate = self;
    
    self.mStyleView.mDelegate = self;
    
    [self.skinBtn setTitle:FUNSLocalizedString(@"美肤", nil) forState:UIControlStateNormal];
    [self.shapeBtn setTitle:FUNSLocalizedString(@"美型", nil) forState:UIControlStateNormal];
    [self.beautyFilterBtn setTitle:FUNSLocalizedString(@"滤镜", nil) forState:UIControlStateNormal];
    [self.mStyleBtn setTitle:FUNSLocalizedString(@"presets", nil) forState:UIControlStateNormal];
    [self.recoverButton setTitle:FUNSLocalizedString(@"恢复", nil) forState:UIControlStateNormal];
    
    self.skinBtn.tag = 101;
    self.shapeBtn.tag = 102;
    self.beautyFilterBtn.tag = 103 ;
    self.mStyleBtn.tag = 104 ;
    
    _isEnble = YES;
}

-(void)layoutSubviews{
    [super layoutSubviews];
}


#pragma mark - Event response
/// 底部功能选择
- (IBAction)bottomBtnsSelected:(UIButton *)sender {
    if (!_isEnble && sender != self.mStyleBtn) {
        if(sender == _skinBtn){
            [self showMessage:[NSString stringWithFormat:FUNSLocalizedString(@"To use, cancel Presets first.", nil),FUNSLocalizedString(@"美肤", nil)]];
        }
        if (sender == _shapeBtn) {
            [self showMessage:[NSString stringWithFormat:FUNSLocalizedString(@"To use, cancel Presets first.", nil),FUNSLocalizedString(@"美型", nil)]];
        }
        if (sender == _beautyFilterBtn) {
            [self showMessage:[NSString stringWithFormat:FUNSLocalizedString(@"To use, cancel Presets first.", nil),FUNSLocalizedString(@"滤镜", nil)]];
        }
        return;
    }
    if (sender.selected) {
        sender.selected = NO ;
        [self hiddenTopViewWithAnimation:YES];
        return ;
    }
    self.skinBtn.selected = NO;
    self.shapeBtn.selected = NO;
    self.beautyFilterBtn.selected = NO;
    self.mStyleBtn.selected = NO;
    
    sender.selected = YES;
    
    self.skinView.hidden = !self.skinBtn.selected ;
    self.shapeView.hidden = !self.shapeBtn.selected;
    self.beautyFilterView.hidden = !self.beautyFilterBtn.selected ;
    self.mStyleView.hidden = !self.mStyleBtn.selected;
    
    [self resetRecoverButtonStatus:YES];
    if (self.shapeBtn.selected) {
        /* 修改当前UI */
        [self resetRecoverButtonStatus:NO];
        [self sliderChangeEnd:nil];
        NSInteger selectedIndex = self.shapeView.selectedIndex;
        self.beautySlider.hidden = selectedIndex < 0 ;
        
        if (selectedIndex >= 0) {
            FUBeautyModel *modle = self.shapeView.dataArray[selectedIndex];
            _seletedParam = modle;
            self.beautySlider.value = modle.mValue / modle.ratio;
        }
    }
    
    if (self.skinBtn.selected) {
        NSInteger selectedIndex = self.skinView.selectedIndex;
        [self resetRecoverButtonStatus:NO];
        [self sliderChangeEnd:nil];
        self.beautySlider.hidden = selectedIndex < 0 ;
        
        if (selectedIndex >= 0) {
            FUBeautyModel *modle = self.skinView.dataArray[selectedIndex];
            _seletedParam = modle;
            self.beautySlider.value = modle.mValue / modle.ratio;
        }
    }
    
    // slider 是否显示
    if (self.beautyFilterBtn.selected) {
        
        NSInteger selectedIndex = self.beautyFilterView.selectedIndex ;
        self.beautySlider.type = FUFilterSliderType01 ;
        self.beautySlider.hidden = selectedIndex <= 0;
        if (selectedIndex >= 0) {
            FUBeautyModel *modle = self.beautyFilterView.filters[selectedIndex];
            _seletedParam = modle;
            self.beautySlider.value = modle.mValue / modle.ratio;
        }
    }
    
    if (self.mStyleBtn.selected) {
        self.beautySlider.hidden = YES;
    }
    
    [self showTopViewWithAnimation:self.topView.isHidden];
    [self updateSliderType:_seletedParam];
}

/// 滑条滑动
- (IBAction)filterSliderValueChange:(FUSlider *)sender {
    _seletedParam.mValue = sender.value * _seletedParam.ratio; //slider 是归一化过后的所以要乘以比例
    if (_beautyFilterBtn.selected) {
        if (_mDelegate && [_mDelegate respondsToSelector:@selector(filterValueChange:)]) {
            [_mDelegate filterValueChange:_seletedParam];
        }
    }else{
        if (_mDelegate && [_mDelegate respondsToSelector:@selector(beautyParamValueChange:)]) {
            [_mDelegate beautyParamValueChange:_seletedParam];
        }
    }
}

/// 滑条停止滑动
- (IBAction)sliderChangeEnd:(FUSlider *)sender {
    if (self.shapeBtn.selected) {
        if ([self.mDelegate respondsToSelector:@selector(isDefaultShapeValue)]) {
            if ([self.mDelegate isDefaultShapeValue]) {
                self.recoverButton.alpha = 0.7;
            } else {
                self.recoverButton.alpha = 1.0;
            }
        }
        [self.shapeView reloadData];
    }
    
    if (self.skinBtn.selected) {
        if ([self.mDelegate respondsToSelector:@selector(isDefaultSkinValue)]) {
            if ([self.mDelegate isDefaultSkinValue]) {
                self.recoverButton.alpha = 0.7;
            } else {
                self.recoverButton.alpha = 1.0;
            }
        }
         [self.skinView reloadData];
    }
    
    [self.filterView reloadData];

}

/// 恢复按钮点击
- (IBAction)recoverAction:(id)sender {
    if ([self.mDelegate respondsToSelector:@selector(isDefaultShapeValue)]) {
        if ([self.mDelegate isDefaultShapeValue] && self.shapeBtn.selected) {
            return ;
        }
    }
  
    if ([self.mDelegate respondsToSelector:@selector(isDefaultSkinValue)]) {
        if ([self.mDelegate isDefaultSkinValue] && self.skinBtn.selected) {
            return ;
        }
    }
    [self recoverBeautyDefaultValue];
}

#pragma mark - Instance methods
-(void)reloadSkinView:(NSArray<FUBeautyModel *> *)skinParams{
    _skinView.dataArray = skinParams;
    _skinView.selectedIndex = 0;
    FUBeautyModel *modle = skinParams[0];
    if (modle) {
        _beautySlider.hidden = NO;
        _beautySlider.value = modle.mValue / modle.ratio;
    }
    [_skinView reloadData];
}

-(void)reloadShapView:(NSArray<FUBeautyModel *> *)shapParams{
    _shapeView.dataArray = shapParams;
    [_shapeView reloadData];
}

-(void)reloadFilterView:(NSArray<FUBeautyModel *> *)filterParams{
    _beautyFilterView.filters = filterParams;
    [_beautyFilterView reloadData];
}

-(void)reloadStyleView:(NSArray <FUBeautyModel *> *)styleParams defaultStyle:(FUBeautyModel *)selStyle {
    _mStyleView.dataArray = styleParams;
    if (selStyle) {
        int indexa = (int)[styleParams indexOfObject:selStyle];
        [self.mStyleView setSelectedIndex:indexa];
        [self changeBottomView];
    }else{
        [self.mStyleView setSelectedIndex:0];
    }
    [_mStyleView reloadData];
}

- (void)updateSubviews:(FUBeautyDefine)beautyItem {
    switch (beautyItem) {
        case FUBeautyDefineSkin:{
            [self bottomBtnsSelected:self.skinBtn];
        }
            break;
        case FUBeautyDefineShape:{
            [self bottomBtnsSelected:self.shapeBtn];
        }
            break;
        case FUBeautyDefineFilter:{
            [self bottomBtnsSelected:self.beautyFilterBtn];
        }
            break;
        case FUBeautyDefineStyle:{
            [self bottomBtnsSelected:self.mStyleBtn];
        }
            break;
    }
}

-(void)setDefaultFilter:(FUBeautyModel *)filter{
    [self.beautyFilterView setDefaultFilter:filter];
}

-(BOOL)isTopViewShow {
    return !self.topView.hidden ;
}


#pragma mark - Private methods

/// 更新Slider类型
-(void)updateSliderType:(FUBeautyModel *)param{
    if (param.iSStyle101) {
        self.beautySlider.type = FUFilterSliderType101;
    }else{
        self.beautySlider.type = FUFilterSliderType01;
    }
}


// 开启上半部分
- (void)showTopViewWithAnimation:(BOOL)animation {
    
    if (animation) {
        self.topView.alpha = 0.0 ;
        self.topView.transform = CGAffineTransformMakeTranslation(0, self.topView.frame.size.height / 2.0) ;
        self.topView.hidden = NO ;
        [UIView animateWithDuration:0.35 animations:^{
            self.topView.transform = CGAffineTransformIdentity ;
            self.topView.alpha = 1.0 ;
        }];
        
        if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(showTopView:)]) {
            [self.mDelegate showTopView:YES];
        }
    }else {
        self.topView.transform = CGAffineTransformIdentity ;
        self.topView.alpha = 1.0 ;
    }
}

// 关闭上半部分
-(void)hiddenTopViewWithAnimation:(BOOL)animation {
    
    if (self.topView.hidden) {
        return ;
    }
    if (animation) {
        self.topView.alpha = 1.0 ;
        self.topView.transform = CGAffineTransformIdentity ;
        self.topView.hidden = NO ;
        [UIView animateWithDuration:0.35 animations:^{
            self.topView.transform = CGAffineTransformMakeTranslation(0, self.topView.frame.size.height / 2.0) ;
            self.topView.alpha = 0.0 ;
        }completion:^(BOOL finished) {
            self.topView.hidden = YES ;
            self.topView.alpha = 1.0 ;
            self.topView.transform = CGAffineTransformIdentity ;
            
            self.skinBtn.selected = NO ;
            self.shapeBtn.selected = NO ;
            self.beautyFilterBtn.selected = NO ;
            self.mStyleBtn.selected = NO;
        }];
        
        if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(showTopView:)]) {
            [self.mDelegate showTopView:NO];
        }
    }else {
        
        self.topView.hidden = YES ;
        self.topView.alpha = 1.0 ;
        self.topView.transform = CGAffineTransformIdentity ;
    }
}

/// 设置恢复按钮隐藏状态
-(void)resetRecoverButtonStatus:(BOOL)hidden{
    _recoverButton.hidden = hidden;
    _sqLine.hidden = hidden;
}

/// 恢复美肤/美型效果方法
-(void)recoverBeautyDefaultValue{
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:nil message:FUNSLocalizedString(@"是否将所有参数恢复到默认值",nil) preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:FUNSLocalizedString(@"取消",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [cancleAction setValue:[UIColor colorWithRed:44/255.0 green:46/255.0 blue:48/255.0 alpha:1.0] forKey:@"titleTextColor"];
    
    UIAlertAction *certainAction = [UIAlertAction actionWithTitle:FUNSLocalizedString(@"确定",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.recoverButton.alpha = 0.7;
        if ([self.mDelegate respondsToSelector:@selector(resetDefaultValue:)]) {
            if (self.skinBtn.selected) {
                //数据修改逻辑不清晰：view和FUManager 都持有同一个model/models 引用，部分数据修改在view，部分在FUManager，这样结果是如果有数据出错不好排查。所以还是建议把数据修改逻辑集中在FUManager里面，然后回调形式刷新model/models
                [self.mDelegate resetDefaultValue:FUBeautyDefineSkin];
                [self.skinView reloadData];
                
                if (!self.beautySlider.hidden && self.skinView.selectedIndex >= 0) {
                    FUBeautyModel *param = self.skinView.dataArray[self.skinView.selectedIndex];
                    self.beautySlider.value = param.mValue / param.ratio;
                }
            }
            if (self.shapeBtn.selected) {
                [self.mDelegate resetDefaultValue:FUBeautyDefineShape];
                [self.shapeView reloadData];
                
                if (!self.beautySlider.hidden && self.shapeView.selectedIndex >= 0) {
                    FUBeautyModel *param = self.shapeView.dataArray[self.shapeView.selectedIndex];
                    self.beautySlider.value = param.mValue / param.ratio;
                }

            }
        }
    }];
    [certainAction setValue:[UIColor colorWithRed:31/255.0 green:178/255.0 blue:255/255.0 alpha:1.0] forKey:@"titleTextColor"];
    
    [alertCon addAction:cancleAction];
    [alertCon addAction:certainAction];
    
    [[self fu_targetViewController]  presentViewController:alertCon animated:YES completion:^{
    }];
}

/// 更新底部功能按钮状态
- (void)changeBottomView {
    if (_mStyleView.selectedIndex == 0) {
        self.shapeBtn.alpha = 1.0;
        self.skinBtn.alpha = 1.0;
        self.beautyFilterBtn.alpha = 1.0;
        _isEnble = YES;
    }else{
        self.shapeBtn.alpha = 0.6;
        self.skinBtn.alpha = 0.6;
        self.beautyFilterBtn.alpha = 0.6;
        _isEnble = NO;
    }
}

- (void)showMessage:(NSString *)string{
    //设置需要显示的文字
    [SVProgressHUD showImage:[UIImage imageNamed:@"wrt424erte2342rx"] status:string];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.74]];
    [SVProgressHUD setBackgroundLayerColor:[UIColor clearColor]];
    [SVProgressHUD setCornerRadius:5];
    [SVProgressHUD dismissWithDelay:1.5];
}

#pragma mark - FUFilterViewDelegate
// 开启滤镜
-(void)filterViewDidSelectedFilter:(FUBeautyModel *)param{
    _seletedParam = param;
    if (_beautyFilterView.selectedIndex > 0) {
        self.beautySlider.value = param.mValue / param.ratio;
        self.beautySlider.hidden = NO;
    }else{
        self.beautySlider.hidden = YES;
    }
    
    if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(filterShowMessage:)]) {
        [self.mDelegate filterShowMessage:param.mTitle];
    }
     [self updateSliderType:_seletedParam];
    
    if (_mDelegate && [_mDelegate respondsToSelector:@selector(filterValueChange:)]) {
        [_mDelegate filterValueChange:_seletedParam];
    }
}

#pragma mark - FUBeautyViewDelegate
-(void)beautyCollectionView:(FUBeautyView *)beautyView didSelectedParam:(FUBeautyModel *)param{
    if (beautyView == _mStyleView) {
        // 推荐风格
        self.beautySlider.hidden = YES;
        if (_mDelegate && [_mDelegate respondsToSelector:@selector(beautyParamValueChange:)]) {
            [_mDelegate beautyParamValueChange:param];
        }
        [self changeBottomView];
        return;
    }
    // 选择其他效果
    _seletedParam = param;
    self.beautySlider.value = param.mValue / param.ratio;
    self.beautySlider.hidden = NO;
    //有bug，数据修改未调用底层FURender库。
    [self updateSliderType:_seletedParam];
    
}

#pragma mark - 截断点击事件方法！！！！！！
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

@end
