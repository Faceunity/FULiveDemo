#  Quick Integration Documentation

## Initialization

```objective-c
// Initialize FURenderKit 
FUSetupConfig *setupConfig = [[FUSetupConfig alloc] init];
setupConfig.authPack = FUAuthPackMake(g_auth_package, **sizeof**(g_auth_package));
[FURenderKit setupWithSetupConfig:setupConfig];
```

## Load AI Model

```objective-c
// Load Face AI Model
NSString *faceAIPath = [[NSBundle mainBundle] pathForResource:@"ai_face_processor" ofType:@"bundle"];
[FUAIKit loadAIModeWithAIType:FUAITYPE_FACEPROCESSOR dataPath:faceAIPath];

// Load Body AI Model
NSString *bodyAIPath = [[NSBundle mainBundle] pathForResource:@"ai_human_processor" ofType:@"bundle"];
[FUAIKit loadAIModeWithAIType:FUAITYPE_HUMAN_PROCESSOR dataPath:bodyAIPath];

// Load Gesture AI Model
NSString *handAIPath = [[NSBundle mainBundle] pathForResource:@"ai_hand_processor" ofType:@"bundle"];
[FUAIKit loadAIModeWithAIType:FUAITYPE_HANDGESTURE dataPath:handAIPath];

// Load Hair AI Model
NSString *hairAIPath = [[NSBundle mainBundle] pathForResource:@"ai_hairseg" ofType:@"bundle"];
[FUAIKit loadAIModeWithAIType:FUAITYPE_HAIRSEGMENTATION dataPath:hairAIPath];
```



## Set Display View

FURenderKit provides the class of FUGLDisplayView to display the rendering results (this step can be ignored if using custom rendering). The user can directly initialize an instance of FUGLDisplayView externally and assign a value to the single instance of FURenderKit. FURenderKit draws the rendering results directly to the instance of the FUGLDisplayView. The example code is as follows:


```objective-c
// set glDisplayView
FUGLDisplayView *glDisplayView = [[FUGLDisplayView alloc] initWithFrame:self.view.bounds];
[self.view addSubview:glDisplayView];
[FURenderKit shareRenderKit].glDisplayView = glDisplayView;
[FURenderKit shareRenderKit].glDisplayView.contentMode = FUGLDisplayViewContentModeScaleAspectFit; //Set image adaptation mode
```

The user can also directly use the relevant interface of the FUGLDisplayView to display images externally without assigning the instance of the FUGLDisplayView to the single instance of the FURenderKit.


## Interior Camera

FURenderKit provides the FUCaptureCamera class to collect images (if you use an external camera, this step can be ignored). Users can directly use the following functions to turn on or off the internal camera function.

```objective-c
// Turn on the internal camera
[[FURenderKit shareRenderKit] startInternalCamera];

// Turn off the internal camera
[[FURenderKit shareRenderKit] stopInternalCamera];
```

**The FURenderKit singleton has an internalCameraSetting instance. When the internal camera is activated, the camera will be configured according to the parameters of internalCameraSetting. The specific properties and default values of internalCameraSetting are as follows. Users can directly modify the related properties of the camera by modifying these parameters：**


```objective-c
@interface FUInternalCameraSetting : NSObject
@property (nonatomic, assign) int format; //default kCVPixelFormatType_32BGRA
@property (nonatomic, copy)  AVCaptureSessionPreset sessionPreset; // default AVCaptureSessionPreset1280x720
@property (nonatomic, assign) AVCaptureDevicePosition position; // default AVCaptureDevicePositionFront
@property (nonatomic, assign) int fps; // default 30
// default NO, It should be noted that when the internal virtual camera is turned on, if the user uses the Scene related function that needs a real camera, the internal will automatically turn on the real camera, and when the user turns off the Scene related function, the internal will automatically turn off.
@property (nonatomic, assign) BOOL useVirtualCamera; 

/// If the internal camera is used, the SDK will automatically determine whether a system camera is needed. If camera is not needed, the internal camera will be simulated and the image will be output circularly.
/// This attribute can set the width and height of the output image. The default width and height is 720x1280. If CGSizeZero is set, the width and height of sessionPreset will be used.
@property (nonatomic, assign) CGSize virtualCameraResolution;
@end
```

