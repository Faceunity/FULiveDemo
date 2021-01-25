# iOS Nama Objective-C API 参考文档
级别：Public   
更新日期：2021-1-25   
SDK版本: 7.3.2  

------

### 最新更新内容：

**2021-1-25 v7.3.2:  **

更新内容  

- 优化人脸表情跟踪驱动性能。
- fuSetup 函数改为线程安全。
- fuSetUp 、fuCreateItemFromPackage、fuLoadAIModel函数增加异常处理，增强鲁棒性。
- 修复自定义哈哈镜功能效果问题。
- 修复SDK在Mac 10.11上crash问题。
- 修复SDK在贴纸和Animoji混用时crash问题。

------
### 目录：
本文档内容目录：

[TOC]

------
### 1. 简介 
本文是相芯人脸跟踪及视频特效开发包（以下简称 Nama SDK）的底层接口文档。该文档中的 Nama API 为底层 native 接口，可以直接用于 PC/iOS/Android NDK/Linux 上的开发。其中，iOS和Android平台上的开发可以利用SDK的应用层接口（Objective-C/Java），相比本文中的底层接口会更贴近平台相关的开发经验。

SDK相关的所有调用要求在同一个线程中顺序执行，不支持多线程。少数接口可以异步调用（如道具加载），会在备注中特别注明。SDK所有主线程调用的接口需要保持 OpenGL context 一致，否则会引发纹理数据异常。如果需要用到SDK的绘制功能，则主线程的所有调用需要预先初始化OpenGL环境，没有初始化或初始化不正确会导致崩溃。我们对OpenGL的环境要求为 GLES 2.0 以上。具体调用方式，可以参考各平台 demo。

底层接口根据作用逻辑归为六类：初始化、加载道具、主运行接口、销毁、功能接口、P2A相关接口。

**注意：**OC API 是对底层C API的封装，OC未包含的高级设置，参考C API文档

------
### 2. APIs
#### 2.1 初始化
##### setupWithData: dataSize: ardata: authPackage: authSize: 
初始化系统环境，加载系统数据，并进行网络鉴权。必须在调用SDK其他接口前执行，否则会引发崩溃。

```objective-c
- (void)setupWithData:(void *)data dataSize:(int)dataSize ardata:(void *)ardata authPackage:(void *)package authSize:(int)size;

```

__参数说明:__

*data*： 内存指针，v3.bundle 对应的二进制数据地址，nama 版本6.6.0后，初始化可以为__nil__

*dataSize*： v3.bundle文件字节数，不使用v3初始化时设置为0

*ardata*： 已废弃

*package*： 内存指针，指向鉴权数据的内容。如果是用包含 authpack.h 的方法在编译时提供鉴权数据，则这里可以写为 ```g_auth_package``` 。

*size*：鉴权数据的长度，以字节为单位。如果鉴权数据提供的是 authpack.h 中的 ```g_auth_package```，这里可写作 ```sizeof(g_auth_package)```

__返回值:__

返回非0值代表成功，返回0代表失败。如初始化失败，可以通过 ```fuGetSystemError``` 获取错误代码。

------

##### setupWithData: dataSize: ardata: authPackage: authSize: shouldCreateContext: 

初始化系统环境，加载系统数据，并进行网络鉴权。必须在调用SDK其他接口前执行，否则会引发崩溃。

```objective-c
- (void)setupWithData:(void *)data dataSize:(int)dataSize ardata:(void *)ardata authPackage:(void *)package authSize:(int)size shouldCreateContext:(BOOL)shouldCreate;
```

__参数:__

*data*： 内存指针，v3.bundle 对应的二进制数据地址，nama 版本6.6.0后，初始化可以为__nil__

*dataSize*：v3.bundle文件字节数，不使用v3初始化时设置为0

*ardata*： 已废弃

*package*： 内存指针，指向鉴权数据的内容。如果是用包含 authpack.h 的方法在编译时提供鉴权数据，则这里可以写为 ```g_auth_package``` 。

*size*：鉴权数据的长度，以字节为单位。如果鉴权数据提供的是 authpack.h 中的 ```g_auth_package```，这里可写作 ```sizeof(g_auth_package)```

*shouldCreate*: 如果设置为 YES，我们会在内部创建并持有一个 EAGLContext，OpenGL相关操作建议所用OC层接口 (**注：**OC接口会切换到内部创建的EAGLContext上执行，防止多EAGLContext异常问题)

__返回值:__

返回非0值代表成功，返回0代表失败。如初始化失败，可以通过 ```fuGetSystemError``` 获取错误代码。

------

##### setupWithDataPath: authPackage: authSize: shouldCreateContext: 

