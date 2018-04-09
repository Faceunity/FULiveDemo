# Nama API OC Reference

本文档为nama oc 层接口文档说明。

**获取 FURenderer 单例接口：**

```
+ (FURenderer *)shareRenderer;
```

接口说明：

- 获取 FURenderer 单例

返回值：

`FURenderer ` FURenderer 单例

------

**初始化接口1：**

```
- (void)setupWithData:(void *)data ardata:(void *)ardata authPackage:(void *)package authSize:(int)size;
```

接口说明：

- 初始化 SDK，并对 SDK 进行授权，在调用其他接口前必须要先进行初始化。使用该接口进行初始化的话，需要在代码中配置 EAGLContext  环境，并且保证我们的接口是在同一个 EAGLContext 下调用的

参数说明：

`data` v3.bundle 对应的二进制数据地址

`ardata ` 该参数已废弃，传 NULL 即可

`package ` 密钥数组，必须配置好密钥， SDK 才能正常工作

`size` 密钥数组大小

------

**初始化接口2：**

```
- (void)setupWithData:(void *)data ardata:(void *)ardata authPackage:(void *)package authSize:(int)size shouldCreateContext:(BOOL)shouldCreate;
```

接口说明：

- 初始化 SDK，并对 SDK 进行授权，在调用其他接口前必须要先进行初始化。与 **初始化接口1** 相比此接口新增 shouldCreate 参数，如果传入YES我们将在内部创建并持有一个 EAGLContext，无需外部再创建 EAGLContext 环境。

参数说明：

`data` v3.bundle 对应的二进制数据地址

`ardata ` 该参数已废弃，传 NULL 即可

`package ` 密钥数组，必须配置好密钥， SDK 才能正常工作

`size` 密钥数组大小

`shouldCreate ` 如果设置为 YES ，我们会在内部创建并持有一个 EAGLContext，此时必须使用 FURenderer.h 内接口，不能再使用 funama.h 接口

------

**初始化接口3：**

```
- (void)setupWithDataPath:(NSString *)v3path authPackage:(void *)package authSize:(int)size shouldCreateContext:(BOOL) shouldCreate;
```

接口说明：

- 初始化 SDK ，并对 SDK 进行授权，在调用其他接口前必须要先进行初始化。与 **初始化接口2** 相比改为通过 v3.bundle 的文件路径进行初始化，并且删除了废弃的 ardata 参数。

参数说明：

`v3path ` v3.bundle 对应的文件路径

`package ` 密钥数组，必须配置好密钥，SDK 才能正常工作

`size` 密钥数组大小

`shouldCreate ` 如果设置为 YES，我们会在内部创建并持有一个 EAGLContext，此时必须使用 FURenderer.h 内接口，不能再使用 funama.h 接口

------

**视频处理接口1：**

```
- (CVPixelBufferRef)renderPixelBuffer:(CVPixelBufferRef)pixelBuffer withFrameId:(int)frameid items:(int*)items itemCount:(int)itemCount;
```

接口说明：

- 将 items 中的道具绘制到 pixelBuffer 中

参数说明：

`pixelBuffer ` 图像数据，支持的格式为：BGRA、YUV420SP

`frameid ` 当前处理的视频帧序数，每次处理完对其进行加 1 操作，不加 1 将无法驱动道具中的特效动画

`items ` 包含多个道具句柄的 int 数组，包括普通道具、美颜道具、手势道具等

`itemCount ` 句柄数组中包含的句柄个数

返回值：

`CVPixelBufferRef ` 被处理过的的图像数据，与传入的 pixelBuffer 为同一个 pixelBuffer

------

**视频处理接口2：**

```
- (CVPixelBufferRef)renderPixelBuffer:(CVPixelBufferRef)pixelBuffer
                      withFrameId:(int)frameid
                            items:(int*)items 
                        itemCount:(int)itemCount
                            flipx:(BOOL)flip;
```

接口说明：

- 将 items 中的道具绘制到 pixelBuffer 中，与 **视频处理接口1** 相比新增 flip 参数，将该参数设置为 YES 可使道具做水平镜像翻转

参数说明：

`pixelBuffer ` 图像数据，支持的格式为：BGRA、YUV420SP

