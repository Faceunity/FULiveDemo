//
//  FUBeautyView.m
//  FUAPIDemoBar
//
//  Created by L on 2018/6/27.
//  Copyright © 2018年 L. All rights reserved.
//

#import "FUBeautyView.h"
#import "UIImage+demobar.h"
#import "UIColor+FUDemoBar.h"
#import "NSString+DemoBar.h"

@interface FUBeautyView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray *dataArray ;
@property (nonatomic, assign, readwrite) NSInteger selectedIndex ;
@end

@implementation FUBeautyView

-(void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    self.delegate = self ;
    self.dataSource = self ;
    [self registerClass:[FUBeautyCell class] forCellWithReuseIdentifier:@"FUBeautyCell"];
    
    _selectedIndex = -1 ;
}

-(void)setType:(FUBeautyViewType)type {
    _type = type ;
    
    switch (type) {
        case FUBeautyViewTypeSkin:
            self.dataArray = @[@"精准美肤", @"清晰磨皮", @"美白",@"红润", @"亮眼",@"美牙"];
            break;
        case FUBeautyViewTypeShape:
            self.dataArray = @[@"瘦脸",@"v脸",@"窄脸",@"小脸", @"大眼", @"下巴",@"额头", @"瘦鼻",@"嘴型"];
    }
    
    [self reloadData];
}

-(void)setFaceShape:(NSInteger)faceShape {
    _faceShape = faceShape ;
    if (self.type == FUBeautyViewTypeShape) {
        
        if (faceShape == 4) {
            self.dataArray = @[@"瘦脸",@"v脸",@"窄脸",@"小脸", @"大眼", @"下巴",@"额头", @"瘦鼻",@"嘴型"];
        }else {
            self.dataArray = @[@"大眼", @"瘦脸"];
        }
        [self reloadData];
    }
}


-(void)setSkinDetect:(BOOL)skinDetect {
    _skinDetect = skinDetect ;
    if (self.type == FUBeautyViewTypeSkin) {
        [self reloadData];
    }
}

-(void)setOpenedDict:(NSDictionary *)openedDict {
    _openedDict = openedDict ;
    [self reloadData ];
}

#pragma mark ---- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count ;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FUBeautyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FUBeautyCell" forIndexPath:indexPath];
    
    if (indexPath.row < self.dataArray.count) {
        
        switch (self.type) {
            case FUBeautyViewTypeSkin:{
                
                NSString *title = self.dataArray[indexPath.row] ;
                NSString *imageName ;
                
                
                if (indexPath.row == 0) {
                    
                    BOOL selected = _selectedIndex == 0 ;
                    
                    if (selected) {
                        imageName = self.skinDetect ? [title stringByAppendingString:@"-3.png"] : [title stringByAppendingString:@"-2.png"] ;
                    }else {
                        imageName = self.skinDetect ? [title stringByAppendingString:@"-1.png"] : [title stringByAppendingString:@"-0.png"] ;
                    }
                    
                    cell.imageView.image = [UIImage imageWithName:imageName];
                    cell.titleLabel.text = [title LocalizableString] ;
                    cell.titleLabel.textColor = _selectedIndex == indexPath.row ? [UIColor colorWithHexColorString:@"5EC7FE"] : [UIColor whiteColor];
                    return cell ;
                }
                
                if (indexPath.row == 1) {
                    
                    title = self.heavyBlur == 0 ? @"清晰磨皮" : @"朦胧磨皮" ;
                    
                    BOOL selected = _selectedIndex == 1 ;
                    
                    NSString *cellName = self.heavyBlur == 0 ? @"blurLevel_0" : @"blurLevel_1" ;
                    
                    BOOL opened = [[_openedDict objectForKey:cellName] boolValue];
                    
                    if (selected) {
                        imageName = opened ? [@"磨皮" stringByAppendingString:@"-3.png"] : [@"磨皮" stringByAppendingString:@"-2.png"] ;
                    }else {
                        imageName = opened ? [@"磨皮" stringByAppendingString:@"-1.png"] : [@"磨皮" stringByAppendingString:@"-0.png"] ;
                    }
                    
                    cell.imageView.image = [UIImage imageWithName:imageName];
                    cell.titleLabel.text = [title LocalizableString] ;
                    cell.titleLabel.textColor = _selectedIndex == indexPath.row ? [UIColor colorWithHexColorString:@"5EC7FE"] : [UIColor whiteColor];
                    return cell ;
                }
                
                NSString *cellName ;
                switch (indexPath.row) {
                    case 2:
                        cellName = @"colorLevel" ;
                        break;
                    case 3:
                        cellName = @"redLevel" ;
                        break;
                    case 4:
                        cellName = @"eyeBrightLevel" ;
                        break;
                    case 5:
                        cellName = @"toothWhitenLevel" ;
                        break;

                    default:
                        break;
                }
                    BOOL opened = [[_openedDict objectForKey:cellName] boolValue];
                    BOOL selected = _selectedIndex == indexPath.row ;

                    if (selected) {
                        imageName = opened ? [title stringByAppendingString:@"-3.png"] : [title stringByAppendingString:@"-2.png"] ;
                    }else {
                        imageName = opened ? [title stringByAppendingString:@"-1.png"] : [title stringByAppendingString:@"-0.png"] ;
                    }
                
                
                cell.imageView.image = [UIImage imageWithName:imageName];
                cell.titleLabel.text = [title LocalizableString] ;
                cell.titleLabel.textColor = _selectedIndex == indexPath.row ? [UIColor colorWithHexColorString:@"5EC7FE"] : [UIColor whiteColor];
            }
                break;
            case FUBeautyViewTypeShape:{
                
                NSString *title = self.dataArray[indexPath.row] ;
                NSString *imageName ;
                
//                if (indexPath.row == 0) {   // 脸型
//                     imageName = _selectedIndex == 0 ? [title stringByAppendingString:@"-1.png"] : [title stringByAppendingString:@"-0.png"];
//                }else {

                    NSString *cellName ;
                    switch (indexPath.row) {
                            
                        case 0:
                            cellName =  @"thinningLevel" ;
                            break;
                        case 1:
                            cellName =  @"vLevel" ;
                            break;
                        case 2:
                            cellName = @"narrowLevel";
                            break;
                        case 3:
                            cellName = @"smallLevel" ;
                            break;
                        case 4:
                            cellName = @"enlargingLevel" ;
                            break;
                        case 5:
                            cellName = @"chinLevel" ;
                            break;
                        case 6:
                            cellName = @"foreheadLevel" ;
                            break;
                        case 7:
                            cellName = @"noseLevel" ;
                            break;
                        case 8:
                            cellName = @"mouthLevel" ;
                            break;
                            
                        default:
                            break;
                    }
                    
                    BOOL opened = [[_openedDict objectForKey:cellName] boolValue];
                    BOOL selected = _selectedIndex == indexPath.row ;
                    
                    if (selected) {
                        imageName = opened ? [title stringByAppendingString:@"-3.png"] : [title stringByAppendingString:@"-2.png"] ;
                    }else {
                        imageName = opened ? [title stringByAppendingString:@"-1.png"] : [title stringByAppendingString:@"-0.png"] ;
                    }
//                }
                
                cell.imageView.image = [UIImage imageWithName:imageName];
                cell.titleLabel.text = [title LocalizableString] ;
                cell.titleLabel.textColor = _selectedIndex == indexPath.row ? [UIColor colorWithHexColorString:@"5EC7FE"] : [UIColor whiteColor];
            }
                break ;
        }
    }
    return cell ;
}

