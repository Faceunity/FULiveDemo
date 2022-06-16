# iOS Nama SDK Integration Guide  

------

Level：Public   
Update date：2021-12-24 
SDK version: 8.0.2

### Updates：

1）Fix some bugs

------

Level：Public   
Update date：2021-11-17 
SDK version: 8.0.1

### Updates：

1）Fix some bugs

------

Level：Public   
Update date：2021-10-27 
SDK version: 8.0.0

### Updates：

1）Optimized beauty special effects, optimized 8 functions such as microdermabrasion, big eyes, face shape, etc., and improved multi-dimensional effects such as skin details, contour lines, deformation ratio, etc.
2）Newly added sub-model adaptation strategy, the use of better uniform dermabrasion on high-end machines, and the use of fine dermabrasion with balanced performance and effect on middle and low-end machines, improving the utilization of the overall equipment
3）Optimized beauty, optimized the naturalness of lipstick, eyebrows, eyelashes, and cosmetic contact lenses, and added lipstick texture and style combination makeup
4）Face detection algorithm optimization, optimized detection rate and false detection rate
5）Optimization of portrait segmentation algorithm to optimize segmentation accuracy, segmentation edge smoothness, background misrecognition and other issues in the PC-side bust scene
6）Added the green screen safe area function, which supports the green screen keying of the designated area according to the template, and the template supports customer customization
7）Optimize the rendering timing issue when multiple functions are mixed
8）Fix some bugs

------

Level：Public   
Update date：2021-07-09 
SDK version: 7.4.1

### Updates：

1）Update 8 types of premium stickers, including 2 PK games, 5 decorative and interactive stickers, and 1 full-body drive prop
2）Update 2 Chinese style Animoji models
3）Fix the problem of portrait segmentation sticker effect. After the repair, the portrait segmentation result and sticker effect will appear at the same time
4）Fix some bugs, including high-resolution dermabrasion effects, face detection and sticker drawing timing issues

------

Level：Public   
Update date：2021-04-19 
SDK version: 7.4.0  

------

### Updates：

2021-04-19  7.4.0
1）[Demo layer] Refactoring the special effects Demo, changing process-oriented to object-oriented, the overall structure and logic are clearer, and customer calls are more convenient. At the same time, it has many advantages such as saving memory, optimizing the automatic destruction logic of itemID, simplifying the process of user input information, and low coupling to improve the flexibility of the architecture.
2）Added emotion recognition function, supporting 8 basic full emotion detection
3）Added content service module to display game props and boutique stickers, mainly including rich special effects props such as games, plots, headwear, atmospheres, etc.
4）Added asynchronous interface to improve the problem of insufficient frame rate for users on low-end devices
5）Optimize body performance, the frame rate on the Android side increased by 24%, and the time consumption on the iOS side decreased by 13%
6）Optimize the performance of portrait segmentation, and the frame rate of Andriod is increased by 39%, and the time consumption of iOS is reduced by 39%
7）Optimize the effect of portrait segmentation, mainly including optimizing the gap problem, so that the portrait segmentation fits the human body more closely, and there will be no obvious gaps; improve the accuracy of human body segmentation and reduce background misrecognition
8）Added a new method of portrait segmentation, open the user-defined background interface, which is convenient for users to quickly change the background; support the portrait stroke gameplay, and customize the stroke width, distance, and color
9）Add the Animoji koala model; optimize the Animoji facial driving effect to improve the stability and sensitivity of the driven model
10）Optimize the beauty effect, including the lipstick no longer appears when the lips are blocked; improve the fit of the color contact lenses; add a variety of color contact materials

------

### Updates：

**2021-1-25 v7.3.2:  **

- Optimize the performance of facial expression tracking driver.
- fuSetup function changed to thread safe.
- fuSetUp 、fuCreateItemFromPackage、fuLoadAIModel functions add exception handling and enhances robustness.
- Fix the effect of custom haha mirror function.
- Fix the SDK crash problem on Mac 10.11.
- Fix the crash problem when the SDK is mixed with "Sticker" and "Animoji".

------

### Updates：

2019-04-29 v1.0:

1. Added a pinch function demo
2. Optimized interaction
3. Updates props

------
## Contents：
[TOC]

------
## 1. Introduction 
This document shows you how to integrate the Faceunity Nama SDK into your IOS project.  

------


## 2. File structure(Using the new architecture FURenderKit dynamic library)