`frameid ` 当前处理的视频帧序数，每次处理完对其进行加 1 操作，不加 1 将无法驱动道具中的特效动画

`items ` 包含多个道具句柄的 int 数组

`itemCount ` 句柄数组中包含的句柄个数

`flip ` 道具镜像使能，如果设置为 YES 可以将道具做镜像操作

返回值：

`CVPixelBufferRef ` 被处理过的的图像数据，与传入的 pixelBuffer 为同一个 pixelBuffer

------

**视频处理接口3：**

```
- (CVPixelBufferRef)renderToInternalPixelBuffer:(CVPixelBufferRef)pixelBuffer withFrameId:(int)frameid items:(int*)items itemCount:(int)itemCount;
```

接口说明：

- 将 items 中的道具绘制到一个新的 pixelBuffer 中，输出与输入不是同一个 pixelBuffer

参数说明：

`pixelBuffer ` 图像数据，支持的格式为：BGRA、YUV420SP

`frameid ` 当前处理的视频帧序数，每次处理完对其进行加 1 操作，不加 1 将无法驱动道具中的特效动画

`items ` 包含多个道具句柄的 int 数组，包括普通道具、美颜道具、手势道具等

`itemCount ` 句柄数组中包含的句柄个数

返回值：

`CVPixelBufferRef ` 被处理过的的图像数据，与传入的 pixelBuffer 不是同一个 pixelBuffer

------

**视频处理接口4：**

```
- (FUOutput)renderPixelBuffer:(CVPixelBufferRef)pixelBuffer bgraTexture:(GLuint)textureHandle withFrameId:(int)frameid items:(int *)items itemCount:(int)itemCount;
```

接口说明：

- 将 items 中的道具绘制到 textureHandle 及 pixelBuffer 中，该接口适用于可同时输入 GLES texture 及 pixelBuffer 的用户，这里的 pixelBuffer 主要用于 CPU 上的人脸检测，如果只有 GLES texture 此接口将无法工作。

参数说明：

`pixelBuffer ` 图像数据，支持的格式为：BGRA、YUV420SP，用于人脸识别

`textureHandle ` 用户当前 EAGLContext 下的 textureID，用于图像处理

`frameid ` 当前处理的视频帧序数，每次处理完对其进行加 1 操作，不加 1 将无法驱动道具中的特效动画

`items ` 包含多个道具句柄的 int 数组，包括普通道具、美颜道具、手势道具等

`itemCount ` 句柄数组中包含的句柄个数

返回值：

`FUOutput ` 被处理过的的图像数据， FUOutput 的定义如下：

```
typedef struct{
    CVPixelBufferRef pixelBuffer;
    GLuint bgraTextureHandle;
}FUOutput;
```

------

**视频处理接口5：**

```
- (FUOutput)renderPixelBuffer:(CVPixelBufferRef)pixelBuffer bgraTexture:(GLuint)textureHandle withFrameId:(int)frameid items:(int *)items itemCount:(int)itemCount flipx:(BOOL)flip;
```

接口说明：

- 将items中的道具绘制到 textureHandle 及 pixelBuffer 中，与 **视频处理接口4** 相比新增 flip 参数，将该参数设置为 YES 可使道具做水平镜像翻转。

参数说明：

`pixelBuffer ` 图像数据，支持的格式为：BGRA、YUV420SP，用于人脸识别

`textureHandle ` 用户当前 EAGLContext 下的 textureID，用于图像处理

`frameid ` 当前处理的视频帧序数，每次处理完对其进行加 1 操作，不加 1 将无法驱动道具中的特效动画

`items ` 包含多个道具句柄的int数组，包括普通道具、美颜道具、手势道具等

`itemCount ` 句柄数组中包含的句柄个数

`flip ` 道具镜像使能，如果设置为 YES 可以将道具做镜像操作

返回值：

`FUOutput ` 被处理过的的图像数据， FUOutput 的定义如下：

```
typedef struct{
    CVPixelBufferRef pixelBuffer;
    GLuint bgraTextureHandle;
}FUOutput;
```

------

**视频处理接口6：**

```
- (CVPixelBufferRef)beautifyPixelBuffer:(CVPixelBufferRef)pixelBuffer withBeautyItem:(int)item;
```

