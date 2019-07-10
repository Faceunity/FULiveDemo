# iOS Nama Objective-C API Reference


### Contents：
[TOC]

------
### 1. Introduction 
This document is the infrastructure layer interface for FaceUnity face tracking and video effects development kit (Nama SDK for short). The Nama API in this document is the Native interface for direct development on PC/iOS/Android NDK/Linux. Development on the iOS and Android platforms can use the SDK's application-level interface (Objective-C/Java), which is closer to the platform-related development experience than the infrastructure layer interface in this article.

All SDK-related calls require sequential execution in the same thread, without support for multithreading. A small number of interfaces can be called asynchronously (such as props loading) and will be specifically noted in the remarks. Interfaces called by all main threads of the SDK need to keep the OpenGL context consistent, otherwise it will cause texture data exceptions. If you need to use the SDK's rendering function, all calls to the main thread need to pre-initialize the OpenGL environment, without initialization or incorrect initialization will cause a crash. Our environment requirement for OpenGL is GLES 2.0 or higher. For the specific call method, please refer to each platform demo.*

The infrastructure layer interface is classified into five categories according to the role of logic: initialization, propsloading, main running interface, destruction, functional interface, P2A related interface.

------
### 2. APIs
#### 2.1 Initialization
##### setupWithData: dataSize: ardata: authPackage: authSize: 
Initialize the system environment, load system data, and perform network authentication. Must be executed before calling other interfaces of the SDK, otherwise it will cause a crash.

```objective-c
- (void)setupWithData:(void *)data dataSize:(int)dataSize ardata:(void *)ardata authPackage:(void *)package authSize:(int)size;

```

__Parameter:__

*data*： memory pointer, the binary data address corresponding to v3.bundle

*dataSize*: V3.bundle file bytes

*ardata*： abandoned

*package*： a memory pointer that points to the contents of the authentication data. If you provide authentication data at compile time with a method that includes authpack.h , you can write it here as g_auth_package .

*size*：The length of the authentication data, in bytes. If the authentication data is provided by g_auth_package in authpack.h, it can be written as sizeof(g_auth_package)

__Return Value:__

Returns a non-zero value for success and 0 for failure. If initialization fails, get the error code via ```fuGetSystemError```

------

##### setupWithData: dataSize: ardata: authPackage: authSize: shouldCreateContext: 

Initialize the system environment, load system data, and perform network authentication. Must be executed before calling other interfaces of the SDK, otherwise it will cause a crash.

```objective-c
- (void)setupWithData:(void *)data dataSize:(int)dataSize ardata:(void *)ardata authPackage:(void *)package authSize:(int)size shouldCreateContext:(BOOL)shouldCreate;
```

__Parameter:__

data*： memory pointer, the binary data address corresponding to v3.bundle

*dataSize*: V3.bundle file bytes

*ardata*： abandoned

*package*： a memory pointer that points to the contents of the authentication data. If you provide authentication data at compile time with a method that includes authpack.h , you can write it here as g_auth_package .

*size*：the length of the authentication data, in bytes. If the authentication data is provided by g_auth_package in authpack.h, it can be written as sizeof(g_auth_package)

*shouldCreate*: if set to YES, we will create and hold an EAGLContext internally, in which case we must use the OC layer interface.

__Return Value:__

Returns a non-zero value for success and 0 for failure. If initialization fails, get the error code via ```fuGetSystemError```

------

##### setupWithDataPath: authPackage: authSize: shouldCreateContext: 

Initialize the system environment, load system data, and perform network authentication. Must be executed before calling other interfaces of the SDK, otherwise it will cause a crash.

```objective-c
- (void)setupWithDataPath:(NSString *)v3path authPackage:(void *)package authSize:(int)size shouldCreateContext:(BOOL)shouldCreate;

```

__Parameter:__

*v3path*：  File path corresponding to v3.bundle

*package*： a memory pointer that points to the contents of the authentication data. If you provide authentication data at compile time with a method that includes authpack.h , you can write it here as g_auth_package .

*size*：the length of the authentication data, in bytes. If the authentication data is provided by g_auth_package in authpack.h, it can be written as sizeof(g_auth_package)