初始化系统环境，加载系统数据，并进行网络鉴权。必须在调用SDK其他接口前执行，否则会引发崩溃。

```objective-c
- (void)setupWithDataPath:(NSString *)v3path authPackage:(void *)package authSize:(int)size shouldCreateContext:(BOOL)shouldCreate;

```

__参数说明:__

*v3path*：  v3.bundle 对应的文件路径，nama 版本6.6.0后，初始化可以为__nil__

*package*： 内存指针，指向鉴权数据的内容。如果是用包含 authpack.h 的方法在编译时提供鉴权数据，则这里可以写为 ```g_auth_package``` 。

*size*：鉴权数据的长度，以字节为单位。如果鉴权数据提供的是 authpack.h 中的 ```g_auth_package```，这里可写作 ```sizeof(g_auth_package)```

*shouldCreate*：如果设置为 YES，我们会在内部创建并持有一个 EAGLContext，此时必须使用OC层接口

__返回值:__

返回非0值代表成功，返回0代表失败。如初始化失败，可以通过 ```fuGetSystemError``` 获取错误代码。

------

##### setupLocalWithV3Path:offLinePath:authPackage: authSize: shouldCreateContext:

```objective-c
- (NSData *)setupLocalWithV3Path:(NSString *)v3path offLinePath:(NSString *)offLinePath authPackage:(void *)package authSize:(int)size shouldCreateContext:(BOOL)shouldCreate;
```

__参数说明:__

*v3path*：  v3.bundle 对应的文件路径，nama 版本6.6.0后，初始化可以为__nil__

*offLinePath*:  offLineBundle.bundle 离线鉴权包路径

*package*： 内存指针，指向鉴权数据的内容。如果是用包含 authpack.h 的方法在编译时提供鉴权数据，则这里可以写为 ```g_auth_package``` 。

*size*：鉴权数据的长度，以字节为单位。如果鉴权数据提供的是 authpack.h 中的 ```g_auth_package```，这里可写作 ```sizeof(g_auth_package)```

*shouldCreate*：如果设置为 YES，我们会在内部创建并持有一个 EAGLContext，此时必须使用OC层接口

__返回值:__

鉴权成功后的文件

------

#### 2.2 加载&销毁道具包

加载道具包，使其可以在主运行接口中被执行。一个道具包可能是一个功能模块或者多个功能模块的集合，加载道具包可以在流水线中激活对应的功能模块，在同一套SDK调用逻辑中实现即插即用。

##### itemWithContentsOfFile： 

``` objective-c
+ (int)itemWithContentsOfFile:(NSString *)path
```

__参数说明:__

*path*： 道具文件路径。道具包通常以 \*.bundle 结尾。

__返回值:__

一个整数句柄，作为该道具在系统内的标识符。

__备注:__

该接口可以和主线程异步执行。为了降低加载道具阻塞主线程，建议异步调用该接口。

------

##### createItemFromPackage: size: 

加载道具包，使其可以在主运行接口中被执行。一个道具包可能是一个功能模块或者多个功能模块的集合，加载道具包可以在流水线中激活对应的功能模块，在同一套SDK调用逻辑中实现即插即用。

```objective-c
+ (int)createItemFromPackage:(void*)data size:(int)size
```

__参数说明:__

*data*： 道具二进制文件。道具包通常以 \*.bundle 结尾。

*size*： 文件大小。

__返回值:__

一个整数句柄，作为该道具在系统内的标识符。

------

##### destroyItem: 

 销毁单个道具：

​     \- 通过道具句柄销毁道具，并释放相关资源

​     \- 销毁道具后请将道具句柄设为 0 ，以避免 SDK 使用无效的句柄而导致程序出错。

```objective-c
+ (void)destroyItem:(int)item
```

__参数说明:__

*item*： 道具句柄。

------

##### destroyAllItems

销毁所有道具： 

​     \- 销毁全部道具，并释放相关资源

​     \- 销毁道具后请将道具句柄数组中的句柄设为 0 ，以避免 SDK 使用无效的句柄而导致程序出错。

```objective-c
+ (void)destroyAllItems;
```

------

##### onCameraChange

切换摄像头时需要调用该接口，我们会在内部重置人脸检测的一些状态

```objective-c
+ (void)onCameraChange;
```

------

##### OnDeviceLostSafe

特殊函数，当客户端调用代码存在逻辑BUG时，可能会导致OpenGL Context状态异常，此时OnDeviceLost无法成功释放GPU资源进而导致应用崩溃，若无法有效定位客户端BUG，可以使用本函数替代。本函数只负责释放CPU资源，对GPU资源不进行销毁操作，借由外部context的销毁统一维护。

