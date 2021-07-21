

----

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
    FUBeautiItem *item = [[FUBeautiItem alloc] initWithPath:path name:@"face_beautification" autoLoad:YES];
    self.beautiyItem = item;
    //加载item
    [FURenderKit shareRenderKit].beautifulItem = item;
    
    //移除item
    [FURenderKit shareRenderKit].beautifulItem = nil;
    
    //道具贴纸示例
    NSString *path = [[NSBundle mainBundle] pathForResource:@"baozi" ofType:@"bundle"];
    FUStickerItem *item = [[FUStickerItem alloc] initWithPath:path name:@"baozi" autoLoad:YES];
    self.arMaskItem = item;
    //添加到stickerContainer 这个道具贴纸容器中，内部会自动处理叠加道具，
    [[FURenderKit shareRenderKit].stickerContainer addStickerItem:item];
    
    //如果不希望叠加 需要移除对应的道具对象
    [[FURenderKit shareRenderKit].stickerContainer removeStickerItem:item];
    
    //按照加载路径移除
    [[FURenderKit shareRenderKit].stickerContainer removeStickerItemForPath:item.path];
    
    //释放所有加载的道具
    [[FURenderKit shareRenderKit].stickerContainer removeAllSticks];
    
    ```
  
    
  
  

#### 1.1 接口说明 ####

* 根据道具路径创建道具对象，可支持自动加载

``` objective-c
/**
* @param path 道具路径
* @param autoLoad 是否自动加载道具
**/

+ (instancetype)initWithPath:(NSString *)path name:(nullable NSString *)name autoLoad:(BOOL)autoLoad;

/**
* 实例方法
**/
- (instancetype)itemWithPath:(NSString *)path name:(nullable NSString *)name autoLoad:(BOOL)autoLoad;
```

* 加载ItemID

```objective-c
带回调
- (void)loadAsync:(void (^)(BOOL successed))completion;

不带回调
- (BOOL)loadSync;
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
| itemID        | int      | 只读，内部生成的道具ID                     |
| loaded        | BOOL     | 是否已经加载                               |
| binded        | BOOL     | 是否已经绑定，用于绑定到其他道具的普通道具 |
| supportARMode | BOOL     | 是否支持 AR 模式                           |

____

____

### 2.0 美颜  FUBeautiItem   ###

* 2.1.0 说明: 美颜模块继承自FUParamsCacheItem， 美颜模块分为主体和三个类扩展: 美肤(skin)、美型(shapre)、滤镜(Filter), 需要证书秘钥包含该功能才可以使用。

* 2.1.1 属性说明

| 属性名称  | 类型 | 说明                                                         | key        |
| --------- | ---- | ------------------------------------------------------------ | ---------- |
| heavyBlur | int  | 朦胧磨皮开关，0为清晰磨皮，1为朦胧磨皮                       | heavy_blur |
| blurType  | int  | 此参数优先级比heavyBlur低，在使用时要将heavy_blur设为0，0 清晰磨皮 1 朦胧磨皮 2精细磨皮 | blur_type  |

____

#### 2.2 美肤 FUBeautiItem (Skin) ####

* 属性说明

| 属性名称                      | 类型   | 说明                                                         | key                              |
| ----------------------------- | ------ | ------------------------------------------------------------ | -------------------------------- |
| blurLevel                     | double | 精细磨皮,磨皮程度，取值范围0.0-6.0，默认6.0                  | blur_level                       |
| colorLevel                    | double | 美白 取值范围 0.0-2.0,0.0为无效果，2.0为最大效果，默认值0.2  | color_level                      |
| redLevel                      | double | 红润 取值范围 0.0-2.0,0.0为无效果，2.0为最大效果，默认值0.5  | red_level                        |
| sharpen                       | double | 锐化 锐化程度，取值范围0.0-1.0，默认0.2                      | sharpen                          |
| eyeBright                     | double | 亮眼 0.0-1.0,  0.0为无效果，1.0为最大效果，默认值1.0 亮眼为高级美颜功能，需要相应证书权限才能使用 | eye_bright                       |
| toothWhiten                   | double | 美牙 取值范围 0.0-1.0,  0.0为无效果，1.0为最大效果，默认值1.0 美牙为高级美颜功能，需要相应证书权限才能使用 | tooth_whiten                     |
| removePouchStrength           | double | 去黑眼圈 范围0.0~1.0,  0.0为无效果，1.0最强，默认0.0  去黑眼圈为高级美颜功能，需要相应证书权限才能使用 | remove_pouch_strength            |
| removeNasolabialFoldsStrength | double | 去法令纹 范围0.0~1.0, 0.0为无效果，1.0最强，默认0.0 去法令纹为高级美颜功能，需要相应证书权限才能使用 | remove_nasolabial_folds_strength |