*shouldCreate*: if set to YES, we will create and hold an EAGLContext internally, in which case we must use the OC layer interface.

__Return Value:__

Returns a non-zero value for success and 0 for failure. If initialization fails, get the error code via ```fuGetSystemError```

------

#### 2.2 Load&Destroy props

Load the prop package so that it can be executed in the main run interface. A prop package may be a function module or a collection of multiple function modules. The prop loading package may activate the corresponding function module and implement plug and play in the same SDK calling logic.

##### itemWithContentsOfFile： 

``` objective-c
+ (int)itemWithContentsOfFile:(NSString *)path
```

__Parameter:__

*path*： the path to the prop file. The prop package usually ends with *.bundle.

__Return Value:__

an integer handle that acts as an identifier for the prop within the system.

__Comment:__

This interface can be executed asynchronously with the main thread. In order to reduce the loader blocking the main thread, it is recommended to call this interface asynchronously.

------

##### createItemFromPackage: size: 

Load the prop package so that it can be executed in the main run interface. A prop package may be a function module or a collection of multiple function modules. The prop loading package may activate the corresponding function module and implement plug and play in the same SDK calling logic.

```objective-c
+ (int)createItemFromPackage:(void*)data size:(int)size
```

__Parameter:__

*data*：the path to the prop file. The prop package usually ends with *.bundle.

*size*： file size

__Return Value:__

an integer handle that acts as an identifier for the prop within the system.

------

##### destroyItem: 

 Destroy a single prop：

​     \- Destroy the prop with the prop handle and release the relevant resources

​     \- After destroying the prop, set the prop handle to 0 to avoid the SDK from using an invalid handle and causing a program error.

```objective-c
+ (void)destroyItem:(int)item
```

__Parameter:__

*item*： prop handle

------

##### destroyAllItems

 Destroy all the props： 

​      \- Destroy the prop with the prop handle and release the relevant resources

​     \- After destroying the prop, set the prop handle to 0 to avoid the SDK from using an invalid handle and causing a program error.

```objective-c
+ (void)destroyAllItems;
```

------

##### onCameraChange

This interface needs to be called when switching cameras. We will reset some states of face detection internally.

```objective-c
+ (void)onCameraChange;
```

------

##### OnDeviceLost

This interface needs to be called when destroying all items. We will internally destroy OpenGL resources in each instruction.

```objective-c
+ (void)OnDeviceLost;
```

------

####2.3 Item Parameter

Modify or set the value of the variable in the item package. The props package variable name, meaning, and value range that can be supported need to refer to the prop documentation.

##### itemSetParam:  withName: value: 

Set NSString and NSNumber type Parameter for the prop:

```objective-c
+ (int)itemSetParam:(int)item withName:(NSString *)name value:(id)value;

```

__Parameter:__

*item*： the item handle, the content should be the Return Value of the itemWithContentsOfFile function, and the item content is not destroyed.

*name*：String pointer, the content is the name of the item variable to be set.

*value*：Parameter value：only support NSString 、 NSNumber 

__Return Value:__

Returns a non-zero value for success and 0 for failure

------

##### itemSetParamdv: withName: value: length:

Set double array Parameter for props

```objective-c
+ (int)itemSetParamdv:(int)item withName:(NSString *)name value:(double *)value length:(int)length;
```

__Parameter:__

*item*： the item handle, the content should be the Return Value of the itemWithContentsOfFile function, and the item content is not destroyed.

*name*：String pointer, the content is the name of the item variable to be set.

*value*：Parameter value：double array.

*length*：When the variable is set to a double array, the length of the array data is in units of double.

__Return Value:__

Returns a non-zero value for success and 0 for failure

-------

##### itemSetParamu8v: withName: buffer: size: 

Set a double-precision array Parameter for the prop

```objective-c
+ (int)itemSetParamu8v:(int)item withName:(NSString *)name buffer:(void *)buffer size:(int)size;
```

__Parameter:__

*item*： Item handle.

*name*：String pointer, the content is the name of the item variable to be set.

