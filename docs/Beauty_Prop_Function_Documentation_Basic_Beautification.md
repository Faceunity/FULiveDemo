# Beauty Prop Parameter Description_Basic Beautification

## Content

[TOC]



## Function Description

Basic beautification includes ruddy, whitening, clear skin grinding, fine skin grinding and filter function.

## Parameter Description

#### Global parameters

The global switch of beauty props is **is_beauty_on**

```
is_beauty_on: Beauty global switch, 0 is off, 1 is on, the default is 1
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
color_level value range 0.0-2.0, 0.0 is no effect, 2.0 is the maximum effect, and the default value is 0.2
```

##### Ruddy

Ruddy is mainly controlled by red_level.

```
red_level value range 0.0-2.0,0.0 is no effect, 2.0 is the maximum effect, and the default value is 0.5
```

#### 3. Blur

There are four parameters to control blurring：blur_level，skin_detect，nonskin_blur_scale，heavy_blur，blur_type

```
blur_level: The value range is 0.0-6.0, and the default value is 6.0
skin_detect: Skin color detection switch, 0 is off, 1 is on, default 0
nonskin_blur_scale: After skin color detection, the fusion degree of non skin color areas is 0.0-1.0, and the default value is 0.0
heavy_blur: Hazy blur switch, 0 for clear blur, 1 for hazy blur
blur_type：This parameter takes precedence over heavy_blur, and when use it, the heavy_blur should be set to 0. 0 clear blur 1 hazy blur  2 fine blur
blur_use_mask: The default value of IOS is 1, and that of other terminals is 0. 1 is to turn on the mask of skin grinding based on human face, and 0 is to turn on normal skin grinding without mask. Only take effect when blur_type is 2.
```

**Note 1：Fine blur is the recommended type.**

Note 2：Hazy blur is an advanced beauty function, which needs corresponding certificate authority to use.  

#### Attention

The value range is indicated after the above parameters. If the value range is exceeded, the effect will be affected and it is not recommended to use 

#### 4. Sharpening

Sharpening can improve the image clarity.

```
sharpen: Sharpening degree, range 0.0-1.0, default 0.2
```
Note：It can be used without blur, and can be superimposed when fine blur is used.



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
gexing11
```

### Corresponding relationship between new and old filters

The corresponding relationship between the key value of new and old filter is as follows. It is recommended to adopt the key value of new filter. A small number of the key values of old filter have been removed due to compatibility problems.

|  New filter corresponding key | Old filter corresponding  key |
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
| gexing11      |               |
|               |               |
|               |               |
|               |               |
|               |               |
|               |               |
|               |               |

Blank means there is no corresponding value.

### Face Beauty Default Parameter Table

The default parameter table of Meiyan recommendation is given in the form of json. The key value is the corresponding parameter name. The corresponding introduction can be found in the above parameter introduction. The value is the corresponding parameter value recommended by us. It is recommended that you use these parameter values as the default parameters.

#### Skin Beauty Default Parameter

```
{	
	"default": {
		"color_level":0.3,
		"red_level":0.3,
		"skin_detect":1,
		"blur_level":4.2,
		"heavy_blur":0,
		"blur_type":2,
		"eye_bright":0.0,
		"tooth_whiten":0.0,
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



