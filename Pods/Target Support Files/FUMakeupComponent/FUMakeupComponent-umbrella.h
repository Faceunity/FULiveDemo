#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "FUMakeupComponent.h"
#import "FUMakeupComponentManager.h"
#import "FUMakeupDefine.h"
#import "FUCombinationMakeupModel.h"
#import "FUCustomizedMakeupModel.h"
#import "FUSubMakeupModel.h"
#import "FUCombinationMakeupView.h"
#import "FUCustomizedMakeupColorPicker.h"
#import "FUCustomizedMakeupView.h"
#import "FUCombinationMakeupViewModel.h"
#import "FUCustomizedMakeupViewModel.h"

FOUNDATION_EXPORT double FUMakeupComponentVersionNumber;
FOUNDATION_EXPORT const unsigned char FUMakeupComponentVersionString[];