____

#### 2.3 美型 FUBeautiItem (Shap) ####

* 属性说明

| 属性名称             | 类型   | 说明                                                         | key                  |
| -------------------- | ------ | ------------------------------------------------------------ | -------------------- |
| faceShape            | int    | 变形取值 0:女神变形 1:网红变形 2:自然变形 3:默认变形 4:精细变形 | face_shape           |
| changeFrames         | int    | 0为关闭 ，大于0开启渐变，值为渐变所需要的帧数 change_frames  | change_frames        |
| faceShapeLevel       | double | 美型的整体程度由face_shape_level参数控制 取值范围 0.0-1.0, 0.0为无效果，1.0为最大效果，默认值1.0  face_shape_level | face_shape_level     |
| cheekThinning        | double | 瘦脸 瘦脸程度范围0.0-1.0 默认0.5                             | cheek_thinning       |
| cheekV               | double | v脸程度范围0.0-1.0 默认0.0                                   | cheek_v              |
| cheekNarrow          | double | 窄脸程度范围0.0-1.0 默认0.0                                  | cheek_narrow         |
| cheekSmall           | double | 小脸程度范围0.0-1.0 默认0.0                                  | cheek_small          |
| intensityCheekbones  | double | 瘦颧骨程度范围0.0~1.0 1.0程度最强 默认0.0                    | intensity_cheekbones |
| intensityLowerJaw    | double | 瘦下颌骨程度范围0.0~1.0 1.0程度最强 默认0.0                  | intensity_lower_jaw  |
| eyeEnlarging         | double | 大眼程度范围0.0-1.0 默认0.5                                  | eye_enlarging        |
| intensityChin        | double | 下巴调整程度范围0.0-1.0，0-0.5是变小，0.5-1是变大 默认0.5    | intensity_chin       |
| intensityForehead    | double | 额头调整程度范围0.0-1.0，0-0.5是变小，0.5-1是变大 默认0.5    | intensity_forehead   |
| intensityNose        | double | 瘦鼻程度范围0.0-1.0 默认0.0                                  | intensity_nose       |
| intensityMouth       | double | 嘴巴调整程度范围0.0-1.0，0-0.5是变大，0.5-1是变小 默认0.5    | intensity_mouth      |
| intensityCanthus     | double | 开眼角程度范围0.0~1.0 1.0程度最强 默认0.0                    | intensity_canthus    |
| intensityEyeSpace    | double | 眼距调节范围0.0~1.0， 0.5-0.0变长，0.5-1.0变短 默认0.5       | intensity_eye_space  |
| intensityEyeRotate   | double | 眼睛角度调节范围0.0~1.0， 0.5-0.0逆时针旋转，0.5-1.0顺时针旋转 默认0.5 | intensity_eye_rotate |
| intensityLongNose    | double | 鼻子长度调节范围0.0~1.0， 0.5-0.0变长，0.5-1.0变短 默认0.5   | intensity_long_nose  |
| intensityPhiltrum    | double | 人中调节范围0.0~1.0， 0.5-1.0变长，0.5-0.0变短 默认0.5       | intensity_philtrum   |
| intensitySmile       | double | 微笑嘴角程度范围0.0~1.0 1.0程度最强 默认0.0                  | intensity_smile      |
| intensity_eye_circle | double | 圆眼程度范围0.0~1.0 1.0程度最强                              | intensity_eye_circle |

