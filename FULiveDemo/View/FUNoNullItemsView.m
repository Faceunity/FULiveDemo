//
//  FUNoNullItemsView.m
//  FULiveDemo
//
//  Created by 孙慕 on 2018/10/9.
//  Copyright © 2018年 L. All rights reserved.
//

#import "FUNoNullItemsView.h"

@implementation FUNoNullItemsView

-(void)updateCollectionArray:(NSArray *)itemArray{

    self.itemsArray = itemArray;
    
    [self.collection reloadData];
}

@end
