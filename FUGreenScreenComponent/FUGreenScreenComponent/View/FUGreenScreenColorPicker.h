//
//  FUGreenScreenColorPicker.h
//  FUGreenScreenComponent
//
//  Created by 项林平 on 2022/8/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FUGreenScreenColorPickerDelegate <NSObject>

- (void)colorPickerDidChangePoint:(CGPoint)point;

@optional
/// 取色结束
/// @param point 结束时的取点
- (void)colorPickerDidEndPickingAtPoint:(CGPoint)point;

@end

@interface FUGreenScreenColorPicker : UIView

@property (nonatomic, weak) id<FUGreenScreenColorPickerDelegate> delegate;

- (void)refreshPickerColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
