//
//  FUColourView.h
//  FULiveDemo
//
//  Created by 孙慕 on 2019/5/31.
//  Copyright © 2019 FaceUnity. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@protocol FUColourViewDelegate <NSObject>

@optional
-(void)colourViewDidSelIndex:(int)index;

@end

@interface FUColourView : UIView
@property (assign,nonatomic) id<FUColourViewDelegate> delegate;

- (void)setDataColors:(NSArray <NSArray*>*)colors;

- (void)setSelCell:(int)index;

@end

@interface FUColourViewCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *topImage;
@property (strong, nonatomic) UILabel *botlabel;
-(void)setColors:(NSArray *)array;


@end


NS_ASSUME_NONNULL_END