```objective-c
+ (void)OnDeviceLostSafe;
```



------

##### OnDeviceLost

特殊函数，当程序退出或OpenGL context准备销毁时，调用该函数，会进行资源清理和回收，所有系统占用的内存资源会被释放，包括GL的GPU资源以及内存。

```objective-c
+ (void)OnDeviceLost;
```

------

#### 2.3 道具参数

修改或设定道具包中变量的值。可以支持的道具包变量名、含义、及取值范围需要参考道具的文档。

##### itemSetParam:  withName: value: 

为道具设置NSString 、 NSNumber类型参数：

```objective-c
+ (int)itemSetParam:(int)item withName:(NSString *)name value:(id)value;

```

__参数说明:__

*item*： 道具句柄，内容应为调用 ```itemWithContentsOfFile``` 函数的返回值，并且道具内容没有被销毁。

*name*：字符串指针，内容为要设定的道具变量名。

*value*：参数值：只支持 NSString 、 NSNumber 两种数据类型

__返回值:__

返回非0值代表成功，返回0代表失败。

------

##### itemSetParamdv: withName: value: length:

为道具设置double 数组参数

```objective-c
+ (int)itemSetParamdv:(int)item withName:(NSString *)name value:(double *)value length:(int)length;
```

__参数说明:__

*item*： 道具句柄，内容应为调用 ```itemWithContentsOfFile``` 函数的返回值，并且道具内容没有被销毁。

*name*：字符串指针，内容为要设定的道具变量名。

*value*：参数值：double 数组。

*length*：设定变量为double数组时，数组数据的长度，以double为单位。

__返回值:__

返回非0值代表成功，返回0代表失败。

-------

##### itemSetParamu8v: withName: buffer: size: 

为道具设置双精度数组参数

```objective-c
+ (int)itemSetParamu8v:(int)item withName:(NSString *)name buffer:(void *)buffer size:(int)size;
```

__参数说明:__

*item*： 道具句柄。

*name*：字符串指针，内容为要设定的道具变量名。

*buffer*：参数值指向一个双精度数组。

*size*：指定值中的元素数。

__返回值:__

返回非0值代表成功，返回0代表失败。

------

##### getStringParamFromItem:  withName:  

 从道具中获取 NSString 型参数值，

```objective-c
+ (NSString *)getStringParamFromItem:(int)item withName:(NSString *)name;
```

__参数说明:__

*item*： 道具句柄。

*name*：参数名。

__返回值:__

参数值。

------

##### getDoubleParamFromItem: withName:  

 从道具中获取 double 型参数值，

```objective-c
+ (double)getDoubleParamFromItem:(int)item withName:(NSString *)name
```

__参数说明:__

*item*： 道具句柄。

*name*：参数名。

__返回值:__

参数值。

------

##### getDoubleParamFromItem: withName:  

 从道具中获取 double 型参数值，

```objective-c
+ (int)itemGetParamu8v:(int)item withName:(NSString *)name buffer:(void *)buffer size:(int)size
```

__参数说明:__

*item*： 道具句柄。

*name*：参数名。

__返回值:__

参数值。

------

#### 2.4 视频图像处理 

视频图像处理接口，同时传入道具包和需要被处理的图像，即可为图像添加特效 

注意：该接口返回的 pixelBuffer 格式为BGRA，且处理后的图像也会回写到输入的 pixelBuffer。如果输入 YUV420SP 格式的 pixelBuffer，且希望结果也是 YUV420SP 格式的 pixelBuffer的话，则不需要使用返回的pixelBuffer，直接使用输入的 pixelBuffer 即可。

##### renderPixelBuffer: withFrameId: items: itemCount:

将 items 中的道具绘制到 pixelBuffer 中

```objective-c
- (CVPixelBufferRef)renderPixelBuffer:(CVPixelBufferRef)pixelBuffer withFrameId:(int)frameid items:(int*)items itemCount:(int)itemCount
```

__参数说明:__

*pixelBuffer*:  图像数据，支持的格式为：BGRA、YUV420SP

*frameid*:  当前处理的视频帧序数，每次处理完对其进行加1操作

*items* : 包含多个道具句柄的 int 数组，包括普通道具、美颜道具、手势道具等

*itemCount*:  句柄数组中包含的句柄个数

*size*:  道具镜像使能，如果设置为YES可以将道具做镜像操作

__返回值:__

被处理过的的图像数据，返回 nil 视频处理失败。

------

##### renderPixelBuffer: withFrameId: items: itemCount: flipx:

将 items 中的道具绘制到 pixelBuffer 中

