//
//  FUAvatarColorKeys.h
//  FURenderKit
//
//  Created by liuyang on 2021/2/18.
//

FUParamsKeysDefine(FUAvatarColor,
                   //   颜色
                   FUAvatarColorSkinColor = @"skinColor",    // 肤色
                   FUAvatarColorLipColor = @"lipColor",    // 唇色
                   FUAvatarColorIrisColor = @"irisColor",    // 瞳孔颜色
                   FUAvatarColorGlassColor = @"glassColor",    // 眼镜片颜色
                   FUAvatarColorGlassFrameColor = @"glass_frameColor",    // 眼镜框颜色
                   FUAvatarColorHairColor = @"hairColor",    // 头发颜色
                   FUAvatarColorBeardColor = @"beardColor",    // 胡子颜色
                   FUAvatarColorHatColor = @"hatColor"    // 帽子颜色
                   )

FUParamsKeysDefine(FUAvatarColorIntensity,
                   //   颜色强度
                   FUAvatarColorIntensityHair = @"hairColor_intensity"    // 头发颜色强度
                   )

FUParamsKeysDefine(FUAvatarColorIndex,
                   //   颜色索引
                   FUAvatarColorIndexSkin = @"skinColor_index",    // 当前肤色在肤色表的索引，从0开始
                   FUAvatarColorIndexLip = @"lipColor_index"    // 当前唇色在唇色表的索引，从0开始
                   )