This section describes the structure of the Demo file, the various directories, and the functions of important files.

```obj
+FULiveDemo
  +FULiveDemo                   //Source code directory
    +Main                     //Main module (homepage and public page UI, model, main business management class)
    +Modules                  //All function modules
      +Normal                   //Ordinary prop module
      +Beauty                   //Beauty module
        ...
    +Helpers                //Main business management class  
      -FUManager              //Nama business class
      +VC                      //Base controller
      +Manager                 //Base Management class
          ...   
    +Config                    //Configuration file directory
      -DataSource             //Main interface, permissions, item prop configuration class
      -makeup.json             //Makeup single array
      -makeup_whole.json      //Makeup configuration
      -avatar.json            //Pinch face color, template profile
    +Resource               
       +items                 //Prop resource 
    +Lib                    //Nama SDK  
      -authpack.h             //Permission file
      -FURenderKit.framework   //FURenderKit dynamic library      
      +Resources               //Resources related to each capability
  +docs                        //Docs
  +Pods                     //Rripartite library management
  -FULiveDemo.xcworkspace   //Project file
  
```
## 3. Integration


### 3.1 Develop environment
#### 3.1.1 Platform
```
iOS 9.0 or above
```
#### 3.1.2 Develop environment
```
Xcode 8 or above
```

### 3.2 Get Started 
 #### 3.2.1 Integration via CocoaPods

Nama full version:

```
pod 'Nama', '8.0.2' 
```

Nama version without physical engine:

```
pod 'Nama-lite', '8.0.2' 
```
FURenderKit full version:

```
pod 'FURenderKit', '8.0.2' 
```

FURenderKit version without physical engine:

```
pod 'FURenderKit-lite', '8.0.2' 
```

Then execute:

```
pod install
```

If prompt that cannot find this version, please try to execute below command:

```
pod repo update or pod setup
```

#### 3.2.1 Integration via GitHub

