//
//  FUMakeUpView.m
//  FULiveDemo
//
//  Created by L on 2018/8/2.
//  Copyright © 2018年 L. All rights reserved.
//

#import "FUMakeUpView.h"
#import "FUMakeupSlider.h"

@interface FUMakeUpView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    NSInteger bottomIndex ;
    NSMutableDictionary *selectedDict ;
    
    NSMutableDictionary *makeupLevels ;
}
@property (nonatomic, strong) NSArray *bottomList;
@property (weak, nonatomic) IBOutlet UICollectionView *bottomCollection;

@property (nonatomic, strong) NSArray *topDataList ;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UICollectionView *topCollection;

@property (weak, nonatomic) IBOutlet UIButton *noitemBtn;

@property (weak, nonatomic) IBOutlet FUMakeupSlider *slider;
@end

@implementation FUMakeUpView

-(void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    
    NSArray *dataArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"makeupSource.plist" ofType:nil]];
    
    NSMutableArray *bottomArray = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *topArray = [NSMutableArray arrayWithCapacity:1];
    
    makeupLevels = [NSMutableDictionary dictionaryWithCapacity:1];
    selectedDict = [NSMutableDictionary dictionaryWithCapacity:1];
    for (NSDictionary *dict in dataArray) {
        NSString *name = dict[@"itemName"] ;
        [bottomArray addObject:name];
        
        NSArray *items = dict[@"items"];
        [topArray addObject:items];
        
        [selectedDict setObject:@(-1) forKey:name];
    }
    self.bottomList = [bottomArray copy];
    self.topDataList = [topArray copy];
    
    self.bottomCollection.dataSource = self ;
    self.bottomCollection.delegate = self ;
    [self.bottomCollection reloadData];
    
    bottomIndex = -1 ;
    self.topView.hidden = YES ;
    
    self.topCollection.dataSource = self ;
    self.topCollection.delegate = self ;
}

- (void)showTopView:(BOOL)shown {
    
    if (shown) {    // 显示
        
        NSString *bottomName = self.bottomList[bottomIndex];
        NSInteger selectedIndex = [[selectedDict objectForKey:bottomName] integerValue] ;
        self.noitemBtn.selected = selectedIndex == -1 ;
        self.slider.hidden = selectedIndex == -1 ;
        
        if (self.topView.hidden) {
            self.topView.alpha = 0.0 ;
            self.topView.transform = CGAffineTransformMakeTranslation(0, self.topView.frame.size.height / 2.0) ;
            self.topView.hidden = NO ;
            [UIView animateWithDuration:0.35 animations:^{
                self.topView.transform = CGAffineTransformIdentity ;
                self.topView.alpha = 1.0 ;
            }];
        }
    }else {     // 关闭
        self.topView.transform = CGAffineTransformIdentity ;
        self.topView.alpha = 1.0 ;
        self.topView.hidden = NO ;
        [UIView animateWithDuration:0.35 animations:^{
            self.topView.alpha = 0.0 ;
            self.topView.transform = CGAffineTransformMakeTranslation(0, self.topView.frame.size.height / 2.0) ;
        }completion:^(BOOL finished) {
            self.topView.hidden = YES ;
        }];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(makeupViewDidShowTopView:)]) {
        [self.delegate makeupViewDidShowTopView:shown];
    }
}

// delete current item
- (IBAction)noitemAction:(UIButton *)sender {
    if (sender.selected) {
        return ;
    }
    sender.selected = YES ;
    
    NSString *bottomName = self.bottomList[bottomIndex];
    [selectedDict setObject:@(-1) forKey:bottomName];
    [self.topCollection reloadData];
    if (self.delegate && [self.delegate respondsToSelector:@selector(makeupViewDidSelectedItemWithType:itemName:value:)]) {
        [self.delegate makeupViewDidSelectedItemWithType:bottomIndex itemName:@"noitem" value:1.0];
    }
    self.slider.hidden = YES ;
}

