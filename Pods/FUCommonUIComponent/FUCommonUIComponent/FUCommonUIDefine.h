//
//  FUCommonUIDefine.h
//  FUCommonUIComponent
//
//  Created by 项林平 on 2022/6/20.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

#ifndef FUCommonUIDefine_h
#define FUCommonUIDefine_h

static inline UIImage * FUCommonUIImageNamed(NSString *name) {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"FUCommonUIComponent" ofType:@"framework" inDirectory:@"Frameworks"];
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    return [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];;
}

#endif /* FUCommonUIDefine_h */