*buffer*：The Parameter value points to a double array.

*size*：Specifies the number of elements in the value.

__Return Value:__

Returns a non-zero value for success and 0 for failure

------

##### getStringParamFromItem:  withName:  

 Get the NSString type Parameter value from the item.

```objective-c
+ (NSString *)getStringParamFromItem:(int)item withName:(NSString *)name;
```

__Parameter:__

*item*： Item handle.

*name*：Parameter value.

__Return Value:__

Parameter value

------

##### getDoubleParamFromItem: withName:  

Get the double type Parameter value from the prop,

```objective-c
+ (double)getDoubleParamFromItem:(int)item withName:(NSString *)name
```

__Parameter:__

*item*： Item handle.

*name*：Parameter value.

__Return Value:__

Parameter value.

------

##### getDoubleParamFromItem: withName:  

 Get the double type Parameter value from the prop,

```objective-c
+ (int)itemGetParamu8v:(int)item withName:(NSString *)name buffer:(void *)buffer size:(int)size
```

__Parameter:__

*item*： Item handle.

*name*：Parameter value.

__Return Value:__

Parameter value.

------

#### 2.4 Video image processing 

Video image processing interface, while adding the prop package and the image to be processed, you can add special effects to the image.

##### renderPixelBuffer: withFrameId: items: itemCount:

render the items in items into pixelBuffer

```objective-c
- (CVPixelBufferRef)renderPixelBuffer:(CVPixelBufferRef)pixelBuffer withFrameId:(int)frameid items:(int*)items itemCount:(int)itemCount
```

__Parameter:__

*pixelBuffer*:  Image data, supported formats are: BGRA, YUV420SP

*frameid*:  The currently processed video frame number, each time it is processed to add 1 operation, without adding 1 will not be able to drive the effect animation in the prop

*items* : An int array containing multiple item handles, including common items, beauty items, gesture items, etc.

*itemCount*:  The number of handles contained in the handle array

*size*:  prop image , if set to YES, the prop can be mirrored

__Return Value:__

The processed image data is the same pixelBuffer as the incoming pixelBuffer.

------

##### renderPixelBuffer: withFrameId: items: itemCount: flipx:

render the items in items into pixelBuffer

```objective-c
- (CVPixelBufferRef)renderPixelBuffer:(CVPixelBufferRef)pixelBuffer withFrameId:(int)frameid items:(int*)items itemCount:(int)itemCount flipx:(BOOL)flip;
```

__Parameter:__

*pixelBuffer*:  Image data, supported formats are: BGRA, YUV420SP

*frameid*:  The currently processed video frame number, each time it is processed to add 1 operation, without adding 1 will not be able to drive the effect animation in the prop

*items* : An int array containing multiple item handles, including common items, beauty items, gesture items, etc.

*itemCount*:  The number of handles contained in the handle array

*size*:  prop image , if set to YES, the prop can be mirrored

__Return Value:__

The processed image data is the same pixelBuffer as the incoming pixelBuffer.

------

##### renderPixelBuffer: withFrameId: items: itemCount: flipx: customSize:

Customizable output resolution

```objective-c
- (CVPixelBufferRef)renderPixelBuffer:(CVPixelBufferRef)pixelBuffer withFrameId:(int)frameid items:(int*)items itemCount:(int)itemCount flipx:(BOOL)flip customSize:(CGSize)customSize;
```

__Parameter:__

*pixelBuffer*:  Image data, supported formats are: BGRA, YUV420SP

*frameid*:  The currently processed video frame number, each time it is processed to add 1 operation, without adding 1 will not be able to drive the effect animation in the prop

*items* : An int array containing multiple item handles, including common items, beauty items, gesture items, etc.

*itemCount*:  The number of handles contained in the handle array

*size*:  prop image , if set to YES, the prop can be mirrored

*customSize*: Custom output resolution, currently only supports BGRA format

__Return Value:__

The processed image data is not the same pixelBuffer as the incoming pixelBuffer.

------

##### renderToInternalPixelBuffer: withFrameId: items: itemCount:

render the items in items into a new pixelBuffer, the output is not the same as the input pixelBuffer

