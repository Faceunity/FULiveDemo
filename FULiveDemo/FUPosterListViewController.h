//
//  FUPosterListViewController.h
//  FULiveDemo
//
//  Created by 孙慕 on 2018/10/8.
//  Copyright © 2018年 L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FULiveModel.h"

@interface FUPosterListViewController : UIViewController
@property (nonatomic, strong) FULiveModel *model ;
@property (weak, nonatomic) IBOutlet UICollectionView *mPosterCollectionView;

@end