```objective-c
- (CVPixelBufferRef)renderPixelBuffer:(CVPixelBufferRef)pixelBuffer withFrameId:(int)frameid items:(int*)items itemCount:(int)itemCount flipx:(BOOL)flip;
```

__参数说明:__

*pixelBuffer*:  图像数据，支持的格式为：BGRA、YUV420SP

*frameid*:  当前处理的视频帧序数，每次处理完对其进行加1操作，不加1将无法驱动道具中的特效动画

*items* : 包含多个道具句柄的int数组

*itemCount*:  句柄数组中包含的句柄个数

*flip*:  道具镜像使能，如果设置为YES可以将道具做镜像操作

__返回值:__

被处理过的的图像数据，返回 nil 视频处理失败。

------

##### renderPixelBuffer: withFrameId: items: itemCount: flipx: customSize:

可以自定义输出分辨率

```objective-c
- (CVPixelBufferRef)renderPixelBuffer:(CVPixelBufferRef)pixelBuffer withFrameId:(int)frameid items:(int*)items itemCount:(int)itemCount flipx:(BOOL)flip customSize:(CGSize)customSize;
```

__参数说明:__

*pixelBuffer*:  图像数据，支持的格式为：BGRA、YUV420SP

*frameid*:  当前处理的视频帧序数，每次处理完对其进行加1操作，不加1将无法驱动道具中的特效动画

*items* : 包含多个道具句柄的int数组

*itemCount*:  句柄数组中包含的句柄个数

*flip*:  道具镜像使能，如果设置为YES可以将道具做镜像操作

*customSize*: 自定义输出的分辨率，目前仅支持BGRA格式 

__返回值:__

被处理过的的图像数据，与传入的 pixelBuffer 为同一pixelBuffer。

------

##### renderPixelBuffer: withFrameId: items: itemCount: flipx: customSize: useAlpha:;

可以自定义输出分辨率

```objective-c
- (CVPixelBufferRef)renderPixelBuffer:(CVPixelBufferRef)pixelBuffer withFrameId:(int)frameid items:(int*)items itemCount:(int)itemCount flipx:(BOOL)flip customSize:(CGSize)customSize useAlpha:(BOOL)useAlpha;;
```

__参数说明:__

*pixelBuffer*:  图像数据，支持的格式为：BGRA、YUV420SP

*frameid*:  当前处理的视频帧序数，每次处理完对其进行加1操作，不加1将无法驱动道具中的特效动画

*items* : 包含多个道具句柄的int数组

*itemCount*:  句柄数组中包含的句柄个数

*flip*:  道具镜像使能，如果设置为YES可以将道具做镜像操作

*customSize*: 自定义输出的分辨率，目前仅支持BGRA格式 

*useAlpha*: 是否带道具透明通道，if  useAlpha = NO,RGBA 数据alpha 会被强制设置为1，其他视频处理接口皆为该模式

__返回值:__

被处理过的的图像数据，与传入的 pixelBuffer 为同一pixelBuffer。

------

##### renderToInternalPixelBuffer: withFrameId: items: itemCount:

将 items 中的道具绘制到一个新的 pixelBuffer 中，输出与输入不是同一个 pixelBuffer

```objective-c
- (CVPixelBufferRef)renderToInternalPixelBuffer:(CVPixelBufferRef)pixelBuffer withFrameId:(int)frameid items:(int*)items itemCount:(int)itemCount
```

__参数说明:__

*pixelBuffer*:  图像数据，支持的格式为：BGRA、YUV420SP

*frameid*:  当前处理的视频帧序数，每次处理完对其进行加1操作，不加1将无法驱动道具中的特效动画

*items* : 包含多个道具句柄的int数组

*itemCount*:  句柄数组中包含的句柄个数

__返回值:__

被处理过的的图像数据，返回 nil 视频处理失败

------

##### renderPixelBuffer: bgraTexture: withFrameId: items: itemCount:

​     \- 将 items 中的道具绘制到 textureHandle 及 pixelBuffer 中

​     \- 该接口适用于可同时输入 GLES texture 及 pixelBuffer 的用户，这里的 pixelBuffer 主要用于 CPU 上的人脸检测，如果只有 GLES texture 此接口将无法工作。

```objective-c
- (FUOutput)renderPixelBuffer:(CVPixelBufferRef)pixelBuffer bgraTexture:(GLuint)textureHandle withFrameId:(int)frameid items:(int *)items itemCount:(int)itemCount;
```

__参数说明:__

*pixelBuffer*:  图像数据，支持的格式为：BGRA、YUV420SP，用于人脸识别

*textureHandle*:  用户当前 EAGLContext 下的 textureID，用于图像处理

*frameid*:  当前处理的视频帧序数，每次处理完对其进行加1操作，不加1将无法驱动道具中的特效动画

