//
//  FUItem+createTexture.h
//  FURenderKit
//
//  Created by Chen on 2021/1/8.
//

#import <FURenderKit/FURenderKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FUItem (createTexture)

- (int)createTextureWithImage:(UIImage *)image forName:(NSString *)name;

//- (int)createTextureWithImage:(UIImage *)image forName:(NSString *)name isCache:(BOOL)isCache;
@end

NS_ASSUME_NONNULL_END
