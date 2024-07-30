#ifndef CNAMASDK_H
#define CNAMASDK_H

#ifdef _WIN32
#ifdef NAMA_BUILD_SHARED_LIB
#define FUNAMA_API __declspec(dllexport)
#else
#define FUNAMA_API
#endif
#else
#define FUNAMA_API __attribute__((visibility("default")))
#endif

#define FU_FORMAT_BGRA_BUFFER 0
#define FU_FORMAT_RGBA_TEXTURE 1
#define FU_FORMAT_NV21_BUFFER 2
#define FU_FORMAT_GL_CURRENT_FRAMEBUFFER 3
#define FU_FORMAT_RGBA_BUFFER 4
#define FU_FORMAT_CAMERA 5
#define FU_FORMAT_RGBA_TEXTURE_EXTERNAL_OES 6
#define FU_FORMAT_ANDROID_DUAL 7
#define FU_FORMAT_NV12_BUFFER 8
#define FU_FORMAT_INTERNAL_IOS_DUAL_INPUT 9
#define FU_FORMAT_GL_SPECIFIED_FRAMEBUFFER 10
#define FU_FORMAT_AVATAR_INFO 12
#define FU_FORMAT_I420_BUFFER 13
#define FU_FORMAT_VOID 14

#define NAMA_FILTER_TYPE_PRE 1
#define NAMA_FILTER_TYPE_ONCE 2
#define NAMA_FILTER_TYPE_FXAA 4
#define NAMA_FILTER_TYPE_NORMAL 8

#define DETECTOR_IMAGE_FORMAT_RGBA 0
#define DETECTOR_IMAGE_FORMAT_MONO 1
#define DETECTOR_IMAGE_FORMAT_BGRA 2
#define DETECTOR_IMAGE_FORMAT_NV21 3
#define DETECTOR_IMAGE_FORMAT_NV12 4
#define DETECTOR_IMAGE_FORMAT_I420 5

typedef enum FUAITYPE {
  FUAITYPE_NONE = 0,
  FUAITYPE_BACKGROUNDSEGMENTATION = 1 << 1,
  FUAITYPE_HAIRSEGMENTATION = 1 << 2,
  FUAITYPE_HANDGESTURE = 1 << 3,
  FUAITYPE_HANDPROCESSOR = 1 << 4,
  FUAITYPE_TONGUETRACKING = 1 << 5,
  FUAITYPE_HUMANPOSE2D = 1 << 6,
  FUAITYPE_BACKGROUNDSEGMENTATION_GREEN = 1 << 7,
  FUAITYPE_FACEPROCESSOR = 1 << 8,
  FUAITYPE_HUMAN_PROCESSOR = 1 << 9,
  FUAITYPE_FACE_RECOGNIZER = 1 << 10,
  FUAITYPE_IMAGE_BEAUTY = 1 << 11,
  FUAITYPE_FACE_ATTRIBUTE_PROCESSOR = 1 << 12,
  FUAITYPE_FACELANDMARKS75 = 1 << 13,
  FUAITYPE_FACELANDMARKS209 = 1 << 14,
  FUAITYPE_FACELANDMARKS239 = 1 << 15,
  FUAITYPE_FACEPROCESSOR_IMAGE_BEAUTY = 1 << 16,
  FUAITYPE_HUMAN_PROCESSOR_IMAGE_BEAUTY = 1 << 17

} FUAITYPE;

#define FUAITYPE_FACEPROCESSOR_FACECAPTURE 1048576                 // 1<<20
#define FUAITYPE_FACEPROCESSOR_FACECAPTURE_TONGUETRACKING 2097152  // 1<<21
#define FUAITYPE_FACEPROCESSOR_HAIRSEGMENTATION 4194304            // 1<<22
#define FUAITYPE_FACEPROCESSOR_HEADSEGMENTATION 8388608            // 1<<23
#define FUAITYPE_FACEPROCESSOR_EXPRESSION_RECOGNIZER 16777216      // 1<<24
#define FUAITYPE_FACEPROCESSOR_EMOTION_RECOGNIZER 33554432         // 1<<25
#define FUAITYPE_FACEPROCESSOR_DISNEYGAN 67108864                  // 1<<26
#define FUAITYPE_FACEPROCESSOR_FACEID 134217728                    // 1<<27
#define FUAITYPE_HUMAN_PROCESSOR_DETECT 268435456                  // 1<<28
#define FUAITYPE_HUMAN_PROCESSOR_SEGMENTATION 536870912            // 1<<29
#define FUAITYPE_HUMAN_PROCESSOR_2D_SELFIE 1073741824              // 1<<30
#define FUAITYPE_HUMAN_PROCESSOR_2D_DANCE 2147483648               // 1<<31
#define FUAITYPE_HUMAN_PROCESSOR_2D_SLIM 4294967296                // 1<<32
#define FUAITYPE_HUMAN_PROCESSOR_3D_SELFIE 8589934592              // 1<<33
#define FUAITYPE_HUMAN_PROCESSOR_3D_DANCE 17179869184              // 1<<34
#define FUAITYPE_HUMAN_PROCESSOR_2D_IMGSLIM 34359738368            // 1<<35
#define FUAITYPE_IMAGE_BEAUTY_UNKNOW 68719476736                   // 1<<36
#define FUAITYPE_FACEPROCESSOR_LIPSOCCUSEGMENT 137438953472        // 1<<37
#define FUAITYPE_FACEPROCESSOR_FACEOCCUSEGMENT 274877906944        // 1<<38
#define FUAITYPE_FACEPROCESSOR_SKINSEGMENT 549755813888            // 1<<39
#define FUAITYPE_FACEPROCESSOR_DELSPOT 1099511627776               // 1<<40
#define FUAITYPE_FACEPROCESSOR_ARMESHV2 2199023255552              // 1<<41

typedef enum FUAIGESTURETYPE {
  FUAIGESTURE_NO_HAND = -1,
  FUAIGESTURE_UNKNOWN = 0,
  FUAIGESTURE_THUMB = 1,
  FUAIGESTURE_KORHEART = 2,
  FUAIGESTURE_SIX = 3,
  FUAIGESTURE_FIST = 4,
  FUAIGESTURE_PALM = 5,
  FUAIGESTURE_ONE = 6,
  FUAIGESTURE_TWO = 7,
  FUAIGESTURE_OK = 8,
  FUAIGESTURE_ROCK = 9,
  FUAIGESTURE_CROSS = 10,
  FUAIGESTURE_HOLD = 11,
  FUAIGESTURE_GREET = 12,
  FUAIGESTURE_PHOTO = 13,
  FUAIGESTURE_HEART = 14,
  FUAIGESTURE_MERGE = 15,
  FUAIGESTURE_EIGHT = 16,
  FUAIGESTURE_HALFFIST = 17,
  FUAIGESTURE_GUN = 18,
} FUAIGESTURETYPE;

typedef enum FULOGLEVEL {
  FU_LOG_LEVEL_TRACE = 0,
  FU_LOG_LEVEL_DEBUG = 1,
  FU_LOG_LEVEL_INFO = 2,
  FU_LOG_LEVEL_WARN = 3,
  FU_LOG_LEVEL_ERROR = 4,
  FU_LOG_LEVEL_CRITICAL = 5,
  FU_LOG_LEVEL_OFF = 6
} FULOGLEVEL;

typedef enum FUAIEXPRESSIONTYPE {
  FUAIEXPRESSION_UNKNOWN = 0,
  FUAIEXPRESSION_BROW_UP = 1 << 1,
  FUAIEXPRESSION_BROW_FROWN = 1 << 2,
  FUAIEXPRESSION_LEFT_EYE_CLOSE = 1 << 3,
  FUAIEXPRESSION_RIGHT_EYE_CLOSE = 1 << 4,
  FUAIEXPRESSION_EYE_WIDE = 1 << 5,
  FUAIEXPRESSION_MOUTH_SMILE_LEFT = 1 << 6,
  FUAIEXPRESSION_MOUTH_SMILE_RIGHT = 1 << 7,
  FUAIEXPRESSION_MOUTH_FUNNEL = 1 << 8,
  FUAIEXPRESSION_MOUTH_OPEN = 1 << 9,
  FUAIEXPRESSION_MOUTH_PUCKER = 1 << 10,
  FUAIEXPRESSION_MOUTH_ROLL = 1 << 11,
  FUAIEXPRESSION_MOUTH_PUFF = 1 << 12,
  FUAIEXPRESSION_MOUTH_SMILE = 1 << 13,
  FUAIEXPRESSION_MOUTH_FROWN = 1 << 14,
  FUAIEXPRESSION_HEAD_LEFT = 1 << 15,
  FUAIEXPRESSION_HEAD_RIGHT = 1 << 16,
  FUAIEXPRESSION_HEAD_NOD = 1 << 17,
} FUAIEXPRESSIONTYPE;

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

typedef enum FUITEMTRIGGERTYPE {
  FUITEMTRIGGER_UNKNOWN = 0,
  FUITEMTRIGGER_CAI_DAN = 1,
} FUITEMTRIGGERTYPE;

typedef enum FUAIEMOTIONTYPE {
  FUAIEMOTION_UNKNOWN = 0,
  FUAIEMOTION_HAPPY = 1 << 1,
  FUAIEMOTION_SAD = 1 << 2,
  FUAIEMOTION_ANGRY = 1 << 3,
  FUAIEMOTION_SURPRISE = 1 << 4,
  FUAIEMOTION_FEAR = 1 << 5,
  FUAIEMOTION_DISGUST = 1 << 6,
  FUAIEMOTION_NEUTRAL = 1 << 7,
  FUAIEMOTION_CONFUSE = 1 << 8,
} FUAIEMOTIONTYPE;

