//
//  FUItem+createTexture.h
//  FURenderKit
//
//  Created by Chen on 2021/1/8.
//

#import "FUItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUItem (createTexture)

- (int)createTextureWithImage:(UIImage *)image forName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
