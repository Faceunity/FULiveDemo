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

#import "FUBeautyComponent.h"
#import "FUBeautyComponentManager.h"
#import "FUBeautyDefine.h"
#import "FUBeautyFilterModel.h"
#import "FUBeautyShapeModel.h"
#import "FUBeautySkinModel.h"
#import "FUBeautyFilterView.h"
#import "FUBeautyShapeView.h"
#import "FUBeautySkinView.h"
#import "FUBeautyFilterViewModel.h"
#import "FUBeautyShapeViewModel.h"
#import "FUBeautySkinViewModel.h"

FOUNDATION_EXPORT double FUBeautyComponentVersionNumber;
FOUNDATION_EXPORT const unsigned char FUBeautyComponentVersionString[];

