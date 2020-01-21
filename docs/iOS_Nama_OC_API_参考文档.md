# iOS Nama Objective-C API 参考文档
级别：Public   
更新日期：2020-01-19   

------

**FaceUnity Nama SDK v6.6.0 (2020-01-19 )**

更新内容
__版本整体说明:__ SDK 6.6.0 主要针对美颜、美妆进行效果优化，性能优化，稳定性优化，同时新增部分特性，使得美颜、美妆效果进入行业顶尖水平。建议对美颜、美妆需求较高的B端用户更新SDK。  
__注意!!!__：此版本由于底层替换原因，表情识别跟踪能力稍有降低，特别是Animoji、表情触发道具的整体表情表现力稍有减弱。Animoji的皱眉、鼓嘴、嘟嘴等动作表现效果比之较差，表情触发道具的发怒（皱眉）、鼓嘴、嘟嘴的表情触发道具较难驱动。其余ARMesh、明星换脸、动态人像（活照片）的面部跟踪整体稍有10%的效果减弱。故用到表情驱动的功能重度B端用户，仍建议使用SDK6.4.0版，使用其余功能（美颜叠加贴纸等其余功能）的场景不受影响，表情识别跟踪能力将在下一版进行优化更新。   

- 美颜优化：  
  1). 新增美型6款功能，包括开眼角、眼距、眼睛角度、长鼻、缩人中、微笑嘴角。
   2). 新增17款滤镜，其中包含8款自然系列滤镜、8款质感灰系列滤镜、1款个性滤镜。
   3). 优化美颜中亮眼、美牙效果。
   4). 优化美颜中3个脸型，调整优化使得V脸、窄脸、小脸效果更自然。
   5). 优化美白红润强度，美白、红润功能开放2倍参数，详见美颜文档。
- 美妆优化：  
  1). 新增13套自然系组合妆，13套组合妆是滤镜+美妆的整体效果，可自定义。
   2). 新增3款口红质地：润泽、珠光、咬唇。
   3). 提升美妆点位准确度 ，人脸点位由209点增加至 239点。
   4). 优化美妆素材叠加方式，使得妆容效果更加服帖自然。
   5). 优化粉底效果，更加贴合人脸轮廓。
- 提升人脸点位跟踪灵敏度，快速移动时跟踪良好，使美颜美妆效果跟随更紧密。
- 提升人脸点位的稳定性，解决了半张脸屏幕、大角度、遮挡等场景的阈值抖动问题，点位抖动问题也明显优化。
- 提升人脸跟踪角度，人脸最大左右偏转角提升至70度，低抬头检测偏转角也明显提升。
- 优化美发道具CPU占有率，Android/iOS提升约30%
- 新增MSAA抗锯齿接口，fuSetMultiSamples，解决虚拟形象（animoji与捏脸功能）边缘锯齿问题，详见接口文档。
- 架构升级，支持底层AI算法能力和业务逻辑拆分，优化性能，使得系统更加容易扩展和更新迭代：  
  1). 新增加接口 fuLoadAIModelFromPackage 用于加载AI能力模型。
   2). 新增加接口 fuReleaseAIModel 用于释放AI能力模型。
   3). 新增加接口 fuIsAIModelLoaded 用于判断AI能力是否已经加载。

__注__1：6.6.0 FaceUnity Nama SDK，为了更新以及迭代更加方便，由原先一个 libnama.a 拆分成两个库 libnama.a 以及 libfuai.a，其中 libnama.a 为轻量级渲染引擎，libfuai.a 为算法引擎。当升级 6.6.0 时，需要添加 libfuai.a 库。
__注2__: 更新SDK 6.6.0时，在fuSetup之后，需要马上调用 fuLoadAIModelFromPackage 加载 ai_faceprocessor.bundle !!!  
__注3__: SDK 6.6.0 进行较大的架构调整 , 架构上拆分底层算法能力和业务场景，使得SDK更能够按需复用算法模块，节省内存开销，算法能力模块后期更容易维护升级，使用方式详见新增加的一组接口定义fuLoadAIModelFromPackage / fuReleaseAIModel / fuIsAIModelLoaded 。

------
### 目录：
本文档内容目录：

[TOC]

------
### 1. 简介 
本文是相芯人脸跟踪及视频特效开发包（以下简称 Nama SDK）的底层接口文档。该文档中的 Nama API 为底层 native 接口，可以直接用于 PC/iOS/Android NDK/Linux 上的开发。其中，iOS和Android平台上的开发可以利用SDK的应用层接口（Objective-C/Java），相比本文中的底层接口会更贴近平台相关的开发经验。