**Users can also directly use FUCaptureCamera to initialize the camera instance externally, obtain the image through the relevant interface of FUCaptureCamera, and then transfer the image to the rendering interface of FURenderKit to process the image. **




## FURenderKit Main Interface Description:

### Rendering Interface

#### 1. Input

FURenderKit defines the class of FURenderInput as input. The specific definition of this class is as follows:

```objective-c
@interface FURenderInput : NSObject

/// Input texture
@property (nonatomic, assign) FUTexture texture;

/// Input pixelBuffer
@property (nonatomic, assign) CVPixelBufferRef pixelBuffer;

/// Input imageBuffer If pass in pixelBuffer at the same time, pixelBuffer will be used first.
/// Input imageBuffer. When onlyOutputTexture in renderConfig is NO，The render result will read the input imageBuffer directly, and the size format is consistent with the input. 
@property (nonatomic, assign) FUImageBuffer imageBuffer;

///Set the input and output configuration related to render. For detailed parameters, please see the interface notes of the FURenderConfig  class.
@property (nonatomic, strong) FURenderConfig *renderConfig;

@end
```

Users can choose to input one or more formats of images according to the data in their own code. When multiple formats are imported, if both pixelBuffer and imageBuffer are imported at the same time, pixelBuffer will be used first for image processing. For FUTexture and FUImageBuffer related properties, please check the related header file.


### 2. Configuration

There is a  FURenderConfig class in FURenderInput, which is used to configure some input and output related settings. The specific definitions are as follows：

```objective-c
@interface FURenderConfig : NSObject

// Customize the size of the output result. Currently, it is only valid for the output texture and pixelBuffer
@property (nonatomic, assign) CGSize customOutputSize;

// Whether the current picture come from the front camera
@property (nonatomic, assign) BOOL isFromFrontCamera;

// Orientation of the original image
@property (nonatomic, assign) FUImageOrientation imageOrientation;

// Gravity switch. Turn on this function to automatically adapt the AI detection direction according to the set imageRotation.
@property (nonatomic, assign) BOOL gravityEnable;

// Setting to YES, only beauty will take effect.
@property (nonatomic, assign) BOOL onlyRenderBeauty;

// Set the direction of rotation of the input texture, and setting this attribute affects the direction of the output texture. Since the texture created by default is inverted, the default value for this parameter is CCROT0_FLIPVERTICAL, if it has been corrected, set the parameter to DEFAULT
@property (nonatomic, assign) TRANSFORM_MATRIX textureTransform;

// Set the rotation direction of the input pixelBuffer / imageBuffer to make the buffer data consistent with the direction of the texture after textureTransform. This parameter is only used for AI algorithm detection, and does not change the direction or image attribute of the buffer
@property (nonatomic, assign) TRANSFORM_MATRIX bufferTransform;

// Whether to render to the current FBO or not When it is set to YES, all data in the returned FURenderOutput are null.
@property (nonatomic, assign) BOOL renderToCurrentFBO;

// When it is set to YES and renderToCurrentFBO is NO, only texture will be output, not CPU layer image.
@property (nonatomic, assign) BOOL onlyOutputTexture;

@end
  
```

### 3. Output

FurenderKit defines the class of FURenderOutput as output. The specific definition of this class is as follows: the type and number of output images are the same as the input.

