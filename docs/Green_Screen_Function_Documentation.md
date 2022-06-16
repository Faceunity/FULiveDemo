# Green Screen bundle Parameter Description

## Content

[TOC]



## Function Introduction

Green screen bundle is mainly used for green screen matting. If you use green or blue background, the matting effect will be better.

## Parameter Description

### Green Screen Matting

The following parameters are some parameters of the green screen, which can be set through the ** fuitemsetparam ** interface：

```
key_color  The default value is [0255,0], the value range is [0-255,0-255,0-255], the selected color is RGB, and the default green can be adjusted according to the actual color
chroma_thres  The default value is 0.518, the value range is 0.0-1.0, similarity: chroma maximum tolerance, the larger the chroma maximum tolerance, more scenes will be culled
chroma_thres_T The default value is 0.22, the value range is 0.0-1.0, smooth: minimum chroma tolerance, the larger the value is, more scenes will be deducted
alpha_L The default value is 0.0, and the range is 0.0-1.0. Transparency: the transparency of the foreground and background of the image is excessive. The higher the value is, the smoother the excessive transparency at the edges of the two
start_x The default value is 0.5, and the value range is 0.0-1.0. The coordinate of the starting point X of the foreground image pixel is used to adjust the position and size of the image in the background image
start_y The default value is 0.5, ranging from 0.0 to 1.0. The coordinate of the starting point y of the foreground pixel is used to adjust the position and size of the image in the background image
end_x The default value is 1.0, and the value range is 0.0-1.0. The coordinates of the pixel endpoint X of the foreground image are used to adjust the position and size of the image in the background image
end_y The default value is 1.0, and the value range is 0.0-1.0. The coordinate of the pixel end y of the foreground image is used to adjust the position and size of the image in the background image
rotation_mode The default value is 0, which is used to rotate the background image
is_bgra The default value is 0, which is used to set whether the color of the background image is bgra
```

### Background texture input

Use the ** fucreatetexforitem ** interface to directly pass in image data in the interface

```
fuCreateTexForItem(int obj_handle,__pointer name,__pointer value,int width,int height)
```

**obj_handle** : BundleID corresponding to the green screen bundle

**name**: “tex_bg” background parameter 

**value**: Corresponding to an array of type U8, corresponding to the image rgba8 data

**width**and **height**: the width and height of corresponding picture 
