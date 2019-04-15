//
//  NSString+DemoBar.m
//  FUAPIDemoBar
//
//  Created by L on 2018/7/10.
//  Copyright © 2018年 刘洋. All rights reserved.
//

#import "NSString+DemoBar.h"

@implementation NSString (DemoBar)

- (NSString *)LocalizableString {
    NSBundle *bundle = [NSBundle bundleForClass:[FUDemoBar class]];
    NSString *eng = [bundle localizedStringForKey:self value:nil table:nil] ;
    return eng ;
}
@end
