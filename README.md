# FULiveDemo

FULiveDemo 是集成了 Faceunity 面部跟踪和虚拟道具及手势识别功能的Demo。

## SDK v4.6 更新

本次更新主要包含以下改动：

- 增强表情优化功能，在人脸快速转动时提高表情稳定性

具体更新内容可以到[这里](https://github.com/Faceunity/FULiveDemo/blob/dev/docs/FUNama%20SDK%20v4.6%20%E6%9B%B4%E6%96%B0%E6%96%87%E6%A1%A3.md)查看详细文档。

## 软件需求

### 一、支持平台

    iOS 8.0以上系统
  
### 二、开发环境

    Xcode 8或更高版本

## SDK集成

### 一、通过cocoapods集成

含有深度学习的版本：

	pod 'Nama', '4.6' #注意此版本目前为dev版
	
不含深度学习的版本（lite版）：
	
	pod 'Nama-lite', '4.6' #注意此版本目前为dev版

接下来执行：

	pod install
	
如果提示无法找到该版本，请尝试执行以下指令后再试：

	pod repo update 或 pod setup
	
### 二、通过 github 下载集成

含有深度学习的版本：[FaceUnity-SDK-iOS-v4.6-dev.zip](https://github.com/Faceunity/FULiveDemo/releases/download/v4.6-dev/FaceUnity-SDK-iOS-v4.6-dev.zip)
	
不含深度学习的版本（lite版）：[FaceUnity-SDK-iOS-v4.6-dev-lite.zip](https://github.com/Faceunity/FULiveDemo/releases/download/v4.6-dev/FaceUnity-SDK-iOS-v4.6-dev-lite.zip)

下载完成并解压后将库文件夹拖入到工程中，并勾选上 Copy items if needed，如图：

---
![](./screenshots/picture1.png)

然后在Build Phases → Link Binary With Libraries 中添加依赖库，这里需要添加 OpenGLES.framework、Accelerate.framework、CoreMedia.framework、AVFoundation.framework、stdc++.tbd 这几个依赖库，如果你使用的是lite版可以不添加 stdc++.tbd 依赖，如图：

---
![](./screenshots/picture2.png)

## 文件说明

### 一、头文件
  - authpack.h 证书文件，一般由我司通过邮箱发送给使用者
  - funama.h C接口头文件
  - FURenderer.h OC接口头文件
  
### 二、库文件
  - libnama.a 人脸跟踪及道具绘制核心静态库 
  
### 三、数据文件
  - v3.bundle 初始化必须的二进制文件 
  - face_beautification.bundle 我司美颜相关的二进制文件
  - items/*.bundle 该文件夹位于 FULiveDemo 的字文件夹中，这些 .bundle 文件是我司制作的特效贴纸文件，自定义特效贴纸制作的文档和工具请联系我司获取。

注：这些数据文件都是二进制数据，与扩展名无关。实际在app中使用时，打包在程序内或者从网络接口下载这些数据都是可行的，只要在相应的函数接口传入正确的文件路径即可。

## 初始化

### 一、获取证书

您需要拥有我司颁发的证书才能使用我们的SDK的功能，获取证书方法：1、拨打电话 **0571-89774660** 2、发送邮件至 **marketing@faceunity.com** 进行咨询。

### 二、初始化FURenderer

初始化接口：

    - (void)setupWithDataPath:(NSString *)v3path 
                  authPackage:(void *)package 
                     authSize:(int)size 
          shouldCreateContext:(BOOL)create;

参数说明：

`v3path` v3.bundle 文件路径

`package` 密钥数组，必须配置好密钥，SDK才能正常工作

`size` 密钥数组大小

`create` 如果设置为YES，我们会在内部创建并持有一个context，此时必须使用OC层接口

调用示例：

首先在代码中引入 FURenderer.h 头文件

```C
#import "FURenderer.h"
```
然后执行初始化

```C
NSString *v3Path = [[NSBundle mainBundle] pathForResource:@"v3" ofType:@"bundle"];
    
[[FURenderer shareRenderer] setupWithDataPath:v3Path authPackage:g_auth_package authSize:sizeof(g_auth_package) shouldCreateContext:YES];
```
注：app启动后只需要setup一次FURenderer即可，其中 g_auth_package 密钥数组声明在 authpack.h 中。

至此，工程的配置及 SDK 的初始化工作已全部完成，下面就可以通过我们的 SDK 进行视频处理了！


## 视频处理
处理视频之前，首先需要创建道具句柄，然后将视频图像数据及道具句柄一同传入我们的绘制接口，处理完成之后道具中的特效就被绘制到图像中了。

### 一、创建道具句柄：
---
创建道具句柄接口：

```C
+ (int)itemWithContentsOfFile:(NSString *)path
```
参数说明：

`path` 道具路径

返回值：

`int` 道具句柄

在实际应用中有时需要同时使用多个道具，我们的图像处理接口接受的的参数是一个包含多个道具句柄的int数组，所以我们需要将创建一个int数组来保存这些道具句柄。下面我们将创建一个花环道具的句柄并保存在int数组的第0位，示例如下：

```C
int items[3];

NSString *path = [[NSBundle mainBundle] pathForResource:@"tiara" ofType:@"bundle"];

int itemHandle = [FURenderer itemWithContentsOfFile:path];

items[0] = itemHandle;
```

### 二、视频图像处理：

图像处理接口：

    - (CVPixelBufferRef)renderPixelBuffer:(CVPixelBufferRef)pixelBuffer
                          	  withFrameId:(int)frameid
                                    items:(int*)items
							    itemCount:(int)itemCount
                                    flipx:(BOOL)flip;

参数说明：

`pixelBuffer ` 图像数据，支持的格式为：BGRA、YUV420SP

`frameid ` 当前处理的视频帧序数，每次处理完对其进行加1操作，不加1将无法驱动道具中的特效动画

`items ` 包含多个道具句柄的int数组

`itemCount ` 句柄数组中包含的句柄个数

`flip ` 道具镜像使能，如果设置为YES可以将道具做镜像操作

返回值：

`CVPixelBufferRef ` 被处理过的的图像数据

具体示例如下：

```C
CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
[[FURenderer shareRenderer] renderPixelBuffer:pixelBuffer withFrameId:frameID items:items itemCount:sizeof(items)/sizeof(int) flipx:YES];

frameID += 1;
```

### 三、道具销毁与切换：

#### 销毁单个道具：

```C
/**
销毁单个道具
 */
+ (void)destroyItem:(int)item;
```

参数说明：

`item ` 要销毁的道具句柄

该接口将释放传入的句柄所对应的资源，为保证编程的严谨性，在执行完该操作后请将该句柄置为0。示例如下：

```C
if (items[0] != 0) {
	[FURenderer destroyItem:items[0]];
}
items[0] = 0;
```

#### 销毁全部道具：

```C
/**
销毁所有道具
 */
+ (void)destroyAllItems;

```

该接口可以销毁全部道具句柄所对应的资源,同样在执行完该接口后请将所有句柄都置为0。示例如下：

```C
[FURenderer destroyAllItems];
    
for (int i = 0; i < sizeof(items) / sizeof(int); i++) {
	items[i] = 0;
}
```

#### 道具切换：
如果需要切换句柄数组中某一位的句柄时，需要先创建一个新的道具句柄，并将该句柄替换到句柄数组中需要被替换的位置上，最后再把被替换的句柄销毁掉。下面以替换句柄数组的第0位为例进行说明：

```C
    // 先创建再释放可以有效缓解切换道具卡顿问题
    NSString *path = [[NSBundle mainBundle] pathForResource:_demoBar.selectedItem ofType:@"bundle"];
    int itemHandle = [FURenderer itemWithContentsOfFile:path];
    
    if (items[0] != 0) {
        [FURenderer destroyItem:items[0]];
    }
    
    items[0] = itemHandle;
```

注意，如果这里先销毁了老的道具，再创建新的道具会可能出现卡顿的现象。

## 视频美颜

### 美颜处理
视频美颜配置方法与视频加特效道具类似，首先创建美颜道具句柄，并保存在句柄数组中:
  
```C
- (void)loadFilter
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"face_beautification" ofType:@"bundle"];
    items[1] = [FURenderer itemWithContentsOfFile:path];
}
```

在处理视频时，美颜道具句柄会通过句柄数组传入图像处理接口，处理完成后美颜效果将会被作用到图像中。示例如下：

```C
CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
[[FURenderer shareRenderer] renderPixelBuffer:pixelBuffer withFrameId:frameID items:items itemCount:sizeof(items)/sizeof(int) flipx:YES];

frameID += 1;
```

### 参数设置
美颜道具主要包含五个模块的内容，滤镜，美白和红润，磨皮，美型。每个模块都有默认效果，它们可以调节的参数如下。

### 一、滤镜

在目前版本中提供以下滤镜：

普通滤镜：

```objc
"origin", "delta", "electric", "slowlived", "tokyo", "warm"
```

美颜滤镜：

```objc
"ziran", "danya", "fennen", "qingxin", "hongrun"
```

其中 "origin" 为原图滤镜，其他滤镜属于风格化滤镜及美颜滤镜。滤镜由参数 filter_name 指定。切换滤镜时，通过 fuItemSetParams 设置美颜道具的参数，如下：

```C
//  Set item parameters - filter
[FURenderer itemSetParam:items[1] withName:@"filter_name" value:@"origin"];
```

另外滤镜开放了滤镜强度接口，具体可到[这里](https://github.com/Faceunity/FULiveDemo/blob/dev/docs/%E8%A7%86%E9%A2%91%E7%BE%8E%E9%A2%9C%E6%9B%B4%E6%96%B0.md)查看详细信息。

### 二、美白和红润

通过参数 color_level 来控制美白程度。该参数的推荐取值范围为[0, 1]，0为无效果，0.5为默认效果，大于1为继续增强效果。

设置参数的例子代码如下：

```C
//  Set item parameters - whiten
[FURenderer itemSetParam:items[1] withName:@"color_level" value:@(0.5)];
```

新版美颜新增红润调整功能。参数名为 red_level 来控制红润程度。使用方法基本与美白效果一样。该参数的推荐取值范围为[0, 1]，0为无效果，0.5为默认效果，大于1为继续增强效果。

### 三、磨皮

新版美颜中，控制磨皮的参数有两个：blur_level、use_old_blur。

参数 blur_level 指定磨皮程度。该参数的推荐取值范围为[0, 6]，0为无效果，对应7个不同的磨皮程度。

参数 use_old_blur 指定是否使用旧磨皮。该参数设置为0即使用新磨皮，设置为大于0即使用旧磨皮

设置参数的例子代码如下：

```C
//  Set item parameters - blur
[FURenderer itemSetParam:items[1] withName:@"blur_level" value:@(6.0)];

//  Set item parameters - use old blur
[FURenderer itemSetParam:items[1] withName:@"use_old_blur" value:@(1.0)];
```

### 四、美型

目前我们支持四种基本脸型：女神、网红、自然、默认。由参数 face_shape 指定：默认（3）、女神（0）、网红（1）、自然（2）。

```C
//  Set item parameters - shaping
[FURenderer itemSetParam:items[1] withName:@"face_shape" value:@(3.0)];
```

在上述四种基本脸型的基础上，我们提供了以下三个参数：face_shape_level、eye_enlarging、cheek_thinning。

参数 face_shape_level 用以控制变化到指定基础脸型的程度。该参数的取值范围为[0, 1]。0为无效果，即关闭美型，1为指定脸型。

若要关闭美型，可将 face_shape_level 设置为0。

```C
//  Set item parameters - shaping level
[FURenderer itemSetParam:items[1] withName:@"face_shape_level" value:@(1.0)];
```

参数 eye_enlarging 用以控制眼睛大小。此参数受参数 face_shape_level 影响。该参数的推荐取值范围为[0, 1]。大于1为继续增强效果。

```C
//  Set item parameters - eye enlarging level
[FURenderer itemSetParam:items[1] withName:@"eye_enlarging" value:@(1.0)];
```

参数 cheek_thinning 用以控制脸大小。此参数受参数 face_shape_level 影响。该参数的推荐取值范围为[0, 1]。大于1为继续增强效果。

```C
//  Set item parameters - cheek thinning level
[FURenderer itemSetParam:items[1] withName:@"cheek_thinning" value:@(1.0)];
```

### 五、平台相关

PC端的美颜，使用前必须将参数 is_opengl_es 设置为 0，移动端无需此操作：

```C
//  Set item parameters
fuItemSetParamd(g_items[1], "is_opengl_es", 0);
```

## 手势识别
目前我们的手势识别功能也是以道具的形式进行加载的。一个手势识别的道具中包含了要识别的手势、识别到该手势时触发的动效、及控制脚本。加载该道具的过程和加载普通道具、美颜道具的方法一致。

线上例子中 heart_v2.bundle 为爱心手势演示道具。将其作为道具加载进行绘制即可启用手势识别功能。手势识别道具可以和普通道具及美颜共存，类似美颜将手势道具句柄保存在items句柄数组即可。

自定义手势道具的流程和2D道具制作一致，具体打包的细节可以联系我司技术支持。

## 接口说明

**获取 FURenderer 单例接口：**

	+ (FURenderer *)shareRenderer;

接口说明：

+ 获取 FURenderer 单例

返回值：

`FURenderer ` FURenderer 单例

---
**初始化接口1：**

	- (void)setupWithData:(void *)data ardata:(void *)ardata authPackage:(void *)package authSize:(int)size;

接口说明：

+ 初始化 SDK，并对 SDK 进行授权，在调用其他接口前必须要先进行初始化。使用该接口进行初始化的话，需要在代码中配置 EAGLContext  环境，并且保证我们的接口是在同一个 EAGLContext 下调用的

参数说明：

`data` v3.bundle 对应的二进制数据地址

`ardata ` 该参数已废弃，传 NULL 即可

`package ` 密钥数组，必须配置好密钥， SDK 才能正常工作

`size` 密钥数组大小

---
**初始化接口2：**

	- (void)setupWithData:(void *)data ardata:(void *)ardata authPackage:(void *)package authSize:(int)size shouldCreateContext:(BOOL)shouldCreate;

接口说明：

+ 初始化 SDK，并对 SDK 进行授权，在调用其他接口前必须要先进行初始化。与 **初始化接口1** 相比此接口新增 shouldCreate 参数，如果传入YES我们将在内部创建并持有一个 EAGLContext，无需外部再创建 EAGLContext 环境。

参数说明：

`data` v3.bundle 对应的二进制数据地址

`ardata ` 该参数已废弃，传 NULL 即可

`package ` 密钥数组，必须配置好密钥， SDK 才能正常工作

`size` 密钥数组大小

`shouldCreate ` 如果设置为 YES ，我们会在内部创建并持有一个 EAGLContext，此时必须使用 FURenderer.h 内接口，不能再使用 funama.h 接口

---
**初始化接口3：**

	- (void)setupWithDataPath:(NSString *)v3path authPackage:(void *)package authSize:(int)size shouldCreateContext:(BOOL) shouldCreate;

接口说明：

+ 初始化 SDK ，并对 SDK 进行授权，在调用其他接口前必须要先进行初始化。与 **初始化接口2** 相比改为通过 v3.bundle 的文件路径进行初始化，并且删除了废弃的 ardata 参数。

参数说明：

`v3path ` v3.bundle 对应的文件路径

`package ` 密钥数组，必须配置好密钥，SDK 才能正常工作

`size` 密钥数组大小

`shouldCreate ` 如果设置为 YES，我们会在内部创建并持有一个 EAGLContext，此时必须使用 FURenderer.h 内接口，不能再使用 funama.h 接口

---
**视频处理接口1：**

	- (CVPixelBufferRef)renderPixelBuffer:(CVPixelBufferRef)pixelBuffer withFrameId:(int)frameid items:(int*)items itemCount:(int)itemCount;

接口说明：

+ 将 items 中的道具绘制到 pixelBuffer 中

参数说明：

`pixelBuffer ` 图像数据，支持的格式为：BGRA、YUV420SP

`frameid ` 当前处理的视频帧序数，每次处理完对其进行加 1 操作，不加 1 将无法驱动道具中的特效动画

`items ` 包含多个道具句柄的 int 数组，包括普通道具、美颜道具、手势道具等

`itemCount ` 句柄数组中包含的句柄个数

返回值：

`CVPixelBufferRef ` 被处理过的的图像数据，与传入的 pixelBuffer 为同一个 pixelBuffer

---
**视频处理接口2：**

	- (CVPixelBufferRef)renderPixelBuffer:(CVPixelBufferRef)pixelBuffer
                          withFrameId:(int)frameid
                                items:(int*)items 
                            itemCount:(int)itemCount
                                flipx:(BOOL)flip;

接口说明：

+ 将 items 中的道具绘制到 pixelBuffer 中，与 **视频处理接口1** 相比新增 flip 参数，将该参数设置为 YES 可使道具做水平镜像翻转

参数说明：

`pixelBuffer ` 图像数据，支持的格式为：BGRA、YUV420SP

`frameid ` 当前处理的视频帧序数，每次处理完对其进行加 1 操作，不加 1 将无法驱动道具中的特效动画

`items ` 包含多个道具句柄的 int 数组

`itemCount ` 句柄数组中包含的句柄个数

`flip ` 道具镜像使能，如果设置为 YES 可以将道具做镜像操作

返回值：

`CVPixelBufferRef ` 被处理过的的图像数据，与传入的 pixelBuffer 为同一个 pixelBuffer

---
**视频处理接口3：**

	- (CVPixelBufferRef)renderToInternalPixelBuffer:(CVPixelBufferRef)pixelBuffer withFrameId:(int)frameid items:(int*)items itemCount:(int)itemCount;

接口说明：

+ 将 items 中的道具绘制到一个新的 pixelBuffer 中，输出与输入不是同一个 pixelBuffer

参数说明：

`pixelBuffer ` 图像数据，支持的格式为：BGRA、YUV420SP

`frameid ` 当前处理的视频帧序数，每次处理完对其进行加 1 操作，不加 1 将无法驱动道具中的特效动画

`items ` 包含多个道具句柄的 int 数组，包括普通道具、美颜道具、手势道具等

`itemCount ` 句柄数组中包含的句柄个数

返回值：

`CVPixelBufferRef ` 被处理过的的图像数据，与传入的 pixelBuffer 不是同一个 pixelBuffer

---
**视频处理接口4：**

	- (FUOutput)renderPixelBuffer:(CVPixelBufferRef)pixelBuffer bgraTexture:(GLuint)textureHandle withFrameId:(int)frameid items:(int *)items itemCount:(int)itemCount;

接口说明：

+ 将 items 中的道具绘制到 textureHandle 及 pixelBuffer 中，该接口适用于可同时输入 GLES texture 及 pixelBuffer 的用户，这里的 pixelBuffer 主要用于 CPU 上的人脸检测，如果只有 GLES texture 此接口将无法工作。

参数说明：

`pixelBuffer ` 图像数据，支持的格式为：BGRA、YUV420SP，用于人脸识别

`textureHandle ` 用户当前 EAGLContext 下的 textureID，用于图像处理

`frameid ` 当前处理的视频帧序数，每次处理完对其进行加 1 操作，不加 1 将无法驱动道具中的特效动画

`items ` 包含多个道具句柄的 int 数组，包括普通道具、美颜道具、手势道具等

`itemCount ` 句柄数组中包含的句柄个数

返回值：

`FUOutput ` 被处理过的的图像数据， FUOutput 的定义如下：

	typedef struct{
	    CVPixelBufferRef pixelBuffer;
	    GLuint bgraTextureHandle;
	}FUOutput;

---
**视频处理接口5：**

	- (FUOutput)renderPixelBuffer:(CVPixelBufferRef)pixelBuffer bgraTexture:(GLuint)textureHandle withFrameId:(int)frameid items:(int *)items itemCount:(int)itemCount flipx:(BOOL)flip;

接口说明：

+ 将items中的道具绘制到 textureHandle 及 pixelBuffer 中，与 **视频处理接口4** 相比新增 flip 参数，将该参数设置为 YES 可使道具做水平镜像翻转。

参数说明：

`pixelBuffer ` 图像数据，支持的格式为：BGRA、YUV420SP，用于人脸识别

`textureHandle ` 用户当前 EAGLContext 下的 textureID，用于图像处理

`frameid ` 当前处理的视频帧序数，每次处理完对其进行加 1 操作，不加 1 将无法驱动道具中的特效动画

`items ` 包含多个道具句柄的int数组，包括普通道具、美颜道具、手势道具等

`itemCount ` 句柄数组中包含的句柄个数

`flip ` 道具镜像使能，如果设置为 YES 可以将道具做镜像操作

返回值：

`FUOutput ` 被处理过的的图像数据， FUOutput 的定义如下：

	typedef struct{
	    CVPixelBufferRef pixelBuffer;
	    GLuint bgraTextureHandle;
	}FUOutput;

---
**视频处理接口6：**

	- (CVPixelBufferRef)beautifyPixelBuffer:(CVPixelBufferRef)pixelBuffer withBeautyItem:(int)item;

接口说明：

+ 该接口不包含人脸检测功能，只能对图像做美白、红润、滤镜、磨皮操作，不包含瘦脸及大眼等美型功能。

参数说明：

`pixelBuffer ` 图像数据，支持的格式为：BGRA、YUV420SP

`item ` 美颜道具句柄

返回值：

`CVPixelBufferRef ` 被处理过的的图像数据

---
**视频处理接口7：**

	- (void)renderFrame:(uint8_t*)y u:(uint8_t*)u v:(uint8_t*)v ystride:(int)ystride ustride:(int)ustride vstride:(int)vstride width:(int)width height:(int)height frameId:(int)frameid items:(int *)items itemCount:(int)itemCount;

接口说明：

+ 将 items 中的道具绘制到 YUV420P 图像中

参数说明：

`y ` Y帧图像地址

`u ` U帧图像地址

`v ` V帧图像地址

`ystride ` Y帧stride

`ustride ` U帧stride

`vstride ` V帧stride

`width ` 图像宽度

`height ` 图像高度

`frameid ` 当前处理的视频帧序数，每次处理完对其进行加 1 操作，不加 1 将无法驱动道具中的特效动画

`items ` 包含多个道具句柄的 int 数组，包括普通道具、美颜道具、手势道具等

`itemCount ` 句柄数组中包含的句柄个数

---
**视频处理接口8：**

	- (void)renderFrame:(uint8_t*)y u:(uint8_t*)u v:(uint8_t*)v ystride:(int)ystride ustride:(int)ustride vstride:(int)vstride width:(int)width height:(int)height frameId:(int)frameid items:(int *)items itemCount:(int)itemCount flipx:(BOOL)flip;

接口说明：

+ 将 items 中的道具绘制到 YUV420P 图像中，与 **视频处理接口7** 相比新增 flip 参数，将该参数设置为 YES 可使道具做水平镜像翻转

参数说明：

`y ` Y帧图像地址

`u ` U帧图像地址

`v ` V帧图像地址

`ystride ` Y帧stride

`ustride ` U帧stride

`vstride ` V帧stride

`width ` 图像宽度

`height ` 图像高度

`frameid ` 当前处理的视频帧序数，每次处理完对其进行加 1 操作，不加 1 将无法驱动道具中的特效动画

`items ` 包含多个道具句柄的 int 数组，包括普通道具、美颜道具、手势道具等

`itemCount ` 句柄数组中包含的句柄个数

`flip ` 道具镜像使能，如果设置为 YES 可以将道具做镜像操作

---
**切换摄像头时需调用的接口：**
 
	+ (void)onCameraChange;
	
接口说明：

+ 切换摄像头时需要调用该接口，我们会在内部重置人脸检测的一些状态

---
**通过道具二进制文件创建道具接口：**
 
	+ (int)createItemFromPackage:(void*)data size:(int)size;

接口说明：

+ 通过道具二进制文件创建道具句柄

参数说明：

`data ` 道具二进制文件

`size ` 文件大小

返回值：

`int ` 创建的道具句柄

---
**通过道具文件路径创建道具接口：**

	+ (int)itemWithContentsOfFile:(NSString *)path;
	
接口说明：

+ 通过道具文件路径创建道具句柄

参数说明：

`path ` 道具文件路径

返回值：

`int ` 创建的道具句柄

---
**销毁单个道具接口：**
 
	+ (void)destroyItem:(int)item;
	
接口说明：

+ 通过道具句柄销毁道具，并释放相关资源，销毁道具后请将道具句柄设为 0 ，以避免 SDK 使用无效的句柄而导致程序出错。

参数说明：

`item ` 道具句柄

---
**销毁所有道具接口：**
 
	+ (void)destroyAllItems;

接口说明：

+ 销毁全部道具，并释放相关资源，销毁道具后请将道具句柄数组中的句柄设为 0 ，以避免 SDK 使用无效的句柄而导致程序出错。

---
**为道具设置参数接口：**

	+ (int)itemSetParam:(int)item withName:(NSString *)name value:(id)value;

接口说明：

+ 为道具设置参数

参数说明：

`item ` 道具句柄

`name ` 参数名

`value ` 参数值：只支持 NSString 、 NSNumber 两种数据类型

返回值：

`int ` 执行结果：返回 0 代表设置失败，大于 0 表示设置成功

---
**从道具中获取 double 型参数值接口：**
 
	+ (double)getDoubleParamFromItem:(int)item withName:(NSString *)name

接口说明：

+ 从道具中获取 double 型参数值

参数说明：

`item ` 道具句柄

`name ` 参数名

返回值：

`double ` 参数值

---
**从道具中获取 NSString 型参数值接口：**

	+ (NSString *)getStringParamFromItem:(int)item withName:(NSString *)name

接口说明：

+ 从道具中获取 NSString 型参数值

参数说明：

`item ` 道具句柄

`name ` 参数名

返回值：

`NSString ` 参数值

---
**判断是否检测到人脸接口：**

	+ (int)isTracking;

接口说明：

+ 判断是否检测到人脸

返回值：

`int ` 检测到的人脸个数，返回 0 代表没有检测到人脸

---
**开启多人检测模式接口：**
 
	+ (int)setMaxFaces:(int)maxFaces;

接口说明：

+ 开启多人检测模式，最多可同时检测 8 张人脸

参数说明：

`maxFaces ` 设置多人模式开启的人脸个数，最多支持 8 个

返回值：

`int ` 上一次设置的人脸个数

---
**人脸信息跟踪接口：**

	+ (int)trackFace:(int)inputFormat inputData:(void*)inputData width:(int)width height:(int)height;

接口说明：

+ 该接口只对人脸进行检测，如果程序中没有运行过视频处理接口( **视频处理接口6** 除外)，则需要先执行完该接口才能使用 **获取人脸信息接口** 来获取人脸信息

参数说明：

`inputFormat ` 输入图像格式：`FU_FORMAT_BGRA_BUFFER` 或 `FU_FORMAT_NV12_BUFFER`

`inputData ` 输入的图像 bytes 地址

`width ` 图像宽度

`height ` 图像高度 

返回值：

`int ` 检测到的人脸个数，返回 0 代表没有检测到人脸

---
**获取人脸信息接口：**
 
	+ (int)getFaceInfo:(int)faceId name:(NSString *)name pret:(float *)pret number:(int)number;

接口说明：

+ 在程序中需要先运行过视频处理接口( **视频处理接口6** 除外)或 **人脸信息跟踪接口** 后才能使用该接口来获取人脸信息；
+ 该接口能获取到的人脸信息与我司颁发的证书有关，普通证书无法通过该接口获取到人脸信息；
+ 什么证书能获取到人脸信息？能获取到哪些人脸信息？请看下方：

```C
	landmarks: 2D人脸特征点，返回值为75个二维坐标，长度75*2
	证书要求: LANDMARK证书、AVATAR证书
	 
	landmarks_ar: 3D人脸特征点，返回值为75个三维坐标，长度75*3
	证书要求: AVATAR证书
	 
	rotation: 人脸三维旋转，返回值为旋转四元数，长度4
	证书要求: LANDMARK证书、AVATAR证书
	 
	translation: 人脸三维位移，返回值一个三维向量，长度3
	证书要求: LANDMARK证书、AVATAR证书
	 
	eye_rotation: 眼球旋转，返回值为旋转四元数,长度4
	证书要求: LANDMARK证书、AVATAR证书         
	 
	rotation_raw: 人脸三维旋转（不考虑屏幕方向），返回值为旋转四元数，长度4
	证书要求: LANDMARK证书、AVATAR证书
	 
	expression: 表情系数，长度46
	证书要求: AVATAR证书
	 
	projection_matrix: 投影矩阵，长度16
	证书要求: AVATAR证书
	 
	face_rect: 人脸矩形框，返回值为(xmin,ymin,xmax,ymax)，长度4
	证书要求: LANDMARK证书、AVATAR证书
	 
	rotation_mode: 人脸朝向，0-3分别对应手机四种朝向，长度1
	证书要求: LANDMARK证书、AVATAR证书
```

参数说明：

`faceId ` 被检测的人脸 ID ，未开启多人检测时传 0 ，表示检测第一个人的人脸信息；当开启多人检测时，其取值范围为 [0 ~ maxFaces-1] ，取其中第几个值就代表检测第几个人的人脸信息

`name ` 人脸信息参数名： "landmarks" , "eye_rotation" , "translation" , "rotation" ....

`pret ` 作为容器使用的 float 数组指针，获取到的人脸信息会被直接写入该 float 数组。

`number ` float 数组的长度

返回值

`int ` 返回 1 代表获取成功，返回 0 代表获取失败

---
**将普通道具绑定到avatar道具的接口：**
 
	+ (int)avatarBindItems:(int)avatarItem items:(int *)items itemsCount:(int)itemsCount contracts:(int *)contracts contractsCount:(int)contractsCount;

接口说明：

+ 该接口主要应用于 P2A 项目中，将普通道具绑定到 avatar 道具上，从而实现道具间的数据共享，在视频处理时只需要传入 avatar 道具句柄，普通道具也会和 avatar 一起被绘制出来。
+ 普通道具又分免费版和收费版，免费版有免费版对应的 contract 文件，收费版有收费版对应的文件，当绑定时需要同时传入这些 contracts 文件才能绑定成功。注： contract 的创建和普通道具创建方法一致

参数说明：

`avatarItem ` avatar 道具句柄

`items ` 需要被绑定到 avatar 道具上的普通道具的句柄数组

`itemsCount ` 句柄数组包含的道具句柄个数

`contracts ` contract 道具的句柄数组

`contractsCount ` contracts 数组中 contract 道具句柄的个数

返回值：

`int ` 被绑定到 avatar 道具上的普通道具个数

---
**将普通道具从avatar道具上解绑的接口：**
 
	+ (int)avatarUnbindItems:(int)avatarItem items:(int *)items itemsCount:(int)itemsCount;

接口说明：

+ 该接口可以将普通道具从 avatar 道具上解绑，主要应用场景为切换道具或去掉某个道具

参数说明：

`avatarItem ` avatar 道具句柄

`items ` 需要从 avatar 道具上的解除绑定的普通道具的句柄数组

`itemsCount ` 句柄数组包含的道具句柄个数

返回值：

`int ` 从 avatar 道具上解除绑定的普通道具个数

---
**绑定道具接口：**

	+ (int)bindItems:(int)item items:(int*)items itemsCount:(int)itemsCount;

接口说明：

+ 该接口可以将一些普通道具绑定到某个目标道具上，从而实现道具间的数据共享，在视频处理时只需要传入该目标道具句柄即可

参数说明：

`item ` 目标道具句柄

`items `  需要被绑定到目标道具上的其他道具的句柄数组

`itemsCount ` 句柄数组包含的道具句柄个数

返回值：

`int ` 被绑定到目标道具上的普通道具个数

---
**解绑所有道具接口：**

	+ (int)unbindAllItems:(int)item;

接口说明：

+ 该接口可以解绑绑定在目标道具上的全部道具

参数说明：

`item` 目标道具句柄

返回值：

`int ` 从目标道具上解除绑定的普通道具个数

---
**获取 SDK 版本信息接口：**

	+ (NSString *)getVersion;

接口说明：

+ 获取当前 SDK 版本号

返回值：

`NSString ` 版本信息

----

## 鉴权

我们的系统通过标准TLS证书进行鉴权。客户在使用时先从发证机构申请证书，之后将证书数据写在客户端代码中，客户端运行时发回我司服务器进行验证。在证书有效期内，可以正常使用库函数所提供的各种功能。没有证书或者证书失效等鉴权失败的情况会限制库函数的功能，在开始运行一段时间后自动终止。

证书类型分为**两种**，分别为**发证机构证书**和**终端用户证书**。

#### - 发证机构证书
**适用对象**：此类证书适合需批量生成终端证书的机构或公司，比如软件代理商，大客户等。

发证机构的二级CA证书必须由我司颁发，具体流程如下。

1. 机构生成私钥
机构调用以下命令在本地生成私钥 CERT_NAME.key ，其中 CERT_NAME 为机构名称。
```
openssl ecparam -name prime256v1 -genkey -out CERT_NAME.key
```

2. 机构根据私钥生成证书签发请求
机构根据本地生成的私钥，调用以下命令生成证书签发请求 CERT_NAME.csr 。在生成证书签发请求的过程中注意在 Common Name 字段中填写机构的正式名称。
```
openssl req -new -sha256 -key CERT_NAME.key -out CERT_NAME.csr
```

3. 将证书签发请求发回我司颁发机构证书

之后发证机构就可以独立进行终端用户的证书发行工作，不再需要我司的配合。

如果需要在终端用户证书有效期内终止证书，可以由机构自行用OpenSSL吊销，然后生成pem格式的吊销列表文件发给我们。例如如果要吊销先前误发的 "bad_client.crt"，可以如下操作：
```
openssl ca -config ca.conf -revoke bad_client.crt -keyfile CERT_NAME.key -cert CERT_NAME.crt
openssl ca -config ca.conf -gencrl -keyfile CERT_NAME.key -cert CERT_NAME.crt -out CERT_NAME.crl.pem
```
然后将生成的 CERT_NAME.crl.pem 发回给我司。

#### - 终端用户证书
**适用对象**：直接的终端证书使用者。比如，直接客户或个人等。

终端用户由我司或者其他发证机构颁发证书，并通过我司的证书工具生成一个代码头文件交给用户。该文件中是一个常量数组，内容是加密之后的证书数据，形式如下。
```
static char g_auth_package[]={ ... }
```

用户在库环境初始化时，需要提供该数组进行鉴权，具体参考 fuSetup 接口。没有证书、证书失效、网络连接失败等情况下，会造成鉴权失败，在控制台或者Android平台的log里面打出 "not authenticated" 信息，并在运行一段时间后停止渲染道具。

任何其他关于授权问题，请email：support@faceunity.com
