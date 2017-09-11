#ifndef __FUNAMA_H
#define __FUNAMA_H
#ifdef _WIN32
#define FUNAMA_API __declspec(dllexport)
#else
#define FUNAMA_API
#endif

/*\brief An I/O format where `ptr` points to a BGRA buffer. It matches the camera format on iOS. */
#define FU_FORMAT_BGRA_BUFFER 0
/*\brief An I/O format where `ptr` points to a single GLuint that is a RGBA texture. It matches the hardware encoding format on Android. */
#define FU_FORMAT_RGBA_TEXTURE 1
/*\brief An I/O format where `ptr` points to an NV21 buffer. It matches the camera preview format on Android. */
#define FU_FORMAT_NV21_BUFFER 2
#define FU_FORMAT_I420_BUFFER 13

/*\brief An output-only format where `out_ptr` is NULL or points to a TGLRenderingDesc structure. 
	The result is rendered onto the current GL framebuffer no matter what `out_ptr` is.
	If a TGLRenderingDesc is specified, we can optionally return an image to the caller in the specified format.
*/
#define FU_FORMAT_GL_CURRENT_FRAMEBUFFER 3
/*\brief An I/O format where `ptr` points to a RGBA buffer. */
#define FU_FORMAT_RGBA_BUFFER 4
/*\brief An input-only format where `ptr` points to a TCameraDesc struct. The input is directly taken from the specified camera. w and h are taken as the preferred image size*/
#define FU_FORMAT_CAMERA 5
/*\brief An input-only format where `in_ptr` points to a single GLuint that is an EXTERNAL_OES texture. It matches the hardware encoding format on Android. */
#define FU_FORMAT_RGBA_TEXTURE_EXTERNAL_OES 6
/*\brief An I/O format where `in_ptr` points to a TAndroidDualMode struct, which provides both a texture and an NV21 buffer as input. 
As the name suggests, this is the most efficient interface  on Android. */
#define FU_FORMAT_ANDROID_DUAL_MODE 7
typedef struct{
	int camera_id;//<which camera should we use, 0 for front, 1 for back
}TCameraDesc;
/*\brief Indicate that the `tex` member is an EXTERNAL_OES texture */
#define FU_ADM_FLAG_EXTERNAL_OES_TEXTURE 1
/*\brief Indicate that the result should also be read back to p_NV21 */
#define FU_ADM_FLAG_ENABLE_READBACK 2
/*\brief Indicate that the input texture is a packed NV21 texture */
#define FU_ADM_FLAG_NV21_TEXTURE 4
/*\brief Indicate that the input texture is a packed IYUV420 texture */
#define FU_ADM_FLAG_I420_TEXTURE 8
/*\brief Indicate that the input buffer is a packed IYUV420 buffer */
#define FU_ADM_FLAG_I420_BUFFER 16

#define FU_ADM_FALG_RGBA_BUFFER 128