```objective-c
@interface FURenderOutput : NSObject

// Set the rotation direction of the input texture, which affects the direction of the output texture. Since the texture created by default is inverted, the default value of this parameter is CCROT0_FLIPVERTICAL. If it has been transferred to regular, please set the parameter to default
@property (nonatomic, assign) TRANSFORM_MATRIX textureTransform;

// Set the rotation direction of the input pixelBuffer/imageBuffer to make the buffer data consistent with the direction of the texture after texture transform. This parameter is only used for AI algorithm detection, and does not change the direction or image attribute of the buffer
@property (nonatomic, assign) TRANSFORM_MATRIX bufferTransform;

// Set the rotation direction of the input pixelBuffer/imageBuffer to make the buffer data consistent with the direction of the texture after texture transform. This parameter is only used for AI algorithm detection, and does not change the direction or image attribute of the buffer
@property (nonatomic, assign) TRANSFORM_MATRIX outputTransform;

// Output texture
@property (nonatomic, assign) FUTexture texture;

// Output pixelBuffer
@property (nonatomic, assign) CVPixelBufferRef pixelBuffer;

// Output imageBuffer，the internal data of which is consistent with the input imageBuffer.
@property (nonatomic, assign) FUImageBuffer imageBuffer;

@end
```



### Internal Render Callback

FURenderKit defines a FURenderKitDelegate protocol, which includes three interfaces: one is the input callback when the internal camera is used to process the image, the other is the output callback when the internal camera is used to process the image

```objective-c
// When using the internal camera, that is to say, when processing the image to input 
- (void)renderKitWillRenderFromRenderInput:(FURenderInput *)renderInput;

// When using the internal camera, the output after processing the image
- (void)renderKitDidRenderToOutput:(FURenderOutput *)renderOutput;

// When using the internal camera, whether to render the internal camera or not. Return No，renderKitDidRenderToOutput interface will output the original image directly. Return YES, renderKitDidRenderToOutput interface output with rendering props
- (BOOL)renderKitShouldDoRender;
```

### External Rendering Interface

FURenderKit provides the following interface to process the image. Users can transfer the image to the interface to obtain the processed image.

```
- (FURenderOutput *)renderWithInput:(FURenderInput *)input;
```

Example：

```objective-c
FURenderInput *renderInput = [[FURenderInput alloc] init];
renderInput.pixelBuffer = pixelBuffer;
FURenderOutput *renderOutput = [[FURenderKit shareRenderKit] renderWithInput:renderInput];
return renderOutput.pixelBuffer;
```



## Turn on / off the camera

```objective-c
#pragma mark - internalCamera

- (void)startInternalCamera;

- (void)stopInternalCamera;
```



## Verify module authority according to certificate

```objective-c
/**
 * Get the module permissions in the certificate
 * code get i-th code, currently available for 0 and 1
 */
+ (int)getModuleCode:(int)code;
```



## Destroy

#### Internally, the camera and various rendering models (beauty, makeup, props, stickers, etc.) will be destroyed, the AI resources will be released, and the underlying resources will be destroyed

```objective-c
- (void)destroy
```



## Eliminate

#### It is differ from destory. Only the rendering models (beauty, makeup, props, stickers, etc.) will be cleared, and others will not be processed.

```objective-c
+ (void)clear;
```



## Video and Photo-Taking

```objective-c
#pragma mark - Record && capture
//Press the video button to call
+ (void)startRecordVideoWithFilePath:(NSString *)filePath;
//Release the video button to call
+ (void)stopRecordVideoComplention:(void(^)(NSString *filePath))complention;
//Capture the current frame as a picture
+ (UIImage *)captureImage;
```



## FUAIKit

AI capability related functions are loaded or acquired through FUAIKit

Introduction to some interfaces and properties

```objective-c
@property (nonatomic, assign) int maxTrackFaces; // Set the maximum number of face tracking default is 1

@property (nonatomic, assign, readonly) int trackedFacesCount; // Number of faces tracked

@property (nonatomic, assign) FUFaceProcessorDetectMode faceProcessorDetectMode; // Image loading mode default is FUFaceProcessorDetectModeVideo

@property (nonatomic, assign) BOOL asyncTrackFace; //Set whether to do asynchronous face tracking

//Load AI bundle
+ (void)loadAIModeWithAIType:(FUAITYPE)type dataPath:(NSString *)dataPath;
//Uninstall AI bundle
+ (void)unloadAIModeForAIType:(FUAITYPE)type;
//Uninstall all AI bundle
+ (void)unloadAllAIMode;

+ (BOOL)loadedAIType:(FUAITYPE)type;
//Load tongue drive
+ (void)loadTongueMode:(NSString *)modePath;
//Face types are loaded separately
+ (void)setTrackFaceAIType:(FUAITYPE)type;

+ (int)trackFaceWithInput:(FUTrackFaceInput *)trackFaceInput;
// Reset ai model HumanProcessor's tracking state.
+ (void)resetHumanProcessor;
//get ai model HumanProcessor's tracking result.
+ (int)aiHumanProcessorNums;
```

