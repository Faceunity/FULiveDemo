# Expression GIF Function Documentation

## Content

[TOC]



## 1. Function Introduction

Expression GIF is a technology that uses 2D blendshape technology to make still photos alive via adding facial features points by users themselves.

## 2. Interface Introduction

All the interfaces of different graphs are encapsulated in bundles. You only need to call the set interface of bundles

### set interface

```
group_type:[],     //Input type array  0-6 corresponding             		'leye','reye','nose','mouth','lbrow','rbrow','face'
group_points:[],	  //All the input points. The number of points is assigned by group_type.
target_width:0,	      //The width of input picture
target_height:0,	  //The height of input picture
is_front:1,			//Whether it is a front camera. Set for Android when switching cameras. IOS does not need to set
is_use_cartoon：1.0  //0 is off and 1 is on. After opening, it will use the cartoon point to run, and the effect of closing eyes is better
use_interpolate2：1.0 //Interpolation switch: 0 is off and 1 is on. When it is on, a circle will be added to the point. However, when the facial features are too close to each other, they are easy to influence each other. When it is off, there will be no circle. When it is single facial features, the influence will be greater


```

### Set input picture interface

```
Corresponding parameter：tex_input
Use the underlying interface fuCreateTexForItem to pass RGBA buffer
```



## 3. Method to generate point location

The client-side calculates the position of the current point according to the rotation, zoom and translation of the facial features image. The picture coordinate system should use the picture **upper left corner** point as the origin

## 4. Method to save the inherent template

Please save it if you need the client-side

1. Pictures entered
2. Picture width and height
3. group_type array
4. group_points array

When loading next time, you can directly set these information into the bundle

## 5. Precautions for making template

1. The closer the eye shape is to the human eye, the better the effect (ellipse)
2. The facial features should not be too close to each other. They may affect each other and cross each other
3. Pay attention to the limit of the number of facial features, each limit is 3