```objective-c
- (CVPixelBufferRef)renderToInternalPixelBuffer:(CVPixelBufferRef)pixelBuffer withFrameId:(int)frameid items:(int*)items itemCount:(int)itemCount
```

__Parameter:__

*pixelBuffer*:  Image data, supported formats are: BGRA, YUV420SP

*frameid*:  The currently processed video frame number, each time it is processed to add 1 operation, without adding 1 will not be able to drive the effect animation in the prop

*items* : An int array containing multiple item handles

*itemCount*:  The number of handles contained in the handle array

__Return Value:__

The processed image data is not the same pixelBuffer as the incoming pixelBuffer.

------

##### renderPixelBuffer: bgraTexture: withFrameId: items: itemCount:

​     \- render items in items into textureHandle and pixelBuffer

​     \- This interface is suitable for users who can input GLES texture and pixelBuffer at the same time. The pixelBuffer here is mainly used for face detection on the CPU. If only GLES texture is used, this interface will not work.

```objective-c
- (FUOutput)renderPixelBuffer:(CVPixelBufferRef)pixelBuffer bgraTexture:(GLuint)textureHandle withFrameId:(int)frameid items:(int *)items itemCount:(int)itemCount;
```

__Parameter:__

*pixelBuffer*:  Image data, supported formats: BGRA, YUV420SP, for face recognition

*textureHandle*:  textureID under the user's current EAGLContext for image processing

*frameid*:  The currently processed video frame number, each time it is processed to add 1 operation, without adding 1 will not be able to drive the effect animation in the prop

*items* : An int array containing multiple item handles

*itemCount*:  The number of handles contained in the handle array

__Return Value:__

Processed image data

------

##### renderPixelBuffer: bgraTexture: withFrameId: items: itemCount: flipx:

```objective-c
- (FUOutput)renderPixelBuffer:(CVPixelBufferRef)pixelBuffer bgraTexture:(GLuint)textureHandle withFrameId:(int)frameid items:(int *)items itemCount:(int)itemCount flipx:(BOOL)flip;
```

__Parameter:__

*pixelBuffer*:  Image data, supported formats: BGRA, YUV420SP, for face recognition

*textureHandle*:  textureID under the user's current EAGLContext for image processing

*frameid*:  The currently processed video frame number, each time it is processed to add 1 operation, without adding 1 will not be able to drive the effect animation in the prop

*items* : An int array containing multiple item handles

*flip*:  prop image , if set to YES, the prop can be mirrored

__Return Value:__

Processed image data

------

##### renderPixelBuffer: bgraTexture: withFrameId: items: itemCount: flipx: customSize:

customSize Parameter，customizable output resolution

```objective-c
- (FUOutput)renderPixelBuffer:(CVPixelBufferRef)pixelBuffer bgraTexture:(GLuint)textureHandle withFrameId:(int)frameid items:(int *)items itemCount:(int)itemCount flipx:(BOOL)flip customSize:(CGSize)customSize;
```

__Parameter:__

*pixelBuffer*:  Image data, supported formats: BGRA, YUV420SP, for face recognition

*textureHandle*:  textureID under the user's current EAGLContext for image processing

*frameid*:  The currently processed video frame number, each time it is processed to add 1 operation, without adding 1 will not be able to drive the effect animation in the prop

*items* : An int array containing multiple item handles

*flip*:  prop image , if set to YES, the prop can be mirrored

*customSize*: Custom output resolution, currently only supports BGRA format

__Return Value:__

Processed image data

------

##### beautifyPixelBuffer: withBeautyItem:

The interface does not include the face detection function, and can be only whiten, rosy, filter, and blur, also does not include the beauty functions such as face-lifting and eye-enlarge.

```objective-c
- (CVPixelBufferRef)beautifyPixelBuffer:(CVPixelBufferRef)pixelBuffer withBeautyItem:(int)item;
```

__Parameter:__

*pixelBuffer*:   Image data, supported formats: BGRA, YUV420SP, for face recognition

*item*:  beauty prop handle

__Return Value:__

Processed image data

------