Other interface references  FUAIKit.h 



## Functional Module： The name of the bundle loaded by the function module can be defined by itself, and the name of the sample code is loaded according to the name defined by itself

### Face Beauty

#### Initialize Face Beauty

Use FUBeauty class to initialize the beauty instance, and assign the beauty instance to FURenderKit. The internal processing is synchronous thread serial queue processing, which will take time. External users can use thread management by themselves.

```objective-c
NSString *path = [[NSBundle mainBundle] pathForResource:@"face_beautification" ofType:@"bundle"];
FUBeauty *beauty = [[FUBeauty alloc] initWithPath:path name:@"face_beautification"];
[FURenderKit shareRenderKit].beauty = beauty;

```

#### Modify Beauty Parameters

You can directly modify the relevant properties of FUBeauty, or initialize a new beauty instance. After modifying the parameters, you can directly assign the value to FURenderKit; An example of modifying an attribute is as follows. See fubeauty.h note for the meaning of the attribute

```objective-c
beauty.blurUseMask = NO;
The value FURenderKit corresponding to the filter FileName has done the corresponding mapping relationship. You can call it directly
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



### Stickers

Use FUSticker or its subclass to initialize the sticker instance. A FUStickerContainer class is provided in the FURenderKit to manage the sticker. Just add and replace the sticker instance to the FUStickerContainer instance to realize the display of the sticker, and then use the delete interface of FUStickerContainer to remove the sticker effect. Examples are as follows:

```objective-c
// Add
NSString *path = [[NSBundle mainBundle] pathForResource:@"sdlu" ofType:@"bundle"];
FUSticker *sticker = [[FUSticker alloc] initWithPath:path name:@"sticker"];
[[FURenderKit shareRenderKit].stickerContainer addSticker:sticker];

// Replace
NSString *path1 = [[NSBundle mainBundle] pathForResource:@"gaoshiqing" ofType:@"bundle"];
FUSticker *sticker1 = [[FUSticker alloc] initWithPath:path1 name:@"sticker"];
[[FURenderKit shareRenderKit].stickerContainer replaceSticker:sticker withSticker:sticker1 completion:nil];

// Delete
[[FURenderKit shareRenderKit].stickerContainer removeSticker:sticker1];
```

Special sticker description with attributes:

```objective-c
1. Portrait Segmentation FUAISegment - How to use outer contour bundle
NSString *path = [[NSBundle mainBundle] pathForResource:@"human_outline" ofType:@"bundle"];
FUAISegment *outline = [FUAISegment alloc] initWithPath:path name:@"sticker"];
outline.lineGap = 2.8; //The distance between the contour line and the person
outline.lineSize = 2.8; //The width of contour split line 
outline.lineColor = FUColorMake(255/255.0, 180/255.0, 0.0, 0.0); //line color
[[FURenderKit shareRenderKit].stickerContainer addSticker:outline];

1. Portrait Segmentation FUAISegment - Custom background video
NSString *path = [[NSBundle mainBundle] pathForResource:@"bg_segment" ofType:@"bundle"];
FUAISegment *segment = [FUAISegment alloc] initWithPath:path name:@"sticker"];
segment.videoPath = @“Background video path”;//NSURL or NSString
[segment startVideoDecode];
//Get the first picture of video parsing
UIImage *image = [segment readFirstFrame];
[[FURenderKit shareRenderKit].stickerContainer replaceSticker:outline withSticker:segment completion:nil];

