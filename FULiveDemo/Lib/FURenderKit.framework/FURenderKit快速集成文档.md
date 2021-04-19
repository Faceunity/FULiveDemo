#  快速集成文档

## 初始化

```objective-c
// 初始化 FURenderKit 
FUSetupConfig *setupConfig = [[FUSetupConfig alloc] init];
setupConfig.authPack = FUAuthPackMake(g_auth_package, **sizeof**(g_auth_package));
[FURenderKit setupWithSetupConfig:setupConfig];
```

## 加载AI模型

```objective-c
// 加载人脸 AI 模型
NSString *faceAIPath = [[NSBundle mainBundle] pathForResource:@"ai_face_processor" ofType:@"bundle"];
[FUAIKit loadAIModeWithAIType:FUAITYPE_FACEPROCESSOR dataPath:faceAIPath];

// 加载身体 AI 模型
NSString *bodyAIPath = [[NSBundle mainBundle] pathForResource:@"ai_human_processor" ofType:@"bundle"];
[FUAIKit loadAIModeWithAIType:FUAITYPE_HUMAN_PROCESSOR dataPath:bodyAIPath];

// 加载手势 AI 模型
NSString *handAIPath = [[NSBundle mainBundle] pathForResource:@"ai_hand_processor" ofType:@"bundle"];
[FUAIKit loadAIModeWithAIType:FUAITYPE_HANDGESTURE dataPath:handAIPath];

// 加载头发 AI 模型
NSString *hairAIPath = [[NSBundle mainBundle] pathForResource:@"ai_hairseg" ofType:@"bundle"];
[FUAIKit loadAIModeWithAIType:FUAITYPE_HAIRSEGMENTATION dataPath:hairAIPath];
```

## 设置显示View

FURenderKit 提供了显示渲染结果的 FUGLDisplayView 类（如果使用自定义渲染可忽略本步骤），用户可直接在外部初始化一个 FUGLDisplayView 实例，并赋值给 FURenderKit 单例。FURenderKit 会将渲染结果直接绘制到该 FUGLDisplayView 实例。示例代码如下：

```objective-c
// set glDisplayView
FUGLDisplayView *glDisplayView = [[FUGLDisplayView alloc] initWithFrame:self.view.bounds];
[self.view addSubview:glDisplayView];
[FURenderKit shareRenderKit].glDisplayView = glDisplayView;
[FURenderKit shareRenderKit].glDisplayView.contentMode = FUGLDisplayViewContentModeScaleAspectFit; //设置图像适配模式
```

用户也可以不将 FUGLDisplayView 实例赋值给 FURenderKit 单例，直接在外部使用 FUGLDisplayView 的相关接口显示图像。

## 内部相机

FURenderKit 提供了采集图像的 FUCaptureCamera 类（如果使用外部相机可忽略本步骤），用户可直接掉用下面的函数开启或关闭内部相机功能。

```objective-c
// 开启内部相机
[[FURenderKit shareRenderKit] startInternalCamera];

// 关闭内部相机
[[FURenderKit shareRenderKit] stopInternalCamera];
```

 FURenderKit 单例有一个 internalCameraSetting 实例，启动内部相机时会根据 internalCameraSetting 的参数配置相机，internalCameraSetting 具体属性及默认值如下，用户可以通过修改这些参数直接修改相机的相关属性：

```objective-c
@interface FUInternalCameraSetting : NSObject
@property (nonatomic, assign) int format; //default kCVPixelFormatType_32BGRA
@property (nonatomic, copy)  AVCaptureSessionPreset sessionPreset; // default AVCaptureSessionPreset1280x720
@property (nonatomic, assign) AVCaptureDevicePosition position; // default AVCaptureDevicePositionFront
@property (nonatomic, assign) int fps; // default 30

/// 如果使用内部相机时，SDK会自动判断当前是否需要使用系统相机，如果不需相机，内部会模拟一个相机并循环输出图像。
/// 该属性可以设置输出图像的宽高，默认宽高为：720x1280，如果设置为CGSizeZero,则会使用 sessionPreset 的宽高。
@property (nonatomic, assign) CGSize virtualCameraResolution;
@end
```