Nama full version:[FaceUnity-SDK-iOS-v8.0.2.zip](https://fu-sdk.oss-cn-hangzhou.aliyuncs.com/FaceUnity-SDK-iOS-v8.0.2.zip)

Nama version without physical engine(lite version):[FaceUnity-SDK-iOS-v8.0.2-lite.zip](https://fu-sdk.oss-cn-hangzhou.aliyuncs.com/FaceUnity-SDK-iOS-v8.0.2-lite.zip)

FURenderKit full version:
    [FURenderKit-v8.0.2.zip](https://fu-sdk.oss-cn-hangzhou.aliyuncs.com/FURenderKit-v8.0.2.zip)

FURenderKit without physical engine(lite version)：
    [FURenderKit-lite-v8.0.2.zip](https://fu-sdk.oss-cn-hangzhou.aliyuncs.com/FURenderKit-lite-v8.0.2.zip)

After downloading and uncompressing, please drag Nama SDK files to your own project and check 'Copy items if needed' as picture below:

------

![](imgs/picture1.png)

Then add dependent libraries through 'Build Phases → Link Binary With Libraries', OpenGL.framework, Accelerate.framework, CoreMedia.framework, AVFoundation.framework and stdc++.tbd are necessary, as picture below:

------

![](imgs/picture2.png)

### 3.3 Configurations

####3.3.1 Import certificate

Certificate license issued by Faceunity is necessary to utilize Nama SDK's functions, which you can get through:

- 1. Call +86-(0)571-89774660 to cunsult
- 1. Email marketing@faceunity.com to consult

Certificate license on iOS is g_auth_package array included in authpack.h, if you've already got this, just introduce it to your own project. According to practice application requirement, authentication data can also be provided when running(download through network), but please pay attention to certificate license leakage to avoid abuse utilization.

### 3.4 Initialization

Firstly import FURenderer.h head file:

```c
#import "FURenderer.h"
```

Then perform initialization:

```c
NSString *v3Path = [[NSBundle mainBundle] pathForResource:@"v3" ofType:@"bundle"];
    
[[FURenderer shareRenderer] setupWithDataPath:v3Path authPackage:g_auth_package authSize:sizeof(g_auth_package) shouldCreateContext:YES];
```

**Note:** After app started, FURenderer only needs to be setup one time, among which ``g_auth_package`` secrect key array declaration is in authpack.h.

So far project configuration and Nama SDK's initialization is all done, next you can start to process video utilizing Nama SDK.

**Interface description:**

```
- (void)setupWithDataPath:(NSString *)v3path 
              authPackage:(void *)package 
                 authSize:(int)size 
      shouldCreateContext:(BOOL)create;
```

参数说明：

**Parameter description:**

`v3path` v3.bundle file directory

`package` memory pointer, points to authentication data contents. If authentication data is provided  by including authpack.h when compiling, then this can be written as g_auth_package.

`size` length of authentication data, in bytes.  If providing g_auth_package in authpack.h as authentication data, here can be written as  sizeof(g_auth_package).

`create`  if set as YES, we will create and possess GL context and in this case project must utilize Objective-C interfaces.

### 3.5 Props

#### 3.5.1 Prop Item Creation

Prop item creation interface:

```objective-c
+ (int)itemWithContentsOfFile:(NSString *)path
```

**Parameter description:**

`path` prop item directory

**Return value:**

`int` prop item handle

**Example code:**

```objective-c
NSString *path = [[NSBundle mainBundle] pathForResource:@"tiara" ofType:@"bundle"];

int itemHandle = [FURenderer itemWithContentsOfFile:path];
```

Sometimes in practice application multiple prop items will be utilized at the same time, in that case parameter that Nama SDK's video processing interfaces accept is a int array including multiple prop item handles, so we need to creat a int array to store these prop item handles. Next we will create a garland prop item handle and store it in position 0 in int array. **Example code as below:**

```objective-c
int items[3];

NSString *path = [[NSBundle mainBundle] pathForResource:@"tiara" ofType:@"bundle"];

int itemHandle = [FURenderer itemWithContentsOfFile:path];

items[0] = itemHandle;
```



#### 3.5.2 Prop Item Destruction

**Single Prop Item Destruction：**

```objective-c
/**
Single Prop Item Destruction
 */
+ (void)destroyItem:(int)item;
```

**Parameter description:**

`item` prop item handle to be destroyed

This interface will release resource corresponding to imported handle, to guarantee coding preciseness, please set this handle to 0 after processing. **Example code as below:**

```objective-c
if (items[0] != 0) {
	[FURenderer destroyItem:items[0]];
}
items[0] = 0;
```

**All Prop Items Destruction：**

```C
/**
All Prop Items Destruction
 */
+ (void)destroyAllItems;

```

This interface can destroy resources corresponding to all prop item handle, please set this handle to 0 after processing as well. **Example code as below:**

```C
[FURenderer destroyAllItems];
    
for (int i = 0; i < sizeof(items) / sizeof(int); i++) {
	items[i] = 0;
}
```

#### 3.5.3 Prop Item Switching

If certain position of handle array needs to be switched, new prop item handle needs to be created first, and then switch this handle with the one needs to be replaced, at last destroy replaced handle. Below is an example of replacing the position 0 handle of handle array:

```C
    // create first and then release can significantlly solve prop item switching stucking problem
    NSString *path = [[NSBundle mainBundle] pathForResource:_demoBar.selectedItem ofType:@"bundle"];
    int itemHandle = [FURenderer itemWithContentsOfFile:path];
    
    if (items[0] != 0) {
        [FURenderer destroyItem:items[0]];
    }
    
    items[0] = itemHandle;
```

**Note:** Destroying old prop item first and creating new one after that will cause prop item discontinuous phenomenon, aka prop loss within short time. 

### 3.6 Video Processing

Pass the items array created in the previous step containing a sticker props handle into the video image processing interface, and at the same time pass in the image that needs to be processed, you can add special effects stickers to the image. The examples are as follows:

```objective-c
CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
[[FURenderer shareRenderer] renderPixelBuffer:pixelBuffer withFrameId:frameID items:items itemCount:sizeof(items)/sizeof(int) flipx:YES];

frameID += 1;
```

Image processing interface description:

```objective-c
- (CVPixelBufferRef)renderPixelBuffer:(CVPixelBufferRef)pixelBuffer
                      	  withFrameId:(int)frameid
                                items:(int*)items
						    itemCount:(int)itemCount
                                flipx:(BOOL)flip;
```

Parameter description:

`pixelBuffer ` :video image data, support BGRA, YUV420SP format

`frameid `: currenr processing video frame's serial number, add 1 after every processing, otherwise animation effect in prop item can not be loaded

`items ` :int array including multiple prop handle

`item:Count `handle quantity in handle array

`flip `: set to YES to enable prop item mirroring

**Return value:**

`CVPixelBufferRef ` :processed video image data



------
## 4. Function
### 4.1 Face Beautification

Configuration of face beautification function is similar to that of adding special effect prop items to video image, create face beautification prop handle first and then save it in items[1] of items array mentioned above. **Example code as below:**

```C
- (void)loadFilter
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"face_beautification" ofType:@"bundle"];
    items[1] = [FURenderer itemWithContentsOfFile:path];
}
```

When processing video image, introducing items array including beautification prop item handle to video image processing interface, and meanwhile introducing video image that needs to be processed can add face beautification effect to the original video image. **Example code as below:**

```C
CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
[[FURenderer shareRenderer] renderPixelBuffer:pixelBuffer withFrameId:frameID items:items itemCount:sizeof(items)/sizeof(int) flipx:YES];

frameID += 1;
```

please refer to [Beautification Filters User Specification](Beautification_Filters_User_Specification.md) for more details.

#### 4.1.1 Filter

Current version provides following filters:

```objc
@"origin",@"bailiang1",@"fennen1",@"lengsediao1",@"nuansediao1",@"xiaoqingxin1"
```

'origin' is original image filter, others are stylish filters and face beautification filters. Face beautification filters possess certain degree face beautification, skin whitening, and lip brighten functions. Filter is assigned by parameter filter_name. Set face beautification prop parameters through fuItemSetParams to switch filter as below:

```C
//  Set item parameters - filter
[FURenderer itemSetParam:items[1] withName:@"filter_name" value:@"origin"];
```

In addition we provide filter strength interface, filter strength can be controlled by parameter filter_level. This parameter's range is [0,1], which 0 stands for no effect and 1 is default effect. Client app should record filter_level chosed by users corresponding to each filter and set this parameter when switching filters.

#### 4.1.2 Skin Whitening & Ruddy

#### Skin Whitening

Control skin whitening level through parameter `color_level`. This parameter's recommended value range is 0~1, which 0 stands for no effect and the default value is 0.5, value larger than 1 stands for continuous effect strengthen.

Parameter setting example as below:

```C
//  Set item parameters - whiten
[FURenderer itemSetParam:items[1] withName:@"color_level" value:@(0.5)];
```

#### Ruddy

Control ruddy level through parameter `red_level`. This parameter's recommended value range is 0~1, which 0 stands for no effect and the default value is 0.5, value larger than 1 stands for continuous effect strengthen.

```objc
//  Set item parameters - red
[FURenderer itemSetParam:items[1] withName:@"red_level" value:@(0.5)];
```

Note: The new beauty filter such as the “shaonv” filter itself can whiten the skin tone and brighten the red lips. When the filter is turned on, the independent whitening and rosy function is appropriately weakened.

#### 4.1.3 Blur

There are 5 parameters to control skin blur: `blur_level`, `skin_detect`, `nonshin_blur_scale`, `heavy_blur`, `blur_blend_ratio`.

```blur_level``` specifies blur level. This parameter's recommended value range is 0~6, which 0 stands for no effect, value larger than 6 is not recommended, even though skin blur effect will strengthen when value increasing larger than 6. 

```skin_detect``` specifies whether enable skin detection, when enabled, detected skin part will be performed specified skin blur according to blur_level, non skin area's blur effect will be weaken to reduce fuzzy. This parameter's value is 0 or 1 which 0 stands for no effect and 1 stands for enable skin detection, default setting is disabled.

```nonshin_blur_scale``` specifies non skin area blur weaken level when enable skin detection. This parameter's range is 0~1 which 0 stands for no blur and 1 stands for maximum level blur and the default value is 0.45. Only if `skin_detect` is enabled can this parameter be modified. 

```heavy_blur``` specifies whether enable heavy blur function. Value larger than 1 stands for enable heavy blur function.

```blur_blend_ratio``` specifies blend ratio of blur effect added image compared with original image. This parameter's range is 0~1.

**Note:** Heavy blur function utilizes relatively strong fuzzy algorithm, the advantage is making skin smoother and reducing lots of flaw and disadvantage is that it will reduce certain level of sharpness. Besides when enable heavy blur function, parameter `blur_level` and `skin_detect` will still take effect but parameter `nonshin_blur_scale` will lose effect. 

Parameter setting example code as below:

```objective-c
//  Set item parameters - blur
[FURenderer itemSetParam:items[1] withName:@"heavy_blur" value:@(1)];
[FURenderer itemSetParam:items[1] withName:@"skin_detect" value:@(1)];
[FURenderer itemSetParam:items[1] withName:@"blur_level" value:@(6.0)];
[FURenderer itemSetParam:items[1] withName:@"blur_blend_ratio" value:@(0.5)];
[FURenderer itemSetParam:items[1] withName:@"nonshin_blur_scale" value:@(0.45)];
```

#### 4.1.4 Eye Brighten

Make eye area's texture more clear and eyes brighter. Eye brighten level can be controlled through parameter `eye_bright`. This parameter's recommended value range is 0~1, which 0 stands for disable and value from 0 to 1 stands for effect strengthen gradually.

**Parameter setting example code as below:**

```objc
//  Set item parameters - eye_bright
[FURenderer itemSetParam:items[1] withName:@"eye_bright" value:@(0.5)];
```

#### 4.1.5 Tooth Whiten

Make eye area's texture more clear and eyes brighter. Eye brighten level can be controlled through parameter `eye_bright`. This parameter's recommended value range is 0~1, which 0 stands for disable and value from 0 to 1 stands for effect strengthen gradually.

**Parameter setting example code as below:**

```objc
//  Set item parameters - tooth_whiten
[FURenderer itemSetParam:items[1] withName:@"tooth_whiten" value:@(0.5)];
```

#### 4.1.6 Face Outline Beautification
##### 4.1.6.1 Basic Face Outline Beautification

Face outline beautification supports four basic beautification types: Goddess, cyber celebrity, nature, default and one advanced face beautification type: custom, which specified by parameter `face_shape`: Goddess(0),cyber celebrity(1), nature(2), default(3) and custom(4).

```C
//  Set item parameters - shaping
[FURenderer itemSetParam:items[1] withName:@"face_shape" value:@(3.0)];
```

Based on above mentioned four basic face outline beautification and one advanced face outline beautification, we provide following three parameters: `face_shape_level`, `eye_enlarging`, `cheek_thinning` in addition.

```face_shape_level``` controls levels changing to specified basic face shape. This parameter's recommended value range is 0~1 which 0 stands for no effect, aka disable face outline beautification, and 1 stands for specifying certain face shape.

Set `face_shape_level` to 0 if you want to disable face outline beautification.

```C
//  Set item parameters - shaping level
[FURenderer itemSetParam:items[1] withName:@"face_shape_level" value:@(1.0)];
```

```eye_enlarging``` controls eyes' size. This parameter can be effected by parameter face_shape_level. This parameter's recommended value range is 0~1, value larger than 1 stands for continuous effect strengthen.

```C
//  Set item parameters - eye enlarging level
[FURenderer itemSetParam:items[1] withName:@"eye_enlarging" value:@(1.0)];
```

```cheek_thinning``` controls cheek's size. This parameter can be effected by parameter `face_shape_level`. This parameter's recommended value range is 0~1, value larger than 1 stands for continuous effect strengthen.

```C
//  Set item parameters - cheek thinning level
[FURenderer itemSetParam:items[1] withName:@"cheek_thinning" value:@(1.0)];
```

##### 4.1.6.2 Advanced Face Outline Beautification

##### face outlines adjustment

Added optimized face-lifting and big-eye effects, increased forehead adjustment, chin adjustment, thin nose, and mouth shape adjustment. 4 face_shape is set to 4 to enable fine face adjustment. FULiveDemo can be selected from the face. Define to turn on fine face adjustment.

__Instructions__：

- loading face_beautification.bundle
- setting the following parameter:
  `face_shape`: 4,   // 4 is enable advance function，0～3 is basic function

**Face-lifting**

Optimize the effect, more natural than before

__Instructions__：

- loading face_beautification.bundle
- setting the following parameter:
  `face_shap`e: 4,   // 4 is enable advance function，0～3 is basic function
  `cheek_thinning`: 0.0,   // Use the original parameter cheek_thinning to control face-lifting, range 0 - 1, default 0.0

**Eye Brighten**

Optimize eye brighten effect , more natural than before

__Instructions__：

- loading face_beautification.bundle
- setting the following parameter:
  `face_shape`: 4,   // 4 is enable advance function，0～3 is basic function
  `eye_enlarging`: 0.0,   // Use the original parameter eye_enlarging to control large eyes, range 0 - 1, default 0.5

**Forehead adjustment**

A new beauty prop that can adjust the forehead size

__Instructions__：

- loading face_beautification.bundle
- setting the following parameter:
  `face_shape`: 4,   // 4 is enable advance function，0～3 is basic function
  `intensity_forehead`: 0.5,   // Greater than 0.5 becomes larger, less than 0.5 becomes smaller, default is 0.5

**Chin adjustment**

A new beauty prop that can adjust the chin size

__Instructions__：

- loading face_beautification.bundle
- setting the following parameter:
  `face_shape`: 4,   // 4 is enable advance function，0～3 is basic function
  `intensity_chin`: 0.5,   // Greater than 0.5 becomes larger, less than 0.5 becomes smaller, default is 0.5

**Thin nose**

A new beauty prop that can adjust the thin size

__Instructions__：

- loading face_beautification.bundle
- setting the following parameter:
  `face_shape`: 4,   //4 is enable advance function，0～3 is basic function
  `intensity_nose`: 0.0,   // 0 is the normal size, greater than 0 starts thin nose, range 0 - 1, default 0.0

**Mouth adjustment**

A new beauty prop that can adjust the mouth size

__Instructions__：

- loading face_beautification.bundle
- setting the following parameter:
  `face_shape`: 4,   // 4 is enable advance function，0～3 is basic function
  `intensity_mouth`: 0.5,   // Greater than 0.5 becomes larger, less than 0.5 becomes smaller, default is 0.5

------

### 4.2 Gesture Recognition

Gesture recognition function is realized by loading prop item as well currently. Gesture recognition prop items cotain gesture to be recognized, animation effect triggered when gesture recognized and control script. Loading process is same with that of common prop items and face beautification prop item.

In LiveDemo heart_v2.bundle is love heart gesture demo prop item. Load it as prop item to render shall enable gesture recognition function. Gesture recognition prop item can exist with common and face beautification prop item at the same time, just like expand mItemsArray to three in face beautification and load gesture recognition prop item at last.

Process of customize gesture prop is same  with that of 2D prop item, please contact Faceunity technical support for details.

Note: Some of the new version of the gesture props need to use the non-lite version of the SDK in order to use normally.

__Instructions__：

Load the gesture item itemName and save it to the handle array items

```objective-c
NSString *path = [[NSBundle mainBundle] pathForResource:[itemName stringByAppendingString:@".bundle"] ofType:nil];
int itemHandle = [FURenderer itemWithContentsOfFile:path];
```

The gesture prop with gravity sensing direction needs to set the rotMode parameter to the gravity direction of the device, and the value is (0 ~ 3);

```objective-c
[FURenderer itemSetParam:itemHandle withName:@"rotMode" value:@(0)];
```

------

### 4.3 3D Render Anti-Aliasing Function

High efficient full screen anti-aliasing, makes 3D render effect smoother.

Load anti-aliased props and save them to the handle array items

```objective-c
NSString *path = [[NSBundle mainBundle] pathForResource:@"fxaa.bundle" ofType:nil];
int itemHandle = [FURenderer itemWithContentsOfFile:path];
```

------

### 4.4 Dynamic Portrait Function

- Instructions:
  - Load corresponding prop item directly
  - Certificate that possess Dynamic Portrait privilege is needed

```objective-c
NSString *path = [[NSBundle mainBundle] pathForResource:[itemName stringByAppendingString:@".bundle"] ofType:nil];
int itemHandle = [FURenderer itemWithContentsOfFile:path];
```

------

### 4.5 Face Warp Function

```objective-c
NSString *path = [[NSBundle mainBundle] pathForResource:[itemName stringByAppendingString:@".bundle"] ofType:nil];
int itemHandle = [FURenderer itemWithContentsOfFile:path];
```

------

### 4.6 Music Filter

Load the music filter item itemName and save it to the handle array items

```objective-c
NSString *path = [[NSBundle mainBundle] pathForResource:[itemName stringByAppendingString:@".bundle"] ofType:nil];
int itemHandle = [FURenderer itemWithContentsOfFile:path];
```

The filter can be play together by setting the play time with the music.

```objective-c
 [FURenderer itemSetParam:items[FUNamaHandleTypeItem] withName:@"music_time" value:@([FUMusicPlayer sharePlayer].currentTime * 1000 + 50)];//Need to add 50ms delay
```

------

### 4.7 Avatar Pinch function

After loading the prepared pinch props, you can set the following parameters to pinch the face.

#### Enter the pinch state

```C
//Enter the pinch state
fuItemSetParamd(1,"enter_facepup",1)
```

#### Clear all pinch parameters

```C
//Clear all pinch parameters
fuItemSetParamd(1,"clear_facepup",1)
```

#### Set the pinch parameter

```C
//Set the weight of the first pinch attribute "big eye", the range [0-1]. param corresponds to the first pinch face attribute here, starting from 1.
fuItemSetParamd(1,"\{\"name\":\"facepup\",\"param\":\"1\"\}",1);

//Set the weight of the second pinch attribute "tip chin", range [0-1]. param corresponds to the first pinch face attribute here, starting from 1
fuItemSetParamd(1,"\{\"name\":\"facepup\",\"param\":\"2\"\}",0.5);
```

**Save or Exit **

Choose one of the two

```C
//1. Directly exit the pinch state, do not save the current pinch state, and enter the tracking state. Use the last pinch face to track facial expressions.
fuItemSetParamd(1,"quit_facepup",1)
//2. Trigger to save the pinch face, and exit the pinch state, enter the tracking state. Time-consuming operation, set if necessary.
fuItemSetParamd(1,"need_recompute_facepup",1);
```

------

### 4.8 Comic Filter + Animoji in AR Mode

#### 4.8.1 Animoji

Load the Animoji item itemName and save it to the handle array items

```objective-c
NSString *path = [[NSBundle mainBundle] pathForResource:[itemName stringByAppendingString:@".bundle"] ofType:nil];
int itemHandle = [FURenderer itemWithContentsOfFile:path];
```

Animoji does not track face position when rendering by default, but can turn on tracking and background image display by turning on AR mode:

```objective-c
[FURenderer itemSetParam:itemHandle withName:@"{\"thing\":\"<global>\",\"param\":\"follow\"}" value:@(1)];
```

The mirror related parameter value is (0 or 1):

```objective-c
[FURenderer itemSetParam:itemHandle withName:@"is3DFlipH" value:@(1)];
[FURenderer itemSetParam:itemHandle withName:@"isFlipExpr" value:@(1)];
[FURenderer itemSetParam:itemHandle withName:@"isFlipTrack" value:@(1)];
[FURenderer itemSetParam:itemHandle withName:@"isFlipLight" value:@(1)];
```

#### 4.8.2 Comic Filter

Load the anime filter item itemName and save it to the handle array items

```objective-c
NSString *path = [[NSBundle mainBundle] pathForResource:[itemName stringByAppendingString:@".bundle"] ofType:nil];
int itemHandle = [FURenderer itemWithContentsOfFile:path];
```

### 4.9 Tongue Driving

load the prop `tongue.bundle`,

```objective-c
NSData *tongueData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tongue.bundle" ofType:nil]];
int ret0 = fuLoadTongueModel((void *)tongueData.bytes, (int)tongueData.length) ;
```

### 4.10 Face Fusion

1.load the bundle

```objective-c
 (void)loadPoster
{
    if (items[FUNamaHandleTypeChangeface] != 0) {
        [FURenderer destroyItem:items[FUNamaHandleTypeChangeface]];
        items[FUNamaHandleTypeChangeface] = 0;
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:@"change_face.bundle" ofType:nil];
    items[FUNamaHandleTypeChangeface] = [FURenderer itemWithContentsOfFile:path];
}
```

2.Get photo and template face information, set to bundle

```objective-c
    /* photo */
fuItemSetParamd(items[FUNamaHandleTypeChangeface], "input_width", photoWidth);
fuItemSetParamd(items[FUNamaHandleTypeChangeface], "input_height", photoHeight);
//75 face point info
fuItemSetParamdv(items[FUNamaHandleTypeChangeface], "input_face_points", photo, 150);
//rgba data
fuCreateTexForItem(items[FUNamaHandleTypeChangeface], "tex_input", photoData, photoWidth, photoHeight);
    /* template */
fuItemSetParamd(items[FUNamaHandleTypeChangeface], "template_width", postersWidth);
fuItemSetParamd(items[FUNamaHandleTypeChangeface], "template_height", postersHeight);
//75 face point for template
fuItemSetParamdv(items[FUNamaHandleTypeChangeface], "template_face_points", poster, 150);
if (warpValue) {//Special template, set the curvature
     fuItemSetParamd(items[FUNamaHandleTypeChangeface], "warp_intensity",                 [warpValue doubleValue]);
}
//rgba data
fuCreateTexForItem(items[FUNamaHandleTypeChangeface], "tex_template", posterData, postersWidth, postersHeight);
```

3.merge

```objective-c
- (UIImage *)renderItemsToImage:(UIImage *)image{
    int postersWidth = (int)CGImageGetWidth(image.CGImage);
    int postersHeight = (int)CGImageGetHeight(image.CGImage);
    CFDataRef dataFromImageDataProvider = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
    GLubyte *imageData = (GLubyte *)CFDataGetBytePtr(dataFromImageDataProvider);
    
    [[FURenderer shareRenderer] renderItems:imageData inFormat:FU_FORMAT_RGBA_BUFFER outPtr:imageData outFormat:FU_FORMAT_RGBA_BUFFER width:postersWidth height:postersHeight frameId:frameID items:items itemCount:sizeof(items)/sizeof(int) flipx:YES];
    
    frameID++;
   
    image = [FUImageHelper convertBitmapRGBA8ToUIImage:imageData withWidth:postersWidth withHeight:postersHeight];
    CFRelease(dataFromImageDataProvider);
    
    return image;
}
```

Note: The image needs to be called multiple times to track the trackFace: inputData: width: height: to get the face 75 points accurately.

### 4.11 Make Up

[Make Up Parameter Specification](Make_Up_Parameter_Specification.md)

1.load the make up bundle

```objective-c
NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:@"bundle"];
items[FUNamaHandleTypeMakeup] = [FURenderer itemWithContentsOfFile:filePath];
fuItemSetParamd(items[FUNamaHandleTypeMakeup], "makeup_lip_mask", 1.0);//optimized lipstick effect
[[FUManager shareManager] setMakeupItemIntensity:0 param:@"makeup_intensity_lip"];//Lipstick set to 0
```

2.Lipstick value setting, lipData double precision rgba array Column: double lipData[4] = {0,0,0,0};

```
fuItemSetParamdv(items[FUNamaHandleTypeMakeup], "makeup_lip_color", lipData, 4);
```

3.Set the facial features, image: makeup image, paramStr: the corresponding parameter value of the makeup (can be understood as the parameter of the specified position)

```objective-c
int photoWidth = (int)CGImageGetWidth(image.CGImage);
int photoHeight = (int)CGImageGetHeight(image.CGImage);
unsigned char *imageData = [FUImageHelper getRGBAWithImage:image];
[[FURenderer shareRenderer] setUpCurrentContext];
fuItemSetParamd(items[FUNamaHandleTypeMakeup], "reverse_alpha", 1.0);
fuCreateTexForItem(items[FUNamaHandleTypeMakeup], (char *)[paramStr UTF8String], imageData, photoWidth, photoHeight);
```

4.Set the degree value, paramStr: the parameter value corresponding to the position of the makeup, the value is (0~1)

```objective-c
int res = fuItemSetParamd(items[FUNamaHandleTypeMakeup], (char *)[paramStr UTF8String],
```

refer to  FULiveDemo 

### 4.12 Hair Color

Load the hair item itemName and save it to the handle array items

```objective-c
NSString *path = [[NSBundle mainBundle] pathForResource:[itemName stringByAppendingString:@".bundle"] ofType:nil];
int itemHandle = [FURenderer itemWithContentsOfFile:path];
```

Color type setting, colorIndex (0~n)	

```objective-c
[FURenderer itemSetParam:items[FUNamaHandleTypeItem] withName:@"Index" value:@(colorIndex)]; 
```

Color development value, Strength value (0 ~ 1.0)

```objective-c
 [FURenderer itemSetParam:items[FUNamaHandleTypeItem] withName:@"Strength" value: @(strength)]; 
```

### 4.13 Light Makeup function

The Nama SDK supports texture and beauty features starting with 6.0.0.

The Light makeup is a more sophisticated and efficient beauty solution, which includes four modules: blur, beauty, filter and beauty. It provides 60+ sets of rich material library to support customers to switch styles and effects.

First load light_makeup.bundle, then set parameters such as blush, eye shadow, eyeliner, lipstick, etc.，and you can refer to our sample code in FULiveDemo.

------
##  
