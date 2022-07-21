//
//  FULiveModel.h
//  FULive
//
//  Created by L on 2018/1/15.
//  Copyright © 2018年 L. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FULiveModel : NSObject

@property (nonatomic, assign) NSInteger maxFace ;

@property (nonatomic, copy) NSString *title ;

@property (nonatomic, assign) BOOL enble ;

@property (nonatomic, assign) FULiveModelType type ;
/* 对比 */
@property (nonatomic, assign) int conpareCode ;

@property (nonatomic, assign) NSArray *modules ;

@property (nonatomic, strong) NSArray <NSString *>*items ;

@property (nonatomic, assign) int selIndex;

@property (nonatomic, assign) BOOL animationIcon;
@property (nonatomic, strong) NSString *animationNamed;

@end
