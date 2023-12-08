----

更新时间: 2023-09-06

创建时间: 2020-01-22

----

### 1.0 Nama基础模型 FUItem

* 说明: 关于nama所有item部分说明: 所有业务模块item底层都基于FUItem 来实现，FUItem 实现了和公司内部库通信功能，中间有一层缓存FUParamsCacheItem 主要为了缓存FUParam ,所以后续文档需要缓存的item都会继承于FUParamsCacheItem，不需要缓存则直接继承FUItem，后续不会在每个业务模块item 里面解释一遍。

* Nama Item 的属性是在键值对基础上进行属性一层封装，更加方便的设置想要的功能。***如果设置项过多建议直接使用封装的键值对setParam或setParam:forName:paramType:方法设置,目前会针对美颜、美妆等封装一层key-value接口提供方便设置，后续会在每个item做详细说明***

* FURenderKit.h 文件声明了所有NamaItem的属性或容器，实际业务开发在初始化之后赋值给 FURenderKit的对应属性值即可. 不用NamaItem 需要把FURenderKit对应的item 设置为nil，FURenderKit 内部就移除对应的效果

  * 示例代码
  
      ```objective-c
    //美颜示例
    NSString *path = [[NSBundle mainBundle] pathForResource:@"face_beautification" ofType:@"bundle"];
    FUBeauty *beauty = [[FUBeauty alloc] initWithPath:path name:@"FUBeauty"];
    
    //加载美颜
    [FURenderKit shareRenderKit].beauty = beauty;
    
    //移除美颜
    [FURenderKit shareRenderKit].beauty = nil;
    
    //道具贴纸示例
    NSString *path = [[NSBundle mainBundle] pathForResource:@"baozi" ofType:@"bundle"];
    FUSticker *sticker = [[FUSticker alloc] initWithPath:path name:@"baozi"];
    
    //添加到stickerContainer 这个道具贴纸容器中，内部会自动处理叠加道具，
    [[FURenderKit shareRenderKit].stickerContainer addSticker:sticker];
    
    //如果不希望叠加 需要移除对应的道具对象
    [[FURenderKit shareRenderKit].stickerContainer removeSticker:sticker];
    
    //按照加载路径移除
    [[FURenderKit shareRenderKit].stickerContainer removeStickerForPath:sticker.path];
    
    //释放所有加载的道具
    [[FURenderKit shareRenderKit].stickerContainer removeAllSticks];
    
    ```
  
    
  
#### 1.1 接口说明 ####

* 根据道具路径创建道具对象，可支持自动加载

``` objective-c
/**
* @param path 道具路径
**/
+ (instancetype)initWithPath:(NSString *)path name:(nullable NSString *)name;

/**
* 实例方法
**/
- (instancetype)itemWithPath:(NSString *)path name:(nullable NSString *)name;
```


* 设置键值对参数，封装成 FUParam 对象

```objective-c

- (int)setParam:(FUParam *)param;
```