用户也可以直接使用 FUCaptureCamera 在外部初始化相机实例，并通过 FUCaptureCamera 相关接口获取图像，再将图像传入 FURenderKit 的渲染接口处理图像。

## 功能模块

### 美颜

#### 初始化美颜

使用 FUBeauty 类初始化美颜实例，并将美颜实例赋值给 FURenderKit 即可。

```objective-c
NSString *path = [[NSBundle mainBundle] pathForResource:@"face_beautification" ofType:@"bundle"];
FUBeauty *beauty = [[FUBeauty alloc] initWithPath:path name:@"face_beautification"];
[FURenderKit shareRenderKit].beauty = beauty;
```

#### 修改美颜参数

可以直接修改 FUBeauty 的相关属性，也可以初始化一个新的美颜实例，修改好参数后直接赋值给 FURenderKit；修改属性示例如下，属性对应的含义详见FUBeauty.h 注释：

```objective-c
beauty.blurUseMask = NO;
beauty.filterLevel = 1;
beauty.filterName = FUFilterOrigin;

beauty.colorLevel = 0.3;
beauty.redLevel = 0.3;
beauty.blurLevel = 0.7*6;
beauty.heavyBlur = 0;
beauty.blurType = 2;

beauty.sharpen = 0.2;
beauty.eyeBright = 0.0;
beauty.toothWhiten = 0.0;

beauty.removePouchStrength = 0.0;
beauty.removeNasolabialFoldsStrength = 0.0;

beauty.faceShapeLevel = 1.0;
beauty.changeFrames = 0;
beauty.faceShape = 4;

beauty.eyeEnlarging = 0.4;
beauty.cheekThinning = 0.0;
beauty.cheekV = 0.5;
beauty.cheekNarrow = 0;
beauty.cheekSmall = 0;
beauty.intensityNose = 0.5;
beauty.intensityForehead = 0.3;
beauty.intensityMouth = 0.4;
beauty.intensityChin = 0.3;
beauty.intensityPhiltrum = 0.5;
beauty.intensityLongNose = 0.5;
beauty.intensityEyeSpace = 0.5;
beauty.intensityEyeRotate = 0.5;
beauty.intensitySmile = 0.0;
beauty.intensityCanthus = 0.5;
beauty.intensityCheekbones = 0;
beauty.intensityLowerJaw= 0.0;
beauty.intensityEyeCircle = 0.0;
```

### 贴纸

使用 FUSticker或其子类初始化贴纸实例，FURenderKit 内部提供了一个 FUStickerContainer 类来管理贴纸，只需将贴纸实例添加、替换到 FUStickerContainer 实例即可实现贴纸的显示，然后可以掉用 FUStickerContainer 的删除接口移除贴纸效果。示例如下：

```objective-c
// 添加
NSString *path = [[NSBundle mainBundle] pathForResource:@"sdlu" ofType:@"bundle"];
FUSticker *sticker = [[FUSticker alloc] initWithPath:path name:@"sticker"];
[[FURenderKit shareRenderKit].stickerContainer addSticker:sticker];

// 替换
NSString *path1 = [[NSBundle mainBundle] pathForResource:@"gaoshiqing" ofType:@"bundle"];
FUSticker *sticker1 = [[FUSticker alloc] initWithPath:path1 name:@"sticker"];
[[FURenderKit shareRenderKit].stickerContainer replaceSticker:sticker withSticker:sticker1];

// 删除
[[FURenderKit shareRenderKit].stickerContainer removeSticker:sticker1];
```

### 海报换脸

使用 FUPoster 初始化一个海报换脸实例，与其他功能不同，不需要将海报换脸实例赋值给 FURenderKit，直接使用海报换脸实例掉用相关接口处理图像即可。示例代码待补充，详细注释可以查看 FUPoster.h 注释。

### 其他模块

FURenderKit 定义了不同功能的模型类，除了贴纸和海报换脸，其他功能的使用与美颜类似，用户只需要初始化对应功能的实例，并赋值给 FURenderKit ，然后通过修改对应示例的属性或调用相关接口即可实现功能的配置，具体文档待补充。

## 渲染接口

### 输入

FURenderKit 定义了 FURenderInput 类作为输入，该类的具体定义如下：

