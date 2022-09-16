# Beauty Prop Parameter Documentation

## Content

[TOC]



## Function Introduction

Beauty includes ruddy, whitening, clear blur, hazy blur, filter, deformation, eye brightening and tooth beautifying functions. Among them, hazy skin grinding, filter, deformation, eye brightening and tooth beautifying are advanced beauty functions, which need corresponding certificate authority.

## Parameter Description

#### Global parameters

The global switch of beauty props is is_beauty_on

```
is_beauty_on: Beauty global switch, 0 is off, 1 is on, the default is 1
```

Whether beauty props use face point ability_Landmark, the American model is not available after shutdown

```
use_landmark:Beauty uses face point switch, 0 is off, 1 is on, default is 1
```


#### 1. Filter

Filters are mainly controlled by filter_level and filter_name

```
filter_level value range 0.0-1.0, 0.0 is no effect, 1.0 is the maximum effect, and the default value is 1.0
filter_name The value is a string，The default value is "origin", which is the effect of using the original image
```

The value of parameter filter_name and related introduction are described in detail in Appendix ** Filter corresponding key value **. For users of the old version (before 6.0), please refer to appendix ** New and old filter corresponding relationship **.

#### 2. Whitening and Ruddy

##### Whitening

Whitening is mainly controlled by color_level.

```
color_level value range 0.0-1.0, 0.0 is no effect, 1.0 is the maximum effect, and the default value is 0.2
```
Note：The recommended range of whitening parameters is 0.0-1.0, and 0.0-2.0 can be selected if individual needs want to have a wider range of effects, among which 1.0-2.0 is more effective.


##### Ruddy

Ruddy is mainly controlled by red_level.

```
red_level value range 0.0-1.0,0.0 is no effect, 1.0 is the maximum effect, and the default value is 0.5
```
Note：The recommended range of ruddy is 0.0-1.0, and 0.0-2.0 can be selected for individual needs, in which the range of 1.0-2.0 is more effective.  

#### 3. Blur

There are several parameters to control blurring：

```
blur_level: The value range is 0.0-6.0, and the default value is 6.0
heavy_blur: Hazy blur switch, 0 for clear blur, 1 for hazy blur
blur_type：This parameter takes precedence over heavy_blur, and when use it, the heavy_blur should be set to 0. 0 clear blur 1 hazy blur  2 fine blur
blur_use_mask: The default value is 0. 1 is to turn on the blur mask based on human face, and 0 is not use it, which takes effect only when blur_type is 2. To enable this function, you need advanced beauty permission.
```

**Note 1：Fine blur is the recommended type.**

Note 2：Hazy blur is an advanced beauty function, which needs corresponding certificate authority to use.  

#### 4. Sharpening

Sharpening can improve the image clarity.

```
sharpen: Sharpening degree, range 0.0-1.0, default 0.2
```
Note：It can be used without blur, and can be superimposed when fine blur is used.


#### 5. Eye Brightening

Eye brightening is mainly controlled by eye_bright.

```
eye_bright   The value range is 0.0-1.0,0.0 is no effect, 1.0 is the maximum effect, and the default value is 1.0
```

Note：Eye brightening is an advanced beauty function, which needs corresponding certificate authority to use  

#### 6. Tooth Whitening

Tooth whitening is mainly controlled by tooth_whiten.

```
tooth_whiten   The value range is 0.0-1.0,0.0 is no effect, 1.0 is the maximum effect, and the default value is 1.0
```

Note：Tooth whitening is an advanced beauty function, which needs corresponding certificate authority to use 

#### 7. Dark Circles Removing

The parameter is remove_pouch_strength

0 ~ 1.0, 0.0 is no effect, 1.0 is the strongest, and the  default is 0.0

Note：Dark circles removing is an advanced beauty function, which needs corresponding certificate authority to use 

#### 8. Nasolabial Folds Removing

The parameter is remove_nasolabial_folds_strength

The value range is 0 ~ 1.0.0.0 is no effect, 1.0 is the strongest, and the default is 0.0

Note：Nasolabial folds removing is an advanced beauty function, which needs corresponding certificate authority to use 

#### 9. Face Outline Beautification 

The degree of face outline beautification is mainly  controlled by face_shape_level.

```
face_shape_level  The value range is 0.0-1.0, 0.0 is no effect, 1.0 is the maximum effect, and the default value is 1.0
```