____

#### 2.4 滤镜 ####

* 属性说明

| 属性名      | 类型     | 说明                                                         | key          |
| ----------- | -------- | ------------------------------------------------------------ | ------------ |
| filterName  | NSString | 取值为一个字符串，默认值为 “origin” ，origin即为使用原图效果 | filter_name  |
| filterLevel | double   | filter_level 取值范围 0.0-1.0,0.0为无效果，1.0为最大效果，默认值1.0 | filter_level |

* 接口说明

  key-value 设置属性

  ```objective-c
  - (void)setFilterValue:(double)value forKey:(FUFilter)filterKey; 
  ```

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

___

### 3.0 美妆 （FUMakeUpItem）

* 3.1.0 整体说明: 美妆模块包含组合妆和子妆,当业务层选中某组合装时候直接添加该组合妆对象（FUMakeUpSubject）实例赋值给美妆（FUMakeUpItem）实例的subjectItem属性即可。粉底、腮红、这些属性在美妆（FUMakeUpItem）实例上设置。
* 3.1.1 属性说明

| 属性名称      | 类型 | 说明                                                         | key             |
| ------------- | ---- | ------------------------------------------------------------ | --------------- |
| isMakeUpOn    | Int  | 美妆开关，1开 0关                                            | is_makeup_on    |
| isClearMakeup | int  | 在解绑妆容时是否清空除口红以外的妆容，0表示不清空，1表示清空，口红可由强度进行设置 | is_clear_makeup |
| lipType       | int  | 口红类型 0雾面 2润泽 3珠光 6高性能（不支持双色）             | lip_type        |
| isTwoColor    | int  | 口红双色开关，0为关闭，1为开启，如果想使用咬唇，开启双色开关，并且将makeup_lip_color2的值都设置为0 | is_two_color    |
| isFlipPoints  | int  | 点位镜像，0为关闭，1为开启                                   | is_flip_points  |
| browWarpType  | int  | 眉毛变形类型 0柳叶眉 1一字眉 2远山眉 3标准眉 4扶形眉 5日常风 6日系风 | brow_warp_type  |
| browWarp      | int  | 是否使用眉毛变形 ，1为开 0为关                               | brow_warp       |

* 3.2 主题妆 FUMakeUpItem (Subject)

  * 属性说明

    | 属性名称      | 类型            | 说明                                                         |
    | ------------- | --------------- | ------------------------------------------------------------ |
    | subjectItem   | FUMakeUpSubject | 组合装对象，通过bundle文件路径生成，此bundle包含该妆的所有局部妆(眼影、眉毛等)资源 |
    | texBrow       | FUItem          | 眉毛对象                                                     |
    | texEye1       | FUItem          | 眼影1对象                                                    |
    | texEye2       | FUItem          | 眼影2对象                                                    |
    | texEye3       | FUItem          | 眼影3对象                                                    |
    | texEye4       | FUItem          | 眼影4对象                                                    |
    | texPupil      | FUItem          | 美瞳对象                                                     |
    | texEyeLash    | FUItem          | 睫毛对象                                                     |
    | texEyeLiner   | FUItem          | 眼线对象                                                     |
    | texBlusher1   | FUItem          | 腮红1对象                                                    |
    | texBlusher2   | FUItem          | 腮红2对象                                                    |
    | texFoundation | FUItem          | 粉底对象                                                     |
    | texHighlight  | FUItem          | 高光对象                                                     |
    | texShadow     | FUItem          | 阴影对象                                                     |