接口说明：

- 该接口不包含人脸检测功能，只能对图像做美白、红润、滤镜、磨皮操作，不包含瘦脸及大眼等美型功能。

参数说明：

`pixelBuffer ` 图像数据，支持的格式为：BGRA、YUV420SP

`item ` 美颜道具句柄

返回值：

`CVPixelBufferRef ` 被处理过的的图像数据

------

**视频处理接口7：**

```
- (void)renderFrame:(uint8_t*)y u:(uint8_t*)u v:(uint8_t*)v ystride:(int)ystride ustride:(int)ustride vstride:(int)vstride width:(int)width height:(int)height frameId:(int)frameid items:(int *)items itemCount:(int)itemCount;
```

接口说明：

- 将 items 中的道具绘制到 YUV420P 图像中

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

------

**视频处理接口8：**

```
- (void)renderFrame:(uint8_t*)y u:(uint8_t*)u v:(uint8_t*)v ystride:(int)ystride ustride:(int)ustride vstride:(int)vstride width:(int)width height:(int)height frameId:(int)frameid items:(int *)items itemCount:(int)itemCount flipx:(BOOL)flip;
```

接口说明：

- 将 items 中的道具绘制到 YUV420P 图像中，与 **视频处理接口7** 相比新增 flip 参数，将该参数设置为 YES 可使道具做水平镜像翻转

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

------

**切换摄像头时需调用的接口：**

```
+ (void)onCameraChange;
```

接口说明：

- 切换摄像头时需要调用该接口，我们会在内部重置人脸检测的一些状态

------

**通过道具二进制文件创建道具接口：**

```
+ (int)createItemFromPackage:(void*)data size:(int)size;
```

接口说明：

- 通过道具二进制文件创建道具句柄

参数说明：

`data ` 道具二进制文件

`size ` 文件大小

返回值：

`int ` 创建的道具句柄

------

**通过道具文件路径创建道具接口：**

```
+ (int)itemWithContentsOfFile:(NSString *)path;
```

接口说明：

- 通过道具文件路径创建道具句柄

参数说明：

`path ` 道具文件路径

返回值：

`int ` 创建的道具句柄

------

**销毁单个道具接口：**

```
+ (void)destroyItem:(int)item;
```

接口说明：

- 通过道具句柄销毁道具，并释放相关资源，销毁道具后请将道具句柄设为 0 ，以避免 SDK 使用无效的句柄而导致程序出错。

参数说明：

`item ` 道具句柄

------

**销毁所有道具接口：**

```
+ (void)destroyAllItems;
```

接口说明：

- 销毁全部道具，并释放相关资源，销毁道具后请将道具句柄数组中的句柄设为 0 ，以避免 SDK 使用无效的句柄而导致程序出错。

------

**为道具设置参数接口：**

```
+ (int)itemSetParam:(int)item withName:(NSString *)name value:(id)value;
```

接口说明：

- 为道具设置参数

参数说明：

`item ` 道具句柄

`name ` 参数名

`value ` 参数值：只支持 NSString 、 NSNumber 两种数据类型

返回值：

`int ` 执行结果：返回 0 代表设置失败，大于 0 表示设置成功

------

**从道具中获取 double 型参数值接口：**

```
+ (double)getDoubleParamFromItem:(int)item withName:(NSString *)name
```

接口说明：

- 从道具中获取 double 型参数值

参数说明：

`item ` 道具句柄

`name ` 参数名

返回值：

`double ` 参数值

------

**从道具中获取 NSString 型参数值接口：**

```
+ (NSString *)getStringParamFromItem:(int)item withName:(NSString *)name
```

接口说明：

- 从道具中获取 NSString 型参数值

参数说明：

`item ` 道具句柄

`name ` 参数名

返回值：

`NSString ` 参数值

------

**判断是否检测到人脸接口：**

```
+ (int)isTracking;
```

接口说明：

- 判断是否检测到人脸

返回值：

`int ` 检测到的人脸个数，返回 0 代表没有检测到人脸

------

**开启多人检测模式接口：**

```
+ (int)setMaxFaces:(int)maxFaces;
```

接口说明：

- 开启多人检测模式，最多可同时检测 8 张人脸

参数说明：