The gradual change of beauty type is controlled by change_frames.

```
change_frames      0 is off, greater than 0 is on, and the value is the number of frames required for the gradient
```

Types of beauty is mainly controlled by face_shape .

```
face_shape: value range 0: Goddess deformation 1: online celebrity deformation 2: natural deformation 3: default deformation 4: fine deformation
```

When face_shape selects different parameters, the corresponding parameters are also different:

##### face_shape Parameter Details

```
1.
When face_shape is 0 1 2 3
Corresponding to 0: Goddess 1: online celebrity 2: nature 3: default 4: fine deformation default 4
Parameters can be used
eye_enlarging: 	default 0.5,		//The extent of eye enlarging 0.0-1.0
cheek_thinning:	default 0.0,  		//The extent of cheek thining 0.0-1.0
2.
When face_shape is 4，for the user-defined fine deformation, the parameters related to face shape are opened, and the parameters of narrow face and small face are added
eye_enlarging: 	default 0.5,		//The extent of eye enlarging 0.0-1.0
cheek_thinning:	default 0.0,  		//The extent of cheek thining 0.0-1.0
cheek_v:	default 0.0,  		//The extent of V-shape cheek 0.0-1.0
cheek_narrow:   default 0.0,          //The extent of  cheek narrowing 0.0-1.0
cheek_small:   default 0.0,          //The extent of  cheek small 0.0-1.0
intensity_nose: default 0.0,        //The extent of nose narrowing 0.0-1.0
intensity_forehead: default 0.5,    //The extent of forehead adjustment 0.0-1.0，0-0.5 is getting smaller，0.5-1 is getting bigger
intensity_mouth: default 0.5,       //The extent of mouth adjustment 0.0-1.0，0-0.5 is getting bigger，0.5-1 is getting smaller
intensity_chin: default 0.5,       //The extent of chin adjustment 0.0-1.0，0-0.5 is getting smaller，0.5-1 is getting bigger
intensity_philtrum：default 0.5    //The extent of philtrum adjustment 0.0~1.0， 0.5-1.0 is lengthening，0.5-0.0 is shortening
intensity_long_nose：default 0.5    //The extent of nose  length adjustment 0.0~1.0， 0.5-0.0 is lengthening，0.5-1.0 is shortening
intensity_eye_space：default 0.5    //The extent of  eye distance0.0~1.0， 0.5-0.0 is lengthening，0.5-1.0 is shortening
intensity_eye_rotate：default 0.5    //The extent of eye angle 0.0~1.0， 0.5-0.0 counter clockwise, 0.5-1.0 clockwise
intensity_smile：default 0.0    //The extent of smile 0.0~1.0 1.0 is the strongest
intensity_canthus：default 0.0    //The extent of canthus 0.0~1.0 1.0 is the strongest
intensity_cheekbones: default 0.0  //The extent of cheek bone thining 0.0~1.0 1.0 is the strongest
intensity_lower_jaw：default 0.0 //The extent of lower jaw narrowing 0.0~1.0 1.0 is the strongest
intensity_eye_circle：default 0.0 //The extent of round eye 0.0~1.0 1.0 is the strongest
```

#### Note

The value range is indicated after the above parameters. If the value range is exceeded, the effect will be affected and it is not recommended to use

## Appendix

### Corresponding key value of filter

```
New Filters
bailiang1
bailiang2
bailiang3
bailiang4
bailiang5
bailiang6
bailiang7
fennen1
fennen2
fennen3
fennen4
fennen5
fennen6
fennen7
fennen8
gexing1
gexing2
gexing3
gexing4
gexing5
gexing6
gexing7
gexing8
gexing9
gexing10
heibai1
heibai2
heibai3
heibai4
heibai5
lengsediao1
lengsediao2
lengsediao3
lengsediao4
lengsediao5
lengsediao6
lengsediao7
lengsediao8
lengsediao9
lengsediao10
lengsediao11
nuansediao1
nuansediao2
nuansediao3
xiaoqingxin1
xiaoqingxin2
xiaoqingxin3
xiaoqingxin4
xiaoqingxin5
xiaoqingxin6
ziran1
ziran2
ziran3
ziran4
ziran5
ziran6
ziran7
ziran8
gexing11
zhiganhui1
zhiganhui2
zhiganhui3
zhiganhui4
zhiganhui5
zhiganhui6
zhiganhui7
zhiganhui8
mitao1
mitao2
mitao3
mitao4
mitao5
mitao6
mitao7
mitao8
```

