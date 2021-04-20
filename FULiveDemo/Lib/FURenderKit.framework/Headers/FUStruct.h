//
//  FUPosition.h
//  FUAvatarSDK
//
//  Created by ly-Mac on 2020/11/24.
//
#import <UIKit/UIKit.h>

struct FUAuthPack {
    char *authData;
    int authDataSize;
};

typedef struct FUAuthPack FUAuthPack;
FUAuthPack FUAuthPackMake(char *authData, int authDataSize);

#pragma mark - FUPosition

struct FUPosition {
    double x;
    double y;
    double z;
};
typedef struct FUPosition FUPosition;
FUPosition FUPositionMake(double x, double y, double z);
FUPosition FUPositionMakeWithX(FUPosition position, double x);
FUPosition FUPositionMakeWithY(FUPosition position, double y);
FUPosition FUPositionMakeWithZ(FUPosition position, double z);
BOOL FUPositionIsEqual(FUPosition position1, FUPosition position2);

#pragma mark - FUColor

struct FUColor {
    double r;
    double g;
    double b;
    double a;
};
typedef struct FUColor FUColor;
FUColor FUColorMake(double r, double g, double b, double a);
FUColor FUColorMakeWithR(FUColor color, double r);
FUColor FUColorMakeWithG(FUColor color, double g);
FUColor FUColorMakeWithB(FUColor color, double b);
FUColor FUColorMakeWithA(FUColor color, double a);
FUColor FUColorMakeWithUIColor(UIColor *color);
BOOL FUColorIsEqual(FUColor color1, FUColor color2);

#pragma mark - FUBlendshape

struct FUBlendshape {
    float *expression;
    int expressionCount;
};
typedef struct FUBlendshape FUBlendshape;
FUBlendshape FUBlendshapeMake(float *expression, int expressionCount);

#pragma mark - FUBlendshapeWeight

struct FUBlendshapeWeight {
    float *expressionWeight;
    int expressionCount;
};
typedef struct FUBlendshapeWeight FUBlendshapeWeight;
FUBlendshapeWeight FUBlendshapeWeightMake(float *expressionWeight, int expressionCount);

struct FUShadowBias {
    double uniformBias;
    double normalBias;
};
typedef struct FUShadowBias FUShadowBias;
FUShadowBias FUShadowBiasMake(double uniformBias, double normalBias);

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
FUPixelBufferInfo FUPixelBufferInfoMake(CVPixelBufferRef pixelBuffer);

struct FULandMark {
    double *landMarks;
    int landMarksCount;
};
typedef struct FULandMark FULandMark;
FULandMark FULandMarkMake(double *landMarks, int landMarksCount);


#pragma mark - LABColor
struct FULABColor {
    double l;
    double a;
    double b;
};
typedef struct FULABColor FULABColor;
FULABColor FULABColorMake(double l, double a, double b);
FULABColor FULABColorMakeWithL(FULABColor color, double l);
FULABColor FULABColorMakeWithA(FULABColor color, double a);
FULABColor FULABColorMakeWithB(FULABColor color, double b);
BOOL FULABColorIsEqual(FULABColor color1, FULABColor color2);

extern FULABColor FULABColorInvalid;
