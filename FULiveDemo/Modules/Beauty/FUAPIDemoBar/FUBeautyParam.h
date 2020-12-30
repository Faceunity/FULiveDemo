//
//  FUBeautyParam.h
//  FULiveDemo
//
//  Created by 孙慕 on 2020/1/7.
//  Copyright © 2020 FaceUnity. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FUBeautyStyleType) {
    FUBeautyStyleType1 = 0,
    FUBeautyStyleType2 = 1,
    FUBeautyStyleType3 = 2,
    FUBeautyStyleType4 = 3,
    FUBeautyStyleType5 = 4,
    FUBeautyStyleType6 = 5,
    FUBeautyStyleType7 = 6,
    FUBeautyStyleType8 = 7,
};



@interface FUBeautyParams : NSObject
/* 全局参数 */
@property (nonatomic,assign)int is_beauty_on;
@property (nonatomic,assign)  int use_landmark;
/* 滤镜参数程度 */
@property (nonatomic,assign)float filter_level;
@property (nonatomic,copy)  NSString *filter_name;
/* 美白 */
@property (nonatomic,assign)float color_level;
/* 红润 */
@property (nonatomic,assign)float red_level;
/* 磨皮 */
@property (nonatomic,assign)float blur_level;
@property (nonatomic,assign)int heavy_blur;
@property (nonatomic,assign)int blur_type;
@property (nonatomic,assign)int blur_use_mask;
/* 锐化 */
@property (nonatomic,assign)float sharpen;
/* 亮眼 */
@property (nonatomic,assign)float eye_bright;
/* 美牙 */
@property (nonatomic,assign)float tooth_whiten;
/* 去黑眼圈 */
@property (nonatomic,assign)float remove_pouch_strength;
/* 去法令纹 */
@property (nonatomic,assign)float remove_nasolabial_folds_strength;
/* 美型 */
/* 美型的整体程度 */
@property (nonatomic,assign)float face_shape_level;
/* 美型的渐变 */
@property (nonatomic,assign)int change_frames;
/* 美型的种类 */
@property (nonatomic,assign)int face_shape;
/* 大眼 */
@property (nonatomic,assign)float eye_enlarging;
/* 瘦脸 */
@property (nonatomic,assign)float cheek_thinning;
/* v脸程度 */
@property (nonatomic,assign)float cheek_v;
/* 窄脸程度 */
@property (nonatomic,assign)float cheek_narrow;
/* 小脸程度 */
@property (nonatomic,assign)float cheek_small;
/* 瘦鼻程度 */
@property (nonatomic,assign)float intensity_nose;
/* 额头调整 */
@property (nonatomic,assign)float intensity_forehead;
/* 嘴巴调整 */
@property (nonatomic,assign)float intensity_mouth;
/* 下巴调整 */
@property (nonatomic,assign)float intensity_chin;
/* 人中调节 */
@property (nonatomic,assign)float intensity_philtrum;
/* 鼻子长度 */
@property (nonatomic,assign)float intensity_long_nose;
/* 眼距调节 */
@property (nonatomic,assign)float intensity_eye_space;
/* 眼睛角度 */
@property (nonatomic,assign)float intensity_eye_rotate;
/* 微笑嘴角 */
@property (nonatomic,assign)float intensity_smile;
/* 开眼角程度 */
@property (nonatomic,assign)float intensity_canthus;
/* 瘦颧骨 */
@property (nonatomic,assign)float intensity_cheekbones;
/* 瘦下颌骨 */
@property (nonatomic,assign)float intensity_lower_jaw;
/* 圆眼 */
@property (nonatomic,assign)float intensity_eye_circle;

+(FUBeautyParams *)defaultParams;

+(FUBeautyParams *)styleWithType:(FUBeautyStyleType)type;

@end


@interface FUBeautyParam : NSObject
@property (nonatomic,copy)NSString *mTitle;

@property (nonatomic,copy)NSString *mParam;

@property (nonatomic,assign)float mValue;

@property (nonatomic,copy)NSString *mImageStr;


/* 双向的参数  0.5是原始值*/
@property (nonatomic,assign) BOOL iSStyle101;

/* 默认值用于，设置默认和恢复 */
@property (nonatomic,assign)float defaultValue;

/* 风格是美颜参数的组合 */
@property(nonatomic,strong)FUBeautyParams *beautyAllparams;
@end

NS_ASSUME_NONNULL_END