### Corresponding relationship between new and old filters

The corresponding relationship between the key value of new and old filter is as follows. It is recommended to adopt the key value of new filter. A small number of the key values of old filter have been removed due to compatibility problems.

| New filter corresponding key |Old filter corresponding key |
| ------------- | ------------- |
| bailiang1     |               |
| bailiang2     | nature_old    |
| bailiang3     | delta         |
| bailiang4     | dry           |
| bailiang5     | refreshing    |
| bailiang6     | newwhite      |
| bailiang7     | ziran         |
| fennen1       |               |
| fennen2       |               |
| fennen3       | red           |
| fennen4       | crimson       |
| fennen5       | danya         |
| fennen6       | fennen        |
| fennen7       | qingxin       |
| fennen8       | hongrun       |
| gexing1       | electric      |
| gexing2       | tokyo         |
| gexing3       | warm          |
| gexing4       | dew           |
| gexing5       | concrete      |
| gexing6       | keylime       |
| gexing7       | cold          |
| gexing8       | lucky         |
| gexing9       | Japanese      |
| gexing10      | cloud         |
| heibai1       |               |
| heibai2       | white level   |
| heibai3       | boardwalk     |
| heibai4       | blackwhite    |
| heibai5       | sliver        |
| lengsediao1   |               |
| lengsediao2   |               |
| lengsediao3   |               |
| lengsediao4   |               |
| lengsediao5   | girly         |
| lengsediao6   | kodak         |
| lengsediao7   | rollei        |
| lengsediao8   | autumn        |
| lengsediao9   | sunshine      |
| lengsediao10  | sakura        |
| lengsediao11  | hongkong      |
| nuansediao1   |               |
| nuansediao2   | red tea       |
| nuansediao3   | forest        |
| xiaoqingxin1  |               |
| xiaoqingxin2  |               |
| xiaoqingxin3  |               |
| xiaoqingxin4  | slowlived     |
| xiaoqingxin5  | pink          |
| xiaoqingxin6  | sweet         |
|               | polaroid      |
|               | cruz          |
|               | fuji          |
|               | cyan          |
|               | pearl         |
| ziran1        |               |
| ziran2        |               |
| ziran3        |               |
| ziran4        |               |
| ziran5        |               |
| ziran6        |               |
| ziran7        |               |
| ziran8        |               |
| gexing11      |               |
| zhiganhui1    |               |
| zhiganhui2    |               |
| zhiganhui3    |               |
| zhiganhui4    |               |
| zhiganhui5    |               |
| zhiganhui6    |               |
| zhiganhui7    |               |
| zhiganhui8    |               |
| mitao1        |               |
| mitao2        |               |
| mitao3        |               |
| mitao4        |               |
| mitao5        |               |
| mitao6        |               |
| mitao7        |               |
| mitao8        |               |

Blank means there is no corresponding value.

### Face Beauty Default Parameter Table

The default parameter table of Meiyan recommendation is given in the form of json. The key value is the corresponding parameter name. The corresponding introduction can be found in the above parameter introduction. The value is the corresponding parameter value recommended by us. It is recommended that you use these parameter values as the default parameters.

#### Skin Beauty Default Parameter

```
{	
	"default": {
		"color_level":0.3,
		"red_level":0.3,
		"blur_level":4.2,
		"heavy_blur":0,
		"blur_type":2,
		"eye_bright":0.0,
		"tooth_whiten":0.0,
		"sharpen":0.2
	}
}
```

#### Filter Default Parameter

```
{	
	"default": {
		"filter_name":"ziran2",
		"filter_level":0.4,
	},
}
```

#### Body Beautification Default Parameter

```
{	
	"default": {
		"face_shape_level":1.0,
		"face_shape":4,
		"eye_enlarging":0.4,
		"cheek_thinning":0.0,
		"cheek_v":0.5,
		"cheek_narrow":0,
		"cheek_small":0,
		"intensity_nose":0.5,
		"intensity_forehead":0.3,
		"intensity_mouth":0.4,
		"intensity_chin":0.3
	}
}
```

