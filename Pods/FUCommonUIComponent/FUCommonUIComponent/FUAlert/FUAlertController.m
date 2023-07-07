//
//  FUAlertController.m
//
//  Created by 项林平 on 2019/6/21.
//

#import "FUAlertController.h"

@implementation FUAlertModel

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message style:(UIAlertControllerStyle)style {
    self = [super init];
    if (self) {
        self.alertTitle = title;
        self.alertMessage = message;
        self.preferredStyle = style;
    }
    return self;
}
@end

@implementation FUAlertController
+(FUAlertController *)makeAlert:(FUAlert)block alertModel:(FUAlertModel *)model {
    FUAlertController *alert = [FUAlertController alertControllerWithTitle:model.alertTitle message:model.alertMessage preferredStyle:model.preferredStyle];
    block(alert);
    return alert;
}
- (FUActions)actionItems {
    FUActions actionsBlock = ^(NSArray<UIAlertAction *> *actions) {
        [actions enumerateObjectsUsingBlock:^(UIAlertAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addAction:obj];
        }];
        return self;
    };
    return actionsBlock;
}
- (FUShowAlert)showAlert {
    FUShowAlert showBlock = ^(UIViewController *controller) {
        [controller presentViewController:self animated:YES completion:nil];
        return self;
    };
    return showBlock;
}
- (FUSourceView)sourceView {
    FUSourceView sourceViewBlock = ^(UIView *sourceView) {
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad && sourceView) {
            self.popoverPresentationController.sourceView = sourceView;
            self.popoverPresentationController.sourceRect = sourceView.bounds;
            self.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        }
        return self;
    };
    return sourceViewBlock;
}


@end