1. Portrait Segmentation FUAISegment - Custom background photo
segment.setBackgroundImage = @"Custom photo";

2. FUAnimoji - expression
NSString *path = [[NSBundle mainBundle] pathForResource:@"animoji" ofType:@"bundle"];
FUAnimoji *animoji = [FUAnimoji alloc] initWithPath:path name:@"animoji"];
animoji.flowEnable = YES; //Whether the cartoon expression follow the character's movement， YES，follow， NO, don't follow

3. FUGesture -- Gesture
NSString *path = [[NSBundle mainBundle] pathForResource:@"fugesture" ofType:@"bundle"];
FUGesture *gesture = [FUGesture alloc] initWithPath:path name:@"animoji"];
gesture.handOffY = YES; //The offset of the comparison center can be adjusted separately, > 0 up and < 0 down

4. FUMusicFilter - Music Filter
NSString *path = [[NSBundle mainBundle] pathForResource:@"music" ofType:@"bundle"];
FUMusicFilter *music = [FUMusicFilter alloc] initWithPath:path name:@"music"];
music.musicPath = "music file path";
```





### Poster Face Transfer

Use FUPoster to initialize a poster face changing instance. Different from other functions, you don't need to assign the poster face changing instance to FURenderKit. You can directly use the poster face changing instance to process the image by using the relevant interface.

Example Code:

```objective-c
[FUAIKit shareKit].maxTrackFaces = 4;

[FUAIKit shareKit].faceProcessorDetectMode = 0;

NSString *path = [[NSBundle mainBundle] pathForResource:@"change_face" ofType:@"bundle"];
FUPoster *poster = [[FUPoster alloc] initWithPath:path name:@"change_face"];
poster.delegate = "The class that implements the proxy";

[poster renderWithInputImage:"Image in need of face transfer" templateImage: "poster image"]];
```

#### Interface

```objective-c
/**
 * inputImage: Need to replace the face picture
 * templateImage: The background template contains images of faces
 */
- (void)renderWithInputImage:(UIImage *)inputImage templateImage:(UIImage *)templateImage;

/**
 * Replace background image
 */
- (void)changeTempImage:(UIImage *)tempImage;

/**
 * Calculate face region
 */
+ (CGRect)cacluteRectWithIndex:(int)index height:(int)originHeight width:(int)orighnWidth;

/**
 * Select a specific face，
 * Get faceId via checkPosterWithFaceIds:rectsMap
 */
- (void)chooseFaceID:(int)faceID;


@protocol FUPosterProtocol <NSObject>

@optional
/**
 * Detect the abnormal call of the face result of the input photo, which is used to handle the UI logic of the abnormal prompt.
 * code: -1, Abnormal face (face detected but angle incorrect, return - 1)，0: No face detected
 */
- (void)poster:(FUPoster *)poster inputImageTrackErrorCode:(int)code;

/**
 * Face detection result of poster template background image (abnormal call)
 * code: -1, Abnormal face (face detected but angle incorrect, return - 1) 0: No face detected
 */
- (void)poster:(FUPoster *)poster tempImageTrackErrorCode:(int)code;

/**
 * When the input photo detects multiple faces, the method is called back to draw the multi face UI at UI layer
 */
- (void)poster:(FUPoster *)poster trackedMultiFaceInfos:(NSArray <FUFaceRectInfo *> *)faceInfos;

/**
 *  Result callback of inputimage and mask image synthesis
 *  data : Image data after poster mask and photo synthesis
 */

- (void)poster:(FUPoster *)poster didRenderToImage:(UIImage *)image;

/**
 * To set the bending of the template, external input is required
 * return double object
 */
- (NSNumber *)renderOfWarp;
```



## Other Modules

FURenderKit defines the model classes of different functions. Except for sticker and poster face changing, the use of other functions is similar to beauty. Users only need to initialize the instance of the corresponding function and assign the value to FURenderKit, and then configure the function by modifying the properties of the corresponding instance or calling the relevant interface. The specific document needs to be supplemented.