typedef enum FUAIHUMANSTATE {
  FUAIHUMAN_NO_BODY = 0,
  FUAIHUMAN_HALF_LESS_BODY = 1,
  FUAIHUMAN_HALF_BODY = 2,
  FUAIHUMAN_HALF_MORE_BODY = 3,
  FUAIHUMAN_FULL_BODY = 4,
} FUAIHUMANSTATE;

typedef enum FUAISCENESTATE {
  FUAISCENE_UNKNOWN = -1,
  FUAISCENE_SELFIE = 0,
  FUAISCENE_DANCE = 1,
  FUAISCENE_SLIM = 2,
} FUAISCENESTATE;

typedef enum FUAIHUMANFOLLOWMODE {
  FUAIHUMAN_FOLLOW_MODE_UNKNOWN = -1,
  FUAIHUMAN_FOLLOW_MODE_FIX = 0,
  FUAIHUMAN_FOLLOW_MODE_ALIGN = 1,
  FUAIHUMAN_FOLLOW_MODE_STAGE = 2
} FUAIHUMANFOLLOWMODE;

typedef enum FUAIHUMANMIRRORTYPE {
  FUAIHUMAN_MIRROR_LR = 0,
  FUAIHUMAN_MIRROR_TB = 1,
  FUAIHUMAN_MIRROR_BOTH = 2,
  FUAIHUMAN_MIRROR_NONE = 3
} FUAIHUMANMIRRORTYPE;

typedef enum FUAIHUMANROTTYPE {
  FUAIHUMAN_ROT_0 = 0,
  FUAIHUMAN_ROT_90 = 1,
  FUAIHUMAN_ROT_180 = 2,
  FUAIHUMAN_ROT_270 = 3
} FUAIHUMANROTTYPE;

typedef enum FUAIHUMANSEGSCENETYPE {
  FUAIHUMAN_SEG_MEETING = 0,
  FUAIHUMAN_SEG_COMMON = 1
} FUAIHUMANSEGSCENETYPE;

typedef enum FUAIHUMANSEGMODE {
  FUAIHUMAN_SEG_CPU_COMMON = 0x00,  //  default
  FUAIHUMAN_SEG_GPU_COMMON = 0x01,
  FUAIHUMAN_SEG_GPU_MEETING = 0x02
} FUAIHUMANSEGMODE;

typedef enum FUAIHUMANMODELCONFIG {                   // human model config
  FUAIHUMAN_SEG_CPU_COMM = FUAIHUMAN_SEG_CPU_COMMON,  //  default
  FUAIHUMAN_SEG_GPU_COMM = FUAIHUMAN_SEG_GPU_COMMON,
  FUAIHUMAN_SEG_GPU_MEET = FUAIHUMAN_SEG_GPU_MEETING,  // HumanSeg 0-7bit
} FUAIHUMANMODELCONFIG;

typedef enum FUAIHUMANALGORITHMCONFIG {  // human algorithm config
  FUAIHUMAN_ENABLE_ALL = 0,
  FUAIHUMAN_DISABLE_HUMAN_SEG = 1 << 0,
} FUAIHUMANALGORITHMCONFIG;

typedef enum FUAIFACEMODELCONFIG {  // face model config
  FUAIFACE_ALL_DEFAULT = -1,
} FUAIFACEMODELCONFIG;

typedef enum FUAIFACEALGORITHMCONFIG {  // face algorithm config
  FUAIFACE_ENABLE_ALL = 0,
  FUAIFACE_DISABLE_FACE_OCCU = 1 << 0,
  FUAIFACE_DISABLE_SKIN_SEG = 1 << 1,
  FUAIFACE_DISABLE_DEL_SPOT = 1 << 2,
  FUAIFACE_DISABLE_ARMESHV2 = 1 << 3,
} FUAIFACEALGORITHMCONFIG;

typedef enum FUAIMACHINETYPE {
  FUAIMACHINE_LOW = 0,   //  low machine
  FUAIMACHINE_HIGH = 1,  //  high machine
} FUAIMACHINETYPE;

typedef enum TRANSFORM_MATRIX {
  /*
   * 8 base orientation cases, first do counter-clockwise rotation in degree,
   * then do flip
   */
  DEFAULT = 0,             // no rotation, no flip
  CCROT0 = DEFAULT,        // no rotation, no flip
  CCROT90,                 // counter-clockwise rotate 90 degree
  CCROT180,                // counter-clockwise rotate 180 degree
  CCROT270,                // counter-clockwise rotate 270 degree
  CCROT0_FLIPVERTICAL,     // vertical flip
  CCROT0_FLIPHORIZONTAL,   // horizontal flip
  CCROT90_FLIPVERTICAL,    // first counter-clockwise rotate 90 degree，then
                           // vertical flip
  CCROT90_FLIPHORIZONTAL,  // first counter-clockwise rotate 90 degree，then
                           // horizontal flip
  /*
   * enums below is alias to above enums, there are only 8 orientation cases
   */
  CCROT0_FLIPVERTICAL_FLIPHORIZONTAL = CCROT180,
  CCROT90_FLIPVERTICAL_FLIPHORIZONTAL = CCROT270,
  CCROT180_FLIPVERTICAL = CCROT0_FLIPHORIZONTAL,
  CCROT180_FLIPHORIZONTAL = CCROT0_FLIPVERTICAL,
  CCROT180_FLIPVERTICAL_FLIPHORIZONTAL = DEFAULT,
  CCROT270_FLIPVERTICAL = CCROT90_FLIPHORIZONTAL,
  CCROT270_FLIPHORIZONTAL = CCROT90_FLIPVERTICAL,
  CCROT270_FLIPVERTICAL_FLIPHORIZONTAL = CCROT90,
} TRANSFORM_MATRIX;

#define FU_ROTATION_MODE_0 0
#define FU_ROTATION_MODE_90 1
#define FU_ROTATION_MODE_180 2
#define FU_ROTATION_MODE_270 3

/*\brief An I/O format where `ptr` points to a BGRA buffer. It matches the
 * camera format on iOS. */
#define FU_FORMAT_BGRA_BUFFER 0
/*\brief An I/O format where `ptr` points to a single GLuint that is a RGBA
 * texture. It matches the hardware encoding format on Android. */
#define FU_FORMAT_RGBA_TEXTURE 1
/*\brief An I/O format where `ptr` points to an NV21 buffer. It matches the
 * camera preview format on Android. */
#define FU_FORMAT_NV21_BUFFER 2
#define FU_FORMAT_I420_BUFFER 13

/*\brief An output-only format where `out_ptr` is NULL or points to a
   TGLRenderingDesc structure. The result is rendered onto the current GL
   framebuffer no matter what `out_ptr` is. If a TGLRenderingDesc is specified,
   we can optionally return an image to the caller in the specified format.
*/
#define FU_FORMAT_GL_CURRENT_FRAMEBUFFER 3
/*\brief An I/O format where `ptr` points to a RGBA buffer. */
#define FU_FORMAT_RGBA_BUFFER 4
/*\brief An input-only format where `ptr` points to a TCameraDesc struct. The
 * input is directly taken from the specified camera. w and h are taken as the
 * preferred image size*/
#define FU_FORMAT_CAMERA 5
/*\brief An input-only format where `in_ptr` points to a single GLuint that is
 * an EXTERNAL_OES texture. It matches the hardware encoding format on Android.
 */
#define FU_FORMAT_RGBA_TEXTURE_EXTERNAL_OES 6
/*\brief An I/O format where `in_ptr` points to a TAndroidDualMode struct, which
provides both a texture and an NV21 buffer as input.
As the name suggests, this is the most efficient interface  on Android. */
#define FU_FORMAT_ANDROID_DUAL_MODE 7
typedef struct {
  int camera_id;  //<which camera should we use, 0 for front, 1 for back
} TCameraDesc;
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
/*\brief Indicate that the input texture is a packed NV12 texture */
#define FU_ADM_FLAG_NV12_TEXTURE 0x400000
/*\brief Indicate that the input buffer is a packed NV12 buffer */
#define FU_ADM_FLAG_NV12_BUFFER 0x800000

#define FU_ADM_FLAG_RGBA_BUFFER 128

typedef struct {
  void* p_NV21;  //<the NV21 buffer
  int tex;       //<the texture
  int flags;
} TAndroidDualMode;
/*\brief An I/O format where `ptr` points to a TNV12Buffer struct, which
 * describes a YpCbCr8BiPlanar buffer. It matches the YUV camera formats on iOS.
 */
#define FU_FORMAT_NV12_BUFFER 8
typedef struct {
  void* p_Y;        //<the Y plane base address
  void* p_CbCr;     //<the CbCr plane base address
  int stride_Y;     //<the Y plane bytes-per-row
  int stride_CbCr;  //<the CbCr plane bytes-per-row
} TNV12Buffer;
/*\brief An internal input format for efficient iOS CVPixelBuffer handling where
 * `ptr` points to a TIOSDualInput structure*/
#define FU_FORMAT_INTERNAL_IOS_DUAL_INPUT 9
#define FU_IDM_FORMAT_BGRA 0
#define FU_IDM_FORMAT_NV12 1
typedef struct {
  // members to be specified in the BGRA mode
  void* p_BGRA;  //<the BGRA plane base address
  // members to be specified in the NV12 mode
  void* p_Y;     //<the Y plane base address
  void* p_CbCr;  //<the CbCr plane base address
  // members to be specified in the BGRA mode
  int stride_BGRA;  //<the BGRA plane bytes-per-row
  // members to be specified in the NV12 mode
  int stride_Y;     //<the Y plane bytes-per-row
  int stride_CbCr;  //<the CbCr plane bytes-per-row
  // commom member
  int tex_handle;  //<the GPU-side input, which has to be an RGBA texture
  /////////////////
  int format;  //<FU_IDM_FORMAT_BGRA or FU_IDM_FORMAT_NV12
} TIOSDualInput;
/*\brief An internal output format for efficient iOS CVPixelBuffer handling
 * where `ptr` points to a TIOSFBO structure*/