* 参数名称具体可查询对应模块的[文档](http://192.168.0.118/quanlongli/FULiveDemo/tree/master/docs)

```objective-c
 设置键值对参数

 /**
* @param param 参数值
* @param name 参数名称 

- (int)setParam:(id)param forName:(NSString *)name paramType:(FUParamType)paramType;
```



* 根据参数名称和类型来获取当前参数值

```
\- (**id**)getParamForName:(NSString *)name paramType:(FUParamType)paramType;
```

#### 1.2 属性说明 ####

| 属性名        | 字段类型 | 说明                                       |
| ------------- | -------- | ------------------------------------------ |
| name          | NSString | 道具名称                                   |
| path          | NSString | 道具绝对路径                               |
| bodyInvisibleList        | NSSet<NSNumber *>     | 身体隐藏区域，用于FUAvatar等道具 |
| supportARMode | BOOL     | 是否支持 AR 模式                           |

____

____

### 2.0 美颜  FUBeauty   ###

* 2.1.0 说明: 美颜模块继承自FUItem， 美颜模块分为主体和三个类扩展: 美肤(Skin)、美型(Shap)、滤镜(Filter), 需要证书秘钥包含该功能才可以使用。

* 2.1.1 属性说明

| 属性名称  | 类型 | 说明                                                         | key        |
| --------- | ---- | ------------------------------------------------------------ | ---------- |
| blurUseMask | BOOL  | blur是否使用mask                      | blur_use_mask |
| heavyBlur | int  | 朦胧磨皮开关，0为清晰磨皮，1为朦胧磨皮                       | heavy_blur |
| blurType  | int  | 此参数优先级比heavyBlur低，在使用时要将heavy_blur设为0，0 清晰磨皮 1 朦胧磨皮 2精细磨皮 3均匀磨皮 |  blur_type  |

____

#### 2.2 美肤 FUBeauty (Skin) ####

* 属性说明

| 属性名称                      | 类型   | 说明                                                         | key                              |
| ----------------------------- | ------ | ------------------------------------------------------------ | -------------------------------- |
| skinDetect                    | double | 肤色检测开关，0为关，1为开 默认值0                  | skin_detect                       |
| nonskinBlurScale              | double | 肤色检测之后非肤色区域的融合程度，取值范围0.0-1.0，默认值0.0                  | nonskin_blur_scale     |                      |
| blurLevel                     | double | 默认均匀磨皮,磨皮程度，取值范围0.0-6.0，默认值6.0                  | blur_level                       |
| antiAcneSpot                  | double | 祛斑痘，取值范围0.0-1.0，默认值0.0                  | delspot_level                       |
| colorLevel                    | double | 美白 取值范围 0.0-1.0，0.0为无效果，1.0为最大效果，默认值0.0  | color_level                      |
| redLevel                      | double | 红润 取值范围 0.0-1.0，0.0为无效果，1.0为最大效果，默认值0.0  | red_level                        |
| clarity                       | double | 清晰 取值范围 0.0-1.0，0.0为无效果，1.0为最大效果，默认值0.0  | clarity                        |
| sharpen                       | double | 锐化 锐化程度，取值范围0.0-1.0，默认0.0                      | sharpen                          |
| faceThreed                    | double | 五官立体 取值范围 0.0-1.0, 0.0为无效果, 1.0为最大效果, 默认值0.0 | face_threed                          |
| eyeBright                     | double | 亮眼 0.0-1.0,  0.0为无效果，1.0为最大效果，默认值0.0 亮眼为高级美颜功能，需要相应证书权限才能使用 | eye_bright                       |
| toothWhiten                   | double | 美牙 取值范围 0.0-1.0,  0.0为无效果，1.0为最大效果，默认值0.0 美牙为高级美颜功能，需要相应证书权限才能使用 | tooth_whiten                     |
| removePouchStrength           | double | 去黑眼圈 范围0.0~1.0,  0.0为无效果，1.0最强，默认0.0  去黑眼圈为高级美颜功能，需要相应证书权限才能使用 | remove_pouch_strength            |
| removeNasolabialFoldsStrength | double | 去法令纹 范围0.0~1.0, 0.0为无效果，1.0最强，默认0.0 去法令纹为高级美颜功能，需要相应证书权限才能使用 | remove_nasolabial_folds_strength |

____

#### 2.3 美型 FUBeauty (Shap) ####

* 属性说明

| 属性名称             | 类型   | 说明                                                         | key                  |
| -------------------- | ------ | ------------------------------------------------------------ | -------------------- |
| faceShape            | int    | 变形取值 0:女神变形 1:网红变形 2:自然变形 3:默认变形 4:精细变形 默认4 | face_shape           |
| changeFrames         | int    | 0为关闭 ，大于0开启渐变，值为渐变所需要的帧数 change_frames  | change_frames        |
| faceShapeLevel       | double | 美型的整体程度由face_shape_level参数控制 取值范围 0.0-1.0, 0.0为无效果，1.0为最大效果，默认值1.0  face_shape_level | face_shape_level     |
| cheekThinning        | double | 瘦脸 瘦脸程度范围0.0-1.0 默认0.0                             | cheek_thinning       |
| cheekV               | double | v脸程度范围0.0-1.0 默认0.0                                   | cheek_v              |
| cheekNarrow          | double | 窄脸程度范围0.0-1.0 默认0.0                                  | cheek_narrow         |
| cheekShort           | double | 短脸程度范围0.0-1.0 默认0.0                                  | cheek_short          |
| cheekSmall           | double | 小脸程度范围0.0-1.0 默认0.0                                  | cheek_small          |
| intensityCheekbones  | double | 瘦颧骨程度范围0.0~1.0 1.0程度最强 默认0.0                    | intensity_cheekbones |
| intensityLowerJaw    | double | 瘦下颌骨程度范围0.0~1.0 1.0程度最强 默认0.0                  | intensity_lower_jaw  |
| eyeEnlarging         | double | 大眼程度范围0.0-1.0 1.0程度最强 默认0.0                     | eye_enlarging        |
| intensityChin        | double | 下巴调整程度范围0.0-1.0，0.5-0.0是变小，0.5-1.0是变大 默认0.5    | intensity_chin       |
| intensityForehead    | double | 额头调整程度范围0.0-1.0，0.5-0.0是变小，0.5-1.0是变大 默认0.5    | intensity_forehead   |
| intensityNose        | double | 瘦鼻程度范围0.0-1.0 1.0程度最强 默认0.0                    | intensity_nose       |
| intensityMouth       | double | 嘴型调整程度范围0.0-1.0，0.5-0.0是变大，0.5-1.0是变小 默认0.5    | intensity_mouth      |
| intensityLipThick       | double | 嘴唇厚度 取值范围 0.0-1.0, 默认值0.5, 0.5-0是变薄, 0.5-1是变厚, 默认值0.5    | intensity_lip_thick      |
| intensityEyeHeight       | double | 眼睛位置 取值范围 0.0-1.0, 默认值0.5, 0.5-0是变低, 0.5-1是变高, 默认值0.5    | intensity_eye_height      |
| intensityCanthus     | double | 开眼角程度范围0.0~1.0 1.0程度最强 默认0.0                    | intensity_canthus    |
| intensityEyeLid       | double | 眼睑下至 取值范围 0.0-1.0, 0.0为无效果, 1.0为最大效果, 默认值0.0   | intensity_eye_lid      |
| intensityEyeSpace    | double | 眼距调节范围0.0~1.0，0.5-0.0是变大，0.5-1.0是变小 默认0.5       | intensity_eye_space  |
| intensityEyeRotate   | double | 眼睛角度调节范围0.0~1.0，0.5-0.0逆时针旋转，0.5-1.0顺时针旋转 默认0.5 | intensity_eye_rotate |
| intensityLongNose    | double | 鼻子长度调节范围0.0~1.0，0.5-0.0是变长，0.5-1.0是变短 默认0.5   | intensity_long_nose  |
| intensityPhiltrum    | double | 人中调节范围0.0~1.0，0.5-0.0是变短，0.5-1.0是变长， 默认0.5       | intensity_philtrum   |
| intensitySmile       | double | 微笑嘴角程度范围0.0~1.0 1.0程度最强 默认0.0                  | intensity_smile      |
| intensityEyeCircle | double | 圆眼程度范围0.0~1.0 1.0程度最强                              | intensity_eye_circle |
| intensityBrowHeight | double | 眉毛上下 取值范围 0.0-1.0, 0.5-0是向上, 0.5-1是向下, 默认值0.5    | intensity_brow_height |
| intensityBrowSpace | double | 眉间距 取值范围 0.0-1.0, 默认值0.5, 0.5-0是变小, 0.5-1是变大, 默认值0.5  | intensity_brow_space |
| intensityBrowThick | double | 眉毛粗细 取值范围 0.0-1.0, 默认值0.5, 0.5-0是变细, 0.5-1是变粗, 默认值0.5  | intensity_brow_thick |

____

#### 2.4 滤镜 FUBeauty (Filter) ####

* 属性说明

| 属性名      | 类型     | 说明                                                         | key          |
| ----------- | -------- | ------------------------------------------------------------ | ------------ |
| filterName  | NSString | 取值为一个字符串，默认值为 “origin” ，origin即为使用原图效果 | filter_name  |
| filterLevel | double   | filter_level 取值范围 0.0-1.0,0.0为无效果，1.0为最大效果，默认值1.0 | filter_level |

* 接口说明

  通过key名称获取对应的value值

  ````objective-c
  - (double)filterValueForKey:(NSString *)filterForKey;
  ````

  获取所有的key名称

  ````objective-c
  - (NSArray *)allFilterKeys;
  ````
  
*  滤镜键Key 可选范围

  | Key          |
  | ------------ |
  | origin       |
  | ziran1       |
  | ziran2       |
  | ziran3       |
  | ziran4       |
  | ziran5       |
  | ziran6       |
  | ziran7       |
  | ziran8       |
  | zhiganhui1   |
  | zhiganhui2   |
  | zhiganhui3   |
  | zhiganhui4   |
  | zhiganhui5   |
  | zhiganhui6   |
  | zhiganhui7   |
  | zhiganhui8   |
  | mitao1       |
  | mitao2       |
  | mitao3       |
  | mitao4       |
  | mitao5       |
  | mitao6       |
  | mitao7       |
  | mitao8       |
  | bailiang1    |
  | bailiang2    |
  | bailiang3    |
  | bailiang4    |
  | bailiang5    |
  | bailiang6    |
  | bailiang7    |
  | fennen1      |
  | fennen2      |
  | fennen3      |
  | fennen5      |
  | fennen6      |
  | fennen7      |
  | fennen8      |
  | lengsediao1  |
  | lengsediao2  |
  | lengsediao3  |
  | lengsediao4  |
  | lengsediao7  |
  | lengsediao8  |
  | lengsediao11 |
  | nuansediao1  |
  | nuansediao2  |
  | gexing1      |
  | gexing2      |
  | gexing3      |
  | gexing4      |
  | gexing5      |
  | gexing7      |
  | gexing10     |
  | gexing11     |
  | xiaoqingxin1 |
  | xiaoqingxin3 |
  | xiaoqingxin4 |
  | xiaoqingxin6 |
  | heibai1      |
  | heibai2      |
  | heibai3      |
  | heibai4      |

  

----

#### 2.5 美颜Mode FUBeauty (Mode) ####

  * 2.5.1 接口说明
  
    ````objective-c
    
    /**
    * 设置部分美颜属性的mode，不同mode会有主观上会有不同效果
    * 必须在设置美颜各个属性值之前调用该接口
    **/
    - (void)addPropertyMode:(FUBeautyPropertyMode)mode forKey:(NSString *)key;
    
    ````
    * 支持的key和mode说明
    
     | key      |   属性   |  支持的mode                                                        |
     | ------------- | -------- | ------------------------------------------------------------ |
     | color_level    |   美白  | FUBeautyPropertyMode1, FUBeautyPropertyMode2(v8.2.0)        |
     | remove_pouch_strength     |   去黑眼圈    | FUBeautyPropertyMode1, FUBeautyPropertyMode2(v8.2.0, 高性能设备推荐)    |
     | remove_nasolabial_folds_strength     |    去法令纹   | FUBeautyPropertyMode1, FUBeautyPropertyMode2(v8.2.0, 高性能设备推荐)        |
     | cheek_thinning    |  瘦脸   | FUBeautyPropertyMode1, FUBeautyPropertyMode2(v8.3.0)     |
     | cheek_narrow    |  窄脸   | FUBeautyPropertyMode1, FUBeautyPropertyMode2(v8.0.0)     |
     | cheek_small  |  小脸   | FUBeautyPropertyMode1, FUBeautyPropertyMode2(v8.0.0)    |
     | eye_enlarging    | 大眼  | FUBeautyPropertyMode1, FUBeautyPropertyMode2(v8.0.0), FUBeautyPropertyMode3(v8.2.0, 高性能设备推荐)        |
     | intensity_chin    | 下巴  | FUBeautyPropertyMode1, FUBeautyPropertyMode2(v8.4.0)   |
     | intensity_forehead    |   额头   | FUBeautyPropertyMode1, FUBeautyPropertyMode2(v8.0.0)     |
     | intensity_nose  |   瘦鼻   | FUBeautyPropertyMode1, FUBeautyPropertyMode2(v8.0.0)    |
     | intensity_mouth    |   嘴型   | FUBeautyPropertyMode1, FUBeautyPropertyMode2(v8.0.0), FUBeautyPropertyMode3(v8.2.0, 高性能设备推荐)       |
    

----

#### 2.6 美颜废弃属性 FUBeauty (Deprecated) ####

----

* 说明: 废弃属性原本用于兼容新老版本美颜效果，v8.2.0以后不建议使用，如需要老版本美颜效果，可以使用 setBeautyMode:forKey: 接口特殊设置

| 属性名称             | 类型   | 说明                                                         |      
| -------------------- | ------ | ------------------------------------------------------------ |
| cheekNarrowV2            | double    | 窄脸 取值范围 0.0-1.0,  0.0为无效果，1.0为最大效果，默认值0.0 |
| cheekSmallV2         | double    | 小脸 取值范围 0.0-1.0,  0.0为无效果，1.0为最大效果，默认值0.0  |
| eyeEnlargingV2       | double | 大眼 取值范围 0.0-1.0,  0.0为无效果，1.0为最大效果，默认值0.0  |
| intensityForeheadV2  | double | 额头 取值范围 0.0-1.0,  0.5-0是变小，0.5-1是变大，默认值0.5   |
| intensityNoseV2      | double | 瘦鼻 取值范围 0.0-1.0,  0.0为无效果，1.0为最大效果，默认值0.0  |
| intensityMouthV2     | double | 嘴型 取值范围 0.0-1.0,  0.5-0.0是变大，0.5-1.0是变小，默认值0.5  |

----
·   
___

### 3.0 美妆 （FUMakeup）

* 3.1.0 整体说明: 美妆模块包含组合妆和子妆，当业务层选中某组合装时候调用（updateMakeupPackage）即可。粉底、腮红、这些属性在美妆（FUMakeup）实例上设置。
* 3.1.1 属性说明

| 属性名称      | 类型 | 说明                                                         | key             |
| ------------- | ---- | ------------------------------------------------------------ | --------------- |
| isMakeUpOn    | BOOL  | 美妆开关，1开 0关                                            | is_makeup_on    |
| isClearMakeup | BOOL  | 在解绑妆容时是否清空除口红以外的妆容，0表示不清空，1表示清空，口红可由强度进行设置 | is_clear_makeup |
| makeupSegmentation    | BOOL  | 美妆分割，1开 0关，建议在高端机型中使用       | machine_level    |
| lipType       | int  | 口红类型 0雾面 2润泽Ⅰ 3珠光 6高性能（不支持双色）7润泽Ⅱ            | lip_type        |
| isLipHighlightOn       | BOOL  | 是否开启口红高光 1开 0关             | makeup_lip_highlight_enable        |
| isTwoColor    | int  | 口红双色开关，0为关闭，1为开启，如果想使用咬唇，开启双色开关，并且将makeup_lip_color2的值都设置为0 | is_two_color    |
| browWarpType  | int  | 眉毛变形类型 0柳叶眉 1一字眉 2远山眉 3标准眉 4扶形眉 5日常风 6日系风 | brow_warp_type  |
| browWarp      | int  | 是否使用眉毛变形 ，1为开 0为关                               | brow_warp       |

* 3.2 主题妆 FUMakeup (Subject)

  * 3.4.1 属性说明

    | 属性名称      | 类型            | 说明                                                         |
    | ------------- | --------------- | ------------------------------------------------------------ |
    | subEyebrow       | FUItem          | 眉毛对象                                                     |
    | subEyeshadow       | FUItem          | 眼影对象                                                    |
    | subPupil      | FUItem          | 美瞳对象                                                     |
    | subEyelash    | FUItem          | 睫毛对象                                                     |
    | subEyeliner   | FUItem          | 眼线对象                                                     |
    | subBlusher   | FUItem          | 腮红对象                                                    |
    | subFoundation | FUItem          | 粉底对象                                                     |
    | subHighlight  | FUItem          | 高光对象                                                     |
    | subShadow     | FUItem          | 阴影对象                                                     |
    | subLip        | FUItem          | 口红对象                                                     |
    
    * 3.4.2 接口说明
    ````objective-c
    /**
     * 更新组合装时是否清除子妆
     * needCleanSubItem： YES 清除，NO 不清除
     */
    - (void)updateMakeupPackage:(FUItem * __nullable)makeupPackage needCleanSubItem:(BOOL)needCleanSubItem;
    ````

* 3.3,0 图层混合 FUMakeup (blend)

  * 属性说明 

    统一说明: 所有眼妆和腮红妆容支持更改图层混合模式，现在的图层混合模式有两种，0为正片叠底，1为正常混合（alpha混合），2为叠加，3为柔光，默认为0。
  
    | 属性名称         | 类型 | 说明                | key                     |
    | ---------------- | ---- | ------------------- | ----------------------- |
    | blendTypeEyeshadow1     | int  | 第1层眼影的混合模式 | blend_type_tex_eye      |
    | blendTypeEyeshadow2     | int  | 第2层眼影的混合模式 | blend_type_tex_eye2     |
    | blendTypeEyeshadow3     | int  | 第3层眼影的混合模式 | blend_type_tex_eye3     |
    | blendTypeEyeshadow4     | int  | 第4层眼影的混合模式 | blend_type_tex_eye4     |
    | blendTypeEyelash  | int  | 睫毛的混合模式      | blend_type_tex_eyeLash  |
    | blendTypeEyeliner | int  | 眼线的混合模式      | blend_type_tex_eyeLiner |
    | blendTypeBlusher1 | int  | 第1层腮红的混合模式 | blend_type_tex_blusher  |
    | blendTypeBlusher2 | int  | 第2层腮红的混合模式 | blend_type_tex_blusher2 |
    | blendTypePupil | int  | 美瞳的混合模式      | blend_type_tex_pupil    |
  
    
  
* 3.4.0 妆容强度 FUMakeup (intensity)

  * 属性说明

    | 属性名称            | 类型   | 说明     | key                         |
    | ------------------- | ------ | -------- | --------------------------- |
    | intensityFoundation | double | 粉底强度 | makeup_intensity_foundation |
    | intensityLip | double | 口红强度 | makeup_intensity_lip |
    | intensityBlusher    | double | 腮红强度 | makeup_intensity_blusher    |
    | intensityEyebrow    | double | 眉毛强度 | makeup_intensity_eyeBrow    |
    | intensityEyeshadow   | double | 眼影强度 | makeup_intensity_eye    |
    | intensityEyelash    | double | 睫毛强度 | makeup_intensity_eyelash    |
    | intensityHighlight  | double | 高光强度 | makeup_intensity_highlight  |
    | intensityShadow     | double | 阴影强度 | makeup_intensity_shadow     |
    | intensityPupil      | double | 美瞳强度 | makeup_intensity_pupil      |

  ***

  

* 3.5.0 颜色 FUMakeup (Color)

  * 3.5.1 属性说明

    | 属性名称        | 类型    | 说明                                                         | key                     |
    | --------------- | ------- | ------------------------------------------------------------ | ----------------------- |
    | foundationColor | FUColor | 粉底调色参数，数组的第四个值（对应alpha）为0时，会关闭粉底的调色功能，大于0时会开启 | makeup_foundation_color |
    | lipColor        | FUColor | 口红颜色                                                   | makeup_lip_color        |
    | lipColor2       | FUColor | 如果is_two_color为1，会启用这个颜色，外圈颜色为makeup_lip_color2，内圈颜色为makeup_lip_color，如果makeup_lip_color2都为0，则外圈为透明，即为咬唇效果 | makeup_lip_color2       |
    | blusherColor    | FUColor | 第一层腮红调色参数，数组的第四个值（对应alpha）为0时，会关闭这一层腮红的调色功能，大于0时会开启 | makeup_blusher_color    |
    | eyebrowColor    | FUColor | 眉毛调色参数，数组的第四个值（对应alpha）为0时，会关闭眉毛的调色功能，大于0时会开启 | makeup_eyeBrow_color    |
    | eyelinerColor   | FUColor | 眼线调色参数，数组的第四个值（对应alpha）为0时，会关闭眼线的调色功能，大于0时会开启 | makeup_eyeLiner_color   |
    | eyelashColor    | FUColor | 睫毛调色参数，数组的第四个值（对应alpha）为0时，会关闭睫毛的调色功能，大于0时会开启 | makeup_eyelash_color    |
    | highlightColor  | FUColor | 高光调色参数，数组的第四个值（对应alpha）为0时，会关闭高光的调色功能，大于0时会开启 | makeup_highlight_color  |
    | shadowColor     | FUColor | 阴影调色参数，数组的第四个值（对应alpha）为0时，会关闭阴影的调色功能，大于0时会开启 | makeup_shadow_color     |
    | pupilColor      | FUColor | 美瞳调色参数，数组的第四个值（对应alpha）为0时，会关闭美瞳的调色功能，大于0时会开启 | makeup_pupil_color      |

  * 3.5.2 接口说明

    ```objective-c
    /**
     * 眼影特殊处理
     * //如果is_two_color为1，会启用这个颜色，外圈颜色为makeup_lip_color2，内圈颜色为makeup_lip_color，如果makeup_lip_color2都为0，则外圈为透明，即为咬唇效果
     * makeup_eye_color:[0.0,0.0,0.0,0.0],//第一层眼影调色参数，数组的第四个值（对应alpha）为0时，会关闭这层的调色功能，大于0时会开启
     * makeup_eye_color2:[0.0,0.0,0.0,0.0],//第二层眼影调色参数，数组的第四个值（对应alpha）为0时，会关闭这层的调色功能，大于0时会开启
     * makeup_eye_color3:[0.0,0.0,0.0,0.0],//第三层眼影调色参数，数组的第四个值（对应alpha）为0时，会关闭这层的调色功能，大于0时会开启
     * makeup_eye_color4:[0.0,0.0,0.0,0.0],//第四层眼影调色参数，数组的第四个值（对应alpha）为0时，会关闭这层的调色功能，大于0时会开启
     */
    - (void)setEyeColor:(FUColor)color
                 color1:(FUColor)color1
                 color2:(FUColor)color2
                 color3:(FUColor)color3;
    ```

  * 3.6.0 人脸点位 FUMakeup (landMark)

    * 属性说明

    | 属性名称      | 类型       | 说明                                                         | key             |
    | ------------- | ---------- | ------------------------------------------------------------ | --------------- |
    | isUserFix     | int        | 这个参数控制是否使用修改过得landmark点，如果设为1为使用，0为不使用 | is_use_fix      |
    | fixMakeUpData | FULandMark | 这个参数为一个数组，需要客户端传递一个数组进去，传递的数组的长度为 150*人脸数，也就是将所有的点位信息存储的数组中传递进来。 | fix_makeup_data |

    

***

***

### 4.0 轻美妆 （FULightMakeup）

* 4.1.0属性说明

  | 属性名称        | 类型 | 说明                                                         | key             |
  | --------------- | ---- | ------------------------------------------------------------ | --------------- |
  | isMakeUpOn      | BOOL  | 美妆开关 1 开 0 关                                           | is_makeup_on    |
  | lipType         | int  | 口红类型 0雾面 2润泽 3珠光 6高性能（不支持双色）             | lip_type        |
  | isTwoColor      | BOOL  | 口红双色开关，0为关闭，1为开启，如果想使用咬唇，开启双色开关，并且将makeup_lip_color2的值都设置为0 | is_two_color    |
  | makeupLipMask | BOOL  | 嘴唇优化效果开关，1 开 0 关                                  | makeup_lip_mask |
  
* 4.2.0 轻美妆子妆图片 FULightMakeup (image)

  * 4.2.1 属性说明

  | 属性说明          | 类型   | 说明     | key                       |
  | ----------------- | ------ | -------- | ------------------------- |
  | subEyebrowImage  | UIImage | 眉毛图片 | tex_brow  |
  | subEyeshadowImage      | UIImage | 眼影图片 | tex_eye      |
  | subPupilImage | UIImage | 美瞳图片 | tex_pupil |
  | subEyelashImage  | UIImage | 睫毛图片 | tex_eyeLash  |
  | subHightLightImage    | UIImage | 高光图片 | tex_highlight    |
  | subEyelinerImage  | UIImage | 眼线图片 | tex_eyeLiner  |
  | subBlusherImage  | UIImage | 腮红图片 | tex_blusher  |

* 4.3.0 轻美妆子妆强度 FULightMakeup (intensity)

  * 属性说明

    | 属性说明          | 类型   | 说明     | key                       |
    | ----------------- | ------ | -------- | ------------------------- |
    | intensityLip  | double | 口红强度 | makeup_intensity_lip  |
    | intensityBlusher  | double | 腮红强度 | makeup_intensity_blusher  |
    | intensityEyeshadow  | double | 眼影强度 | makeup_intensity_eye      |
    | intensityEyeLiner | double | 眼线强度 | makeup_intensity_eyeLiner |
    | intensityEyelash  | double | 睫毛强度 | makeup_intensity_eyelash  |
    | intensityPupil    | double | 美瞳强度 | makeup_intensity_pupil    |
    | intensityEyeBrow  | double | 眉毛强度 | makeup_intensity_eyeBrow  |

* 4.3.0 FULightMakeup (Color)

  * 属性说明

    | 属性说明       | 类型类型 | 说明                                    | key              |
    | -------------- | -------- | --------------------------------------- | ---------------- |
    | makeUpLipColor | double   | [0,0,0,0]   //长度为4的数组，rgba颜色值 | makeup_lip_color |

  

* 4.4.0 人脸点位 FULightMakeup (landMark)

  * 属性说明

  | 属性名称      | 类型       | 说明                                                         | key             |
  | ------------- | ---------- | ------------------------------------------------------------ | --------------- |
  | isUserFix     | int        | 这个参数控制是否使用修改过得landmark点，如果设为1为使用，0为不使用 | is_use_fix      |
  | fixMakeUpData | FULandMark | 这个参数为一个数组，需要客户端传递一个数组进去，传递的数组的长度为 150*人脸数，也就是将所有的点位信息存储的数组中传递进来。 | fix_makeup_data |

  

***

***

### 5.0 海报换脸  FUPoster ###

* 接口说明

```objective-c
/**
 * inputImage 需要替换包含人脸图片
 * templateImage 背景模板包含人脸的图片
 * 特殊说明:该方法内部会自动检测需要替换的图像inputImage 和 templateImage海报模板的图片人脸是否合法，如果都合法并且都只有一张人脸，自动进行人脸替换合成操作，调用者可以直接在renderResultWithImageData代理方法里面直接获取到已经渲染融合后的UIImage，
 其他情况(多人脸)会根据协议FUPosterProtocol的回调方法进行业务处理。
 */
- (void)renderWithInputImage:(UIImage *)inputImage templateImage:(UIImage *)templateImage
```



```objective-c
/**
 * 替换海报蒙版背景图片
 */
- (void)changeTempImage:(UIImage *)tempImage;

```

```objective-c
/**
 * 选择某张具体的人脸，
 * faceId 通过 checkPosterWithFaceIds:rectsMap获取
 */
- (void)chooseFaceIds:(int)faceId;
```

```objective-c
/**
 * 计算人脸区域
 */
+ (CGRect)cacluteRectWithIndex:(int)index height:(int)originHeight width:(int)orighnWidth;
```

```objective-c
/**
 * 选择某张具体的人脸，
 * faceId 通过 checkPosterWithFaceIds:rectsMap 获取
 */
- (void)chooseFaceID:(int)faceID;
```
***

***

### 6.0 绿幕 FUGreenScreen

* 接口说明

```objective-c
/**
 * 开始视频播放
 */
- (void)startVideoDecode;

```

```objective-c
/**
 * 取消视频播放,内部停止渲染视频帧
 */
- (void)stopVideoDecode;
```

* 属性说明

| 属性名称     | 类型    | 说明                                                         | key              |
| ------------ | ------- | ------------------------------------------------------------ | ---------------- |
| backgroundImage     | UIImage | 设置背景图片 |         |
| safeAreaImage     | UIImage | 设置安全区域图片 |         |
| videoPath     | NSString | 设置背景视频 |         |
| keyColor     | FUColor | 设置绿幕关键颜色, 默认值为[0,255,0]，取值范围[0-255,0-255,0-255] | key_color        |
| chromaThres  | double  | 取值范围0.0-1.0，相似度：色度最大容差，色度最大容差值越大，更多幕景被抠除 | chroma_thres     |
| chromaThrest | double  | 取值范围0.0-1.0，平滑度：色度最小限差，值越大，更多幕景被扣除  | chroma_thres_T   |
| alphal       | double  | 取值范围0.0-1.0，祛色度：图像前后景祛色度过度，值越大，两者边缘处透明过度更平滑  | alpha_L          |
| center       | CGPoint | 当前图片偏移量                                               | start_x、start_y |
| scale        | float   | 图片宽高放大值                                               | end_x、end_y     |
| rotationMode | int     | 当前设备方向0、1、2、3                                       | rotation_mode    |
| cutouting    | BOOL    | 当前是否正在进行抠图,抠图就停止绿慕渲染                      |                  |
| pause    | BOOL    | 背景视频播放是否暂停                     |                  |

***

***

### 7.0 道具贴纸  FUSticker

* 说明

  无特殊设置项的道具直接使用此类实例化

  FUMusicFilter音乐滤镜、FUAnimoji 表情、FUGesture手势道具、FUAISegment 人像分割 用各自具体子类实例化
  

***

***

### 8.0 音乐滤镜  FUMusicFilter 

* 属性说明

| 属性名称     | 类型    | 说明                                                         | key              |
| ------------ | ------- | ------------------------------------------------------------ | ---------------- |
| musicPath     | NSString | 设置音乐文件路径，但不播放，等到乐滤镜在底层库渲染时自动播放音乐 |         |

* 接口说明

```objective-c
/**
 * 播放当前已经设置的音乐
 */
- (void)play;

/**
 * 继续播放
 */
- (void)resume;
/**
 * 停止播放
 */
- (void)stop;
/**
 * 暂停
 */
- (void)pause;
/**
 * 获取播放进度
 */
- (float)playProgress;
/**
 * 获取当前媒体播放时间
 */
- (NSTimeInterval)currentTime;
```

***

***

### 9.0 表情  FUAnimoji

* 属性说明

| 属性名称   | 类型 | 说明             | key                                              |
| ---------- | ---- | ---------------- | ------------------------------------------------ |
| flowEnable | int  | 表情是否跟随人脸 | @"{\"thing\":\"<global>\",\"param\":\"follow\"}" |

***

***

### 10.0 手势道具 FUGesture

* 属性说明

| 属性名称 | 类型   | 说明                   | key      |
| -------- | ------ | ---------------------- | -------- |
| handOffY | double | 调整手部比心的位置参数 | handOffY |

***

***

### 11.0 人像分割 FUAISegment

* 属性说明

| 属性名称   | 类型 | 说明           | key         |
| ---------- | ---- | -------------- | ----------- |
| cameraMode | int  | 设置相机前后置 | camera_mode |
| lineGap | double  | 轮廓分割线和人之间的间距 | lineGap |
| lineSize | double  | 轮廓分割线宽度 | lineSize |
| lineColor | FUColor  | 轮廓分割线颜色 | lineColor |
| backgroundImage     | UIImage | 设置背景视频 |         |
| videoPath     | NSURL 或者 NSString | 设置背景视频 |         |
| pause    | BOOL    | 背景视频播放是否暂停                      |                  |

* 接口说明

```objective-c
/**
 * 开始视频播放
 */
- (void)startVideoDecode;

/**
 * 取消视频播放
 */
- (void)stopVideoDecode;

/**
 * 视频解析获取第一帧图片
 */
- (UIImage *)readFirstFrame;
```

***

***

### 12.0 道具叠加容器 FUStickerContainer

* 接口说明

```objective-c
/**
 * 单个FUSticker操作接口
 * 内部已经加锁，外部无需处理
 */
- (void)addSticker:(FUSticker *)sticker completion:(nullable void(^)(void))completion;

- (void)removeSticker:(FUSticker *)sticker completion:(nullable void(^)(void))completion;

- (void)removeStickerForPath:(NSString *)stickerPath completion:(nullable void(^)(void))completion;

- (void)replaceSticker:(FUSticker *)oldSticker withSticker:(FUSticker *)newSticker completion:(nullable void(^)(void))completion;
```

```objective-c
/**
 * 多个FUSticker操作接口
 * 内部已经加锁，外部无需处理
 */
- (void)addStickers:(NSArray <FUSticker *> *)stickers completion:(nullable void(^)(void))completion;

- (void)removeStickers:(NSArray <FUSticker *> *)stickers completion:(nullable void(^)(void))completion;

- (void)removeStickersForPaths:(NSArray <NSString *> *)stickerPaths completion:(nullable void(^)(void))completion;
```

```objective-c
/**
 * 移除所有已经添加的FUSticker
 * 内部已经枷锁，外部无序需处理
 */
- (void)removeAllSticks;

/**
 * 获取所有已经添加的FUSticker
 */
- (NSArray *)allStickers;
```

***

***

### 13.0 动漫滤镜 FUComicFilter （FUItem的子类）

* 属性说明

| 属性名称 | 类型   | 说明                                   | key   |
| -------- | ------ | -------------------------------------- | ----- |
| style    | FUComicFilterStyle | 范围 -1 - 7，对应不同的动漫滤镜效果 | style |

* style 值介绍

  | style | Value                  |
  | ----- | ---------------------- |
  | -1    | 移除滤镜，使用原图效果 |
  | 0     | 动漫                   |
  | 1     | 素描                   |
  | 2     | 人像                   |
  | 3     | 油画                   |
  | 4     | 沙画                   |
  | 5     | 钢笔画                 |
  | 6     | 铅笔画                 |
  | 7     | 涂鸦                   |

***

***

### 14.0 美发 FUHairBeauty

* 属性说明

| 属性名称       | 类型       | 说明                                                         | key                    |
| -------------- | ---------- | ------------------------------------------------------------ | ---------------------- |
| index          | int        | 单色美发道具 index 对应的值范围 0 - 7，渐变色美发道具，index对应的值范围 0 - 4 | Index                  |
| strength       | double     | 0对应无效果，1对应最强效果，中间连续过渡。                   | Strength               |
| normalColor    | FULABColor | 内部会分别设置LAB颜色色值                                    | Col_L、Col_A、Col_B    |
| shine          | double     | 正常头发的亮度值                                             | Shine                  |
| gradientColor0 | FULABColor | 渐变色头发颜色设置，内部会分别设置LAB颜色色值                | Col0_L、Col0_A、Col0_B |
| gradientColor1 | FULABColor |                                                              | Col1_L、Col1_A、Col1_B |
| shine0         | double     |                                                              | Shine0                 |
| shine1         | double     |                                                              | Shine1                 |

***

***

### 15.0 美体 FUBodyBeauty

* 属性说明

| 属性名称             | 类型   | 说明                                                         | key                  |
| -------------------- | ------ | ------------------------------------------------------------ | -------------------- |
| bodySlimStrength     | double | 瘦身:0.0表示强度为0，值越大，强度越大，瘦身效果越明显，默认为0.0 | bodySlimStrength     |
| legSlimStrength      | double | 长腿:0.0表示强度为0，值越大，腿越长，默认为0.0               | LegSlimStrength      |
| waistSlimStrength    | double | 瘦腰:0.0表示强度为0，值越大，腰越细，默认为0.0               | WaistSlimStrength    |
| shoulderSlimStrength | double | 美肩:0.5表示强度为0，0.5到1.0，值越大，肩膀越宽，0.5到0.0，值越小，肩膀越窄，0.5为默认值 | ShoulderSlimStrength |
| hipSlimStrength      | double | 美臀:0.0表示强度为0，值越大，强度越大， 提臀效果越明显，默认为0.0 | HipSlimStrength      |
| headSlim             | double | 小头：0.0表示强度为0，值越大，小头效果越明显，默认为0.0      | HeadSlim             |
| legSlim             | double | 瘦腿：0.0表示强度为0，值越大，瘦腿效果越明显，默认为0.0      | LegSlim             |
| debug                | int    | 是否开启debug点位，0表示关闭，1表示开启，默认关闭            | Debug                |
| clearSlim            | int    | 重置:清空所有的美体效果，恢复为默认值                        | clearSlim            |
| orientation          | int    | 方向参数 取值范围 0 - 3                                      | Orientation          |

***

***

### 16.0 动作识别 FUActionRecognition

* 直接初始化实例即可，无需设置额外参数

***

***

### 17.0 精品贴纸  FUQualitySticker （FUSticker的子类）

* 属性说明

  | 属性说明       | 类型类型 | 说明                                    | key              |
  | -------------- | -------- | --------------------------------------- | ---------------- |
  | isFlipPoints | BOOL   | 是否点位镜像 | is_flip_points |
  | is3DFlipH | BOOL   | 是否翻转模型 | is3DFlipH |
  
* 接口说明

```objective-c

/// 精品贴纸点击屏幕特殊效果
- (void)clickToChange;
```

***

***