SDK相关的所有调用要求在同一个线程中顺序执行，不支持多线程。少数接口可以异步调用（如道具加载），会在备注中特别注明。SDK所有主线程调用的接口需要保持 OpenGL context 一致，否则会引发纹理数据异常。如果需要用到SDK的绘制功能，则主线程的所有调用需要预先初始化OpenGL环境，没有初始化或初始化不正确会导致崩溃。我们对OpenGL的环境要求为 GLES 2.0 以上。具体调用方式，可以参考各平台 demo。

底层接口根据作用逻辑归为五类：初始化、加载道具、主运行接口、销毁、功能接口、P2A相关接口。

------
### 2. APIs
#### 2.1 初始化
##### setupWithData: dataSize: ardata: authPackage: authSize: 
初始化系统环境，加载系统数据，并进行网络鉴权。必须在调用SDK其他接口前执行，否则会引发崩溃。

```objective-c
- (void)setupWithData:(void *)data dataSize:(int)dataSize ardata:(void *)ardata authPackage:(void *)package authSize:(int)size;

```

__参数说明:__

*data*： 内存指针，v3.bundle 对应的二进制数据地址

*dataSize*： v3.bundle文件字节数

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

*data*： 内存指针，v3.bundle 对应的二进制数据地址

*dataSize：v3.bundle文件字节数

*ardata*： 已废弃

*package*： 内存指针，指向鉴权数据的内容。如果是用包含 authpack.h 的方法在编译时提供鉴权数据，则这里可以写为 ```g_auth_package``` 。

*size*：鉴权数据的长度，以字节为单位。如果鉴权数据提供的是 authpack.h 中的 ```g_auth_package```，这里可写作 ```sizeof(g_auth_package)```

*shouldCreate*: 如果设置为 YES，我们会在内部创建并持有一个 EAGLContext，此时必须使用OC层接口

__返回值:__

返回非0值代表成功，返回0代表失败。如初始化失败，可以通过 ```fuGetSystemError``` 获取错误代码。

------

##### setupWithDataPath: authPackage: authSize: shouldCreateContext: 

初始化系统环境，加载系统数据，并进行网络鉴权。必须在调用SDK其他接口前执行，否则会引发崩溃。

```objective-c
- (void)setupWithDataPath:(NSString *)v3path authPackage:(void *)package authSize:(int)size shouldCreateContext:(BOOL)shouldCreate;

```

__参数说明:__

*v3path*：  v3.bundle 对应的文件路径

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

*v3path*：  v3.bundle 对应的文件路径

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

##### OnDeviceLost

销毁所有道具时需要调用该接口，我们会在内部销毁每个指令中的OpenGL资源

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

*textureHandle*:  用户当前 EAGLContext 下的 textureID，用于图像处理

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

##### avatarBindItems: items: itemsCount: t contracts: contractsCount: 

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

##### avatarUnbindItems: items: itemsCount: 

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

- 在程序中需要先运行过视频处理接口( 视频处理接口8 除外)或 人脸信息跟踪接口 后才能使用该接口来获取人脸信息；
- 该接口能获取到的人脸信息与我司颁发的证书有关，普通证书无法通过该接口获取到人脸信息；
- 具体参数及证书要求如下：

```properties
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
	证书要求: LANDMARK证书

	rotation_mode: 人脸朝向，0-3分别对应手机四种朝向，长度1
	证书要求: LANDMARK证书
```

**参数说明：**

*faceId*: 被检测的人脸 ID ，未开启多人检测时传 0 ，表示检测第一个人的人脸信息；当开启多人检测时，其取值范围为 [0 ~ maxFaces-1] ，取其中第几个值就代表检测第几个人的人脸信息

*name*: 人脸信息参数名： "landmarks" , "eye_rotation" , "translation" , "rotation" ....

*pret*: 作为容器使用的 float 数组指针，获取到的人脸信息会被直接写入该 float 数组。

*number*: float 数组的长度

**返回值**

 返回 1 代表获取成功，返回 0 代表获取失败

------

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

##### setExpressionCalibration:

开启表情校准功能

```objc
+ (void)setExpressionCalibration:(int)expressionCalibration;
```

**参数说明：**

*expressionCalibration*: 0为关闭表情校准，2为被动校准。

------

##### namaLibDestroy

释放nama SDK 占用资源

------

### 3. 常见问题 