typedef struct {
  // we will reuse the FBO internally as an intermediate render target, so we
  // need to know the texture we expect a depth buffer to be bound to the FBO
  int fbo;  //<the FBO to render onto
  int tex;  //<the texture bound to that FBO
} TSPECFBO;
#define FU_FORMAT_GL_SPECIFIED_FRAMEBUFFER 10
////////////
/**\brief take a user-defined param and a a width / height pair and return a
 * pointer to receive the image output*/
typedef void* (*PFRECEIVE_RESULT)(void* param, int w, int h);
typedef struct {
  unsigned char orientation;  //<the target orientation and flags
  unsigned char version;  //<version==0 for orientation only, set version to 1
                          // if you want to read back anything
  unsigned short __padding;
  // version==1 members
  int image_output_mode;  //<FU_FORMAT_BGRA_BUFFER, FU_FORMAT_RGBA_TEXTURE,
                          // FU_FORMAT_NV21_BUFFER, or
                          // FU_FORMAT_GL_CURRENT_FRAMEBUFFER for nothing at all
  PFRECEIVE_RESULT fcallback;  //<the callback for receiving the image
  void* param;                 //<the user-defined param for the callback
} TGLRenderingDesc;

#define FU_FORMAT_AVATAR_INFO 12

typedef struct {
  float* p_translation;
  float* p_rotation;
  float* p_expression;
  float* rotation_mode;
  float* pupil_pos;
  int is_valid;
} TAvatarInfo;

typedef struct {
  void* in_ptr;
  int in_type;
  int out_w;
  int out_h;
  float view_0_ratio;
  int margin_in_pixel;
  int is_vertical;
  int is_image_first;
  int rotation_mode_before_crop;
  float crop_ratio_top;
  int use_black_edge;
} TSplitViewInfo;

#define NAMA_RENDER_FEATURE_TRACK_FACE 0x10
#define NAMA_RENDER_FEATURE_BEAUTIFY_IMAGE 0x20
#define NAMA_RENDER_FEATURE_RENDER 0x40
#define NAMA_RENDER_FEATURE_ADDITIONAL_DETECTOR 0x80
#define NAMA_RENDER_FEATURE_RENDER_ITEM 0x100
#define NAMA_RENDER_FEATURE_FULL                                      \
  (NAMA_RENDER_FEATURE_RENDER_ITEM | NAMA_RENDER_FEATURE_TRACK_FACE | \
   NAMA_RENDER_FEATURE_BEAUTIFY_IMAGE | NAMA_RENDER_FEATURE_RENDER |  \
   NAMA_RENDER_FEATURE_ADDITIONAL_DETECTOR)
#define NAMA_RENDER_FEATURE_MASK 0xff0
#define NAMA_RENDER_OPTION_FLIP_X 0x1000
#define NAMA_RENDER_OPTION_FLIP_Y 0x2000
#define NAMA_NOCLEAR_CURRENT_FRAMEBUFFER 0x4000
#define NAMA_RENDER_OPTION_MASK 0xff000