*items* : 包含多个道具句柄的int数组

*itemCount*:  句柄数组中包含的句柄个数

__返回值:__

被处理过的的图像数据

------

##### renderPixelBuffer: bgraTexture: withFrameId: items: itemCount: flipx:

```objective-c
- (FUOutput)renderPixelBuffer:(CVPixelBufferRef)pixelBuffer bgraTexture:(GLuint)textureHandle withFrameId:(int)frameid items:(int *)items itemCount:(int)itemCount flipx:(BOOL)flip;
```

__参数说明:__

*pixelBuffer*:  图像数据，支持的格式为：BGRA、YUV420SP，用于人脸识别

*textureHandle*:  用户当前 EAGLContext 下的 textureID，用于图像处理

*frameid*:  当前处理的视频帧序数，每次处理完对其进行加1操作，不加1将无法驱动道具中的特效动画

*items* : 包含多个道具句柄的int数组

*flip*:  道具镜像使能，如果设置为YES可以将道具做镜像操作

__返回值:__

被处理过的的图像数据

------

##### renderPixelBuffer: bgraTexture: withFrameId: items: itemCount: flipx: customSize:

customSize 参数，可以自定义输出分辨率

```objective-c
- (FUOutput)renderPixelBuffer:(CVPixelBufferRef)pixelBuffer bgraTexture:(GLuint)textureHandle withFrameId:(int)frameid items:(int *)items itemCount:(int)itemCount flipx:(BOOL)flip customSize:(CGSize)customSize;
```

__参数说明:__

*pixelBuffer*:  图像数据，支持的格式为：BGRA、YUV420SP，用于人脸识别

*textureHandle*:  用户当前 EAGLContext 下的 textureID，用于图像处理

*frameid*:  当前处理的视频帧序数，每次处理完对其进行加1操作，不加1将无法驱动道具中的特效动画

*items* : 包含多个道具句柄的int数组

*flip*:  道具镜像使能，如果设置为YES可以将道具做镜像操作

*customSize*: 自定义输出的分辨率，目前仅支持BGRA格式

__返回值:__

被处理过的的图像数据

------

##### beautifyPixelBuffer: withBeautyItem:

该接口不包含人脸检测功能，只能对图像做美白、红润、滤镜、磨皮操作，不包含瘦脸及大眼等美型功能。

```objective-c
- (CVPixelBufferRef)beautifyPixelBuffer:(CVPixelBufferRef)pixelBuffer withBeautyItem:(int)item;
```

__参数说明:__

*pixelBuffer*:  图像数据，支持的格式为：BGRA、YUV420SP，用于人脸识别

*item*:  美颜道具句柄

__返回值:__

被处理过的的图像数据，返回 nil 视频处理失败

------

##### renderPixelBuffer: withFrameId: items: itemCount: flipx: masks:

新增 masks 参数，用来指定 items 中的道具画在多人中的哪一张脸上

```objective-c
- (CVPixelBufferRef)renderPixelBuffer:(CVPixelBufferRef)pixelBuffer withFrameId:(int)frameid items:(int*)items itemCount:(int)itemCount flipx:(BOOL)flip masks:(void*)masks;
```

__参数说明:__

*pixelBuffer*:  图像数据，支持的格式为：BGRA、YUV420SP，用于人脸识别

*frameid*:  当前处理的视频帧序数，每次处理完对其进行加1操作，不加1将无法驱动道具中的特效动画

*items* : 包含多个道具句柄的int数组

*flip*:  道具镜像使能，如果设置为YES可以将道具做镜像操作

*masks*: 指定items中的道具画在多张人脸中的哪一张脸上的 int 数组，其长度要与 items 长度一致，

​        masks中的每一位与items中的每一位道具一一对应。使用方法为：要使某一个道具画在检测到的第一张人脸上，

​        对应的int值为 "2的0次方"，画在第二张人脸上对应的int值为 “2的1次方”，第三张人脸对应的int值为 “2的2次方”，

​        以此类推。例：masks = {pow(2,0),pow(2,1),pow(2,2)....},值得注意的是美颜道具对应的int值为 0

__返回值:__

处理过的的图像数据，返回 nil 视频处理失败

------

##### renderFrame: u: v: ystride: ustride: vstride: width: height: frameId: items: itemCount:

```objective-c
- (void)renderFrame:(uint8_t*)y u:(uint8_t*)u v:(uint8_t*)v ystride:(int)ystride ustride:(int)ustride vstride:(int)vstride width:(int)width height:(int)height frameId:(int)frameid items:(int *)items itemCount:(int)itemCount;
```

__参数说明:__