- (IBAction)sliderValueChange:(FUMakeupSlider *)sender {
    
    NSArray *dataArray = self.topDataList[bottomIndex] ;
    
    NSString *name = self.bottomList[bottomIndex] ;
    NSInteger index = [[selectedDict objectForKey:name] integerValue] ;
    NSString *itemName = dataArray[index] ;
    
    [makeupLevels setObject:@(sender.value) forKey:itemName];
    
    if ([self.delegate respondsToSelector:@selector(makeupViewDidChangeValue:Type:)]) {
        [self.delegate makeupViewDidChangeValue:sender.value Type:bottomIndex];
    }
}

- (float)makeupLevelWithName:(NSString *)itemName {
    NSArray *array = makeupLevels.allKeys ;
    
    if ([array containsObject:itemName]) {
        return [[makeupLevels objectForKey:itemName] floatValue] ;
    }
    [makeupLevels setObject:@(1.0) forKey:itemName];
    return 1.0 ;
}


// 隐藏上半部分View
-(void)hiddenMakeupViewTopView {
    if (!self.topView.hidden) {
        [self showTopView:NO];
        bottomIndex = -1 ;
        [self.bottomCollection reloadData];
    }
}

#pragma mark --- UICollectionViewDataSource, UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (collectionView == self.bottomCollection) {
        return self.bottomList.count ;
    }
    
    if (bottomIndex > -1) {
        
        NSArray *dataArray = self.topDataList[bottomIndex] ;
        return dataArray.count ;
    }else{
        return 0 ;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.bottomCollection) {
        FUMakeupBottomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FUMakeupBottomCell" forIndexPath:indexPath];
        
        cell.name.textColor = bottomIndex == indexPath.row ? [UIColor colorWithRed:94/255.0 green:199/255.0 blue:254/255.0 alpha:1.0] : [UIColor whiteColor];
        cell.name.text = NSLocalizedString(self.bottomList[indexPath.row], nil) ;
        return cell ;
    }
    
    FUMakeupTopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FUMakeupTopCell" forIndexPath:indexPath];
    
    if (bottomIndex != -1) {
        NSArray *dataArray = self.topDataList[bottomIndex] ;
        NSString *imageName = dataArray[indexPath.row] ;
        cell.imageView.image = [UIImage imageNamed:imageName];
        
        NSString *bottomName = self.bottomList[bottomIndex];
        NSInteger selectedIndex = [[selectedDict objectForKey:bottomName] integerValue] ;
        cell.imageView.layer.borderWidth = selectedIndex == indexPath.row ? 3.0 : 0.0 ;
        cell.imageView.layer.borderColor = selectedIndex == indexPath.row ? [UIColor colorWithRed:94/255.0 green:199/255.0 blue:254/255.0 alpha:1.0].CGColor : [UIColor clearColor].CGColor;
    }
    return cell ;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.bottomCollection) {
        return CGSizeMake(59.0, self.bottomCollection.bounds.size.height) ;
    }
    
    return CGSizeMake(54.0, 54.0) ;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.bottomCollection) {
        
        if (bottomIndex == indexPath.row) {
            bottomIndex = -1 ;
            [self showTopView:NO];
        }else {
            bottomIndex = indexPath.row ;
            
            [self showTopView:YES];
        }
        
        [self.bottomCollection reloadData];
        
        [self.topCollection reloadData];
    }else {
        NSString *bottomName = self.bottomList[bottomIndex];
        [selectedDict setObject:@(indexPath.row) forKey:bottomName];
        [self.topCollection reloadData];
        
        NSArray *dataArray = self.topDataList[bottomIndex] ;
        NSString *itemName = dataArray[indexPath.row] ;
        
        self.noitemBtn.selected = NO ;
        self.slider.hidden = NO ;
        self.slider.value = [self makeupLevelWithName:itemName];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(makeupViewDidSelectedItemWithType:itemName:value:)]) {
            [self.delegate makeupViewDidSelectedItemWithType:bottomIndex itemName:itemName value:[self makeupLevelWithName:itemName]];
        }
    }
}


@end


@implementation FUMakeupTopCell
@end

@implementation FUMakeupBottomCell
@end
