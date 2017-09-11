# FULiveDemo

FULiveDemo 是集成了 Faceunity 面部跟踪和虚拟道具功能的Demo。
## v3.3 美颜模块升级
在v3.3中我们升级了美颜模块。保留老版磨皮算法的同时，默认提供了效果更好的新磨皮算法，进一步减少涂抹感。另外，我们改进了美白效果，并新增了可调节的红润效果，进一步改善肤色。在美型模块中，我们新增了三个脸型调整模板，以进一步满足不同的美型需要。具体细节可以参见[这里](https://github.com/Faceunity/FULiveDemo/tree/dev#视频美颜)。

另外，我们改进了手势识别模块，引入了移动端深度神经网络，提高了手势检出率，同时降低了误检率。
具体细节可以参见[这里](https://github.com/Faceunity/FULiveDemo/tree/dev#手势识别)。

## 库文件
  - funama.h 函数调用接口头文件
  - FURenderer.h OC接口头文件
  - libnama.a 人脸跟踪及道具绘制核心库    
  
## 数据文件
目录 faceunity/ 下的 \*.bundle 为程序的数据文件。数据文件中都是二进制数据，与扩展名无关。实际在app中使用时，打包在程序内或者从网络接口下载这些数据都是可行的，只要在相应的函数接口传入正确的二进制数据即可。

其中 v3.bundle 是所有道具共用的数据文件，缺少该文件会导致初始化失败。其他每一个文件对应一个道具。自定义道具制作的文档和工具请联系我司获取。
  
## 集成方法
首先将Demo中的 SDK 文件夹（Faceunity）拖入到项目中，并勾选上 Destination。

然后向Build Phases → Link Binary With Libraries 中添加依赖库，这里只需要添加Accelerate.framework一个库即可

![](./screenshots/screenshots.png)

之后在代码中包含 FURenderer.h 即可调用相关函数。

```C
#import "FURenderer.h"
```

Faceunity 的接口一般都需要在视频流回调的线程中进行，这里以 AVFoundation 的回调为例进行讲解。

```C
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection

```


**Faceunity初始化：** 其中 `g_auth_package` 为密钥数组，必须配置好密钥，SDK才能正常工作。注：app启动后只需要初始化一次Faceunity即可，切勿多次初始化。

```C
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initFaceunity];
}

- (void)initFaceunity
{
    #warning faceunity全局只需要初始化一次
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        int size = 0;
        
        void *v3 = [self mmap_bundle:@"v3.bundle" psize:&size];
        
        #warning 这里新增了一个参数shouldCreateContext，设为YES的话，不用在外部设置context操作，我们会在内部创建并持有一个context。如果设置为YES,则需要调用FURenderer.h中的接口，不能再调用funama.h中的接口。
        
        [[FURenderer shareRenderer] setupWithData:v3 ardata:NULL authPackage:&g_auth_package authSize:sizeof(g_auth_package) shouldCreateContext:YES];
        
    });
    
    //开启多脸识别（最高可设为8，不过考虑到性能问题建议设为4以内）
    [FURenderer setMaxFaces:4];
    
    [self loadItem];
    [self loadFilter];
}
```

**加载道具：** 声明一个int数组，将fuCreateItemFromPackage返回的道具handle保存下来

```C
int items[2];

- (void)loadItem
{
    if ([_demoBar.selectedItem isEqual: @"noitem"] || _demoBar.selectedItem == nil)
    {
        if (items[0] != 0) {
            NSLog(@"faceunity: destroy item");
            [FURenderer destroyItem:items[0]];
        }
        items[0] = 0;
        return;
    }
    
    int size = 0;
    
    // 先创建再释放可以有效缓解切换道具卡顿问题
    void *data = [self mmap_bundle:[_demoBar.selectedItem stringByAppendingString:@".bundle"] psize:&size];
    
    int itemHandle = [FURenderer createItemFromPackage:data size:size];
    
    if (items[0] != 0) {
        NSLog(@"faceunity: destroy item");
        [FURenderer destroyItem:items[0]];
    }
    
    items[0] = itemHandle;
    
    NSLog(@"faceunity: load item");
}

- (void *)mmap_bundle:(NSString *)bundle psize:(int *)psize {
    
    // Load item from predefined item bundle
    NSString *str = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:bundle];
    const char *fn = [str UTF8String];
    int fd = open(fn,O_RDONLY);
    
    int size = 0;
    void* zip = NULL;
    
    if (fd == -1) {
        NSLog(@"faceunity: failed to open bundle");
        size = 0;
    }else
    {
        size = [self getFileSize:fd];
        zip = mmap(nil, size, PROT_READ, MAP_SHARED, fd, 0);
        close(fd);
    }
    
    *psize = size;
    return zip;
}

- (int)getFileSize:(int)fd
{
    struct stat sb;
    sb.st_size = 0;
    fstat(fd, &sb);
    return (int)sb.st_size;
}

```
**道具绘制：** 调用renderPixelBuffer函数进行道具绘制，其中frameID用来记录当前处理了多少帧图像，该参数与道具中的动画播放有关。itemCount为传入接口的道具数量，flipx设为YES可以使道具做水平镜像操作。

```C
CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);

[[FURenderer shareRenderer] renderPixelBuffer:pixelBuffer withFrameId:frameID items:items itemCount:1 flipx:YES];
```
**具体代码如下：**

```C

#pragma -FUCameraDelegate
- (void)didOutputVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer
{
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
        return;
    }
    
    //人脸跟踪
    int curTrack = [FURenderer isTracking];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.noTrackView.hidden = curTrack;
    });
    
    #warning 如果需开启手势检测，请打开下方的注释
    /*
     if (items[2] == 0) {
     [self loadHeart];
     }
     */
    
    /*设置美颜效果（滤镜、磨皮、美白、瘦脸、大眼....）*/
    [FURenderer itemSetParam:items[1] withName:@"cheek_thinning" value:@(self.demoBar.thinningLevel)]; //瘦脸
    [FURenderer itemSetParam:items[1] withName:@"eye_enlarging" value:@(self.demoBar.enlargingLevel)]; //大眼
    [FURenderer itemSetParam:items[1] withName:@"color_level" value:@(self.demoBar.beautyLevel)]; //美白
    [FURenderer itemSetParam:items[1] withName:@"filter_name" value:_demoBar.selectedFilter]; //滤镜
    [FURenderer itemSetParam:items[1] withName:@"blur_level" value:@(self.demoBar.selectedBlur)]; //磨皮
    [FURenderer itemSetParam:items[1] withName:@"face_shape" value:@(self.demoBar.faceShape)]; //瘦脸类型
    [FURenderer itemSetParam:items[1] withName:@"face_shape_level" value:@(self.demoBar.faceShapeLevel)]; //瘦脸等级
    [FURenderer itemSetParam:items[1] withName:@"red_level" value:@(self.demoBar.redLevel)]; //红润
    
    //Faceunity核心接口，将道具及美颜效果作用到图像中，执行完此函数pixelBuffer即包含美颜及贴纸效果
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    [[FURenderer shareRenderer] renderPixelBuffer:pixelBuffer withFrameId:frameID items:items itemCount:3 flipx:YES];//flipx 参数设为YES可以使道具做水平方向的镜像翻转
    frameID += 1;
    
    #warning 执行完上一步骤，即可将pixelBuffer绘制到屏幕上或推流到服务器进行直播
    //本地显示视频图像
    
    CFRetain(sampleBuffer);
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.bufferDisplayer.status == AVQueuedSampleBufferRenderingStatusFailed) {
            [self.bufferDisplayer flush];
        }
        
        if ([self.bufferDisplayer isReadyForMoreMediaData]) {
            [self.bufferDisplayer enqueueSampleBuffer:sampleBuffer];
        }
        
        CFRelease(sampleBuffer);
    });
}
```

**道具销毁：**

销毁单个道具：

```C
//该接口可以销毁传入的道具所占的内存。
/**
销毁单个道具
 */
+ (void)destroyItem:(int)item;
```

销毁全部道具：

```C
//该接口可以销毁全部道具所占的内存。
- (void)destoryFaceunityItems
{
    
    [FURenderer destroyAllItems];
    
    for (int i = 0; i < sizeof(items) / sizeof(int); i++) {
        items[i] = 0;
    }
}

```
这里需要注意的是，以上两个接口都需要和fuCreateItemFromPackage在同一个context线程上调用

## 视频美颜
美颜功能实现步骤与道具类似，首先加载美颜道具，并将fuCreateItemFromPackage返回的美颜道具handle保存下来:
  
```C
- (void)loadFilter
{
    
    int size = 0;
    
    void *data = [self mmap_bundle:@"face_beautification.bundle" psize:&size];
    
    items[1] = [FURenderer createItemFromPackage:data size:size];
}
```

之后，将该handle和其他需要绘制的道具一起传入绘制接口即可。注意 fuRenderItems() 最后一个参数为所绘制的道具数量，这里以一个普通道具和一个美颜道具一起绘制为例。加载美颜道具后不需设置任何参数，即可启用默认设置的美颜的效果。

```C
[[FURenderer shareRenderer] renderPixelBuffer:pixelBuffer withFrameId:frameID items:items itemCount:2 flipx:YES];
```

美颜道具主要包含五个模块的内容，滤镜，美白和红润，磨皮，美型。每个模块可以调节的参数如下。

#### 滤镜

在目前版本中提供以下滤镜：
```C
"nature", "delta", "electric", "slowlived", "tokyo", "warm"
```

其中 "nature" 作为默认的美白滤镜，其他滤镜属于风格化滤镜。滤镜由参数 filter_name 指定。切换滤镜时，通过 fuItemSetParams 设置美颜道具的参数，如：
```C
//  Set item parameters - filter
[FURenderer itemSetParam:items[1] withName:@"filter_name" value:@"nature"];
```

#### 美白和红润

通过参数 color_level 来控制美白程度。该参数的推荐取值范围为[0, 1]，0为无效果，0.5为默认效果，大于1为继续增强效果。

设置参数的例子代码如下：

```C
//  Set item parameters - whiten
[FURenderer itemSetParam:items[1] withName:@"color_level" value:@(0.5)];
```

新版美颜新增红润调整功能。参数名为 red_level 来控制红润程度。使用方法基本与美白效果一样。该参数的推荐取值范围为[0, 1]，0为无效果，0.5为默认效果，大于1为继续增强效果。

#### 磨皮

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

#### 美型

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

#### 平台相关

PC端的美颜，使用前必须将参数 is_opengl_es 设置为 0，移动端无需此操作：

```C
//  Set item parameters
fuItemSetParamd(g_items[1], "is_opengl_es", 0);
```

## 手势识别
目前我们的手势识别功能也是以道具的形式进行加载的。一个手势识别的道具中包含了要识别的手势、识别到该手势时触发的动效、及控制脚本。加载该道具的过程和加载普通道具、美颜道具的方法一致。

线上例子中 heart.bundle 为爱心手势演示道具。将其作为道具加载进行绘制即可启用手势识别功能。手势识别道具可以和普通道具及美颜共存，类似美颜将 items 扩展为三个并在最后加载手势道具即可。

自定义手势道具的流程和2D道具制作一致，具体打包的细节可以联系我司技术支持。

## OC封装层

- fuSetup接口封装

```C
- (void)setupWithData:(void *)data ardata:(void *)ardata authPackage:(void *)package authSize:(int)size;

```
- fuSetup扩展接口封装：新增shouldCreateContext，设置为YES,将在FURenderer内部创建并持有一个context，用户不用再管理和设置context，从而避免context环境复杂时出现问题。

```C
- (void)setupWithData:(void *)data ardata:(void *)ardata authPackage:(void *)package authSize:(int)size shouldCreateContext:(BOOL)create;
```

- 单输入接口：输入一个pixelBuffer并返回一个加过美颜或道具的pixelBuffer，支持YUV及BGRA格式出入，输出与输入格式一致且地址相同。

```C
- (CVPixelBufferRef)renderPixelBuffer:(CVPixelBufferRef)pixelBuffer withFrameId:(int)frameid items:(int*)items itemCount:(int)itemCount;
```
- 双输入接口：输入pixelBuffer及texture，然后返回一个FUOutput结构体，结构体中包含的就是加过美颜或道具的pixelBuffer及texture。输入的pixelBuffer支持YUV及BGRA格式，输入的texture只支持BGRA格式，输出与输入格式一致。

```C
- (FUOutput)renderPixelBuffer:(CVPixelBufferRef)pixelBuffer bgraTexture:(GLuint)textureHandle withFrameId:(int)frameid items:(int *)items itemCount:(int)itemCount;

```
- FUOutput结构体：包含一个pixelBuffer和一个texture

```C
typedef struct{
    CVPixelBufferRef pixelBuffer;
    GLuint bgraTextureHandle;
}FUOutput;

```

- 其他接口

```C
/**
 切换摄像头时调用
 */
+ (void)onCameraChange;

/**
创建道具
 */
+ (int)createItemFromPackage:(void*)data size:(int)size;

/**
销毁单个道具
 */
+ (void)destroyItem:(int)item;

/**
销毁所有道具
 */
+ (void)destroyAllItems;

/**
 人脸信息跟踪
 */
+ (int)trackFace:(int)inputFormat inputData:(void*)inputData width:(int)width height:(int)height;

/**
 为道具设置参数
 
 value 只支持 NSString NSNumber两种数据类型
 
 */
+ (int)itemSetParam:(int)item withName:(NSString *)name value:(id)value;

/**
 从道具中获取double值
 */
+ (double)itemGetDoubleParam:(int)item withName:(NSString *)name;

/**
 从道具中获取string值
 */
+ (void)itemGetStringParam:(int)item withName:(NSString *)name buf:(char *)buf size:(int)size;

/**
 判断是否识别到人脸，返回值为人脸个数
 */
+ (int)isTracking;

/**
 设置多人，最多设置8个
 */
+ (int)setMaxFaces:(int)maxFaces;

/**
 获取人脸信息
 */
+ (int)getFaceInfo:(int)faceId name:(NSString *)name pret:(float *)pret number:(int)number;

/**
 将普通道具绑定到avatar道具
 */
+ (int)avatarBindItems:(int)avatarItem items:(int *)items itemsCount:(int)itemsCount contracts:(int *)contracts contractsCount:(int)contractsCount;

/**
 将普通道具从avatar道具上解绑
 */
+ (int)avatarUnbindItems:(int)avatarItem items:(int *)items itemsCount:(int)itemsCount;

/**
 绑定道具
 */
+ (int)bindItems:(int)item items:(int*)items itemsCount:(int)itemsCount;

/**
 解绑道具
 */
+ (int)unbindAllItems:(int)item;

/**
获取版本信息
 */
+ (NSString *)getVersion;

```

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

## 函数接口及参数说明

```C
/**
\brief Initialize and authenticate your SDK instance to the FaceUnity server, must be called exactly once before all other functions.
  The buffers should NEVER be freed while the other functions are still being called.
  You can call this function multiple times to "switch pointers".
\param v2data should point to contents of the "v2.bin" we provide
\param ardata should point to contents of the "ar.bin" we provide
\param authdata is the pointer to the authentication data pack we provide. You must avoid storing the data in a file.
  Normally you can just `#include "authpack.h"` and put `g_auth_package` here.
\param sz_authdata is the authentication data size, we use plain int to avoid cross-language compilation issues.
  Normally you can just `#include "authpack.h"` and put `sizeof(g_auth_package)` here.
*/
void fuSetup(float* v2data,float* ardata,void* authdata,int sz_authdata);

/**
\brief Call this function when the GLES context has been lost and recreated.
  That isn't a normal thing, so this function could leak resources on each call.
*/
void fuOnDeviceLost();

/**
\brief Call this function to reset the face tracker on camera switches
*/
void fuOnCameraChange();

/**
\brief Create an accessory item from a binary package, you can discard the data after the call.
  This function MUST be called in the same GLES context / thread as fuRenderItems.
\param data is the pointer to the data
\param sz is the data size, we use plain int to avoid cross-language compilation issues
\return an integer handle representing the item
*/
int fuCreateItemFromPackage(void* data,int sz);

/**
\brief Destroy an accessory item.
  This function MUST be called in the same GLES context / thread as the original fuCreateItemFromPackage.
\param item is the handle to be destroyed
*/
void fuDestroyItem(int item);

/**
\brief Destroy all accessory items ever created.
  This function MUST be called in the same GLES context / thread as the original fuCreateItemFromPackage.
*/
void fuDestroyAllItems();

/**
\brief Render a list of items on top of a GLES texture or a memory buffer.
  This function needs a GLES 2.0+ context.
\param texid specifies a GLES texture. Set it to 0u if you want to render to a memory buffer.
\param img specifies a memory buffer. Set it to NULL if you want to render to a texture.
  If img is non-NULL, it will be overwritten by the rendered image when fuRenderItems returns
\param w specifies the image width
\param h specifies the image height
\param frameid specifies the current frame id. 
  To get animated effects, please increase frame_id by 1 whenever you call this.
\param p_items points to the list of items
\param n_items is the number of items
\return a new GLES texture containing the rendered image in the texture mode
*/
int fuRenderItems(int texid,int* img,int w,int h,int frame_id, int* p_items,int n_items);

/*\brief An I/O format where `ptr` points to a BGRA buffer. It matches the camera format on iOS. */
#define FU_FORMAT_BGRA_BUFFER 0
/*\brief An I/O format where `ptr` points to a single GLuint that is a RGBA texture. It matches the hardware encoding format on Android. */
#define FU_FORMAT_RGBA_TEXTURE 1
/*\brief An I/O format where `ptr` points to an NV21 buffer. It matches the camera preview format on Android. */
#define FU_FORMAT_NV21_BUFFER 2
/*\brief An output-only format where `ptr` is NULL. The result is directly rendered onto the current GL framebuffer. */
#define FU_FORMAT_GL_CURRENT_FRAMEBUFFER 3
/*\brief An I/O format where `ptr` points to a RGBA buffer. */
#define FU_FORMAT_RGBA_BUFFER 4

/**
\brief Generalized interface for rendering a list of items.
  This function needs a GLES 2.0+ context.
\param out_format is the output format
\param out_ptr receives the rendering result, which is either a GLuint texture handle or a memory buffer
\param in_format is the input format
\param in_ptr points to the input image, which is either a GLuint texture handle or a memory buffer
\param w specifies the image width
\param h specifies the image height
\param frameid specifies the current frame id. 
  To get animated effects, please increase frame_id by 1 whenever you call this.
\param p_items points to the list of items
\param n_items is the number of items
\return a GLuint texture handle containing the rendering result if out_format isn't FU_FORMAT_GL_CURRENT_FRAMEBUFFER
*/
int fuRenderItemsEx(
  int out_format,void* out_ptr,
  int in_format,void* in_ptr,
  int w,int h,int frame_id, int* p_items,int n_items);
  
/**
\brief Set an item parameter to a double value
\param item specifies the item
\param name is the parameter name
\param value is the parameter value to be set
\return zero for failure, non-zero for success
*/
int fuItemSetParamd(int item,char* name,double value);

/**
\brief Set an item parameter to a double array
\param item specifies the item
\param name is the parameter name
\param value points to an array of doubles
\param n specifies the number of elements in value
\return zero for failure, non-zero for success
*/
int fuItemSetParamdv(int item,char* name,double* value,int n);

/**
\brief Set an item parameter to a string value
\param item specifies the item
\param name is the parameter name
\param value is the parameter value to be set
\return zero for failure, non-zero for success
*/
int fuItemSetParams(int item,char* name,char* value);

/**
\brief Get an item parameter to a double value
\param item specifies the item
\param name is the parameter name
\return double value of the parameter
*/
double fuItemGetParamd(int item,char* name);

/**
\brief Get the face tracking status
\return zero for not tracking, non-zero for tracking
*/
int fuIsTracking();

/**
\brief Set the default orientation for face detection. The correct orientation would make the initial detection much faster.
One of 0..3 should work.
*/
void fuSetDefaultOrientation(int rmode);
```