*y*: Y帧图像地址

*u*: U帧图像地址

*v*: V帧图像地址

*ystride*: Y帧stride

*ustride*: U帧stride

*vstride*: V帧stride

*width*: 图像宽度

*height*: 图像高度

*frameid*: 当前处理的视频帧序数，每次处理完对其进行加 1 操作，不加 1 将无法驱动道具中的特效动画

*items*: 包含多个道具句柄的 int 数组，包括普通道具、美颜道具、手势道具等

*itemCount*: 句柄数组中包含的句柄个数

------

##### renderFrame: u: v: ystride: ustride: vstride: width: height: frameId: items: itemCount: flipx:

```objective-c
- (void)renderFrame:(uint8_t*)y u:(uint8_t*)u v:(uint8_t*)v ystride:(int)ystride ustride:(int)ustride vstride:(int)vstride width:(int)width height:(int)height frameId:(int)frameid items:(int *)items itemCount:(int)itemCount flipx:(BOOL)flip;
```

__参数说明:__

*y*: Y帧图像地址

*u*: U帧图像地址

*v*: V帧图像地址

*ystride*: Y帧stride

*ustride*: U帧stride

*vstride*: V帧stride

*width*: 图像宽度

*height*: 图像高度

*frameid*: 当前处理的视频帧序数，每次处理完对其进行加 1 操作，不加 1 将无法驱动道具中的特效动画

*items*: 包含多个道具句柄的 int 数组，包括普通道具、美颜道具、手势道具等

*itemCount*: 句柄数组中包含的句柄个数

*flip*: 道具镜像使能，如果设置为 YES 可以将道具做镜像操作 

------

#### 2.5 P2A 相关接口

##### ~~avatarBindItems: items: itemsCount: t contracts: contractsCount:~~ 

注：版本更新使用替换 **bindItems: items: itemsCount:** 

\- 该接口主要应用于 P2A 项目中，将普通道具绑定到 avatar 道具上，从而实现道具间的数据共享；

\- 在视频处理时只需要传入 avatar 道具句柄，普通道具也会和 avatar 一起被绘制出来。

\- 普通道具又分免费版和收费版，免费版有免费版对应的 contract 文件，收费版有收费版对应的 contract 文件，当绑定时需要同时传入这些 contracts 文件才能绑定成功。

**注意**： contract 的创建和普通道具创建方法一致

```objective-c
+ (int)avatarBindItems:(int)avatarItem items:(int *)items itemsCount:(int)itemsCount contracts:(int *)contracts contractsCount:(int)contractsCount
```

**参数说明：**

*avatarItem*:  avatar 道具句柄

*items*:   需要被绑定到 avatar 道具上的普通道具的句柄数组

*itemsCount*:   句柄数组包含的道具句柄个数

*contracts*:   contract 道具的句柄数组

*contractsCount*: contracts 数组中 contract 道具句柄的个数

**返回值：**

 被绑定到 avatar 道具上的普通道具个数

------

##### ~~avatarUnbindItems: items: itemsCount:~~

注：版本更新使用替换 **unBindItems: items: itemsCount:**

该接口可以将普通道具从 avatar 道具上解绑，主要应用场景为切换道具或去掉某个道具

```objective-c
+ (int)avatarUnbindItems:(int)avatarItem items:(int *)items itemsCount:(int)itemsCount
```

**参数说明：**

*avatarItem*:  avatar 道具句柄

*items*:   需要被绑定到 avatar 道具上的普通道具的句柄数组

*itemsCount*:   句柄数组包含的道具句柄个数

**返回值：**

从 avatar 道具上解除绑定的普通道具个数

------

##### bindItems: items: itemsCount:

该接口可以将一些普通道具绑定到某个目标道具上，从而实现道具间的数据共享，在视频处理时只需要传入该目标道具句柄即可

```objective-c
+ (int)bindItems:(int)item items:(int*)items itemsCount:(int)itemsCount
```

**参数说明：**

*item*:  目标道具句柄

*items*:   需要被绑定到目标道具上的其他道具的句柄数组

*itemsCount*:   句柄数组包含的道具句柄个数

**返回值：**

被绑定到目标道具上的普通道具个数

------

##### unBindItems: items: itemsCount:

 该接口可以将一些普通道具从某个目标道具上解绑

```objective-c
+ (int)unBindItems:(int)item items:(int *)items itemsCount:(int)itemsCount
```

**参数说明：**

*item*:  avatar 目标道具句柄

*items*:   需要被绑定到 avatar 道具上的普通道具的句柄数组

*itemsCount*:   句柄数组包含的道具句柄个数

**返回值：**

被绑定到目标道具上的普通道具个数

------