typedef struct{
	void* p_NV21;//<the NV21 buffer
	int tex;//<the texture
	int flags;
}TAndroidDualMode;
/*\brief An I/O format where `ptr` points to a TNV12Buffer struct, which describes a YpCbCr8BiPlanar buffer. It matches the YUV camera formats on iOS. */
#define FU_FORMAT_NV12_BUFFER 8
typedef struct{
	void* p_Y;//<the Y plane base address
	void* p_CbCr;//<the CbCr plane base address
	int stride_Y;//<the Y plane bytes-per-row
	int stride_CbCr;//<the CbCr plane bytes-per-row
}TNV12Buffer;
/*\brief An internal input format for efficient iOS CVPixelBuffer handling where `ptr` points to a TIOSDualInput structure*/
#define FU_FORMAT_INTERNAL_IOS_DUAL_INPUT 9
#define FU_IDM_FORMAT_BGRA 0
#define FU_IDM_FORMAT_NV12 1
typedef struct{
	//members to be specified in the BGRA mode
	void* p_BGRA;//<the BGRA plane base address
	//members to be specified in the NV12 mode
	void* p_Y;//<the Y plane base address
	void* p_CbCr;//<the CbCr plane base address
	//members to be specified in the BGRA mode
	int stride_BGRA;//<the BGRA plane bytes-per-row
	//members to be specified in the NV12 mode
	int stride_Y;//<the Y plane bytes-per-row
	int stride_CbCr;//<the CbCr plane bytes-per-row
	//commom member
	int tex_handle;//<the GPU-side input, which has to be an RGBA texture
	/////////////////
	int format;//<FU_IDM_FORMAT_BGRA or FU_IDM_FORMAT_NV12
}TIOSDualInput;
/*\brief An internal output format for efficient iOS CVPixelBuffer handling where `ptr` points to a TIOSFBO structure*/
typedef struct{
	//we will reuse the FBO internally as an intermediate render target, so we need to know the texture
	//we expect a depth buffer to be bound to the FBO
	int fbo;//<the FBO to render onto
	int tex;//<the texture bound to that FBO
}TIOSFBO;
#define FU_FORMAT_INTERNAL_IOS_FBO 10
#define FU_FORMAT_INTERNAL_IOS_DUAL_OUTPUT 11
////////////
/**\brief take a user-defined param and a a width / height pair and return a pointer to receive the image output*/
typedef void*(*PFRECEIVE_RESULT)(void* param,int w,int h);
typedef struct{
	unsigned char orientation;//<the target orientation and flags
	unsigned char version;//<version==0 for orientation only, set version to 1 if you want to read back anything
	unsigned short __padding;
	//version==1 members
	int image_output_mode;//<FU_FORMAT_BGRA_BUFFER, FU_FORMAT_RGBA_TEXTURE, FU_FORMAT_NV21_BUFFER, or FU_FORMAT_GL_CURRENT_FRAMEBUFFER for nothing at all
	PFRECEIVE_RESULT fcallback;//<the callback for receiving the image
	void* param;//<the user-defined param for the callback
}TGLRenderingDesc;

#define FU_FORMAT_AVATAR_INFO 12
typedef struct{	
	float* p_translation;	
	float* p_rotation;
	float* p_expression;
	float* rotation_mode;
	float* pupil_pos;
	int is_valid;
}TAvatarInfo;

#define FU_FORMAT_VOID 13