* 3.3,0 图层混合 FUMakeUpItem (blend)

  * 属性说明 

    统一说明: 所有眼妆和腮红妆容支持更改图层混合模式，现在的图层混合模式有两种，0为正片叠底，1为正常混合（alpha混合），2为叠加，3为柔光，默认为0。
  
    | 属性名称         | 类型 | 说明                | key                     |
    | ---------------- | ---- | ------------------- | ----------------------- |
    | blendTexEye1     | int  | 第1层眼影的混合模式 | blend_type_tex_eye      |
    | blendTexEye2     | int  | 第2层眼影的混合模式 | blend_type_tex_eye2     |
    | blendTexEye3     | int  | 第3层眼影的混合模式 | blend_type_tex_eye3     |
    | blendTexEye4     | int  | 第4层眼影的混合模式 | blend_type_tex_eye4     |
    | blendTexEyeLash  | int  | 睫毛的混合模式      | blend_type_tex_eyeLash  |
  | blendTexEyeLiner | int  | 眼线的混合模式      | blend_type_tex_eyeLiner |
    | blendTexBlusher1 | int  | 第1层腮红的混合模式 | blend_type_tex_blusher  |
  | blendTexBlusher2 | int  | 第2层腮红的混合模式 | blend_type_tex_blusher2 |
    | blendTexTexPupil | int  | 美瞳的混合模式      | blend_type_tex_pupil    |
  
    
  
* 3.4.0 子妆 FUMakeUpItem (Child)

  * 3.4.1 属性说明

    | 属性名称            | 类型   | 说明     | key                         |
    | ------------------- | ------ | -------- | --------------------------- |
    | intensityFoundation | double | 粉底强度 | makeup_intensity_foundation |
    | intensityBlusher    | double | 腮红强度 | makeup_intensity_blusher    |
    | intensityEye        | double | 眼影强度 | makeup_intensity_eyeBrow    |
    | intensityEyelash    | double | 睫毛强度 | makeup_intensity_eyelash    |
    | intensityHighlight  | double | 高光强度 | makeup_intensity_highlight  |
    | intensityShadow     | double | 阴影强度 | makeup_intensity_shadow     |
    | intensityPupil      | double | 美瞳强度 | makeup_intensity_pupil      |

  * 3.4.2 接口说明

    ````objective-c
    /**
     * 设置眉毛需 需要额外特殊处理，
     *  type : 眉毛变形类型  0柳叶眉  1一字眉  2远山眉 3标准眉 4扶形眉  5日常风 6日系风
     *  enable, 眉毛是否变形开关， 0 关闭变形，1 开启变形
     */
    - (void)setEyeBrowValue:(double)value
                eyeBrowtype:(int)type
                     enable:(int)enable;
    ````

    ```objective-c
    /**
     * 口红特殊处理
     * type:  0雾面 2润泽 3珠光 6高性能（不支持双色）
     * enable  口红双色开关，0为关闭，1为开启，如果想使用咬唇，开启双色开关，并且将makeup_lip_color2的值都设置为0
     */
    - (void)setLipValue:(double)value
                lipType:(int)type
                 enable:(int)enable
    ```

    ```objective-c
    //键值对的形式设置 子妆的属性,主要是为了多个属性的情况下方便设置。效果和属性一致
    - (void)setChildValue:(double)value forKey:(FUMakeUpChildStrengthKey)key;
    ```

    ```objective-c
    //获取当前所有子妆强度key值数组
    - (NSArray *)allMakeUpChildKeys;
    ```

  ***

  