#pragma mark ---- UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (self.type) {
        case FUBeautyViewTypeSkin:{
            
            if (_selectedIndex == indexPath.row && indexPath.row > 1) {
                return ;
            }

            if (indexPath.row == 0) {
                
                _selectedIndex = indexPath.row ;
                [self reloadData];
                
                self.skinDetect = !self.skinDetect ;
                if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(skinDetectChanged:)]) {
                    [self.mDelegate skinDetectChanged:self.skinDetect];
                }
                return ;
            }
            
            if (indexPath.row == 1) {
                
                if (_selectedIndex == 1) {
                    self.heavyBlur ++ ;
                    self.heavyBlur = self.heavyBlur % 2 ;
                    if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(heavyBlurChange:)]) {
                        [self.mDelegate heavyBlurChange:self.heavyBlur];
                    }
                }
            }
            
            _selectedIndex = indexPath.row ;
            [self reloadData];
            
            if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(skinViewDidSelectedIndex:)]) {
                [self.mDelegate skinViewDidSelectedIndex:_selectedIndex];
            }
        }
            break;
        case FUBeautyViewTypeShape:{
            
            if (_selectedIndex == indexPath.row) {
                return ;
            }
            _selectedIndex = indexPath.row ;
            [self reloadData];
            
            if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(shapeViewDidSelectedIndex:)]) {
                [self.mDelegate shapeViewDidSelectedIndex:_selectedIndex];
            }
        }
            break ;
    }
}

#pragma mark ---- UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    switch (self.type) {
        case FUBeautyViewTypeSkin:{
//            if (self.performance) {
//
//                CGFloat left = (self.frame.size.width - 44 * 3 - 32) / 2.0 ;
//                return UIEdgeInsetsMake(16, left, 6, 16) ;
//            }
            return UIEdgeInsetsMake(16, 16, 6, 16) ;
        }
            break;
        case FUBeautyViewTypeShape:{
             return UIEdgeInsetsMake(16, 16, 6, 16) ;
//            if (self.faceShape == 4) {
//                return UIEdgeInsetsMake(16, 16, 6, 16) ;
//            }
//            
//            CGFloat left = (self.frame.size.width - 44 * 3 - 32) / 2.0 ;
//            return UIEdgeInsetsMake(16, left, 6, 16) ;
        }
            break ;
    }
}





@end


@implementation FUBeautyCell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        self.imageView.layer.masksToBounds = YES ;
        self.imageView.layer.cornerRadius = frame.size.width / 2.0 ;
        [self addSubview:self.imageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(-5, frame.size.width + 2, frame.size.width + 10, frame.size.height - frame.size.width - 2)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter ;
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont systemFontOfSize:10];
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        
        [self addSubview:self.titleLabel ];
    }
    return self ;
}

@end
