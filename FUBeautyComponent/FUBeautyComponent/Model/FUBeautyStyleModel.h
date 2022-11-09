//
//  FUBeautyStyleModel.h
//  FUBeautyComponent
//
//  Created by 项林平 on 2022/6/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FUBeautyStyleModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) double blurLevel;
@property (nonatomic, assign) double colorLevel;
@property (nonatomic, assign) double redLevel;
@property (nonatomic, assign) double sharpen;
@property (nonatomic, assign) double faceThreed;
@property (nonatomic, assign) double eyeBright;
@property (nonatomic, assign) double toothWhiten;
@property (nonatomic, assign) double removePouchStrength;
@property (nonatomic, assign) double removeNasolabialFoldsStrength;

@property (nonatomic, assign) double cheekThinning;
@property (nonatomic, assign) double cheekV;
@property (nonatomic, assign) double cheekNarrow;
@property (nonatomic, assign) double cheekShort;
@property (nonatomic, assign) double cheekSmall;
@property (nonatomic, assign) double cheekbones;
@property (nonatomic, assign) double lowerJaw;
@property (nonatomic, assign) double eyeEnlarging;
@property (nonatomic, assign) double eyeCircle;
@property (nonatomic, assign) double chin;
@property (nonatomic, assign) double forehead;
@property (nonatomic, assign) double nose;
@property (nonatomic, assign) double mouth;
@property (nonatomic, assign) double lipThick;
@property (nonatomic, assign) double eyeHeight;
@property (nonatomic, assign) double canthus;
@property (nonatomic, assign) double eyeLid;
@property (nonatomic, assign) double eyeSpace;
@property (nonatomic, assign) double eyeRotate;
@property (nonatomic, assign) double longNose;
@property (nonatomic, assign) double philtrum;
@property (nonatomic, assign) double smile;
@property (nonatomic, assign) double browHeight;
@property (nonatomic, assign) double browSpace;
@property (nonatomic, assign) double browThick;

@property (nonatomic, copy) NSString *filterName;
@property (nonatomic, assign) double filterLevel;

@end

NS_ASSUME_NONNULL_END