##### renderPixelBuffer: withFrameId: items: itemCount: flipx: masks:

Added masks Parameter to specify which of the multiple faces the props are rendered on.

```objective-c
- (CVPixelBufferRef)renderPixelBuffer:(CVPixelBufferRef)pixelBuffer withFrameId:(int)frameid items:(int*)items itemCount:(int)itemCount flipx:(BOOL)flip masks:(void*)masks;
```

__Parameter:__

*pixelBuffer*:  Image data, supported formats: BGRA, YUV420SP, for face recognition

*textureHandle*:  textureID under the user's current EAGLContext for image processing

*frameid*:  The currently processed video frame number, each time it is processed to add 1 operation, without adding 1 will not be able to drive the effect animation in the prop

*items* : An int array containing multiple item handles

*flip*:  prop image , if set to YES, the prop can be mirrored

*masks*: Specify the int array of the faces in the items rendered by the items , the length of which must be the same as the length of the items.

​       Each bit in the masks corresponds to each item in the items. To use it, you want to make a prop on the first person's face detected.

         The corresponding int value is "2 to the power of 0", the int value corresponding to the second person's face is "2 to the power of 1", and the int value corresponding to the third face is "2 to the power of 2". ",

         And so on. Example: masks = {pow(2,0), pow(2,1), pow(2,2)....}, it is worth noting that the int value corresponding to the beauty item is 0.

__Return Value:__

The processed image data is the same pixelBuffer as the incoming pixelBuffer

------

##### renderFrame: u: v: ystride: ustride: vstride: width: height: frameId: items: itemCount:

```objective-c
- (void)renderFrame:(uint8_t*)y u:(uint8_t*)u v:(uint8_t*)v ystride:(int)ystride ustride:(int)ustride vstride:(int)vstride width:(int)width height:(int)height frameId:(int)frameid items:(int *)items itemCount:(int)itemCount;
```

__Parameter:__

*y*: Y frame image address

*u*: U frame image address

*v*: V frame image address

*ystride*: Y frame stride

*ustride*: U frame stride

*vstride*: V frame stride

*width*: Image width

*height*: Image height

*frameid*: The currently processed video frame number, each time it is processed to add 1 operation, without adding 1 will not be able to drive the effect animation in the prop

*items* : An int array containing multiple item handles, including common items, beauty items, gesture items, etc.

*itemCount*: The number of handles contained in the handle array

------

##### renderFrame: u: v: ystride: ustride: vstride: width: height: frameId: items: itemCount: flipx:

```objective-c
- (void)renderFrame:(uint8_t*)y u:(uint8_t*)u v:(uint8_t*)v ystride:(int)ystride ustride:(int)ustride vstride:(int)vstride width:(int)width height:(int)height frameId:(int)frameid items:(int *)items itemCount:(int)itemCount flipx:(BOOL)flip;
```

__Parameter:__

*y*: Y frame image address

*u*: U frame image address

*v*: V frame image address

*ystride*: Y frame stride

*ustride*: U frame stride

*vstride*: V frame stride

*width*: Image width

*height*: Image height

*frameid*: The currently processed video frame number, each time it is processed to add 1 operation, without adding 1 will not be able to drive the effect animation in the prop

*items* : An int array containing multiple item handles, including common items, beauty items, gesture items, etc.

*itemCount*: The number of handles contained in the handle array

*flip*:  prop image , if set to YES, the prop can be mirrored

------



#### 2.5 Other function interface

##### isTracking

Determine if a face is detected

```objective-c
+ (int)isTracking
```

**Return Value：**

The number of faces detected, returning 0 means no face detected

------

##### setMaxFaces:

Turn on multi-person detection mode to detect up to 8 faces at the same time

```objective-c
+ (int)setMaxFaces:(int)maxFaces
```

**Parameter：** 

*maxFaces*:  Set the number of faces opened in multiplayer mode, up to 8

**Return Value：**

 The number of faces set last time

------

##### getVersion

Get the current SDK version number

```objective-c
+ (NSString *)getVersion;
```

**Return Value：**

version information

------

##### trackFace: inputData: width: height:

