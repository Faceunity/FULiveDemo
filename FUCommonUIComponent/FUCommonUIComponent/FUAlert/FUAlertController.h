//
//  FUAlertController.h
//
//  Created by 项林平 on 2019/6/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FUAlertController;

@interface FUAlertModel : NSObject
@property (nonatomic, copy) NSString *alertTitle;
@property (nonatomic, copy) NSString *alertMessage;
@property (nonatomic, assign) UIAlertControllerStyle preferredStyle;

- (instancetype) initWithTitle:(NSString *)title message:(NSString *)message style:(UIAlertControllerStyle)style;

@end

typedef void (^FUAlert)(FUAlertController *controller);
typedef FUAlertController * _Nonnull (^FUShowAlert)(UIViewController *controller);
typedef FUAlertController * _Nonnull (^FUActions)(NSArray<UIAlertAction *> *actions);
typedef FUAlertController * _Nullable (^FUSourceView)(UIView *sourceView);

@interface FUAlertController : UIAlertController

+ (FUAlertController *)makeAlert:(FUAlert)block alertModel:(FUAlertModel *)model;

/**
 设置Actions

 @return Self
 */
- (FUActions)actionItems;

/**
 当设备为iPad时设置SourceView

 @return Self
 */
- (FUSourceView)sourceView;

/**
 显示Alert

 @return Self
 */
- (FUShowAlert)showAlert;

@end

NS_ASSUME_NONNULL_END
