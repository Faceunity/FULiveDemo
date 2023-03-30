//
//  FUPosition.h
//  FUAvatarSDK
//
//  Created by ly-Mac on 2020/11/24.
//
#import <UIKit/UIKit.h>
/* Definition of `FU_EXTERN'. */

#if !defined(FU_EXTERN)
#  if defined(__cplusplus)
#   define FU_EXTERN extern "C" __attribute__((visibility("default")))
#  else
#   define FU_EXTERN extern __attribute__((visibility("default")))
#  endif
#endif /* !defined(FU_EXTERN) */

/* Definition of `FU_EXTERN'. */

#if !defined(FU_INLINE)
# if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 199901L
#  define FU_INLINE inline
# elif defined(__cplusplus)
#  define FU_INLINE inline
# elif defined(__GNUC__)
#  define FU_INLINE __inline__
# else
#  define FU_INLINE
# endif
#endif

/* Definition of the `FU_BOXABLE'. */

#if defined(__has_attribute) && __has_attribute(objc_boxable)
# define FU_BOXABLE __attribute__((objc_boxable))
#else
# define FU_BOXABLE
#endif

struct FUAuthPack {
    char *authData;
    int authDataSize;
};

typedef struct FUAuthPack FUAuthPack;
FU_EXTERN FUAuthPack FUAuthPackMake(char *authData, int authDataSize);

#pragma mark - FUPosition

struct FUPosition {
    float x;
    float y;
    float z;
};
typedef struct FU_BOXABLE FUPosition FUPosition;
FU_EXTERN FUPosition FUPositionMake(float x, float y, float z);
FU_EXTERN FUPosition FUPositionMakeWithX(FUPosition position, float x);
FU_EXTERN FUPosition FUPositionMakeWithY(FUPosition position, float y);
FU_EXTERN FUPosition FUPositionMakeWithZ(FUPosition position, float z);
FU_EXTERN BOOL FUPositionIsEqual(FUPosition position1, FUPosition position2);

#pragma mark - FUColor

struct FUColor {
    double r;
    double g;
    double b;
    double a;
};
typedef struct FUColor FUColor;
FU_EXTERN FUColor FUColorMake(double r, double g, double b, double a);
FU_EXTERN FUColor FUColorMakeWithR(FUColor color, double r);
FU_EXTERN FUColor FUColorMakeWithG(FUColor color, double g);
FU_EXTERN FUColor FUColorMakeWithB(FUColor color, double b);
FU_EXTERN FUColor FUColorMakeWithA(FUColor color, double a);
FU_EXTERN FUColor FUColorMakeWithUIColor(UIColor *color);
FU_EXTERN BOOL FUColorIsEqual(FUColor color1, FUColor color2);

#pragma mark - FURGBColor
struct FURGBColor {
    float r;
    float g;
    float b;
};
typedef struct FU_BOXABLE FURGBColor FURGBColor;
FU_EXTERN FURGBColor FURGBColorMake(float r, float g, float b);
FU_EXTERN FURGBColor FURGBColorMakeWithR(FURGBColor color, float r);
FU_EXTERN FURGBColor FURGBColorMakeWithG(FURGBColor color, float g);
FU_EXTERN FURGBColor FURGBColorMakeWithB(FURGBColor color, float b);
FU_EXTERN FURGBColor FURGBColorMakeWithUIColor(UIColor *color);
FU_EXTERN FURGBColor FURGBColorMakeWithNSData(NSData *data);
FU_EXTERN BOOL FURGBColorIsEqual(FURGBColor color1, FURGBColor color2);

#pragma mark - FUBlendshape

struct FUBlendshape {
    float *expression;
    int expressionCount;
};
typedef struct FUBlendshape FUBlendshape;
FU_EXTERN FUBlendshape FUBlendshapeMake(float *expression, int expressionCount);

#pragma mark - FUBlendshapeWeight

struct FUBlendshapeWeight {
    float *expressionWeight;
    int expressionCount;
};
typedef struct FUBlendshapeWeight FUBlendshapeWeight;
FU_EXTERN FUBlendshapeWeight FUBlendshapeWeightMake(float *expressionWeight, int expressionCount);

struct FUShadowBias {
    float uniformBias;
    float normalBias;
};
typedef struct FUShadowBias FUShadowBias;
FU_EXTERN FUShadowBias FUShadowBiasMake(float uniformBias, float normalBias);

struct FUGestureID {
    int left;
    int right;
};
typedef struct FUGestureID FUGestureID;

struct FUPixelBufferInfo {
    OSType format;
    CGSize size;
    
    size_t stride0;
    size_t stride1;
    
    size_t dataSize;
};
typedef struct FUPixelBufferInfo FUPixelBufferInfo;
FU_EXTERN FUPixelBufferInfo FUPixelBufferInfoMake(CVPixelBufferRef pixelBuffer);

struct FULandMark {
    double *landMarks;
    int landMarksCount;
};
typedef struct FULandMark FULandMark;
FU_EXTERN FULandMark FULandMarkMake(double *landMarks, int landMarksCount);


#pragma mark - LABColor
struct FULABColor {
    float l;
    float a;
    float b;
};
typedef struct FULABColor FULABColor;
FU_EXTERN FULABColor FULABColorMake(float l, float a, float b);
FU_EXTERN FULABColor FULABColorMakeWithL(FULABColor color, float l);
FU_EXTERN FULABColor FULABColorMakeWithA(FULABColor color, float a);
FU_EXTERN FULABColor FULABColorMakeWithB(FULABColor color, float b);
FU_EXTERN BOOL FULABColorIsEqual(FULABColor color1, FULABColor color2);

extern FULABColor FULABColorInvalid;
extern FURGBColor FURGBColorInvalid;
