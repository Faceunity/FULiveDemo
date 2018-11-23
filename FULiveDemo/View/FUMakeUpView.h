//
//  FUMakeUpView.h
//  FULiveDemo
//
//  Created by L on 2018/8/2.
//  Copyright © 2018年 L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FUMakeupSupModel : NSObject
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *imageStr;
@property (assign, nonatomic) BOOL isSel;

+(FUMakeupSupModel *)getClassName:(NSString *)name image:(NSString *)imageStr isSel:(BOOL)sel;
@end


@protocol FUMakeUpViewDelegate <NSObject>

@optional

// 点击事件
-(void)makeupViewDidSelectedItemWithType:(NSInteger)typeIndex itemName:(NSString *)itemName value:(float)value ;
// 滑动事件
- (void)makeupViewDidChangeValue:(float)value Type:(NSInteger)typeIndx ;
// 显示上半部分View
//-(void)makeupViewDidShowTopView:(BOOL)shown;

- (void)makeupSupItemDidSel:(int)index value:(float)value;

- (void)makeupSupDidChangeValue:(int)index value:(float)value;
@end

@interface FUMakeUpView : UIView
@property (nonatomic, assign,readonly) int supIndex;

@property (nonatomic, assign) id<FUMakeUpViewDelegate>delegate ;

-(void)setDefaultSupItem:(int)index;

@end


@interface FUMakeupTopCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView ;

@property (weak, nonatomic) IBOutlet UILabel *mLabel;

@end


@interface FUMakeupBottomCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *mImageView;


@end
