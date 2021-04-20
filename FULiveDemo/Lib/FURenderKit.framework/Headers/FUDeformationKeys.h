//
//  FUDeformationKeys.h
//  FUAvatarSDK
//
//  Created by ly-Mac on 2020/12/23.
//

#import "FUKeysDefine.h"

FUParamsKeysDefine(FUDeformation,
                   //身材
                   FUDeformationTall = @"tall", //高
                   FUDeformationShort = @"short", //矮
                   FUDeformationFat = @"fat", //胖
                   FUDeformationThin = @"thin", //瘦
                   
                   //脸型
                   FUDeformationEyeNarrow = @"eye_narrow",    //眼睛窄
                   FUDeformationEyeWide = @"eye_wide",    // 眼睛宽
                   FUDeformationEyeDown = @"eye_down",    //眼睛下
                   FUDeformationEyeUp = @"eye_up",    // 眼睛上
                   FUDeformationEyeInner = @"eye_inner",    // 眼睛内
                   FUDeformationEyeBackward = @"eye_backward",    //眼睛小
                   FUDeformationEyeForward = @"eye_forward",    //眼睛大
                   FUDeformationUpperlidoutNarrow = @"upperLidOut_narrow",    //外上眼皮右
                   FUDeformationUpperlidoutWide = @"upperLidOut_wide",    // 外上眼皮左
                   FUDeformationUpperlidoutDown = @"upperLidOut_down",    //外上眼皮左下
                   FUDeformationUpperlidoutUp = @"upperLidOut_up",    //外上眼皮左上
                   FUDeformationUpperlidmidNarrow = @"upperLidMid_narrow",    //中上眼皮右
                   FUDeformationUpperlidmidWide = @"upperLidMid_wide",    // 中上眼皮左
                   FUDeformationUpperlidmidDown = @"upperLidMid_down",    // 中上眼皮下
                   FUDeformationUpperlidmidUp = @"upperLidMid_up",    // 中上眼皮上
                   FUDeformationUpperlidinNarrow = @"upperLidIn_narrow",    //内上眼皮右
                   FUDeformationUpperlidinWide = @"upperLidIn_wide",    // 内上眼皮左
                   FUDeformationUpperlidinDown = @"upperLidIn_down",    //内上眼皮下
                   FUDeformationUpperlidinUp = @"upperLidIn_up",    // 内上眼皮上下
                   FUDeformationLidinnerNarrow = @"lidInner_narrow",    //内眼角内
                   FUDeformationLidinnerWide = @"lidInner_wide",    //内眼角外
                   FUDeformationLidinnerDown = @"lidInner_down",    //内眼角下
                   FUDeformationLidinnerUp = @"lidInner_up",    // 内眼角上
                   FUDeformationLowerlidinNarrow = @"lowerLidIn_narrow",    //内下眼皮右
                   FUDeformationLowerlidinWide = @"lowerLidIn_wide",    //内下眼皮左
                   FUDeformationLowerlidinDown = @"lowerLidIn_down",    // 内下眼皮下
                   FUDeformationLowerlidinUp = @"lowerLidIn_up",    //内下眼皮上
                   FUDeformationLowerlidmidNarrow = @"lowerLidMid_narrow",    //中下眼皮右
                   FUDeformationLowerlidmidWide = @"lowerLidMid_wide",    //中下眼皮左
                   FUDeformationLowerlidmidDown = @"lowerLidMid_down",    //中下眼皮下
                   FUDeformationLowerlidmidUp = @"lowerLidMid_up",    // 中下眼皮上
                   FUDeformationLowerlidoutNarrow = @"lowerLidOut_narrow",    // 外下眼皮右
                   FUDeformationLowerlidoutWide = @"lowerLidOut_wide",    //外下眼皮左
                   FUDeformationLowerlidoutDown = @"lowerLidOut_down",    // 外下眼皮下
                   FUDeformationLowerlidoutUp = @"lowerLidOut_up",    //外下眼皮上
                   FUDeformationLidouterNarrow = @"lidOuter_narrow",    //外眼角内
                   FUDeformationLidouterWide = @"lidOuter_wide",    // 外眼角外
                   FUDeformationLidouterDown = @"lidOuter_down",    //外眼角下
                   FUDeformationLidouterUp = @"lidOuter_up",    //外眼角上
                   FUDeformationNoseDown = @"nose_down",    //鼻子下
                   FUDeformationNoseUp = @"nose_up",    //鼻子上
                   FUDeformationNoseBackward = @"nose_backward",    //鼻子后
                   FUDeformationNoseForward = @"nose_forward",    //鼻子前
                   FUDeformationNosetipDown = @"noseTip_down",    // 鼻尖下
                   FUDeformationNosetipUp = @"noseTip_up",    //鼻尖上
                   FUDeformationNosetipBackward = @"noseTip_backward",    // 鼻尖后
                   FUDeformationNosetipForward = @"noseTip_forward",    // 鼻尖前
                   FUDeformationUpperheadNarrow = @"upperHead_narrow",    // 脸窄
                   FUDeformationUpperheadWide = @"upperHead_wide",    // 脸宽
                   FUDeformationUpperheadDown = @"upperHead_down",    // 上脸短
                   FUDeformationUpperheadUp = @"upperHead_up",    //上脸长
                   FUDeformationUpperheadBackward = @"upperHead_backward",    //上脸后
                   FUDeformationUpperheadForward = @"upperHead_forward",    //上脸前
                   FUDeformationLowerheadDown = @"lowerHead_down",    //下脸长
                   FUDeformationLowerheadUp = @"lowerHead_up",    //下脸短
                   FUDeformationLowerheadBackward = @"lowerHead_backward",    // 下脸后
                   FUDeformationLowerheadForward = @"lowerHead_forward",    //下脸前
                   FUDeformationUpperjawNarrow = @"upperJaw_narrow",    //脸颊瘦
                   FUDeformationUpperjawWide = @"upperJaw_wide",    //脸颊胖
                   FUDeformationMidjawNarrow = @"midJaw_narrow",    //下颚瘦
                   FUDeformationMidjawWide = @"midJaw_wide",    //下颚胖
                   FUDeformationMidjawDown = @"midJaw_down",    //下颚下
                   FUDeformationMidjawUp = @"midJaw_up",    //下颚上
                   FUDeformationLowerjawNarrow = @"lowerJaw_narrow",    //腮帮瘦
                   FUDeformationLowerjawWide = @"lowerJaw_wide",    //腮帮胖
                   FUDeformationLowerjawDown = @"lowerJaw_down",    //腮帮下
                   FUDeformationLowerjawUp = @"lowerJaw_up",    //腮帮上
                   FUDeformationJawlineNarrow = @"jawLine_narrow",    // 下颌角窄
                   FUDeformationJawlineWide = @"jawLine_wide",    // 下颌角宽
                   FUDeformationJawlineDown = @"jawLine_down",    // 下颌角下
                   FUDeformationJawlineUp = @"jawLine_up",    // 下颌角上
                   FUDeformationJawtipNarrow = @"jawTip_narrow",    // 下巴瘦
                   FUDeformationJawtipWide = @"jawTip_wide",    //下巴胖
                   FUDeformationJawtipDown = @"jawTip_down",    //下巴下
                   FUDeformationJawtipUp = @"jawTip_up",    // 下巴上
                   FUDeformationJawtipBackward = @"jawTip_backward",    //下巴后
                   FUDeformationJawtipForward = @"jawTip_forward",    //下巴前
                   FUDeformationJawtipPeakNarrow = @"jawTip_peak_narrow",    //下巴尖窄
                   FUDeformationJawtipPeakWide = @"jawTip_peak_wide",    // 下巴尖宽
                   FUDeformationJawtipPeakDown = @"jawTip_peak_down",    // 下巴尖长
                   FUDeformationJawtipPeakUp = @"jawTip_peak_up",    // 下巴尖短
                   FUDeformationJawtipPeakBackward = @"jawTip_peak_backward",    // 下巴尖后
                   FUDeformationJawtipPeakForward = @"jawTip_peak_forward",    //下巴尖前
                   FUDeformationLowerchinDown = @"lowerChin_down",    // 下巴内侧下
                   FUDeformationLowerchinUp = @"lowerChin_up",    //下巴内侧上
                   FUDeformationMouthNarrow = @"mouth_narrow",    // 嘴巴小
                   FUDeformationMouthWide = @"mouth_wide",    //嘴巴大
                   FUDeformationMouthDown = @"mouth_down",    //嘴巴下
                   FUDeformationMouthUp = @"mouth_up",    // 嘴巴上
                   FUDeformationMouthBackward = @"mouth_backward",    // 嘴巴后
                   FUDeformationMouthForward = @"mouth_forward",    // 嘴巴前
                   FUDeformationGlobalbrowDown = @"globalBrow_down",    // 眉毛下
                   FUDeformationGlobalbrowUp = @"globalBrow_up",    // 眉毛上
                   FUDeformationInnerbrowDown = @"InnerBrow_down",    //内眉毛下
                   FUDeformationInnerbrowUp = @"InnerBrow_up",    //内眉毛上
                   FUDeformationMiddlebrowDown = @"middleBrow_down",    // 中眉毛下
                   FUDeformationMiddlebrowUp = @"middleBrow_up",    // 中眉毛上
                   FUDeformationOuterbrowDown = @"outerBrow_down",    // 外眉毛下
                   FUDeformationOuterbrowUp = @"outerBrow_up",    //外眉毛上
                   FUDeformationEarNarrow = @"ear_narrow",    //耳朵小
                   FUDeformationEarWide = @"ear_wide",    //耳朵大
                   FUDeformationEarDown = @"ear_down",    //耳朵下
                   FUDeformationEarUp = @"ear_up",    //耳朵上
                   FUDeformationUpperearDown = @"upperEar_down",    // 上耳朵下
                   FUDeformationUpperearUp = @"upperEar_up"    // 上耳朵上
                   )
