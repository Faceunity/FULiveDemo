//
//  FUFacepupKeys.h
//  FURenderKit
//
//  Created by ly-Mac on 2020/12/23.
//
#import "FUKeysDefine.h"

//FUParamsKeysDefine(FUFacepup,
//                   //   脸型
//                   FUFacepupHeadBoneWide = @"HeadBone_wide",    // 头型变宽
//                   FUFacepupHeadNarrow = @"Head_narrow",    // 头型变窄
//                   FUFacepupHeadShrink = @"head_shrink",    // 头部缩短
//                   FUFacepupHeadStretch = @"head_stretch",    // 头部拉长
//                   FUFacepupHeadFat = @"head_fat",    // 胖
//                   FUFacepupHeadThin = @"head_thin",    // 瘦
//                   FUFacepupCheekWide = @"cheek_wide",    // 颊变宽
//                   FUFacepupCheekBoneNarrow = @"cheekbone_narrow",    // 颊变短
//                   FUFacepupJawBoneWide = @"jawbone_Wide",    // 下颌角向下
//                   FUFacepupJawBoneNarrow = @"jawbone_Narrow",    // 下颌角向下
//                   FUFacepupJawMWide = @"jaw_m_wide",    // 下颌变宽
//                   FUFacepupJawMNarrow = @"jaw_M_narrow",    // 下颌变窄
//                   FUFacepupJawWide = @"jaw_wide",    // 下巴变宽
//                   FUFacepupJawNarrow = @"jaw_narrow",    // 下巴变窄
//                   FUFacepupJawUp = @"jaw_up",    // 下巴变短
//                   FUFacepupJawLower = @"jaw_lower",    // 下巴变长
//                   FUFacepupJawtipForward = @"jawTip_forward",    // 下巴向前
//                   FUFacepupJawtipBackward = @"jawTip_backward",    // 下巴向后
//                   FUFacepupJawboneMUp = @"jawBone_m_up",    // 下颌中间变窄
//                   FUFacepupJawboneMDown = @"jawBone_m_down",    // 下颌中间变宽
//                   
//                   //   眼睛
//                   FUFacepupEyeWide = @"Eye_wide",    // 眼睛放大
//                   FUFacepupEyeShrink = @"Eye_shrink",    // 眼睛缩小
//                   FUFacepupEyeUp = @"Eye_up",    // 眼睛向上
//                   FUFacepupEyeDown = @"Eye_down",    // 眼睛向下
//                   FUFacepupEyeIn = @"Eye_in",    // 眼睛向里
//                   FUFacepupEyeOut = @"Eye_out",    // 眼睛向外
//                   FUFacepupEyeCloseL = @"Eye_close_L",    // 左眼闭
//                   FUFacepupEyeCloseR = @"Eye_close_R",    // 右眼闭
//                   FUFacepupEyeOpenL = @"Eye_open_L",    // 左眼睁
//                   FUFacepupEyeOpenR = @"Eye_open_R",    // 右眼睁
//                   FUFacepupEyeUpperUpL = @"Eye_upper_up_L",    // 左上眼皮向上
//                   FUFacepupEyeUpperUpR = @"Eye_upper_up_R",    // 右上眼皮向上
//                   FUFacepupEyeUpperDownL = @"Eye_upper_down_L",    // 左上眼皮向下
//                   FUFacepupEyeUpperDownR = @"Eye_upper_down_R",    // 右上眼皮向下
//                   FUFacepupEyeUpperbendInL = @"Eye_upperBend_in_L",    // 左上眼皮向里
//                   FUFacepupEyeUpperbendInR = @"Eye_upperBend_in_R",    // 右上眼皮向里
//                   FUFacepupEyeUpperbendOutL = @"Eye_upperBend_out_L",    // 左上眼皮向外
//                   FUFacepupEyeUpperbendOutR = @"Eye_upperBend_out_R",    // 右上眼皮向外
//                   FUFacepupEyeDownerUpL = @"Eye_downer_up_L",    // 左下眼皮向上
//                   FUFacepupEyeDownerUpR = @"Eye_downer_up_R",    // 右下眼皮向上
//                   FUFacepupEyeDownerDnL = @"Eye_downer_dn_L",    // 左下眼皮向下
//                   FUFacepupEyeDownerDnR = @"Eye_downer_dn_R",    // 右下眼皮向下
//                   FUFacepupEyeDownerbendInL = @"Eye_downerBend_in_L",    // 左下眼皮向里
//                   FUFacepupEyeDownerbendInR = @"Eye_downerBend_in_R",    // 右下眼皮向里
//                   FUFacepupEyeDownerbendOutL = @"Eye_downerBend_out_L",    // 左下眼皮向外
//                   FUFacepupEyeDownerbendOutR = @"Eye_downerBend_out_R",    // 右下眼皮向外
//                   FUFacepupEyeOutterIn = @"Eye_outter_in",    // 外眼角向里
//                   FUFacepupEyeOutterOut = @"Eye_outter_out",    // 外眼角向外
//                   FUFacepupEyeOutterUp = @"Eye_outter_up",    // 外眼角向上
//                   FUFacepupEyeOutterDown = @"Eye_outter_down",    // 外眼角向下
//                   FUFacepupEyeInnerIn = @"Eye_inner_in",    // 内眼角向里
//                   FUFacepupEyeInnerOut = @"Eye_inner_out",    // 内眼角向外
//                   FUFacepupEyeInnerUp = @"Eye_inner_up",    // 内眼角向上
//                   FUFacepupEyeInnerDown = @"Eye_inner_down",    // 内眼角向下
//                   FUFacepupEyeForward = @"Eye_forward",    // 眼睛向前
//                   
//                   //   嘴巴
//                   FUFacepupUpperlipThick = @"upperLip_Thick",    // 上唇变厚
//                   FUFacepupUpperlipsideThick = @"upperLipSide_Thick",    // 上唇两侧变厚
//                   FUFacepupLowerlipThick = @"lowerLip_Thick",    // 下唇变厚
//                   FUFacepupLowerlipsideThin = @"lowerLipSide_Thin",    // 下唇两侧变薄
//                   FUFacepupLowerlipsideThick = @"lowerLipSide_Thick",    // 下唇两侧变厚
//                   FUFacepupUpperlipThin = @"upperLip_Thin",    // 上唇变薄
//                   FUFacepupLowerlipThin = @"lowerLip_Thin",    // 下唇变薄
//                   FUFacepupMouthMagnify = @"mouth_magnify",    // 嘴巴放大
//                   FUFacepupMouthShrink = @"mouth_shrink",    // 嘴巴缩小
//                   FUFacepupLipcornerOut = @"lipCorner_Out",    // 嘴角向外
//                   FUFacepupLipcornerIn = @"lipCorner_In",    // 嘴角向里
//                   FUFacepupLipcornerUp = @"lipCorner_up",    // 嘴角向上
//                   FUFacepupLipcornerDown = @"lipCorner_down",    // 嘴角向下
//                   FUFacepupMouthMDown = @"mouth_m_down",    // 唇尖向下
//                   FUFacepupMouthMUp = @"mouth_m_up",    // 唇尖向上
//                   FUFacepupMouthUp = @"mouth_Up",    // 嘴向上
//                   FUFacepupMouthDown = @"mouth_Down",    // 嘴向下
//                   FUFacepupMouthSideUp = @"mouth_side_up",    // 唇线两侧向上
//                   FUFacepupMouthSideDown = @"mouth_side_down",    // 唇线两侧向下
//                   FUFacepupMouthForward = @"mouth_forward",    // 嘴向前
//                   FUFacepupMouthBackward = @"mouth_backward",    // 嘴向后
//                   FUFacepupUpperlipsideThin = @"upperLipSide_thin",    // 上唇两侧变薄
//                   
//                   //   鼻子
//                   FUFacepupNostrilOut = @"nostril_Out",    // 鼻翼变宽
//                   FUFacepupNostrilIn = @"nostril_In",    // 鼻翼变窄
//                   FUFacepupNosetipUp = @"noseTip_Up",    // 鼻尖向上
//                   FUFacepupNosetipDown = @"noseTip_Down",    // 鼻尖向下
//                   FUFacepupNoseUp = @"nose_Up",    // 鼻子向上
//                   FUFacepupNoseTall = @"nose_tall",    // 鼻子变高
//                   FUFacepupNoseLow = @"nose_low",    // 鼻子变矮
//                   FUFacepupNoseDown = @"nose_Down",    // 鼻子向下
//                   FUFacepupNosetipForward = @"noseTip_forward",    // 鼻尖向前
//                   FUFacepupNosetipBackward = @"noseTip_backward",    // 鼻尖向后
//                   FUFacepupNosetipMagnify = @"noseTip_magnify",    // 鼻尖放大
//                   FUFacepupNosetipShrink = @"noseTip_shrink",    // 鼻尖缩小
//                   FUFacepupNostrilUp = @"nostril_up",    // 鼻翼向上
//                   FUFacepupNostrilDown = @"nostril_down",    // 鼻翼向下
//                   FUFacepupNoseboneTall = @"noseBone_tall",    // 鼻梁变高
//                   FUFacepupNoseboneLow = @"noseBone_low",    // 鼻梁变低
//                   FUFacepupNoseWide = @"nose_wide",    // 鼻子变宽
//                   FUFacepupNoseShrink = @"nose_shrink"    // 鼻子变窄
//                   )