#ifdef __cplusplus
extern "C" {
#endif

/**
 \brief open file log
 \param file_fullname - nullptr for default terminal, non-null for log into
 file. \param max_file_size, max file size in byte. \param max_files, max file
 num for rotating log. \return zero for failed, one for success.
*/
FUNAMA_API int fuOpenFileLog(const char* file_pullname, int max_file_size,
                             int max_files);
/**
 \brief Set log level
 \param level - define in FULOGLEVEL enumeration.
 \return zero for failed, one for success.
*/
FUNAMA_API int fuSetLogLevel(FULOGLEVEL level);

/**
 \brief set log prefix
 \param prefix, log prefix
 */
FUNAMA_API void fuSetLogPrefix(const char* prefix);

/**
 \brief Get current log level
 \return ref to FULOGLEVEL
*/
FUNAMA_API FULOGLEVEL fuGetLogLevel();

/**
  \brief init gl context, which managed by SDK
  \param sharedContext ptr of shared context, can be null.
  \return non null for success.
  \warning experimental API
*/
FUNAMA_API void* fuInitGLContext(void* sharedContext);

/**
  \brief destroy the managed gl context, created by fuInitGLContext.
  \return true for success, vice versa.
  \warning experimental API
*/
FUNAMA_API bool fuDestroyGLContext();

/**
  \brief make the managed gl context current, context that created by
  fuInitGLContext.
  \return true for success, vice versa.
  \warning experimental API
*/
FUNAMA_API bool fuMakeGLContextCurrent();
FUNAMA_API void* fuGetCurrentGLContext();

/**
 \brief Initialize and authenticate your SDK instance to the FaceUnity server,
 must be called exactly once before all other functions. The buffers should
 NEVER be freed while the other functions are still being called. You can call
 this function multiple times to "switch pointers".
 \param v3data should point to contents of the "v3.bin" we provide
 \param sz_v3data should point to num-of-bytes of the "v3.bin" we provide
 \param ardata should be NULL
 \param authdata is the pointer to the authentication data pack we provide. You
 must avoid storing the data in a file. Normally you can just `#include
 "authpack.h"` and put `g_auth_package` here.
 \param sz_authdata is the authentication data size, we use plain int to avoid
 cross-language compilation issues. Normally you can just `#include
 "authpack.h"` and put `sizeof(g_auth_package)` here.
 \return non-zero for success, zero for failure
*/
FUNAMA_API int fuSetup(float* sdk_data, int sz_sdk_data, float* ardata,
                       void* authdata, int sz_authdata);

FUNAMA_API int fuSetupWithoutRetry(float* sdk_data, int sz_sdk_data,
                                   float* ardata, void* authdata,
                                   int sz_authdata);
/**
 \brief offline authentication
        Initialize and authenticate your SDK instance to the FaceUnity server,
 must be called exactly once before all other functions. The buffers should
 NEVER be freed while the other functions are still being called. You can call
 this function multiple times to "switch pointers".
 \param v3data should point to contents of the "v3.bin" we provide
 \param sz_v3data should point to num-of-bytes of the "v3.bin" we provide
 \param ardata should be NULL
 \param authdata is the pointer to the authentication data pack we provide. You
 must avoid storing the data in a file. Normally you can just `#include
 "authpack.h"` and put `g_auth_package` here.
 \param sz_authdata is the authentication data size, we use plain int to avoid
 cross-language compilation issues. Normally you can just `#include
 "authpack.h"` and put `sizeof(g_auth_package)` here.
 \param offline_bundle_ptr is the pointer to offline bundle from FaceUnity
 server
 \param offline_bundle_sz is size of offline bundle
 \return non-zero for success, zero for failure
*/

FUNAMA_API int fuSetupLocal(float* v3data, int sz_v3data, float* ardata,
                            void* authdata, int sz_authdata,
                            void** offline_bundle_ptr, int* offline_bundle_sz);

FUNAMA_API int fuSetupLocal2(float* v3data, int sz_v3data, float* ardata,
                             void* authdata, int sz_authdata,
                             void* offline_input_bundle_ptr,
                             int offline_input_bundle_sz,
                             void** offline_output_bundle_ptr,
                             int* offline_output_bundle_sz);

/**
 \brief Initialize and authenticate your SDK instance with internal check,
 must be called exactly once before all other functions. The buffers should
 NEVER be freed while the other functions are still being called. You can call
 this function multiple times to "switch pointers".
 \param v3data should point to contents of the "v3.bin" we provide
 \param sz_v3data should point to num-of-bytes of the "v3.bin" we provide
 \param ardata should be NULL
 \param authdata is the pointer to the authentication data pack we provide. You
 must avoid storing the data in a file. Normally you can just `#include
 "authpack.h"` and put `g_auth_package` here.
 \param sz_authdata is the authentication data size, we use plain int to avoid
 cross-language compilation issues. Normally you can just `#include
 "authpack.h"` and put `sizeof(g_auth_package)` here.
 \return non-zero for success, zero for failure
*/
FUNAMA_API int fuSetupInternalCheck(float* sdk_data, int sz_sdk_data,
                                    float* ardata, void* authdata,
                                    int sz_authdata);

/**
 \brief Initialize and authenticate your SDK instance with internal check,
 must be called exactly once before all other functions. The buffers should
 NEVER be freed while the other functions are still being called. You can call
 this function multiple times to "switch pointers".
 \param v3data should point to contents of the "v3.bin" we provide
 \param sz_v3data should point to num-of-bytes of the "v3.bin" we provide
 \param ardata should be NULL
 \param authdata is the pointer to the authentication data pack we provide. You
 must avoid storing the data in a file. Normally you can just `#include
 "authpack.h"` and put `g_auth_package` here.
 \param sz_authdata is the authentication data size, we use plain int to avoid
 cross-language compilation issues. Normally you can just `#include
 "authpack.h"` and put `sizeof(g_auth_package)` here.
 \param auth_info_data is the pointer to the encrypted authentication
 information data. You must avoid storing the data in a file, compute at runtime
 instead.
 \param sz_auth_info_data is the encrypted authentication information
 data size,
 \return non-zero for success, zero for failure
*/
FUNAMA_API int fuSetupInternalCheckEx(float* sdk_data, int sz_sdk_data,
                                      float* ardata, void* authdata,
                                      int sz_authdata, void* auto_info_data,
                                      int sz_auto_info_data);
/**
 \brief Initialize and authenticate your SDK instance with internal check,
 must be called exactly once before all other functions. The buffers should
 NEVER be freed while the other functions are still being called. You can call
 this function multiple times to "switch pointers".
 \param v3data should point to contents of the "v3.bin" we provide
 \param sz_v3data should point to num-of-bytes of the "v3.bin" we provide
 \param ardata should be NULL
 \param authdata is the pointer to the authentication data pack we provide. You
 must avoid storing the data in a file. Normally you can just `#include
 "authpack.h"` and put `g_auth_package` here.
 \param sz_authdata is the authentication data size, we use plain int to avoid
 cross-language compilation issues. Normally you can just `#include
 "authpack.h"` and put `sizeof(g_auth_package)` here.
 \return non-zero for success, zero for failure
*/
FUNAMA_API int fuSetupInternalCheckPackageBind(float* sdk_data, int sz_sdk_data,
                                               float* ardata, void* authdata,
                                               int sz_authdata);

/**
 \brief if opengl is supported return 1, else return 0
        call after fuSetup
*/
FUNAMA_API int fuGetOpenGLSupported();

/**
 \brief Generalized interface for rendering a list of items with extension.
        This function needs a GLES 2.0+ context.
 \param out_format is the output format
 \param out_ptr receives the rendering result, which is either a GLuint texture
handle or a memory buffer Note that in the texture cases, we will overwrite
*out_ptr with a texture we generate.
 \param in_format is the input format
 \param in_ptr points to the input image, which is either a GLuint texture
handle or a memory buffer
 \param w specifies the image width
 \param h specifies the image height
 \param frameid specifies the current frame id. To get animated effects, please
increase frame_id by 1 whenever you call this.
 \param p_items points to the list of items
 \param n_items is the number of items
 \param func_flag flags indicate all changable functionalities of render
interface
 \param p_masks indicates a list of masks for each item, bitwisely work
on certain face
 \return a GLuint texture handle containing the rendering result if out_format
isn't FU_FORMAT_GL_CURRENT_FRAMEBUFFER
*/
FUNAMA_API int fuRenderItemsEx2(int out_format, void* out_ptr, int in_format,
                                void* in_ptr, int w, int h, int frame_id,
                                int* p_items, int n_items, int func_flag,
                                void* p_item_masks);

FUNAMA_API int fuRender(int out_format, void* out_ptr, int in_format,
                        void* in_ptr, int w, int h, int frame_id, int* p_items,
                        int n_items, int func_flag, void* p_item_masks);

FUNAMA_API int fuRenderBundles(int out_format, void* out_ptr, int in_format,
                               void* in_ptr, int w, int h, int frame_id,
                               int* p_items, int n_items);

FUNAMA_API int fuRenderBundlesEx(int out_format, void* out_ptr, int in_format,
                                 void* in_ptr, int w, int h, int frame_id,
                                 int* p_items, int n_items, int func_flag,
                                 void* p_item_masks);

FUNAMA_API int fuRenderBundlesSplitView(int out_format, void* out_ptr,
                                        int in_format, void* in_ptr, int w,
                                        int h, int frame_id, int* p_items,
                                        int n_items, int func_flag,
                                        void* p_item_masks,
                                        TSplitViewInfo* split_info);

FUNAMA_API int fuRotateImage(void* in_ptr, int in_format, int in_w, int in_h,
                             int rotate_mode, int flip_x, int flip_y,
                             void* out_ptr1, void* out_ptr2);
/**
 this api will be deprecated. use
 fuSetInputCameraTextureMatrix/fuSetInputCameraBufferMatrix
 \brief input description for fuRenderBundles api, use to rotate or flip input
 texture to portrait mode.
 \param flip_x, flip input texture horizontally
 \param flip_y, flip input texture vertically
 \param rotate_mode w.r.t to rotation the the input texture counterclockwise,
 0=0^deg, 1=90^deg,2=180^deg, 3=270^deg
 */
FUNAMA_API void fuSetInputCameraMatrix(int flip_x, int flip_y, int rotate_mode);

/**
 \brief input description for fuRender api, use to transform the input gpu
 texture to portrait mode(head-up). then the final output will portrait mode.
 the outter user present render pass should use identity matrix to present the
 result.
 \param tex_trans_mat, the transform matrix use to transform the input
 texture to portrait mode.
 \note when your input is cpu buffer only don't use
 this api, fuSetInputCameraBufferMatrix will handle all case.
 */
FUNAMA_API void fuSetInputCameraTextureMatrix(TRANSFORM_MATRIX tex_trans_mat);

/**
 \brief input description for fuRender api, use to transform the input cpu
 buffer to portrait mode(head-up). then the final output will portrait mode. the
 outter user present render pass should use identity matrix to present the
 result.
 \param buf_trans_mat, the transform matrix use to transform the input
 cpu buffer to portrait mode.
 \note when your input is gpu texture only don't
 use this api, fuSetInputCameraTextureMatrix will handle all case.
 */
FUNAMA_API void fuSetInputCameraBufferMatrix(TRANSFORM_MATRIX buf_trans_mat);

/**
 \brief set input camera texture transform matrix state, turn on or turn off
 */

FUNAMA_API void fuSetInputCameraTextureMatrixState(bool isEnable);

/**
 \brief set input camera buffer transform matrix state, turn on or turn off
 */
FUNAMA_API void fuSetInputCameraBufferMatrixState(bool isEnable);
/**
 \brief add optional transform for final result, when use
 fuSetInputCameraTextureMatrix/fuSetInputCameraBufferMatrix, we means the output
 is in portrait mode(head-up), and the outter user present render pass should
 use identity matrix to present the result. but in some rare case, user would
 like to use a diffent orientation output. in this case,use
 fuSetInputCameraTextureMatrix/fuSetInputCameraBufferMatrix(portrait mode), then
 use the additional fuSetOutputMatrix to transform the final result to perfer
 orientation.
 \note Don't use this api unless you have to!
 */
FUNAMA_API void fuSetOutputMatrix(TRANSFORM_MATRIX out_trans_mat);

/**
 \brief set additional transform matrix state, turn on or turn off
 */
FUNAMA_API void fuSetOutputMatrixState(bool isEnable);

/**
 \brief set internal render target cache state, it is turn off by default.
 */
FUNAMA_API void fuSetRttCacheState(bool isEnable);

/**
 \brief control output resolution for fuRenderBundles.
 \param w, width of output texture
 \param h, height of output texture
 */
FUNAMA_API void fuSetOutputResolution(int w, int h);

/**
 \brief Generalized interface for rendering a list of items. This function needs
a GLES 2.0+ context.
 \param out_format is the output format
 \param out_ptr receives the rendering result, which is either a GLuint texture
handle or a memory buffer Note that in the texture cases, we will overwrite
*out_ptr with a texture we generate.
 \param in_format is the input format
 \param in_ptr points to the input image, which is either a GLuint texture
handle or a memory buffer
 \param w specifies the image width
 \param h specifies the image height
 \param frameid specifies the current frame id. To get animated effects, please
increase frame_id by 1 whenever you call this.
 \param p_items points to the list of items
 \param n_items is the number of items
 \return a GLuint texture handle containing the rendering result if out_format
isn't FU_FORMAT_GL_CURRENT_FRAMEBUFFER
*/
FUNAMA_API int fuRenderItemsEx(int out_format, void* out_ptr, int in_format,
                               void* in_ptr, int w0, int h0, int frame_id,
                               int* p_items, int n_items);

/**
 \brief Generalized interface for rendering a list of items. This function needs
a GLES 2.0+ context.
 \param out_format is the output format
 \param out_ptr receives the rendering result, which is either a GLuint texture
handle or a memory buffer Note that in the texture cases, we will overwrite
*out_ptr with a texture we generate.
 \param in_format is the input format
 \param in_ptr points to the input image, which is either a GLuint texture
handle or a memory buffer
 \param w specifies the image width
 \param h specifies the image height
 \param frameid specifies the current frame id. To get animated effects, please
increase frame_id by 1 whenever you call this.
 \param p_items points to the list of items
 \param n_items is the number of items
 \param p_masks indicates a list of masks for each item, bitwisely work on
certain face
 \return a GLuint texture handle containing the rendering result if out_format
isn't FU_FORMAT_GL_CURRENT_FRAMEBUFFER
*/
FUNAMA_API int fuRenderItemsMasked(int out_format, void* out_ptr, int in_format,
                                   void* in_ptr, int w0, int h0, int frame_id,
                                   int* p_items, int n_items,
                                   void* p_item_masks);

/**
\brief Generalized interface for beautifying image.
        Disable face tracker and item rendering.
        This function needs a GLES 2.0+ context.
\param out_format is the output format
\param out_ptr receives the rendering result, which is either a GLuint texture
handle or a memory buffer Note that in the texture cases, we will overwrite
*out_ptr with a texture we generate.
\param in_format is the input format
\param in_ptr points to the input image, which is either a GLuint texture handle
or a memory buffer
\param w specifies the image width
\param h specifies the image height
\param frameid specifies the current frame id. To get animated effects, please
increase frame_id by 1 whenever you call this.
\param p_items points to the list of items
\param n_items is the number of items
\return a GLuint texture handle containing the rendering result if out_format
isn't FU_FORMAT_GL_CURRENT_FRAMEBUFFER
*/
FUNAMA_API int fuBeautifyImage(int out_format, void* out_ptr, int in_format,
                               void* in_ptr, int w, int h, int frame_id,

                               int* p_items, int n_items);

/**
 \brief Create an accessory item from a binary package, you can discard the data
 after the call. This function MUST be called in the same GLES context / thread
 as fuRenderItems.
 \param data is the pointer to the data
 \param sz is the data size, we use plain int to avoid cross-language
 compilation issues
 \return an integer handle representing the item
*/
FUNAMA_API int fuCreateItemFromPackage(void* data, int sz);

FUNAMA_API int fuCreateLiteItemFromPackage(int handle, void* data, int sz);

/**
 \brief Destroy an accessory item. This function no need to be called in the
 same GLES context / thread as the original fuCreateItemFromPackage.
 \param item is the handle to be destroyed.
*/
FUNAMA_API void fuDestroyItem(int item);

/**
 \brief Destroy all accessory items ever created.This function MUST be called in
 the same GLES context / thread as the original fuCreateItemFromPackage.
*/
FUNAMA_API void fuDestroyAllItems();

/**
\brief Destroy all internal data, resources, threads, etc.
*/
FUNAMA_API void fuDestroyLibData();

/**
\brief Call this function when the GLES context has been lost, this function
won't do gl resource release, it only reset cpu flags.
*/
FUNAMA_API void fuOnDeviceLostSafe();

/**
\brief Call this function when the GLES context has been lost and recreated.
        That isn't a normal thing, so this function could leak resources on each
call.
*/
FUNAMA_API void fuOnDeviceLost();

/**
\brief Call this function when the GLES context has been lost and recreated.
        That isn't a normal thing, so this function could leak resources on
each. This function only releses all gl resource compared to fuOnDeviceLost
call.
*/
FUNAMA_API void fuReleaseGLResources();

/**
\brief Call this function when the GLES context has been lost and recreated.
        This function won't do gl resource release, it only reset cpu flags.
        This function only releses all gl resource compared to
fuOnDeviceLostSafe call.
*/
FUNAMA_API void fuReleaseGLResourcesSafe();

/**
\brief Call this function to reset the face tracker on camera switches
*/
FUNAMA_API void fuOnCameraChange();

/**
 \brief Check whether an item is debug version
 \param data - the pointer to the item data
 \param sz - the data size, we use plain int to avoid cross-language compilation
issues
 \return 0 - normal item 1 - debug item -1 - corrupted item data
*/
FUNAMA_API int fuCheckDebugItem(char* data, int sz);

/**
 \brief Bind items to target item, target item act as a controller,target item
 should has 'OnBind' function, already bound items won't be unbound
 \param obj_handle is the target item handle
 \param p_items points to a list of item handles to be bound to the  target item
 \param n_items is the number of item handles in p_items
 \return the number of items newly bound to the avatar
*/
FUNAMA_API int fuBindItems(int obj_handle, int* p_items, int n_items);

/**
 \brief Unbind items from the target item
 \param obj_hand is the target item handle
 \param p_items points to a list of item handles to be unbound from the target
 item
 \param n_items is the number of item handles in p_items
 \return the number of items unbound from the target item
*/
FUNAMA_API int fuUnbindItems(int obj_handle, int* p_items, int n_items);

/**
 \brief Unbind all items from the target item
 \param obj_handle is the target item handle
 \return the number of items unbound from the target item
*/
FUNAMA_API int fuUnbindAllItems(int obj_handle);

/**
 \warning: deprecated API，use fuBindItems instead
 \brief Bind items to an avatar, already bound items won't be unbound
 \param avatar_item is the avatar item handle
 \param p_items points to a list of item handles to be bound to the avatar
 \param n_items is the number of item handles in p_items
 \param p_contracts points to a list of contract handles for authorizing items
 \param n_contracts is the number of contract handles in p_contracts
 \return the number of items newly bound to the avatar
*/
FUNAMA_API int fuAvatarBindItems(int obj_handle, int* p_items, int n_items,
                                 int* p_contracts, int n_contracts);

/**
 \warning: deprecated API，use fuUnindItems instead
 \brief Unbind items from an avatar
 \param obj_handle is the avatar item handle
 \param p_items points to a list of item handles to be unbound from the avatar
 \param n_items is the number of item handles in p_items
 \return the number of items unbound from the avatar
*/
FUNAMA_API int fuAvatarUnbindItems(int obj_handle, int* p_items, int n_items);

/**
 \brief Get an item parameter as a double value
 \param obj_handle specifies the item
 \param name is the parameter name
 \return double value of the parameter
*/
FUNAMA_API double fuItemGetParamd(int obj_handle, const char* name);

/**
 \brief Set an item parameter to a double value
 \param obj_handle specifies the item
 \param name is the parameter name
 \param value is the parameter value to be set
 \return zero for failure, non-zero for success
*/
FUNAMA_API int fuItemSetParamd(int obj_handle, const char* name, double value);

/**
 \brief Set an item parameter to a double array
 \param item specifies the item
 \param name is the parameter name
 \param value points to an array of doubles
 \param n specifies the number of elements in value
 \return zero for failure, non-zero for success
*/
FUNAMA_API int fuItemSetParamdv(int obj_handle, const char* name, double* value,
                                int n);

/**
 \brief Get an item parameter as a string
 \param item specifies the item
 \param name is the parameter name
 \param buf receives the string value
 \param sz is the number of bytes available at buf
 \return the length of the string value, or -1 if the parameter is not a string.
*/
FUNAMA_API int fuItemGetParams(int obj_handle, const char* name, char* buf,
                               int buf_sz);

/**
 \brief Set an item parameter to a string value
 \param item specifies the item
 \param name is the parameter name
 \param value is the parameter value to be set
 \return zero for failure, non-zero for success
*/
FUNAMA_API int fuItemSetParams(int obj_handle, const char* name,
                               const char* value);

/**
 \brief Get an item parameter to a byte buffer
 \param obj_handle specifies the item
 \param name is the parameter name
 \param buf is the parameter value to be set
 \param n is the parameter value to be set
 \return zero for failure, non-zero for success
*/
FUNAMA_API int fuItemGetParamu8v(int obj_handle, const char* name, char* buf,
                                 int n);
/**
 \brief Set an item parameter to a byte buffer
 \param obj_handle specifies the item
 \param name is the parameter name
 \param buf is the parameter value to be set
 \param n is the parameter value to be set
 \return zero for failure, non-zero for success
*/
FUNAMA_API int fuItemSetParamu8v(int obj_handle, const char* name,
                                 const void* value, int n);

/**
\brief Set an item parameter to a u64 value
\param item specifies the item
\param name is the parameter name
\param value is the parameter value to be set
\return zero for failure, non-zero for success
*/
FUNAMA_API int fuItemSetParamu64(int item, char* name,
                                 unsigned long long value);

/**
\brief Get an item parameter as a double array
\param item specifies the item
\param name is the parameter name
\param buf receives the double array value
\param n specifies the number of elements in value
\return the length of the double array value, or -1 if the parameter is not a
double array.
*/
FUNAMA_API int fuItemGetParamdv(int item, char* name, double* buf, int n);

/**
\brief Get an item parameter as a float array
\param item specifies the item
\param name is the parameter name
\param buf receives the double array value
\param n specifies the number of elements in value
\return the length of the double array value, or -1 if the parameter is not a
double array.
*/
FUNAMA_API int fuItemGetParamfv(int item, char* name, float* buf, int sz);

/**
 \brief create a texture for a rgba buffer and set tex as an item parameter
 \param item specifies the item
 \param name is the parameter name
 \param value rgba buffer
 \param width image width
 \param height image height
 \return zero for failure, non-zero for success
*/
FUNAMA_API int fuCreateTexForItem(int item, const char* name, void* value,
                                  int width, int height);

/**
 \brief delete the texture in item,only can be used to delete texutre create by
 fuCreateTexForItem
 \param item specifies the item
 \param name is the parameter name
 \return zero for failure, non-zero for success
*/
FUNAMA_API int fuDeleteTexForItem(int item, const char* name);

/**
 \brief Get the face tracking status
 \return The number of valid faces currently being tracked
*/
FUNAMA_API int fuIsTracking();

/**
\brief Get library init status
\return 1 inited, 0 not init.
*/
FUNAMA_API int fuIsLibraryInit();

/**
 \brief Get the camera image size
 \param pret points to two integers, which receive the size
*/
FUNAMA_API void fuGetCameraImageSize(int* ret);

/**
 \brief Set the default orientation for face detection. The correct orientation
would make the initial detection much faster.
 \param rmode is the default orientation to be set to, one of 0..3 should work.
*/
FUNAMA_API void fuSetDefalutOrientation();

/**
\brief Set the default rotationMode.
\param rotationMode is the default rotationMode to be set to, one of 0..3 should
work.
*/
FUNAMA_API void fuSetDefaultRotationMode(int rotationMode);

/**
\brief Set the device's Orientation.
\param deviceOrientation is the device's runtime orientation, one of 0..3 should
work.
*/
FUNAMA_API int fuSetDeviceOrientation(int deviceOrientation);

/**
 \brief Set the maximum number of faces we track. The default value is 1.
 \param n is the new maximum number of faces to track
 \return The previous maximum number of faces tracked
*/
FUNAMA_API int fuSetMaxFaces(int n_max_faces);

/**
 \brief Set detect face every how number of frame when no face
 \param n is the number of frame
*/
FUNAMA_API void fuSetFaceProcessorDetectEveryNFramesWhenNoFace(int n_frames);

/**
 \brief Set detect face every how number of frame when having face
 \param n is the number of frame
*/
FUNAMA_API void fuSetFaceProcessorDetectEveryNFramesWhenFace(int n_frames);

/**
 \brief Get the unique identifier for each face during current tracking
        Lost face tracking will change the identifier, even for a quick retrack
 \param face_id is the id of face, index is smaller than which is set in
fuSetMaxFaces If this face_id is x, it means x-th face currently tracking
 \return the unique identifier for each face
*/
FUNAMA_API int fuGetFaceIdentifier(int face_id);

/**
 \brief Get face info. Certificate aware interface.
 \param face_id is the id of face, index is smaller than which is set in
fuSetMaxFaces If this face_id is x, it means x-th face currently tracking To get
a unique id for each face, use fuGetFaceIdentifier interface
 \param name the name of certain face info
 \param pret allocated memory space as container
 \param num is number of float allocated in pret
 eg:
  "landmarks" - 2D landmarks coordinates in image space - 75*2 float
  "landmarks_ar" - 3D landmarks coordinates in camera space - 75*3 float
  "eye_rotation" - eye rotation quaternion - 4 float - (Conversion between
quaternions and Eular angles:
https://en.wikipedia.org/wiki/Conversion_between_quaternions_and_Euler_angles)
  "translation" - 3D translation of face in camera space - 3 float
  "rotation" - rotation quaternion - 4 float - (Conversion between
quaternions and Eular angles:
https://en.wikipedia.org/wiki/Conversion_between_quaternions_and_Euler_angles)
  "projection_matrix" - the transform matrix from camera space to image space -
16 float
  "face_rect" - the rectangle of tracked face in image
space,(xmin,ymin,xmax,ymax) - 4 float
  "rotation_mode" - the relative orientaion of face agains phone, 0-3 - 1 float
  "failure_rate" - the failure rate of face tracking, the less the more
confident about tracking result - 1 float
 \return 1 means successful fetch, container filled with info 0 means failure,
general failure is due to invalid face info other specific failure will print on
the console
*/
FUNAMA_API int fuGetFaceInfo(int face_id, const char* name, void* pret,
                             int num);

/*
  result is rotated and fliped according to fuSetInputCameraBufferMatrix
*/
FUNAMA_API int fuGetFaceInfoRotated(int face_id, const char* name, void* pret,
                                    int num);

FUNAMA_API int fuGetAIInfo(int index, const char* name, void* pret, int num);
FUNAMA_API int fuGetAIInfoRotated(int index, const char* name, void* pret,
                                  int num);

FUNAMA_API void* fuGetFaceProcessorResult();
/**
 \warning deprecated api
 \brief Set the quality-performance tradeoff.
 \param quality is the new quality value.
       It's a floating point number between 0 and 1.
       Use 0 for maximum performance and 1 for maximum quality.
       The default quality is 1 (maximum quality).
*/
FUNAMA_API void fuSetQualityTradeoff(float quality);

/**
 * @brief Get the dynamic quality.
 *
 * @param quality
 * @return FUNAMA_API
 */
FUNAMA_API void fuGetDynamicQuality(float* quality);

/**
 * @brief Set the dynamic quality [0,1.0].
 *
 * @param quality
 * @return FUNAMA_API
 */
FUNAMA_API void fuSetDynamicQuality(float quality);

/**
 * @brief set the params.
 *
 * @param trigger_fps the fps value which triggers the quality controller.
 * bigger than 1, defualt is 25.
 * @param quality_change_speed control the speed of quliaty change. bigger than
 * 0,  defualt is 1.7.
 * @param quality_change_smooth_time control the smoothness of qulaity change.
 * bigger than 0, default is 2.5s.
 * @return FUNAMA_API
 */
FUNAMA_API void fuSetDynamicQualityParams(float trigger_fps,
                                          float quality_change_speed,
                                          float quality_change_smooth_time);
/**
 * @brief Set Dynamic Quality Tradeoff, if enable, the quality of rendering
 * will be adjust according to the fps automatically. default fps is 25. Should
 * be enabled on machine level 1,-1
 *
 *
 * @param enable true for enable, false for disable.
 * @return FUNAMA_API
 */
FUNAMA_API void fuSetDynamicQualityControl(bool enable);

/**
 \brief Set AI type for fuTrackFace and fuTrackFaceWithTongue interface
 \param ai_type, is a bit combination of FUAITYPE and subtypes;
 */
FUNAMA_API void fuSetTrackFaceAIType(unsigned long long ai_type);

/**
 \brief Generalized interface for tracking face.
 \param out_format is the output format
 \param out_ptr receives the rendering result, which is either a
GLuint texture handle or a memory buffer Note that in the texture cases, we will
overwrite *out_ptr with a texture we generate.
 \param in_format is the input format
 \param in_ptr points to the input image, which is either a GLuint texture
handle or a memory buffer
 \param w specifies the image width
 \param h specifies the image height
 \param frameid specifies the current frame id. To get animated
effects, please increase frame_id by 1 whenever you call this.
 \param p_items points to the list of items
 \param n_items is the number of items
 \return a GLuint texture handle containing the rendering result if out_format
isn't FU_FORMAT_GL_CURRENT_FRAMEBUFFER
*/
FUNAMA_API int fuTrackFace(int in_format, void* in_ptr, int w0, int h0);

/**
 \brief Generalized interface for tracking face with tongue tracking.
 */
FUNAMA_API int fuTrackFaceWithTongue(int in_format, void* in_ptr, int w0,
                                     int h0);

/**
 \brief Get system error, which causes system shutting down
 \return System error code represents one or more errors
        Error code can be checked against following bitmasks, non-zero result
means certain error This interface is not a callback, needs to be called on
every frame and check result, no cost Inside authentication error
(NAMA_ERROR_BITMASK_AUTHENTICATION), meanings for each error code are listed
below:
  1 failed to seed the RNG
  2 failed to parse the CA cert
  3 failed to connect to the server
  4 failed to configure TLS
  5 failed to parse the client cert
  6 failed to parse the client key
  7 failed to setup TLS
  8 failed to setup the server hostname
  9 TLS handshake failed
  10 TLS verification failed
  11 failed to send the request
  12 failed to read the response
  13 bad authentication response
  14 incomplete authentication palette info
  15 not inited yet
  16 failed to create a thread
  17 authentication package rejected
  18 void authentication data
  19 bad authentication package
  20 certificate expired 21 invalid certificate
*/
#define NAMA_ERROR_BITMASK_AUTHENTICATION 0xff
#define NAMA_ERROR_BITMASK_DEBUG_ITEM 0x100
#define NAMA_ERROR_SEED_RNG_FAILURE 1
#define NAMA_ERROR_PARSE_CA_CERT_FAILURE 2
#define NAMA_ERROR_CONNECT_SERVER_FAILURE 3
#define NAMA_ERROR_CONFIG_TLS_FAILURE 4
#define NAMA_ERROR_PARSE_CLIENT_CERT_FAILURE 5
#define NAMA_ERROR_PARSE_CLIENT_KEY_FAILURE 6
#define NAMA_ERROR_SETUP_TLS_FAILURE 7
#define NAMA_ERROR_SETUP_SERVER_FAILURE 8
#define NAMA_ERROR_TLS_HANDSHAKE_FAILURE 9
#define NAMA_ERROR_TLS_VERIFICATION_FAILURE 10
#define NAMA_ERROR_SEND_REQUEST_FAILURE 11
#define NAMA_ERROR_READ_RESPONSE_FAILURE 12
#define NAMA_ERROR_BAD_RESPONSE 13
#define NAMA_ERROR_INCOMPLETE_PALETTE_INFO 14
#define NAMA_ERROR_AUTH_NOT_INITED 15
#define NAMA_ERROR_CREATE_THREAD_FAILURE 16
#define NAMA_ERROR_AUTH_PACKAGE_REJECTED 17
#define NAMA_ERROR_VOID_AUTH_DATA 18
#define NAMA_ERROR_BAD_AUTH_PACKAGE 19
#define NAMA_ERROR_CERTIFICATE_EXPIRED 20
#define NAMA_ERROR_INVALID_CERTIFICATE 21
#define NAMA_ERROR_PARSE_SYSTEM_DATA_FAILURE 22
FUNAMA_API int fuGetSystemError();

/**
 \brief Interpret system error code
 \param code - System error code returned by fuGetSystemError()
 \return One error message from the code
*/
FUNAMA_API const char* fuGetSystemErrorString(int code);

/**
 \brief Turn on or turn off Tongue Tracking, used in trackface.
 \param enable > 0 means turning on, enable <= 0 means turning off
*/
FUNAMA_API int fuSetTongueTracking(int i);

/**
 \brief Turn on or turn off multisample anti-alising, msaa has an impact on
performance.
 \param samples > 0 means turning on, samples <= 0 means turning off, 0 by
default. samples<=GL_MAX_SAMPLES(usually 4).
*/
FUNAMA_API int fuSetMultiSamples(int samples);

/**
 \brief Load Tongue Detector data, to support tongue animation.
 \param data - the pointer to tongue model data 'tongue.bundle',
        which is along beside lib files in SDK package
 \param sz - the data size, we use plain int to avoid cross-language compilation
issues
 \return zero for failure, one for success
*/
FUNAMA_API int fuLoadTongueModel(void* data, int sz);

/**
 \warning deprecated api.
 */
FUNAMA_API void fuSetStrictTracking(int i);

/**
 \brief Get the current rotationMode.
 \return the current rotationMode, one of 0..3 should work.
*/
FUNAMA_API int fuGetCurrentRotationMode();

/**
 \brief Get certificate permission code for modules
 \param i - get i-th code, currently available for 0 and 1
 \return The permission code
*/
FUNAMA_API int fuGetModuleCode(int i);

/**
 \brief the same as fuIsTracking
 */
FUNAMA_API int fuHasFace();

/**
 \warning deprecated api.
 */
FUNAMA_API int fuSetASYNCTrackFace(int i);

/**
 \brief Clear Physics World
 \return 0 means physics disabled and no need to clear,1 means cleared
successfully
*/
FUNAMA_API int fuClearPhysics();

/**
 \warning depreated api
 */
FUNAMA_API int fuSetFaceDetParam(void* name, void* pinput);

/**
 \warning depreated api
 */
FUNAMA_API int fuSetFaceTrackParam(void* name, void* pinput);

/**
 \brief Get SDK version string, Major.Minor.Fix_ID
 \return SDK version string in const char*
*/
FUNAMA_API const char* fuGetVersion();

/**
 \brief Get SDK commit time string
 \return SDK commit time string in const char*
*/
FUNAMA_API const char* fuGetCommitTime();

/**
 \brief Load AI model data, to support tongue animation.
 \param data - the pointer to AI model data 'ai_xxx.bundle',which is along
beside lib files in SDK package
 \param sz - the data size, we use plain int to avoid cross-language compilation
issues
 \param type - define in FUAITYPE enumeration.
 \return zero for failure, one for success.
*/
FUNAMA_API int fuLoadAIModelFromPackage(void* data, int sz, FUAITYPE type);

/**
 \brief Preprocess AI model.
 \param data - the pointer to AI model data 'ai_xxx.bundle',which is along
beside lib files in SDK package
 \param sz - the data size, we use plain int to avoid cross-language compilation
issues
 \param type - define in FUAITYPE enumeration.
 \return zero for failure, one for success.
*/
FUNAMA_API int fuPreprocessAIModelFromPackage(void* data, int sz,
                                              FUAITYPE type);

/**
 \brief Release AI Model, when no more need some type of AI albility.
 \param type - define in FUAITYPE enumeration.
 \return zero for failure, one for success.
*/
FUNAMA_API int fuReleaseAIModel(FUAITYPE type);

/**
 \brief Get AI Model load status
 \param type - define in FUAITYPE enumeration.
 \return zero for unloaded, one for loaded.
*/
FUNAMA_API int fuIsAIModelLoaded(FUAITYPE type);

/**
 \brief Render a list of items on top of a GLES texture or a memory buffer.
        This function needs a GLES 2.0+ context.
 \param texid specifies a GLES texture. Set it to 0u if you want to render to a
memory buffer.
 \param img specifies a memory buffer. Set it to NULL if you want
to render to a texture. If img is non-NULL, it will be overwritten by the
rendered image when fuRenderItems returns
 \param w specifies the image width
 \param h specifies the image height
 \param frameid specifies the current frame id.
        To get animated effects, please increase frame_id by 1 whenever you call
this.
 \param p_items points to the list of items
 \param n_items is the number of items
 \return a new GLES texture containing the rendered image in the texture
mode
*/
FUNAMA_API int fuRenderItems(int texid, int* img, int w, int h, int frame_id,
                             int* p_items, int n_items);

/**
\brief set crop state.
\param state is the Cropped switch
\return zero for closed, one for open
*/
FUNAMA_API int fuSetCropState(int state);

/**
\brief Set the coordinates of the crop.
\param (x0,y0) is the coordinates of the starting point after cropping. (x0,y0)
is (0,0) befor cropping \param (x1,y1) is the coordinate of the end point after
cropping. (x1,y1) is (imageWideth, imageHeight) before cropping \return zero for
failure, one for success
*/
FUNAMA_API int fuSetCropFreePixel(int x0, int y0, int x1, int y1);

/**
\brief Count API calls.
\param name is the API name
*/
FUNAMA_API int fuAuthCountWithAPIName(char* name);

FUNAMA_API void fuHexagonInitWithPath(const char* lib_directory_path);
FUNAMA_API void fuHexagonTearDown();

/**
 \brief set if use pixel buffer to speed up reading pixel from buffer.
 \param use,set use or not use.
*/
FUNAMA_API int fuSetUsePbo(bool use);

/**
 \brief set Set texture loading quality
 \param quality, 0:high 1:medium 2.low
*/
FUNAMA_API int fuSetLoadQuality(int quality);

/**
 \brief set if use the output texture for async reading, when use spcified
 framebuffer for output. \param use,set 1 for use or 0 for not use, not use by
 default for performance.
*/
FUNAMA_API int fuSetUseTexAsync(bool use);

/**
 \brief set if force use gl 2.
 \param use,set 1 for use or 0 for not use.
*/
FUNAMA_API int fuSetForceUseGL2(int use);

/**
 * \brief HandGestureCallBack,callback with first handgesture type.
 * \param type, ref to FUAIGESTURETYPE
 */
typedef void (*HandGestureCallBack)(int type);

/**
 * \brief set callback for handgesture detection.
 * \param onHandGestureListener,
 * callback. will override the older one, null for reset callback.
 * \note this callback will be called with the first hand's type, you should
 * use fuHandDetectorGetResultNumHands and fuHandDetectorGetResultGestureType
 * for all info.
 * \note this callback will be called when calling Render* interface. when use
 * fuTrackFace*, you should use fuHandDetectorGetResultNumHands and
 * fuHandDetectorGetResultGestureType for all info.
 */
FUNAMA_API void fuSetHandGestureCallBack(HandGestureCallBack cb);

/**
 * \brief ItemCallBack,callback.
 * \param handle, ref to handle for triggered item.
 * \param type, ref to FUITEMTRIGGERTYPE.
 */
typedef void (*ItemCallBack)(int handle, int type);

/**
 * \brief set callback for item.
 * \param item,
 * handle for time
 * \param cb,
 * callback. will override the older one, null for reset callback.
 * \note this callback will be called when calling Render* interface.
 */
FUNAMA_API int fuSetItemCallBack(int handle, ItemCallBack cb);

/**
 * \brief prepare GL resource for a list of items in advance
 *        This function needs a GLES 2.0+ context.
 * \param p_items, points to the list of items
 * \param n_items, is the number of items
 */
FUNAMA_API void fuPrepareGLResource(int* p_items, int n_items);

/**
 \brief check prepare gl resource is ready.
        This function needs a GLES 2.0+ context.
 \param output, 1 for ready prepared, 0 false, -1 load program binary failed
*/
FUNAMA_API int fuIsGLPrepared(int* p_items, int n_items);

FUNAMA_API int fuGetFaceTransferTexID();

/**
 * \brief set use async ai inference.
 * \param use_async,
 * ture or false.
 */
FUNAMA_API int fuSetUseAsyncAIInference(int use_async);

/**
 * \brief set use multi buffer.
 * \param use_multi_gpu_textuer,
 * ture or false.
 * \param use_multi_cpu_buffer,
 * ture or false.
 */
FUNAMA_API int fuSetUseMultiBuffer(int use_multi_gpu_textuer,
                                   int use_multi_cpu_buffer);

/**
 \brief check gl error
 \return OpenGL error information, 0 for no error
*/
FUNAMA_API int fuCheckGLError();

/**
 FaceProcessor related api
*/

/**
 \brief Set tracking fov for ai model FaceProcessor.
 */
FUNAMA_API int fuSetFaceProcessorFov(float fov);

/**
 \brief Get tracking fov of ai model FaceProcessor.
 */
FUNAMA_API float fuGetFaceProcessorFov();

/**
 \brief set faceprocessor's face detect mode. when use 1 for video mode, face
 detect strategy is opimized for no face scenario. In image process scenario,
 you should set detect mode into 0 image mode.
 \param mode, 0 for image, 1 for video, 1 by default
 */
FUNAMA_API int fuSetFaceProcessorDetectMode(int mode);

/**
 \brief set ai model FaceProcessor's minium track face size.
 \param ratio, ratio with min(w,h).
 */
FUNAMA_API void fuFaceProcessorSetMinFaceRatio(float ratio);

/**
 \brief set ai model FaceProcessor's landmark quality.
 \param quality, landmark quality, 0 for low quality, 1 for mediem, 2 for high
 quality. 1 by default.
 */
FUNAMA_API void fuFaceProcessorSetFaceLandmarkQuality(int quality);

/**
 \brief set ai model FaceProcessor's detector mode.
 \param use, 0 for disable detect small face, 1 for enable detect small face
 */
FUNAMA_API void fuFaceProcessorSetDetectSmallFace(int use);

/**
 \brief set ai model FaceProcessor use capture eye look camera.
 \param use, 0 for disable, 1 for enable
 \return zero for failed, one for success
 */
FUNAMA_API int fuFaceProcessorSetUseCaptureEyeLookCam(int use);

/**
 \brief get ai model FaceProcessor's tracking hair mask with index.
 \param index, index of fuFaceProcessorGetNumResults.
 \param mask_width,  width of return.
 \param mask_height,  height of return.
 \return mask data.
 */
FUNAMA_API const float* fuFaceProcessorGetResultHairMask(int index,
                                                         int* mask_width,
                                                         int* mask_height);

/**
 \brief get ai model FaceProcessor's tracking head mask with index.
 \param index, index of fuFaceProcessorGetNumResults.
 \param mask_width,  width of return.
 \param mask_height,  height of return.
 \return mask data.
 */
FUNAMA_API const float* fuFaceProcessorGetResultHeadMask(int index,
                                                         int* mask_width,
                                                         int* mask_height);

/**
 \brief get ai model FaceProcessor's tracking face occlusion.
 \param index, index of fuFaceProcessorGetNumResults.
 \return zero for no occlusion, one for occlusion, minus one for no tracked face
 */
FUNAMA_API int fuFaceProcessorGetResultFaceOcclusion(int index);

/**
 \brief get ai model FaceProcessor's face detection confidence score.
 \param index, index of fuFaceProcessorGetNumResults.
 \return face detection confidence score.
 */
FUNAMA_API float fuFaceProcessorGetConfidenceScore(int index);

/**
 \brief get ai model FaceProcessor's tracking face count.
 \return  num of faces.
 */
FUNAMA_API int fuFaceProcessorGetNumResults();

/**
 HumanProcessor related api
*/

/**
 \brief set humanprocessor's human detect mode. when use 1 for video mode, human
 detect strategy is opimized for no human scenario. In image process scenario,
 you should set detect mode into 0 image mode.
 \param mode, 0 for image, 1 for video, 1 by default
 */
FUNAMA_API int fuSetHumanProcessorDetectMode(int mode);

/**
 \brief Reset ai model HumanProcessor's tracking state.
*/
FUNAMA_API void fuHumanProcessorReset();

/**
 \brief set ai model HumanProcessor's maxinum tracking people.
 */
FUNAMA_API void fuHumanProcessorSetMaxHumans(int max_humans);

/**
\param n_buffer_frames(default 5 and > 0): filter buffer frames.
\param pos_w(default 0.05 and >= 0): root position filter weight, less pos_w
-> smoother.
\param angle_w(default 1.2 and >= 0): joint angle filter weight, less angle_w ->
smoother.
 */
FUNAMA_API void fuHumanProcessorSetAvatarAnimFilterParams(int n_buffer_frames,
                                                          float pos_w,
                                                          float angle_w);

/**
 \brief set ai model HumanProcessor's tracking fov, use to 3d joint projection.
 \param fov.
 */
FUNAMA_API void fuHumanProcessorSetFov(float fov);

/**
 \brief get ai model HumanProcessor's tracking fov, use to 3d joint projection.
 \return fov
 */
FUNAMA_API float fuHumanProcessorGetFov();

/**
 \brief get ai model HumanProcessor's tracking result.
 \return tracked people number
 */
FUNAMA_API int fuHumanProcessorGetNumResults();

/**
 \brief get ai model HumanProcessor's tracking id.
 \param index, index of fuHumanProcessorGetNumResults
 \return tracking id
 */
FUNAMA_API int fuHumanProcessorGetResultTrackId(int index);

/**
 \brief get ai model HumanProcessor's tracking human state with id.
 \param index is index of fuHumanProcessorGetNumResults
 \return state, enum of FUAIHUMANSTATE
 */
FUNAMA_API int fuHumanProcessorGetHumanState(int index);

/**
 \brief get ai model HumanProcessor's tracking gesture types with id.
 \param index is index of fuHumanProcessorGetNumResults
 \param size, size of return data.
 \return gesture types array, [left hand gesture, right hand gesture], enum of
 FUAIGESTURETYPE
 */
FUNAMA_API const int* fuHumanProcessorGetGestureTypes(int index, int* size);

/**
 \brief get ai model HumanProcessor's action type with index.
 \param index, index of fuHumanProcessorGetNumResults
 \return action type
 */
FUNAMA_API int fuHumanProcessorGetResultActionType(int index);

/**
 \brief get ai model HumanProcessor's action score with index.
 \param index, index of fuHumanProcessorGetNumResults
 \return score
 */
FUNAMA_API float fuHumanProcessorGetResultActionScore(int index);

/**
 \brief get ai model HumanProcessor's tracking rect with index.
 \param index, index of fuHumanProcessorGetNumResults
 \return rect array
 */
FUNAMA_API const float* fuHumanProcessorGetResultRect(int index);

/**
 \brief get ai model HumanProcessor's tracking 2d joint with index.
 \param index, index of fuHumanProcessorGetNumResults
 \param size,  size of return data.
 */
FUNAMA_API const float* fuHumanProcessorGetResultJoint2ds(int index, int* size);

/**
 \brief get ai model HumanProcessor's tracking 3d joint with index.
 \param index, index of fuHumanProcessorGetNumResults
 \param size,  size of return data.
 */
FUNAMA_API const float* fuHumanProcessorGetResultJoint3ds(int index, int* size);

/**
 \brief get ai model HumanProcessor's pof2d joint with index.(The joint2ds
 generated by human driver). \param index, index of
 fuHumanProcessorGetNumResults \param size,  size of return data.
 */
FUNAMA_API const float* fuHumanProcessorGetResultPofJoint2ds(int index,
                                                             int* size);

/**
 \brief get ai model HumanProcessor's pof2d joint scores with index. (The
 joint2ds generated by human driver). \param index, index of
 fuHumanProcessorGetNumResults \param size,  size of return data.
 */
FUNAMA_API const float* fuHumanProcessorGetResultPofJointScores(int index,
                                                                int* size);

/**
 \brief enable model HumanProcessor's BVH motion frame output.
 \param enable: (default is true).
 */
FUNAMA_API void fuHumanProcessorSetEnableBVHOutput(bool enable);

/**
 \brief set the inplane rotation of model HumanProcessor's BVH output.
 \param inplane_rot: inplane counter-clock-wise rotation type.
 */
FUNAMA_API void fuHumanProcessorSetBVHInPlaneRotation(
    FUAIHUMANROTTYPE inplane_rot);

/**
 \brief set the inplane mirror type of model HumanProcessor's BVH output.
 \param inplane_mirror_type: inplane mirror type.
 */
FUNAMA_API void fuHumanProcessorSetBVHInPlaneMirrorType(
    FUAIHUMANMIRRORTYPE inplane_mirror_type);

/**
 \brief get model HumanProcessor's BVH motiont frame output.
 \param index: index of fuHumanProcessorGetNumResults
 \param size:  size of return data.
 */
FUNAMA_API const float* fuHumanProcessorGetResultBVHMotionFrameOutput(
    int index, int* size);

/**
 \brief get ai model HumanProcessor's tracking full body mask with index.
 \param index, index of fuHumanProcessorGetNumResults.
 \param mask_width,  width of return.
 \param mask_height,  height of return.
 \return mask data.
 */
FUNAMA_API const float* fuHumanProcessorGetResultHumanMask(int index,
                                                           int* mask_width,
                                                           int* mask_height);

/**
 \brief calculate action distance.
 \return score of distance, range [0,1], 1 for fully match.
*/
FUNAMA_API float fuHumanActionMatchDistance(const float* src_pose, int sz_src,
                                            const float* ref_pose, int sz_ref);

/**
 \brief calculate action distance with left and right.
 \return score of distance, range [0,1], 1 for fully match.
*/
FUNAMA_API float fuHumanActionMatchLeftRightHandDistance(const float* src_pose,
                                                         int sz_src,
                                                         const float* ref_pose,
                                                         int sz_ref,
                                                         bool mirror);

/**
 \brief get hand detector's tracking results.
 \return num of hand tracked.
*/
FUNAMA_API int fuHandDetectorGetResultNumHands();

/**
 \brief get hand detector's tracking rect with index.
 \param index ,index of fuHandDetectorGetResultNumHands.
 \return rect data, float array with size 4.
*/
FUNAMA_API const float* fuHandDetectorGetResultHandRect(int index);

/**
 \brief get hand detector's tracking hand gesture type with index.
 \param index ,index of fuHandDetectorGetResultNumHands.
 \return gesture type, ref to FUAIGESTURETYPE.
*/
FUNAMA_API FUAIGESTURETYPE fuHandDetectorGetResultGestureType(int index);

/**
 \brief get hand detector's tracking hand gesture score with index.
 \param index ,index of fuHandDetectorGetResultNumHands.
 \return gesture score, range [0,1]
*/
FUNAMA_API float fuHandDetectorGetResultHandScore(int index);

FUNAMA_API void fuSetOutputImageSize(int w, int h);

FUNAMA_API void fuSetCacheDirectory(const char* dir);

/**
 \brief cache data manually.
*/
FUNAMA_API void fuRunCache();

/**
 \brief record current memory usage. this interface works on android for now.
 The device must root and run corrspond monitor process.
 \return zero for failure, one for success
*/
FUNAMA_API int fuRecordMemoryUsage(const char* tag);

/**
 \brief when application pause calling fuRender,  call
 fuSetRenderPauseState(true) to pause the internal physis update.
 \param pause ,pause state, if true SDK will pause physis update, and will be
 turn on in next fuRender call automatically.
 */
FUNAMA_API void fuSetRenderPauseState(bool pause);

/**
 \brief internal api for profile
 */
FUNAMA_API int fuProfileGetNumTimers();
FUNAMA_API const char* fuProfileGetTimerName(int index);
FUNAMA_API long long fuProfileGetTimerAverage(int index);
FUNAMA_API long long fuProfileGetTimerCount(int index);
FUNAMA_API long long fuProfileGetTimerMin(int index);
FUNAMA_API long long fuProfileGetTimerMax(int index);
FUNAMA_API int fuProfileResetAllTimers();

FUNAMA_API void fuSetForcePortraitMode(int mode);

FUNAMA_API void fuSetFaceDelayLeaveFrameNum(int frame_num);

FUNAMA_API void fuSetFaceDelayLeaveEnable(bool use);

FUNAMA_API void fuSetHumanSegScene(FUAIHUMANSEGSCENETYPE seg_scene);

FUNAMA_API void fuSetHandDetectEveryNFramesWhenNoHand(int frame_num);

FUNAMA_API void fuSetHumanSegMode(FUAIHUMANSEGMODE flag);

/**
 \brief set face processor model config, ref to FUAIFACEMODELCONFIG
*/
FUNAMA_API void fuSetFaceModelConfig(long long flag);
/**
 \brief set face processor algorithm config, ref to FUAIFACEALGORITHMCONFIG ,
 use to disable some sub-module while load face ai module
*/
FUNAMA_API void fuSetFaceAlgorithmConfig(long long flag);

/**
 \brief set face processor model config, ref to FUAIHUMANMODELCONFIG, config cpu
 or gpu mode,eth.
 */
FUNAMA_API void fuSetHumanModelConfig(long long flag);
/**
 \brief set human processor algorithm config, ref to FUAIHUMANALGORITHMCONFIG ,
 use to disable some sub-module while load human ai module
*/
FUNAMA_API void fuSetHumanAlgorithmConfig(long long flag);

/**
 \brief force fu ai model to run on CPU
*/
FUNAMA_API void fuSetModelToCPU();

FUNAMA_API void fuSetMachineType(FUAIMACHINETYPE flag);

FUNAMA_API void fuSetMakeupCoverResource(bool is_cover);

FUNAMA_API bool fuGetDelspotStatus();

FUNAMA_API void fuSetARMeshV2(bool use);

#ifdef __cplusplus
}
#endif

#endif  // !CNAMASDK_H