* 3.5.0 颜色 FUMakeUpItem (Color)

  * 3.5.1 属性说明

    | 属性名称        | 类型    | 说明                                                         | key                     |
    | --------------- | ------- | ------------------------------------------------------------ | ----------------------- |
    | foundationColor | FUColor | 粉底调色参数，数组的第四个值（对应alpha）为0时，会关闭粉底的调色功能，大于0时会开启 | makeup_foundation_color |
    | lipColor        | FUColor | 为口红颜色                                                   | makeup_lip_color        |
    | lipColor2       | FUColor | 如果is_two_color为1，会启用这个颜色，外圈颜色为makeup_lip_color2，内圈颜色为makeup_lip_color，如果makeup_lip_color2都为0，则外圈为透明，即为咬唇效果 | makeup_lip_color2       |
    | blusherColor    | FUColor | 第一层腮红调色参数，数组的第四个值（对应alpha）为0时，会关闭这一层腮红的调色功能，大于0时会开启 | makeup_blusher_color    |
    | eyeBrowColor    | FUColor | 眉毛调色参数，数组的第四个值（对应alpha）为0时，会关闭眉毛的调色功能，大于0时会开启 | makeup_eyeBrow_color    |
    | eyeLinerColor   | FUColor | 眼线调色参数，数组的第四个值（对应alpha）为0时，会关闭眼线的调色功能，大于0时会开启 | makeup_eyeLiner_color   |
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

    ```objective-c
    //键值对的形式设置颜色属性
    - (void)setColor:(FUColor)color forKey:(FUMakeUpColor)colorKey
    ```

    ```objective-c
    //获取当前所有colorKey数组
    - (NSArray *)allFUMakeUpColorKeys;
    ```

  * 3.6.0 人脸点位 FULightMakeUpItem (landMark)

    * 属性说明

    | 属性名称      | 类型       | 说明                                                         | key             |
    | ------------- | ---------- | ------------------------------------------------------------ | --------------- |
    | isUserFix     | int        | 这个参数控制是否使用修改过得landmark点，如果设为1为使用，0为不使用 | is_use_fix      |
    | fixMakeUpData | FULandMark | 这个参数为一个数组，需要客户端传递一个数组进去，传递的数组的长度为 150*人脸数，也就是将所有的点位信息存储的数组中传递进来。 | fix_makeup_data |

    

***

***

### 4.0 轻美妆 （FULightMakeUpItem）

* 4.1.0属性说明

  | 属性名称        | 类型 | 说明                                                         | key             |
  | --------------- | ---- | ------------------------------------------------------------ | --------------- |
  | isMakeUpOn      | int  | 美妆开关 1 开 0 关                                           | is_makeup_on    |
  | lipType         | int  | 口红类型 0雾面 2润泽 3珠光 6高性能（不支持双色）             | lip_type        |
  | isTwoColor      | int  | 口红双色开关，0为关闭，1为开启，如果想使用咬唇，开启双色开关，并且将makeup_lip_color2的值都设置为0 | is_two_color    |
  | makeup_lip_mask | int  | 嘴唇优化效果开关，1 开 0 关                                  | makeup_lip_mask |

* 接口说明

  ```objective-c
  //图片纹理形式添加，底部调用fuCreateTexForItem接口
  - (void)setLightMakeUpImage:(UIImage *)image forKey:(FULightMakeUpTextureKey)key;
  ```

  ```objective-c
  //获取所有纹理图片key数组
  - (NSArray *)allImageMakeUpKeys;
  ```

* 4.2.0 子妆 FULightMakeUpItem (Child)

  * 4.2.1 属性说明

    | 属性说明          | 类型   | 说明     | key                       |
    | ----------------- | ------ | -------- | ------------------------- |
    | intensityBlusher  | double | 腮红强度 | makeup_intensity_blusher  |
    | intensityEye      | double | 眼影强度 | makeup_intensity_eye      |
    | intensityEyeLiner | double | 眼线强度 | makeup_intensity_eyeLiner |
    | intensityEyelash  | double | 睫毛强度 | makeup_intensity_eyelash  |
    | intensityPupil    | double | 美瞳强度 | makeup_intensity_pupil    |
    | intensityEyeBrow  | double | 眉毛强度 | makeup_intensity_eyeBrow  |

  * 4.2.2 接口说明

    ```objective-c
    /**
     * 口红特殊处理
     * type:  0雾面 2润泽 3珠光 6高性能（不支持双色）
     * enable  口红双色开关，0为关闭，1为开启，如果想使用咬唇，开启双色开关，并且将makeup_lip_color2的值都设置为0
     */
    - (void)setLipType:(int)type enable:(int)enable;
    ```

* 4.3.0 FULightMakeUpItem (Color)

  * 属性说明

    | 属性说明       | 类型类型 | 说明                                    | key              |
    | -------------- | -------- | --------------------------------------- | ---------------- |
    | makeUpLipColor | double   | [0,0,0,0]   //长度为4的数组，rgba颜色值 | makeup_lip_color |

  