#ifdef __cplusplus
extern "C"{
#endif
/**
\brief Initialize and authenticate your SDK instance to the FaceUnity server, must be called exactly once before all other functions.
	The buffers should NEVER be freed while the other functions are still being called.
	You can call this function multiple times to "switch pointers".
\param v3data should point to contents of the "v3.bin" we provide
\param ardata should be NULL
\param authdata is the pointer to the authentication data pack we provide. You must avoid storing the data in a file.
	Normally you can just `#include "authpack.h"` and put `g_auth_package` here.
\param sz_authdata is the authentication data size, we use plain int to avoid cross-language compilation issues.
	Normally you can just `#include "authpack.h"` and put `sizeof(g_auth_package)` here.
\return non-zero for success, zero for failure
*/
FUNAMA_API int fuSetup(float* v3data,float* ardata,void* authdata,int sz_authdata);
/**
\brief Call this function when the GLES context has been lost and recreated.
	That isn't a normal thing, so this function could leak resources on each call.
*/
FUNAMA_API void fuOnDeviceLost();
/**
\brief Call this function to reset the face tracker on camera switches
*/
FUNAMA_API void fuOnCameraChange();
/**
\brief Create an accessory item from a binary package, you can discard the data after the call.
	This function MUST be called in the same GLES context / thread as fuRenderItems.
\param data is the pointer to the data
\param sz is the data size, we use plain int to avoid cross-language compilation issues
\return an integer handle representing the item
*/
FUNAMA_API int fuCreateItemFromPackage(void* data,int sz);
/**
\brief Destroy an accessory item.
	This function MUST be called in the same GLES context / thread as the original fuCreateItemFromPackage.
\param item is the handle to be destroyed
*/
FUNAMA_API void fuDestroyItem(int item);
/**
\brief Destroy all accessory items ever created.
	This function MUST be called in the same GLES context / thread as the original fuCreateItemFromPackage.
*/
FUNAMA_API void fuDestroyAllItems();

FUNAMA_API void fuClearRenderData();
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
FUNAMA_API int fuRenderItems(int texid,int* img,int w,int h,int frame_id, int* p_items,int n_items);

/**
\brief Generalized interface for rendering a list of items.
	This function needs a GLES 2.0+ context.
\param out_format is the output format
\param out_ptr receives the rendering result, which is either a GLuint texture handle or a memory buffer
	Note that in the texture cases, we will overwrite *out_ptr with a texture we generate.
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
FUNAMA_API int fuRenderItemsEx(
	int out_format,void* out_ptr,
	int in_format,void* in_ptr,
	int w,int h,int frame_id, int* p_items,int n_items);
	
/**
\brief Generalized interface for rendering a list of items.
	This function needs a GLES 2.0+ context.
\param out_format is the output format
\param out_ptr receives the rendering result, which is either a GLuint texture handle or a memory buffer
	Note that in the texture cases, we will overwrite *out_ptr with a texture we generate.
\param in_format is the input format
\param in_ptr points to the input image, which is either a GLuint texture handle or a memory buffer
\param w specifies the image width
\param h specifies the image height
\param frameid specifies the current frame id. 
	To get animated effects, please increase frame_id by 1 whenever you call this.
\param p_items points to the list of items
\param n_items is the number of items
\param p_masks indicates a list of masks for each item, bitwisely work on certain face
\return a GLuint texture handle containing the rendering result if out_format isn't FU_FORMAT_GL_CURRENT_FRAMEBUFFER
*/
FUNAMA_API int fuRenderItemsMasked(
	int out_format,void* out_ptr,
	int in_format,void* in_ptr,
	int w,int h,int frame_id, int* p_items,int n_items, int* p_masks);
	
/**
\brief Generalized interface for beautifying image.
	Disable face tracker and item rendering.
	This function needs a GLES 2.0+ context.
\param out_format is the output format
\param out_ptr receives the rendering result, which is either a GLuint texture handle or a memory buffer
	Note that in the texture cases, we will overwrite *out_ptr with a texture we generate.
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
FUNAMA_API int fuBeautifyImage(
	int out_format,void* out_ptr,
	int in_format,void* in_ptr,
	int w,int h,int frame_id, int* p_items,int n_items);

/**
\brief Generalized interface for tracking face.
	Disable item rendering and image beautifying.
	This function needs a GLES 2.0+ context.
\param out_format is the output format
\param out_ptr receives the rendering result, which is either a GLuint texture handle or a memory buffer
	Note that in the texture cases, we will overwrite *out_ptr with a texture we generate.
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
FUNAMA_API int fuTrackFace(int in_format,void* in_ptr,int w,int h);
	
/**
\brief Generalized interface for rendering a list of items with extension.	
	This function needs a GLES 2.0+ context.
\param out_format is the output format
\param out_ptr receives the rendering result, which is either a GLuint texture handle or a memory buffer
	Note that in the texture cases, we will overwrite *out_ptr with a texture we generate.
\param in_format is the input format
\param in_ptr points to the input image, which is either a GLuint texture handle or a memory buffer
\param w specifies the image width
\param h specifies the image height
\param frameid specifies the current frame id. 
	To get animated effects, please increase frame_id by 1 whenever you call this.
\param p_items points to the list of items
\param n_items is the number of items
\param func_flag flags indicate all changable functionalities of render interface
\param p_masks indicates a list of masks for each item, bitwisely work on certain face
\return a GLuint texture handle containing the rendering result if out_format isn't FU_FORMAT_GL_CURRENT_FRAMEBUFFER
*/
FUNAMA_API int fuRenderItemsEx2(
	int out_format,void* out_ptr,
	int in_format,void* in_ptr,
	int w,int h,int frame_id, int* p_items,int n_items,
	int func_flag, void* p_item_masks);
	
#define NAMA_RENDER_FEATURE_TRACK_FACE 0x10
#define NAMA_RENDER_FEATURE_BEAUTIFY_IMAGE 0x20
#define NAMA_RENDER_FEATURE_RENDER 0x40
#define NAMA_RENDER_FEATURE_ADDITIONAL_DETECTOR 0x80
#define NAMA_RENDER_FEATURE_RENDER_ITEM 0x100
#define NAMA_RENDER_FEATURE_FULL (NAMA_RENDER_FEATURE_RENDER_ITEM | NAMA_RENDER_FEATURE_TRACK_FACE | NAMA_RENDER_FEATURE_BEAUTIFY_IMAGE | NAMA_RENDER_FEATURE_RENDER | NAMA_RENDER_FEATURE_ADDITIONAL_DETECTOR)
#define NAMA_RENDER_FEATURE_MASK 0xff0
#define NAMA_RENDER_OPTION_FLIP_X 0x1000
#define NAMA_RENDER_OPTION_FLIP_Y 0x2000
#define NAMA_RENDER_OPTION_MASK 0xff000

/**************************************************************
The set / get functions do not make sense on their own. Refer to
the documentation of specific items for their get/set-able
parameters. Most items do not have any.
**************************************************************/

/**
\brief Set an item parameter to a double value
\param item specifies the item
\param name is the parameter name
\param value is the parameter value to be set
\return zero for failure, non-zero for success
*/
FUNAMA_API int fuItemSetParamd(int item,char* name,double value);
/**
\brief Set an item parameter to a double array
\param item specifies the item
\param name is the parameter name
\param value points to an array of doubles
\param n specifies the number of elements in value
\return zero for failure, non-zero for success
*/
FUNAMA_API int fuItemSetParamdv(int item,char* name,double* value,int n);
/**
\brief Set an item parameter to a string value
\param item specifies the item
\param name is the parameter name
\param value is the parameter value to be set
\return zero for failure, non-zero for success
*/
FUNAMA_API int fuItemSetParams(int item,char* name,char* value);
/**
\brief Get an item parameter as a double value
\param item specifies the item
\param name is the parameter name
\return double value of the parameter
*/
FUNAMA_API double fuItemGetParamd(int item,char* name);
/**
\brief Get an item parameter as a string
\param item specifies the item
\param name is the parameter name
\param buf receives the string value
\param sz is the number of bytes available at buf
\return the length of the string value, or -1 if the parameter is not a string.
*/
FUNAMA_API int fuItemGetParams(int item,char* name,char* buf,int sz);

/**
\brief Turn off the camera
*/
FUNAMA_API void fuTurnOffCamera();
/**
\brief Get the camera image size
\param pret points to two integers, which receive the size
*/
FUNAMA_API void fuGetCameraImageSize(int* pret);
/**
\brief Get the face tracking status
\return The number of valid faces currently being tracked
*/
FUNAMA_API int fuIsTracking();
/**
\brief Set the default orientation for face detection. The correct orientation would make the initial detection much faster.
\param rmode is the default orientation to be set to, one of 0..3 should work.
*/
FUNAMA_API void fuSetDefaultOrientation(int rmode);
/**
\brief Set the maximum number of faces we track. The default value is 1.
\param n is the new maximum number of faces to track
\return The previous maximum number of faces tracked
*/
FUNAMA_API int fuSetMaxFaces(int n);
/**
\brief Set the quality-performance tradeoff. 
\param quality is the new quality value. 
       It's a floating point number between 0 and 1.
       Use 0 for maximum performance and 1 for maximum quality.
       The default quality is 1 (maximum quality).
*/
FUNAMA_API void fuSetQualityTradeoff(float quality);

/**
\brief Get face info. Certificate aware interface.
\param face_id is the id of face, index is smaller than which is set in fuSetMaxFaces
\param name is among "landmarks", "eye_rotation", "translation", "rotation"
\param pret allocated memory space as container
\param num is number of float allocated in pret
	eg: 	  "landmarks" - 75*2 float
			  "landmarks_ar" - 75*3 float
			  "eye_rotation" - 4
			  "translation" - 3
			  "rotation" - 4
			  "projection_matrix" - 16
\return 1 means successful fetch, container filled with info
	0 means failure, general failure is due to invalid face info
	other specific failure will print on the console
*/
FUNAMA_API int fuGetFaceInfo(int face_id, char* name, float* pret, int num);

/**
\brief Bind items to an avatar, already bound items won't be unbound
\param avatar_item is the avatar item handle
\param p_items points to a list of item handles to be bound to the avatar
\param n_items is the number of item handles in p_items
\param p_contracts points to a list of contract handles for authorizing items
\param n_contracts is the number of contract handles in p_contracts
\return the number of items newly bound to the avatar
*/
FUNAMA_API int fuAvatarBindItems(int avatar_item, int* p_items,int n_items, int* p_contracts,int n_contracts);
/**
\brief Unbind items from an avatar
\param avatar_item is the avatar item handle
\param p_items points to a list of item handles to be unbound from the avatar
\param n_items is the number of item handles in p_items
\return the number of items unbound from the avatar
*/
FUNAMA_API int fuAvatarUnbindItems(int avatar_item, int* p_items,int n_items);

//
FUNAMA_API int fuBindItems(int item_src, int* p_items,int n_items);
FUNAMA_API int fuUnbindAllItems(int item_src);

/**
\brief Get SDK version string
\return SDK version string in const char*
*/
FUNAMA_API const char* fuGetVersion();

#ifdef __cplusplus
}
#endif

#endif
