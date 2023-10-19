//
//  FUCustomizedMakeupColorPicker.h
//  FUMakeupComponent
//
//  Created by 项林平 on 2022/9/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FUCustomizedMakeupColorPickerDelegate <NSObject>

- (void)colorPickerDidSelectColorAtIndex:(NSUInteger)index;

@end

@interface FUCustomizedMakeupColorPicker : UIView

@property (nonatomic, weak) id<FUCustomizedMakeupColorPickerDelegate> delegate;

@property (nonatomic, copy) NSArray<NSArray<NSNumber *> *> *colors;

- (void)selectAtIndex:(NSUInteger)index;

@end

@interface FUCustomizedMakeupColorCell : UICollectionViewCell

@property (nonatomic, copy) NSArray<NSNumber *> *color;

@end


@interface FUCustomizedMakeupColorFlowLayout : UICollectionViewFlowLayout

@end

NS_ASSUME_NONNULL_END