* 4.4.0 人脸点位 FUMakeUpItem (landMark)

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
 * 特殊蒙板需要设置弯曲度
 */
@property (nonatomic, copy) void(^WarpBlock)(NSNumber *warp);
```

```objective-c
/**
 * 检测输入照片人脸结果异常调用， 用于处理异常提示 UI逻辑.
 * code: -1, 人脸异常（检测到人脸但是角度不对返回-1），0: 未检测到人脸
 */
- (void)checkInputFaceWithResultCode:(int)code;
```

```objective-c
/**
 * 输入照片检测到多张人脸回调此方法,用于UI层绘制多人脸 UI
 */
- (void)checkPosterWithFaceInfos:(NSArray <FUFaceRectInfo *> *)faceInfos;
```

```objective-c
/**
 * 检测海报模版背景图片人脸结果（异常调用）
 * code: -1, 人脸异常（检测到人脸但是角度不对返回-1） 0: 未检测到人脸
 */
- (void)checkTempImageWithResultCode:(int)code;
```

```objective-c
/**
 *  inputImage图片 和 海报蒙板图片合成的结果回调
 *  data : inputImage图片和海报蒙板图片合成之后的图片数据
 */
- (void)renderResultWithImageData:(UIImage *)data;
```

***

***

### 6.0 绿幕 FUGreenScreenItem

* 接口说明

```objective-c
/**
 * 根据传入的图进和点位进行取色，获取到的颜色需要生效直接设置 self.keyColor
 */
+ (UIColor *)pixelColorWithmage:(UIImage *)originImage point:(CGPoint)point;
```

```objective-c
/**
 * 根据传入的CVPixelBufferRef和点位进行取色
 */
+ (UIColor *)pixelColorWithPixelBuffer:(CVPixelBufferRef)buffer point:(CGPoint)point;
```

```objective-c
/**
 * 绿幕背景视频设置,内部逐帧解析渲染。
 */
- (void)setUpVideoDecodeWithUrl:(NSURL *)url;

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
| keyColor     | FUColor | 设置绿幕取色, 颜色值按照十六进制大小设置 ex: RGBA (255.0, 255.0, 255.0, 1.0) | key_color        |
| chromaThres  | double  |                                                              | chroma_thres     |
| chromaThrest | double  |                                                              | chroma_thres_T   |
| alphal       | double  |                                                              | alpha_L          |
| center       | CGPoint | 当前图片偏移量                                               | start_x、start_y |
| scale        | float   | 图片宽高放大值                                               | end_x、end_y     |
| rotationMode | int     | 当前设备方向0、1、2、3                                       | rotation_mode    |
| isBgra       | int     |                                                              | is_bgra          |
| cutouting    | BOOL    | 当前是否正在进行抠图,抠图就停止绿慕渲染                      |                  |

***

***

### 7.0 道具贴纸  FUStickerItem

* 说明

  无特殊设置项的道具直接使用此类实例化

  FUMusicFilterItem音乐滤镜、FUAnimojiItem 表情、FUGestureItem手势道具、FUAISegmentItem 人像分割 用各自具体子类实例化
    

***

***

### 8.0 音乐滤镜  FUMusicFilterItem ：FUStickerItem 

* 接口说明

```objective-c
/**
 * 立即播放音乐
 */
- (void)playWithMusicName:(NSString *)music;
```

```objective-c
/**
 * 设置音乐名称，但不播放，等到乐滤镜在底层苦渲染时自动播放音乐
 * 同步音乐和渲染效果
 */
- (void)setMusicName:(NSString *)music;
```

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

### 9.0 表情  FUAnimojiItem 

* 属性说明

| 属性名称   | 类型 | 说明             | key                                              |
| ---------- | ---- | ---------------- | ------------------------------------------------ |
| flowEnable | int  | 表情是否跟随人脸 | @"{\"thing\":\"<global>\",\"param\":\"follow\"}" |

***

***

### 10.0 手势道具 FUGestureItem

* 属性说明