```objective-c
@interface FURenderInput : NSObject

/// 输入的纹理
@property (nonatomic, assign) FUTexture texture;

/// 输入的 pixelBuffer
@property (nonatomic, assign) CVPixelBufferRef pixelBuffer;

/// 输入的 imageBuffer，如果同时传入了 pixelBuffer，将优先使用 pixelBuffer
/// 输入 imageBuffer，在 renderConfig 的 onlyOutputTexture 为 NO 时，render 结果会直接读会输入的 imageBuffer，大小格式与输入均保持一致。
@property (nonatomic, assign) FUImageBuffer imageBuffer;

/// 设置render相关的输入输出配置，详细参数请查看 FURenderConfig 类的接口注释。
@property (nonatomic, strong) FURenderConfig *renderConfig;

@end
```

用户可以根据自己代码中的数据，选择输入一种或多种格式的图像，如果传入多种格式时，如果同时传入了 pixelBuffer 和 imageBuffer，会优先使用 pixelBuffer 进行图像处理。FUTexture 及 FUImageBuffer相关属性，请查看相关头文件。

### 配置

FURenderInput 中有一个 FURenderConfig 类，该类用来配置一些输入及输出的相关设置，具体定义如下：

```objective-c
@interface FURenderConfig : NSObject

/// 自定义输出结果的大小，当前只会对输出的纹理及pixelBuffer有效
@property (nonatomic, assign) CGSize customOutputSize;

/// 当前图片是否来源于前置摄像头
@property (nonatomic, assign) BOOL isFromFrontCamera;

/// 设置输入纹理的旋转方向，设置该属性会影响输出纹理的方向。由于默认创建的纹理是倒着的，所以该参数的默认值为 CCROT0_FLIPVERTICAL，如已转正，请将该参数设置为 DEFAULT
@property (nonatomic, assign) TRANSFORM_MATRIX textureTransform;

/// 设置输入pixelBuffer/imageBuffer的旋转方向，以使buffer数据与textureTransform作用后纹理的方向一致，该参数仅用于AI算法检测，不会改变buffer的方向或镜像属性
@property (nonatomic, assign) TRANSFORM_MATRIX bufferTransform;

/// 是否渲染到当前的FBO，设置为YES时，返回的 FURenderOutput 内的所有数据均为空值。
@property (nonatomic, assign) BOOL renderToCurrentFBO;

/// 设置为YES 且 renderToCurrentFBO 为 NO 时，只会输出纹理，不会输出CPU层的图像。
@property (nonatomic, assign) BOOL onlyOutputTexture;

@end
```

### 输出

FURenderKit 定义了 FURenderOutput 类作为输出，该类的具体定义如下：

```objective-c
@interface FURenderOutput : NSObject

/// 输出的纹理
@property (nonatomic, assign) FUTexture texture;

/// 输出的 pixelBuffer
@property (nonatomic, assign) CVPixelBufferRef pixelBuffer;

/// 输出的 imageBuffer，内部数据与输入的 imageBuffer 一致。
@property (nonatomic, assign) FUImageBuffer imageBuffer;

@end
```

输出的图像类型及个数与输入相同。

### 内部渲染回调

FURenderKit 定义了一个 FURenderKitDelegate 协议，该协议包含两个接口，一个是使用内部相机时即将处理图像时输入回调，另一个是使用内部相机时处理图像后的输出回调

```objective-c
// 使用内部相机时，即将处理图像时输入
- (void)renderKitWillRenderFromRenderInput:(FURenderInput *)renderInput;

// 使用内部相机时，处理图像后的输出
- (void)renderKitDidRenderToOutput:(FURenderOutput *)renderOutput;
```

### 外部渲染接口

FURenderKit 提供了下面的接口处理图像，用户可以在外部将图像传入该接口获取处理之后的图像。

```
- (FURenderOutput *)renderWithInput:(FURenderInput *)input;
```

示例如下：

```objective-c
FURenderInput *renderInput = [[FURenderInput alloc] init];
renderInput.pixelBuffer = pixelBuffer;
FURenderOutput *renderOutput = [[FURenderKit shareRenderKit] renderWithInput:renderInput];
return renderOutput.pixelBuffer;
```

## 其他功能

待补充，详情可以查看相关头文件及其注释。