##### unbindAllItems:

该接口可以解绑绑定在目标道具上的全部道具

```objective-c
+ (int)unbindAllItems:(int)item
```

**参数说明：**

*item*:  目标道具句柄

**返回值：**

从目标道具上解除绑定的普通道具个数

------

#### 2.6 其他功能接口

##### isTracking

判断是否检测到人脸

```objective-c
+ (int)isTracking
```

**返回值：**

检测到的人脸个数，返回 0 代表没有检测到人脸

------

##### setMaxFaces:

开启多人检测模式，最多可同时检测 8 张人脸

```objective-c
+ (int)setMaxFaces:(int)maxFaces
```

**参数说明：** 

*maxFaces*:  设置多人模式开启的人脸个数，最多支持 8 个

**返回值：**

 上一次设置的人脸个数

------

##### getVersion

获取当前 SDK 版本号

```objective-c
+ (NSString *)getVersion;
```

**返回值：**

版本信息

------

##### trackFace: inputData: width: height:

该接口只对人脸进行检测，如果程序中没有运行过视频处理接口( 视频处理接口8 除外)，则需要先执行完该接口才能使用 获取人脸信息接口 来获取人脸信息

```objective-c
+ (int)trackFace:(int)inputFormat inputData:(void*)inputData width:(int)width height:(int)height
```

**参数说明：**

*inputFormat*:  输入图像格式：`FU_FORMAT_RGBA_BUFFER` 、 `FU_FORMAT_NV21_BUFFER` 、 `FU_FORMAT_NV12_BUFFER` 、 `FU_FORMAT_I420_BUFFER`

*inputData*:  输入的图像 bytes 地址

*width*:  图像数据的宽度

*height* : 图像数据的高度

**返回值：**

检测到的人脸个数，返回 0 代表没有检测到人脸

------

##### getFaceInfo: name: pret: number:

```objective-c
+ (int)getFaceInfo:(int)faceId name:(NSString *)name pret:(float *)pret number:(int)number
```

**接口说明：**

在主接口执行过人脸跟踪操作后，通过该接口获取人脸跟踪的结果信息。获取信息需要证书提供相关权限，目前人脸信息权限包括以下级别：默认、Landmark、Avatar。

**参数说明：**

*faceId*: 被检测的人脸 ID ，未开启多人检测时传 0 ，表示检测第一个人的人脸信息；当开启多人检测时，其取值范围为 [0 ~ maxFaces-1] ，取其中第几个值就代表检测第几个人的人脸信息

*name*: 人脸信息参数名： "landmarks" , "eye_rotation" , "translation" , "rotation" ....

*pret*: 作为容器使用的 float 数组指针，获取到的人脸信息会被直接写入该 float 数组。

*number*: float 数组的长度

**返回值**

`int ` 返回 1 代表获取成功，返回 0 代表获取失败，具体错误信息通过`fuGetSystemError`获取。如果返回值为 0 且无控制台打印，说明所要求的人脸信息当前不可用。

__备注:__  

所有支持获取的信息、含义、权限要求如下：

| 信息名称       | 长度 | 类型|含义                                                         | 权限     |
| -------------- | ---- | ------------------------------------------------------------ | -------- | -------- |
| face_rect      | 4    | float |人脸矩形框，图像分辨率坐标，数据为 (x_min, y_min, x_max, y_max) | 默认     |
| rotation_mode  | 1    | int |识别人脸相对于设备图像的旋转朝向，取值范围 0-3，分别代表旋转0度、90度、180度、270度 | 默认     |
| failure_rate[已废弃] | 1    | float |人脸跟踪的失败率，表示人脸跟踪的质量。取值范围为 0-2，取值越低代表人脸跟踪的质量越高 | 默认     |
| is_calibrating | 1    | int |表示是否SDK正在进行主动表情校准，取值为 0 或 1。             | 默认     |
| focal_length   | 1    | float| SDK当前三维人脸跟踪所采用的焦距数值                          | 默认     |
| landmarks      | 75*2 | float|人脸 75 个特征点，图像分辨率坐标                             | Landmark |
| landmarks_ar | 75*3 | float |3D 人脸特征点 | Avatar |
| rotation       | 4    | float|人脸三维旋转，数据为旋转四元数\*                              | Landmark |
| translation    | 3    | float|人脸三维平移，数据为 (x, y, z)                               | Landmark |
| eye_rotation   | 4    | float| 眼球旋转，数据为旋转四元数\*，上下22度，左右30度。                                  | Landmark |
| eye_rotation_xy   | 2    | float| 眼球旋转，数据范围为[-1,1]，第一个通道表示水平方向转动，第二个通道表示垂直方向转动                                  | Landmark |
| expression     | 46   | float| 人脸表情系数，表情系数含义可以参考《Expression Guide》       | Avatar   |
| expression_with_tongue     | 56   | float | 1-46为人脸表情系数，同上expression，表情系数含义可以参考《Expression Guide》。47-56为舌头blendshape系数       | Avatar   |
| armesh_vertex_num     | 1   |int| armesh三维网格顶点数量       | armesh   |
| armesh_face_num     | 1   | int| armesh三维网格三角面片数量       | armesh   |
| armesh_vertices     | armesh_vertex_num * 3   |float| armesh三维网格顶点位置数据       | armesh   |
| armesh_uvs     | armesh_vertex_num * 2   |float| armesh三维网格顶点纹理数据       | armesh   |
| armesh_faces     | armesh_face_num * 3   |int| armesh三维网格三角片数据       | armesh  |
| armesh_trans_mat     | 4x4 |float| armesh 的transformation。 __注意:__ 1. 获取'armesh_trans_mat'前需要先获取对应脸的'armesh_vertices'。2. 该trans_mat,相比使用'position'和'rotation'重算的transform更加准确，配合armesh，更好贴合人脸。 | armesh  |
| tongue_direction | 1 |int| 舌头方向，数值对应 FUAITONGUETYPE 定义，见下表。 | Avatar |
| expression_type | 1 |int| 表情识别，数值对应 FUAIEXPRESSIONTYPE定义，见下表。 | Avatar |
| rotation_euler | 3 |float| 返回头部旋转欧拉角，分别为roll、pitch、yaw | 默认 |

