//
//  FUStickerProtocol.h
//  FULiveDemo
//
//  Created by Chen on 2021/2/26.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FUStickerDefine.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FUStickerProtocol <NSObject>
@optional

/** 加载道具 */
- (void)loadItem:(NSString *_Nullable)itemName
      completion:(void (^ __nullable)(BOOL finished))completion;

@property (nonatomic, assign) FUStickerType type;

/**选中的道具名称*/
@property (nonatomic, strong) NSString * _Nullable selectedItem;
/** 获取道具对应的提示语 */
- (NSString *_Nonnull)getStickTipsWithItemName:(NSString *_Nonnull)itemName;

@end

NS_ASSUME_NONNULL_END