The interface only detects the face. If the video processing interface has not been run in the program (except for the video processing interface 8), you need to execute the interface before you can use the face information interface to obtain the face information.

```objective-c
+ (int)trackFace:(int)inputFormat inputData:(void*)inputData width:(int)width height:(int)height
```

**Parameter：**

*inputFormat*:  `FU_FORMAT_RGBA_BUFFER` 、 `FU_FORMAT_NV21_BUFFER` 、 `FU_FORMAT_NV12_BUFFER` 、 `FU_FORMAT_I420_BUFFER`

*inputData*:  Input image bytes address

*width*:  width of image data

*height* : height of image data

**Return Value：**

The number of faces detected, returning 0 means no face detected

------

##### getFaceInfo: name: pret: number:

```objective-c
+ (int)getFaceInfo:(int)faceId name:(NSString *)name pret:(float *)pret number:(int)number
```

**interface description：**

- In the program, you need to run the video processing interface (except video processing interface 8) or the face information tracking interface before you can use this interface to obtain face information.
- The face information that can be obtained by the interface is related to the certificate issued by our company. The ordinary certificate cannot obtain the face information through the interface.；
- The specific Parameter and certificate requirements are as follows：

```properties
	landmarks: 2D face feature points，Return Value is 75 two-dimensional coordinates, length 75*2
	Requirement: LANDMARK、AVATAR

	landmarks_ar: 3D face feature points，Return Value is 75 three-dimensional coordinates, length 75*3
	Requirement: AVATAR

	rotation: Human face three-dimensional rotation，Return Value is a rotating quaternion, length 4
	Requirement: LANDMARK、AVATAR

	translation: 3D displacement of the face, Return Value a 3D vector, length 3
	Requirement: LANDMARK、AVATAR

	eye_rotation: Eyeball rotation, Return Value is a rotating quaternion, length 4
	Requirement: LANDMARK、AVATAR

	rotation_raw: 3D rotation of the face (regardless of the screen orientation), Return Value is the rotation quaternion, length 4
	Requirement: LANDMARK、AVATAR

	expression: Expression coefficient, length 46
	Requirement: AVATAR

	projection_matrix: Projection matrix, length 16
	Requirement: AVATAR

	face_rect: Face rectangle, Return Value is (xmin, ymin, xmax, ymax), length 4
	Requirement: LANDMARK、AVATAR

	rotation_mode: Face orientation, 0-3 corresponds to the four orientations of the mobile phone, length 1
	Requirement: LANDMARK、AVATAR
```

**Parameter：**

*faceId*: The face ID to be detected is 0 when the multi-person detection is not turned on, indicating that the face information of the first person is detected; when multi-person detection is turned on, the value range is [0 ~ maxFaces-1], which is taken as the first Several values represent the face information of the first few people.

*name*: Face information Parameter name: "landmarks" , "eye_rotation" , "translation" , "rotation" ....

*pret*: As a float array pointer used by the container, the obtained face information is directly written to the float array.

*number*: The length of the float array

**Return Value**

 Return 1 means success, return 0 means failure

------

##### loadTongueModel: size:

To use Animoji with a tongue, please load the tongue props after fuSetup to use Animoji with tongue.

```objective-c
+ (int)loadTongueModel:(void*)model size:(int)size
```

------

##### ~~loadExtendedARData: size:~~

abandoned

Load AR high-precision data package and enable this function

```objective-c
+ (int)loadExtendedARData:(void *)data size:(int)size;
```

**Parameter：**

*data*: AR high precision data packet byte[]

*size*:  byte[] length

------

##### ~~loadAnimModel: size:~~

abandoned

Load the emoticon animation package and turn it on

```objective-c
+ (int)loadAnimModel:(void *)model size:(int)size;
```

**Parameter：**

*model*： Emoticon animation data packet byte[]

*size*：byte[] length

------

##### setExpressionCalibration:

Turn on the emoticon function

```objc
+ (void)setExpressionCalibration:(int)expressionCalibration;
```

**Parameter：**

*expressionCalibration*: 0 is to close the expression calibration, 2 is passive calibration.

------

###  