*注：*旋转四元数转换为欧拉角可以参考 [该网页](https://en.wikipedia.org/wiki/Conversion_between_quaternions_and_Euler_angles)。

```C
typedef enum FUAITONGUETYPE {
  FUAITONGUE_UNKNOWN = 0,
  FUAITONGUE_UP = 1 << 1,
  FUAITONGUE_DOWN = 1 << 2,
  FUAITONGUE_LEFT = 1 << 3,
  FUAITONGUE_RIGHT = 1 << 4,
  FUAITONGUE_LEFT_UP = 1 << 5,
  FUAITONGUE_LEFT_DOWN = 1 << 6,
  FUAITONGUE_RIGHT_UP = 1 << 7,
  FUAITONGUE_RIGHT_DOWN = 1 << 8,
} FUAITONGUETYPE;
```

```C
typedef enum FUAIEXPRESSIONTYPE {
  FUAIEXPRESSION_UNKNOWN = 0,
  FUAIEXPRESSION_SMILE = 1 << 1,
  FUAIEXPRESSION_MOUTH_OPEN = 1 << 2,
  FUAIEXPRESSION_EYE_BLINK = 1 << 3,
  FUAIEXPRESSION_POUT = 1 << 4,
} FUAIEXPRESSIONTYPE;
```

-----

##### loadTongueModel: size:

如需使用带舌头的Animoji，请在fuSetup后加载舌头道具，即可正常使用带舌头的Animoji。

```objective-c
+ (int)loadTongueModel:(void*)model size:(int)size
```

------

##### ~~loadExtendedARData: size:~~

已弃用。

加载AR高精度数据包，并开启该功能

```objective-c
+ (int)loadExtendedARData:(void *)data size:(int)size;
```

**参数说明：**

*data*: AR高精度数据包byte[]

*size*:  byte[] 长度

------

##### ~~loadAnimModel: size:~~

已弃用。

加载表情动画数据包，并开启该功能

```objective-c
+ (int)loadAnimModel:(void *)model size:(int)size;
```

**参数说明：**

*model*： 表情动画数据包byte[]

*size*：byte[] 长度

------

##### ~~setExpressionCalibration:~~

开启表情校准功能

```objc
+ (void)setExpressionCalibration:(int)expressionCalibration;
```

**参数说明：**

*expressionCalibration*: 0为关闭表情校准，2为被动校准。

------

##### ~~fuSetASYNCTrackFace~~
已弃用。

设置人脸跟踪异步接口。默认处于关闭状态。

```objective-c
+ (void)setAsyncTrackFaceEnable:(int)enable
```

__参数:__  

*enable*：1 开启异步跟踪，0 关闭异步跟踪。

__返回值: __ 

设置后跟踪状态，1 异步跟踪已经开启，0 异步跟踪已经关闭。 

__备注:__  

默认处于关闭状态。开启后，人脸跟踪会和渲染绘制异步并行，cpu占用略有上升，但整体速度提升，帧率提升。

-------



##### namaLibDestroy

释放nama SDK 占用资源

------

### 3. 常见问题 


