# Makeup Prop Function Documentation

## Content

[TOC]



## Function Introduction

Beauty function is a kind of technology to fit various makeup resources to the face. These include cosmetic contact lenses, eyeliner, eyelash, eyebrows, blush, beautiful pupil, lipstick and other makeups.

## Parameter Description

### Beauty parameters

The following parameters are some switches and degree parameters of beauty, which can be set through the**fuItemSetParam** interface:

```
	is_makeup_on:	1,     //makeup switch
	//The following is a separate parameter for each make-up. Setting intensity to 0 is to turn off this makeup effect
	makeup_intensity:1.0,     //overall intensity
    makeup_intensity_lip:1.0,		//lipstick intensity
    makeup_intensity_pupil:1.0,		//pupil intensity
    makeup_intensity_eye:1.0,  		//eyebrow intensity
    makeup_intensity_eyeLiner:1.0,  		//eyeliner intensity
    makeup_intensity_eyelash:1.0,  		//eyelash intensity
    makeup_intensity_eyeBrow:1.0,  		//eyebrow intensity 
    makeup_intensity_blusher:1.0,		//blusher intensity
    makeup_intensity_foundation:1.0,		//foundation intensity
    makeup_intensity_highlight:1.0,		//highlight intensity
    makeup_intensity_shadow:1.0,		//shadow intensity
    //lipstick related interfaces
	lip_type:1,         //Lipstick type 0, foggy surface 2, moisturizing 3, pearlescent 6, high performance (two colors are not supported)
	is_two_color:0,   //Lipstick two-color switch, 0 is off, 1 is on, if you want to use lip biting, turn on the two-color switch, and set the value of makeup_lip_color2 to 0
	//Eyebrow related interface
	brow_warp:1.0, 			//Whether to use eyebrow deformation, 1.0 is on, 0 is off
	brow_warp_type:0,   //Eyebrow deformation type 0 willow leaf eyebrow 1 straight eyebrow 2 distant mountain eyebrow 3 standard eyebrow 4 Fuxing eyebrow 5 normal style 6 Japanese style
	//Point mirror switch
	is_flip_points:0.0,  //Point image, 0 is off, 1 is on
	is_clear_makeup:0, //Whether to empty the makeup except lipstick when unbundling the makeup, 0 means not empty, 1 means empty, lipstick can be set by the intensity
```

### Color conversion parameters

```
{
	"makeup_lip_color": [
		0.77,0.22,0.13,0.86
	],  // is lipstick color
	makeup_lip_color2:[
	0.9,0.09,0.35,0.0
	],  //If is_two_color is 1，this color will be enabled，The color of the outer ring is makeup_lip_color2，The color of the inner ring is makeup_lip_color，If makeup_lip_color2 is 0，The outer ring is transparent, which is the lip biting effect
	makeup_eye_color:[0.0,0.0,0.0,0.0],//The first layer of eye shadow color adjustment parameter, the fourth value of the array (corresponding to alpha) is 0, it will turn off the color palette function, which will be opened when more than 0.
	makeup_eye_color2:[0.0,0.0,0.0,0.0],//The second layers of eye shadow color adjustment parameters, the array of fourth values (corresponding to alpha) is 0, will turn off the color palette function, greater than 0 will be opened.
	makeup_eye_color3:[0.0,0.0,0.0,0.0],//The third layers of eye shadow color adjustment parameters, the array of fourth values (corresponding to alpha) is 0, will turn off the color palette function, greater than 0 will be opened.
	makeup_eye_color4:[0.0,0.0,0.0,0.0],//The fourth layers of eye shadow color adjustment parameters, the array of fourth values (corresponding to alpha) is 0, will turn off the color palette function, greater than 0 will be opened.
	"makeup_eyeLiner_color":[
		1.0,0.0,0.0,1.0
	],//The color matching parameter of the eye liner, the fourth value of the array (corresponding to alpha) is 0, which will turn off the color matching function of the eyeliner, and will open when the value is greater than 0.
	"makeup_eyelash_color":[
		0.0,0.0,1.0,1.0
	],//Eyelash tinting parameter. When the fourth value of the array (corresponding alpha) is 0, the eyelash tinting function will be turned off. When it is greater than 0, the eyelash tinting function will be turned on
	"makeup_blusher_color":[
		0.0,0.0,0.0,0.0
	],//The first layer of blush coloring parameters, the array of fourth values (corresponding to alpha) is 0, will turn off this layer of blush color palette, greater than 0 will be opened.
	"makeup_blusher_color2":[
		0.0,1.0,0.0,1.0
	],//The first layer of blush coloring parameters, the array of fourth values (corresponding to alpha) is 0, will turn off this layer of blush color palette, greater than 0 will be opened.
	"makeup_foundation_color":[
		1.0,0.0,0.0,1.0
	],//The color palette parameter of the foundation, the fourth value of the array (corresponding to alpha) is 0, it will turn off the palette function of the foundation. It will be opened when the value is greater than 0.
	"makeup_highlight_color":[
		1.0,0.0,0.0,1.0
	],//Highlight color matching parameter. When the fourth value of the array (corresponding to alpha) is 0, the highlight color matching function will be turned off. When it is greater than 0, the highlight color matching function will be turned on
	"makeup_shadow_color":[
		1.0,0.0,0.0,1.0
	],//Shadow color matching parameter. When the fourth value of the array (corresponding to alpha) is 0, the shadow color matching function will be turned off. When it is greater than 0, the shadow color matching function will be turned on
	"makeup_eyeBrow_color":[
		1.0,0.0,0.0,1.0
	],//Eyebrow color matching parameter. When the fourth value of the array (corresponding to alpha) is 0, the eyebrow color matching function will be turned off. When it is greater than 0, the eyebrow color matching function will be turned on
	makeup_pupil_color:[
	0.0,0.0,0.0,0.0
	],//Color matching parameter. When the fourth value of the array (corresponding to alpha) is 0, color matching function will be turned off. When it is greater than 0, color matching function will be turned on
	
}
```