| 属性名称 | 类型   | 说明                   | key      |
| -------- | ------ | ---------------------- | -------- |
| rotMode  | double | 设备方向参数           | rotMode  |
| handOffY | double | 调整手部比星的位置参数 | handOffY |

***

***

### 11.0 人像分割 FUAISegmentItem

* 属性说明

| 属性名称   | 类型 | 说明           | key         |
| ---------- | ---- | -------------- | ----------- |
| cameraMode | int  | 设置相机前后置 | camera_mode |

***

***

### 12.0 道具叠加容器 FUStickerContainer

* 接口说明

```objective-c
/**
 * 添加item，移除当前已经加载的所有item
 * flag: YES 移除，NO 叠加(不移除)
 */
- (void)addStickerItem:(FUStickerItem *)item removeCurrent:(BOOL)flag;
/**
* 单个FUStickerItem操作接口
* 内部已经加锁，外部无序需处理
*/
- (void)addStickerItem:(FUStickerItem *)item;
- (void)removeStickerItem:(FUStickerItem *)item;
- (void)updateStickerItem:(FUStickerItem *)item;
//按照路径移除
- (void)removeStickerItemForPath:(NSString *)itemPath;
```

```objective-c
/**
* 多个FUStickerItem操作接口
* 内部已经加锁，外部无序需处理
*/
- (void)addStickerItems:(NSArray <FUStickerItem *> *)items;
- (void)removeStickerItems:(NSArray <FUStickerItem *> *)items;
- (void)updateStickerItems:(NSArray <FUStickerItem *> *)items;
- (void)removeStickerItemsForPaths:(NSArray <NSString *> *)itemPaths;
```

```objective-c
/**
* 移除所有已经添加的FUStickerItem
* 内部已经枷锁，外部无需处理
*/
- (void)removeAllSticks;
/**
* 获取所有已经添加的FUStickerItem
*/
- (NSArray *)allStickerItemItems;
```

***

***

### 13.0 动漫滤镜 FUAnimationFilterItem

* 接口说明

| 属性名称 | 类型   | 说明                                   | key   |
| -------- | ------ | -------------------------------------- | ----- |
| style    | double | 范围 0.0 - 7.0，对应不同的动漫滤镜效果 | style |

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

### 14.0 美发 FUHairItem

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

### 15.0 美体 FUBodyBeautyItem

* 属性说明

| 属性名称             | 类型   | 说明                                                         | key                  |
| -------------------- | ------ | ------------------------------------------------------------ | -------------------- |
| bodySlimStrength     | double | 瘦身:0.0表示强度为0，值越大，强度越大，瘦身效果越明显，默认为0.0 | bodySlimStrength     |
| LegSlimStrength      | double | 长腿:0.0表示强度为0，值越大，腿越长，默认为0.0               | LegSlimStrength      |
| WaistSlimStrength    | double | 瘦腰:0.0表示强度为0，值越大，腰越细，默认为0.0               | WaistSlimStrength    |
| ShoulderSlimStrength | double | 美肩:0.5表示强度为0，0.5到1.0，值越大，肩膀越宽，0.5到0.0，值越小，肩膀越窄，0.5为默认值 | ShoulderSlimStrength |
| HipSlimStrength      | double | 美臀:0.0表示强度为0，值越大，强度越大， 提臀效果越明显，默认为0.0 | HipSlimStrength      |
| clearSlim            | int    | 重置:清空所有的美体效果，恢复为默认值                        | clearSlim            |
| Debug                | int    | 是否开启debug点位，0表示关闭，1表示开启，默认关闭            | Debug                |
| HeadSlim             | double | 小头：0.0表示强度为0，值越大，小头效果越明显，默认为0.0      | HeadSlim             |
| orientation          | int    | 方向参数 取值范围 0 - 3                                      | Orientation          |

***

***

### 16.0 动作识别 FUActionRecognition

* 直接初始化实例即可，无需设置额外参数

***

***

### 17.0 精品贴纸  FUQualityStickerItem ：FUStickerItem

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