`maxFaces ` 设置多人模式开启的人脸个数，最多支持 8 个

返回值：

`int ` 上一次设置的人脸个数

------

**人脸信息跟踪接口：**

```
+ (int)trackFace:(int)inputFormat inputData:(void*)inputData width:(int)width height:(int)height;
```

接口说明：

- 该接口只对人脸进行检测，如果程序中没有运行过视频处理接口( **视频处理接口6** 除外)，则需要先执行完该接口才能使用 **获取人脸信息接口** 来获取人脸信息

参数说明：

`inputFormat ` 输入图像格式：`FU_FORMAT_BGRA_BUFFER` 或 `FU_FORMAT_NV12_BUFFER`

`inputData ` 输入的图像 bytes 地址

`width ` 图像宽度

`height ` 图像高度 

返回值：

`int ` 检测到的人脸个数，返回 0 代表没有检测到人脸

------

**获取人脸信息接口：**

```
+ (int)getFaceInfo:(int)faceId name:(NSString *)name pret:(float *)pret number:(int)number;
```

接口说明：

- 在程序中需要先运行过视频处理接口( **视频处理接口6** 除外)或 **人脸信息跟踪接口** 后才能使用该接口来获取人脸信息；
- 该接口能获取到的人脸信息与我司颁发的证书有关，普通证书无法通过该接口获取到人脸信息；
- 什么证书能获取到人脸信息？能获取到哪些人脸信息？请看下方：

```c
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

------

**将普通道具绑定到avatar道具的接口：**

```
+ (int)avatarBindItems:(int)avatarItem items:(int *)items itemsCount:(int)itemsCount contracts:(int *)contracts contractsCount:(int)contractsCount;
```

接口说明：

- 该接口主要应用于 P2A 项目中，将普通道具绑定到 avatar 道具上，从而实现道具间的数据共享，在视频处理时只需要传入 avatar 道具句柄，普通道具也会和 avatar 一起被绘制出来。
- 普通道具又分免费版和收费版，免费版有免费版对应的 contract 文件，收费版有收费版对应的文件，当绑定时需要同时传入这些 contracts 文件才能绑定成功。注： contract 的创建和普通道具创建方法一致

参数说明：

`avatarItem ` avatar 道具句柄

`items ` 需要被绑定到 avatar 道具上的普通道具的句柄数组

`itemsCount ` 句柄数组包含的道具句柄个数

`contracts ` contract 道具的句柄数组

`contractsCount ` contracts 数组中 contract 道具句柄的个数

返回值：

`int ` 被绑定到 avatar 道具上的普通道具个数

------

**将普通道具从avatar道具上解绑的接口：**

```
+ (int)avatarUnbindItems:(int)avatarItem items:(int *)items itemsCount:(int)itemsCount;
```

接口说明：

- 该接口可以将普通道具从 avatar 道具上解绑，主要应用场景为切换道具或去掉某个道具

参数说明：

`avatarItem ` avatar 道具句柄

`items ` 需要从 avatar 道具上的解除绑定的普通道具的句柄数组

`itemsCount ` 句柄数组包含的道具句柄个数

返回值：

`int ` 从 avatar 道具上解除绑定的普通道具个数

------

**绑定道具接口：**

```
+ (int)bindItems:(int)item items:(int*)items itemsCount:(int)itemsCount;
```

接口说明：

- 该接口可以将一些普通道具绑定到某个目标道具上，从而实现道具间的数据共享，在视频处理时只需要传入该目标道具句柄即可

参数说明：

`item ` 目标道具句柄

`items `  需要被绑定到目标道具上的其他道具的句柄数组

`itemsCount ` 句柄数组包含的道具句柄个数

返回值：

`int ` 被绑定到目标道具上的普通道具个数

------

**解绑所有道具接口：**

```
+ (int)unbindAllItems:(int)item;
```

接口说明：

- 该接口可以解绑绑定在目标道具上的全部道具

参数说明：

`item` 目标道具句柄

返回值：

`int ` 从目标道具上解除绑定的普通道具个数

------

**获取 SDK 版本信息接口：**

```
+ (NSString *)getVersion;
```

接口说明：

- 获取当前 SDK 版本号

返回值：

`NSString ` 版本信息