Note：After the 6.4.2 version of color parameters, array parameters can be obtained through the interface **fuItemGetParamdv(int item,char* name,double* buf,int n)**.

### Layer Blending Options

All eye makeup and blush makeup support changing the layer blending mode. There are two kinds of layer blending modes, 0 for the positive stacking bottom, 1 for normal mixing (alpha mixing), 2 for overlay, 3 for soft light, and 0 for default.

```
blend_type_tex_eye:0,//The first layer eye shadow blending mode
blend_type_tex_eye2:0,//The second layer eye shadow blending mode
blend_type_tex_eye3:0,//The third layer eye shadow blending mode
blend_type_tex_eye4:0,//The fourth layer eye shadow blending mode
blend_type_tex_eyeLash:0,//Blending mode of eyelashes
blend_type_tex_eyeLiner:0,//Blending mode of Eyeliner
blend_type_tex_blusher:0,//The first layer blusher blending mode
blend_type_tex_blusher2:0,//The second layer blusher blending mode
blend_type_tex_pupil:0,//Blending mode of pupil
```



### Texture Input

**Note: the following interfaces are used after 5.8**

Use **fuCreateTexForItem** interface，directly pass in the image data in the interface

```
fuCreateTexForItem(int obj_handle,__pointer name,__pointer value,int width,int height)
```

**obj_handle** bundleID corresponding to makeup bundle

**name** You can take the following values

```
tex_brow eyebrow
tex_eye eyeshadow
tex_eye2 eyeshadow 2
tex_eye3 eyeshadow 3
tex_eye4 eyeshadow 4
tex_pupil pupil
tex_eyeLash eyelash
tex_eyeLiner eyeliner
tex_blusher blusher 1
tex_blusher2 blusher 2
tex_foundation foundation
tex_highlight highlight
tex_shadow shadow
```

**value** Corresponding to an array of type u8, corresponding to the data of picture rgba8

**width** and **height** correspond to the width and height of picture

### landmark modification

The values of landmark  related parameters are also set through the **fuItemSetParam** interface：

```
The main purpose of landmark modification is to edit the feature points of beauty use and optimize the effect.
The landmark modification is mainly controlled by two parameters. The students in the client need to set these two parameters to modify and use landmark
1. is_use_fix：This parameter controls whether the modified landmark point is used. If it is set to 1, it is used and 0 is not used
2. fix_makeup_data：This parameter is an array. The client needs to pass in an array. The length of the passed array is 150 * number of faces, that is, all the point information is passed in the array stored.

```

#### Note：

The reason why the length of fix_makeup_data is 150 is that we return a total of 75 landmarks. Each landmarks has x and y data, so it is 75 * 2 = 150



## Note

1. The new makeup features only support  RGBA,BGRA,NV21,NV12,I420.
2. It is recommended to use single input mode for beauty props in Android terminal, and use dual input mode. Due to the delay of data transmission in Android system, the delay of makeup may be caused.

## Appendix



### Use of makeup resources

