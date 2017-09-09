# FULiveDemo

FULiveDemo 是集成了 Faceunity 面部跟踪和虚拟道具功能的Demo。

## SDK v4.0 更新
在v4.0版本中，我们全面升级了移动端实时深度学习框架，更好地支持视频应用中日益增长的AI需求。随之推出的第一个功能是背景分割，开启该功能的道具可以在相机画面中自动分割出人像，并替换背景为其他内容。

由于深度学习框架的升级，SDK的库文件从之前的 ~3M 增加到了 ~5M，如果不需要AI相关功能，可以下载[SDK lite版](https://github.com/Faceunity/FULiveDemo/releases)，库文件大小和老版本保持一致。

与新版SDK一起，我们也推出更方便和好用的2D/3D贴纸道具制作工具——FUEditor，助力视频应用快速应对市场，推出具有个性化和吸引力的道具和玩法。相关文档和下载在[这里](https://github.com/Faceunity/FUEditor)，制作过程中遇到问题可以联系我司技术支持。

此外，我们优化了SDK的系统稳定性，在网络条件波动的情况下保持SDK正常运行，并提供了获取SDK系统错误信息的接口，方便应用灵活处理。

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

Faceunity 的接口一般都需要在视频流回调的线程中进行，这里以 AVFoundation 的 

```C
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection

```
回调为例进行讲解。

**首先创建一个OpenGL Context：**

```C
//如果当前环境中已存在EAGLContext，此步骤可省略，但必须要调用[EAGLContext setCurrentContext:curContext]函数。
#pragma -Faceunity Set EAGLContext

static EAGLContext *mcontext;

- (void)setUpContext
{
    if(!mcontext){
        mcontext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    }
    if(!mcontext || ![EAGLContext setCurrentContext:mcontext]){
        NSLog(@"faceunity: failed to create / set a GLES2 context");
    }
    
}

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
        
        [[FURenderer shareRenderer] setupWithData:v3 ardata:NULL authPackage:&g_auth_package authSize:sizeof(g_auth_package)];
    });
    
    //开启多脸识别（最高可设为8，不过考虑到性能问题建议设为4以内）
//    fuSetMaxFaces(4);
    
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
            fuDestroyItem(items[0]);
        }
        items[0] = 0;
        return;
    }
    
    
    [self setUpContext];
    
    int size = 0;
    
    // 先创建再释放可以有效缓解切换道具卡顿问题
    void *data = [self mmap_bundle:[_demoBar.selectedItem stringByAppendingString:@".bundle"] psize:&size];
    
    int itemHandle = fuCreateItemFromPackage(data, size);
    
    if (items[0] != 0) {
        NSLog(@"faceunity: destroy item");
        fuDestroyItem(items[0]);
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

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
  
  	if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
        return;
    }
    
    //如果当前环境中已存在EAGLContext，此步骤可省略，但必须要调用[EAGLContext setCurrentContext:curContext]函数。
    #warning 此步骤不可放在异步线程中执行
    [self setUpContext];
    
    //人脸跟踪
    int curTrack = fuIsTracking();
    dispatch_async(dispatch_get_main_queue(), ^{
        self.noTrackView.hidden = curTrack;
    });
    
    //设置美颜效果（滤镜、磨皮、美白、瘦脸、大眼....）
    fuItemSetParamd(items[1], "cheek_thinning", self.demoBar.thinningLevel); //瘦脸
    fuItemSetParamd(items[1], "eye_enlarging", self.demoBar.enlargingLevel); //大眼
    fuItemSetParamd(items[1], "color_level", self.demoBar.beautyLevel); //美白
    fuItemSetParams(items[1], "filter_name", (char *)[_demoBar.selectedFilter UTF8String]); //滤镜
    fuItemSetParamd(items[1], "blur_level", self.demoBar.selectedBlur); //磨皮
    fuItemSetParamd(items[1], "face_shape", self.demoBar.faceShape); //瘦脸类型
    fuItemSetParamd(items[1], "face_shape_level", self.demoBar.faceShapeLevel); //瘦脸等级
    fuItemSetParamd(items[1], "red_level", self.demoBar.redLevel); //红润
    
    //Faceunity核心接口，将道具及美颜效果作用到图像中，执行完此函数pixelBuffer即包含美颜及贴纸效果
    #warning 此步骤不可放在异步线程中执行
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    [[FURenderer shareRenderer] renderPixelBuffer:pixelBuffer withFrameId:frameID items:items itemCount:2 flipx:YES];//flipx 参数设为YES可以使道具做水平方向的镜像翻转
    frameID += 1;
    
}
```

**道具销毁：**

销毁单个道具：

```C
//该接口可以销毁传入的道具所占的内存。
void fuDestroyItem(int item)
```

销毁全部道具：

```C
//该接口可以销毁全部道具所占的内存。
- (void)destoryFaceunityItems
{
    [self setUpContext];
    
    fuDestroyAllItems();
    
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
    [self setUpContext];
    
    int size = 0;
    
    void *data = [self mmap_bundle:@"face_beautification.bundle" psize:&size];
    
    items[1] = fuCreateItemFromPackage(data, size);
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
fuItemSetParams(g_items[1], "filter_name", "nature");
```

#### 美白和红润

通过参数 color_level 来控制美白程度。该参数的推荐取值范围为[0, 1]，0为无效果，0.5为默认效果，大于1为继续增强效果。

设置参数的例子代码如下：

```C
//  Set item parameters - whiten
fuItemSetParamd(g_items[1], "color_level", 0.5);
```

新版美颜新增红润调整功能。参数名为 red_level 来控制红润程度。使用方法基本与美白效果一样。该参数的推荐取值范围为[0, 1]，0为无效果，0.5为默认效果，大于1为继续增强效果。

#### 磨皮

新版美颜中，控制磨皮的参数有两个：blur_level、use_old_blur。

参数 blur_level 指定磨皮程度。该参数的推荐取值范围为[0, 6]，0为无效果，对应7个不同的磨皮程度。

参数 use_old_blur 指定是否使用旧磨皮。该参数设置为0即使用新磨皮，设置为大于0即使用旧磨皮

设置参数的例子代码如下：

```C
//  Set item parameters - blur
fuItemSetParamd(g_items[1], "blur_level", 6.0);

//  Set item parameters - use old blur
fuItemSetParamd(g_items[1], "use_old_blur", 1.0);
```

#### 美型

目前我们支持四种基本脸型：女神、网红、自然、默认。由参数 face_shape 指定：默认（3）、女神（0）、网红（1）、自然（2）。

```C
//  Set item parameters - shaping
fuItemSetParamd(g_items[1], "face_shape", 3);
```

在上述四种基本脸型的基础上，我们提供了以下三个参数：face_shape_level、eye_enlarging、cheek_thinning。

参数 face_shape_level 用以控制变化到指定基础脸型的程度。该参数的取值范围为[0, 1]。0为无效果，即关闭美型，1为指定脸型。

若要关闭美型，可将 face_shape_level 设置为0。

```C
//  Set item parameters - shaping level
fuItemSetParamd(g_items[1], "face_shape_level", 1.0);
```

参数 eye_enlarging 用以控制眼睛大小。此参数受参数 face_shape_level 影响。该参数的推荐取值范围为[0, 1]。大于1为继续增强效果。

```C
//  Set item parameters - eye enlarging level
fuItemSetParamd(g_items[1], "eye_enlarging", 1.0);
```

参数 cheek_thinning 用以控制脸大小。此参数受参数 face_shape_level 影响。该参数的推荐取值范围为[0, 1]。大于1为继续增强效果。

```C
//  Set item parameters - cheek thinning level
fuItemSetParamd(g_items[1], "cheek_thinning", 1.0);
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

在原有SDK基础上对fuSetup及fuRenderItemsEx这两个函数进行了封装，总共包括三个接口：

- fuSetup接口封装

```C
+ (void)setupWithData:(void *)data ardata:(void *)ardata authPackage:(void *)package authSize:(int)size;

```
- 单输入接口：输入一个pixelBuffer并返回一个加过美颜或道具的pixelBuffer，支持YUV及BGRA格式出入，且输出与输入格式一致。

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