Each set of makeup in fulivedemo corresponds to a makeup.json file

It is recommended to use Notepad + + to open it. The contents are as follows

**Each set of makeup corresponds to a set of makeup.json**

```
{
	"makeup_lip_color": [
		0.77,0.22,0.13,0.86
	],  //lipstick color
	lip_type":0,    //lipstick type
	brow_warp:1.0, 			//Whether to use eyebrow deformation, 1.0 is on, 0 is off
	brow_warp_type:0,   //Eyebrow deformation type 0 willow leaf eyebrow 1 straight eyebrow 2 distant mountain eyebrow 3 standard eyebrow 4 Fuxing eyebrow 5 normal style 6 Japanese style
	"makeup_eye_color":
	[
		1.0,0.0,0.0,1.0,
		0.0,1.0,0.0,1.0,
		0.0,0.0,1.0,1.0
	], //Eye shadow color matching parameters, the three sets of parameters correspond to the first, second, third layers of eye shadow color, and the fourth value of the array (corresponding to alpha) is 0, which will turn off the color matching function of eye shadow, and will open at more than 0.
	"makeup_eyeLiner_color":[
		1.0,0.0,0.0,1.0
	],//The color matching parameter of the eye liner, the fourth value of the array (corresponding to alpha) is 0, which will turn off the color matching function of the eyeliner, and will open when the value is greater than 0.
	"makeup_eyelash_color":[
		0.0,0.0,1.0,1.0
	],//Eyelash tinting parameter. When the fourth value of the array (corresponding alpha) is 0, the eyelash tinting function will be turned off. When it is greater than 0, the eyelash tinting function will be turned on
	"makeup_blusher_color":[
		0.0,1.0,0.0,1.0
	],//The blush parameter of the blush, the fourth value of the array (corresponding to alpha) is 0, will turn off the blush function of the blush, will open when more than 0.
	"makeup_foundation_color":[
		1.0,0.0,0.0,1.0
	],//The color palette parameter of the foundation, the fourth value of the array (corresponding to alpha) is 0, it will turn off the palette function of the foundation. It will be opened when the value is greater than 0.
	"makeup_highlight_color":[
		1.0,0.0,0.0,1.0
	],//Highlight color matching parameter. When the fourth value of the array (corresponding to alpha) is 0, the highlight color matching function will be turned off. When it is greater than 0, the highlight color matching function will be turned on
	"makeup_shadow_color":[
		1.0,0.0,0.0,1.0
	],//Shadow color matching parameter. When the fourth value of the array (corresponding to alpha) is 0, the shadow color matching function will be turned off. When it is greater than 0, the shadow color matching function will be turned on
	"makeup_eyeBrow_color":[
		1.0,0.0,0.0,1.0
	],//Eyebrow color matching parameter. When the fourth value of the array (corresponding to alpha) is 0, the eyebrow color matching function will be turned off. When it is greater than 0, the eyebrow color matching function will be turned on
	//makeup intensity
	makeup_intensity:1.0,     //Overall intensity
    makeup_intensity_lip:1.0,		//lipstick intensity
    makeup_intensity_pupil:1.0,		//pupil intensity
    makeup_intensity_eye:1.0,  		//eyeshadow intensity
    makeup_intensity_eyeLiner:1.0,  		//eyeliner intensity
    makeup_intensity_eyelash:1.0,  		//eyelash intensity
    makeup_intensity_eyeBrow:1.0,  		//eyebrow intensity 
    makeup_intensity_blusher:1.0,		//blusher intensity
    makeup_intensity_foundation:1.0,		//foundation intensity
    makeup_intensity_highlight:1.0,		//highlight intensity
    makeup_intensity_shadow:1.0,		//shadow intensity
	
	
}
```

### The use of makeup resource bundle

Makeup props now support binding with resource props to replace. Use the fuBindItems function to bind (make up), and use fuUnbindItems to unbind (remove makeup)

```
fuBindItems(int item_src, int* p_items,int n_items);
fuUnbindItems(int item_src, int* p_items,int n_items);
item_src: bundle ID of makeup bundle
p_items：the bundle ID corresponding to the resource prop. Note that a pointer is passed in here
n_items：Number of resource props

Tip: The beauty props of Creator 2.0 and above support makeup changing and mixing with other props. You need to put the ID of the beauty resource bundle and the ID of facemakeup into the rendering array

```

The following interfaces are obsolete：
fuCreateTexForItem(int obj_handle, const char* name, void* value, int width, int height)
fuDeleteTexForItem(int obj_handle, const char* name)

```

```