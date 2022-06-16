# Contorller Parameter Documentation

## Special Instructions
```C
The handle of controller.bundle created by fuCreateItemFromPackage is 1
//After creating a controller, first create a controller_config.bundle and bind it to the controller. In this way, the controller is initialized correctly.
```
------

## Multiplayer Mode
```C
//Use fuBindItems to bind props, fuUnbindItems to unbind props, and parameters set on controller to affect the current role. By default, the ID of the current role is No. 0.

//To use multiplayer mode, you need to set the parameter current_instance_id, switch the current role. For example, switch to role 1:
fuItemSetParamd(1, "current_instance_id", 1.0);

//Get ID of the current role
fuItemGetParamd(1, "current_instance_id");

//Destroy the instance of the corresponding parameter and release the resources occupied by the corresponding instance. The currently used instance cannot be released
fuItemSetParamd(1, "destroy_instance", 1.0);
```

------

## Set Role Location
```C
//Nama uses the right-hand coordinate system, X-axis horizontal right, Y-axis vertical up, Z-axis vertical screen out
```
------
##### Sets the rotation angle of the character about the Y axis in 3D space
```C
//The third parameter is the normalized rotation angle, range [0.0, 1.0], 0.0 represents 0 degrees, 1.0 represents 360 degrees
fuItemSetParamd(1, "target_angle", 0.5);
```
##### Set the size of the character
```C
//The third parameter is the z-direction coordinates of the character in 3D space, with the range of [- 3000, 600]. The larger the value is, the larger the character will be displayed
fuItemSetParamd(1, "target_scale", -300.0);
```
##### Set the vertical position of the character
```C
//The third parameter is the position and range of the character in the Y direction in 3D space[-600, 800]
fuItemSetParamd(1, "target_trans", 30.0);
```
##### Set the position of the character in 3D space
```C
//The third parameter is the character's coordinates in 3D space [x, y, Z], X range [- 200, 200], y range [- 600, 800], Z range [- 3000, 600]
fuItemSetParamdv(1, "target_position", [30.0, 0.0, -300]);
```
##### Call the reset command to make the above setting command  of position effective
```C
//The third parameter is the number of transition frames, with a range of [1.0, 60.0], indicating how many frames have passed from the current position to the target position
fuItemSetParamd(1, "reset_all", 1.0);
```
------
##### Rotate character
```C
//The third parameter is the rotation increment, and the value range[-1.0, 1.0]
fuItemSetParamd(1, "rot_delta", 1.0);
```
##### Zoom character
```C
//The third parameter is scaling increment, value range[-1.0, 1.0]
fuItemSetParamd(1, "scale_delta", 1.0);
```
##### Move characters up and down
```C
//The third parameter is the up-down increment, with a range[-1.0, 1.0]
fuItemSetParamd(1, "translate_delta", 1.0);
```

##### Get the position of the character in 3D space
```C
fuItemGetParamdv(1, "current_position");
```
------

## Animation Control
```C
//Suppose: the handle of anim.bundle created by fuCreateItemFromPackage is 2
//The following control interfaces are only valid for the current role
```
------
```C
//The number of bones supported by individual devices is limited, so it is not possible to run bone animation by default. Turn on this option at this time
fuItemSetParamd(1, "enable_vtf", 1.0); 

//Play animation with handle 2 from scratch (loop)
fuItemSetParamd(1, "play_animation", 2);

//Play animation with handle 2 from scratch (single shot)
fuItemSetParamd(1, "play_animation_once", 2);

//Continue to play the current animation. The parameters are meaningless
fuItemSetParamd(1, "start_animation", 1);

//Pause the current animation. The parameters are meaningless
fuItemSetParamd(1, "pause_animation", 1);

//Stop playing animation. The parameters are meaningless
fuItemSetParamd(1, "stop_animation", 1);

//Reset animation, parameters meaningless, the effect is equivalent to call stop_animation first, then call start_animation
fuItemSetParamd(1, "reset_animation", 1);

//Sets the transition time of the animation in seconds
fuItemSetParamd(1, "animation_transition_time", 4.0); 

//1 is on and 0 is off. When on, 25 frames of animation will be interpolated to the actual number of rendered frames (such as 60 frames) to make the animation smoother. However, in some cases, it is not suitable for interpolation. If there are flash operations and other animations that do not want interpolation, you can take the initiative to close them.
//This parameter is turned on by default
//This switch does not have an effect on the loaded animation, which cannot change the inter frame interpolation in real time
//Turn on or off this switch and then load the animation, which will produce the above effect
fuItemSetParamd(1, "animation_internal_lerp", 1.0); 

//Get the current progress of the animation with handle 2
//0 ~ 0.9999 is the first cycle, 1.0 ~ 1.9999 is the second cycle, and so on
//Even if play_animation_once, the progress will break through 1.0 and run as usual
fuItemGetParamd(1, "{\"name\":\"get_animation_progress\", \"anim_id\":2}"); 

//Get the current transition progress of the animation with handle 2
//When the progress is less than 0, the animation is not in the transition state, whether as source or target
//When the progress is greater than or equal to 0, the animation is in the transition, the range is 0 ~ 1.0, 0 is the beginning and 1.0 is the end
fuItemGetParamd(1, "{\"name\":\"get_animation_transition_progress\", \"anim_id\":2}"); 

//Get the total number of frames of animation with handle 2
fuItemGetParamd(1, "{\"name\":\"get_animation_frame_num\", \"anim_id\":2}"); 

//Get the layerid of the animation with handle 2
fuItemGetParamd(1, "{\"name\":\"get_animation_layerid\", \"anim_id\":2}"); 

//Print current animation system status
fuItemSetParamd(1, "animator_Print", 1);
fuItemSetParamd(1, "Bone_Print", 1);
fuItemSetParamd(1, "BlendShape_Print", 1);
fuItemSetParamd(1, "Camera_Print", 1);
```

------

## DynamicBone Control
```C
//Suppose: the handle of mesh.bundle with physical mesh props created by fuCreateItemFromPackage is 2
//The following control interfaces are only valid for the current role
```
------
```C
//1 is on and 0 is off. When on, the value of the mobile character will be set into the skeleton system. At this time, the model with DynamicBone will have related effects
//If you add a model without bones, turn off this value, otherwise you cannot move the model
//Off by default
//The value of each role is independent
fuItemSetParamd(1, "modelmat_to_bone", 1.0); 

//When 1 is on and 0 is off, the loaded physics will take effect when it is on, and the new bundle with physics will also take effect when it is loaded. When it is off, the loaded physics will stop taking effect, but the cache will not be cleared (when it is turned on again, the physics will take effect here). At this time, the bundle with physics will not take effect and the cache will not be generated, That is to say, if the bundle with physics loaded after closing is opened again immediately, the physics will not take effect and needs to be reloaded
fuItemSetParamd(1, "enable_dynamicbone", 1.0); 

//This parameter and enable_dynamicbone are union, that is, when both enable_dynamicbone and enable_single_dynamicbone are turned on, physics will run
//New loading prop enable_single_dynamicbone is on
//Open the physical effect of the prop with the specified handle separately, and the input parameter is the prop handle
fuItemSetParamd(1, "enable_single_dynamicbone", 2); 
//Individually close the physical effect of the prop with the specified handle, and the input parameter is the prop handle
fuItemSetParamd(1, "disable_single_dynamicbone", 2); 

//1 is on and 0 is off. When on, character movement or animation will not displace the bones controlled by dynamicbone. When off, the effect of dynamicbone will be calculated. When the character needs to move / rotate quickly, it is strongly recommended to turn this on, and then turn it off after the movement / rotation is finished, so as to prevent threading and flashing.
fuItemSetParamd(1, "dynamicBone_TeleportMode", 1.0); 

//1 is on and 0 is off. The speed limit switch of the root bone (the root bone specified when editing DynamicBone) will automatically reset when the speed of the root bone exceeds a certain value
//The default value and speed limit value are edited and saved in the corresponding bundle
fuItemSetParamd(1, "dynamicBone_RootTranslateSpeedLimitMode", 1.0); 
//1 is on and 0 is off. The speed limit switch of the root bone (the root bone specified when editing dynamicbone) will automatically reset when the rotation speed of the root bone exceeds a certain value
//The default value and speed limit value are edited and saved in the corresponding bundle
fuItemSetParamd(1, "dynamicBone_RootRotateSpeedLimitMode", 1.0); 

//Sometimes fast movement / rotation or large animation will cause some rigid bodies to be stuck. At this time, you can set the following two parameters to restore the default position of the rigid body. The parameters of these two interfaces are meaningless, just occupying space
//Refresh will reconstruct the whole DynamixBone，with great costs. Don't use it unless you have to
fuItemSetParamd(1, "dynamicBone_Refresh", 1.0); 
//Reset will reset the position of the rigid body, and the consumption is small. This is recommended. Use Refresh when Reset is invalid.
fuItemSetParamd(1, "dynamicBone_Reset", 1.0); 
//The refresh interface is a delayed version, which won't executed immediately, but will executed at the next rendering frame
fuItemSetParamd(1, "dynamicBone_Delay_Refresh", 1.0); 
//The reset interface is a delayed version，which won't executed immediately, but will executed at the next rendering frame
fuItemSetParamd(1, "dynamicBone_Delay_Reset", 1.0); 

//Print the current DynamicBone state
fuItemSetParamd(1, "dynamicBone_Print", 1);
```

------

## Cloth NvCloth Control
```C
//Suppose: the handle of mesh.bundle with cloth created by fuCreateItemFromPackage is 2
//The following control interfaces are only valid for the current role
```
------
```C
//1 is on, 0 is off, when it is on, the value of moving character will be set into the bone system. At this time, the model with fabric NvCloth will have relevant effects
//If you add a model without bones, turn off this value, otherwise you cannot move the model
//Off by default
//The value of each role is independent
fuItemSetParamd(1, "modelmat_to_bone", 1.0); 

//When 1 is on and 0 is off, the loaded physics will take effect when it is on, and the new bundle with physics will also take effect when it is loaded. When it is off, the loaded physics will stop taking effect, but the cache will not be cleared (when it is turned on again, the physics will take effect here). At this time, the bundle with physics will not take effect and the cache will not be generated, That is to say, if the bundle with physics loaded after closing is opened again immediately, the physics will not take effect and needs to be reloaded
fuItemSetParamd(1, "enable_nvcloth", 1.0); 

//This parameter and enable_nvcloth are union enable_nvcloth, that is to day, when both enable_nvcloth and enable_single_nvcloth turn on，physics will work
//New loading prop enable_single_nvcloth is on
//Open the physical effect of the prop with the specified handle separately, and the input parameter is the prop handle
fuItemSetParamd(1, "enable_single_nvcloth", 2); 
//Individually close the physical effect of the prop with the specified handle, and the input parameter is the prop handle
fuItemSetParamd(1, "disable_single_nvcloth", 2); 

//The character movement or animation between the execution of this line of code and the next frame will not make the model of the cloth nvcloth produce displacement effect. When the character needs to move / rotate quickly, it is strongly recommended to turn this on every frame, and then turn it off after the movement / rotation is finished, so as to prevent threading and flashing.
//The parameters of this interface are meaningless, just occupying the space
//This interface is not executed immediately, but at the next frame of rendering
fuItemSetParamd(1, "nvcloth_TeleportMode", 1.0); 

//Sometimes fast movement / rotation or large animation will cause some rigid bodies to be stuck. At this time, you can set the following two parameters to restore the default position of rigid bodies.
//The parameters of this interface are meaningless, just occupying the space
//This interface is not executed immediately, but at the next frame of rendering
fuItemSetParamd(1, "nvcloth_Refresh", 1.0); 
```

------

## Camera Control
//Control the lens parameters of the camera through the following interfaces

```C
//The default value is 0
//0 is perspective projection, when FOV works, it has the effect of near big far small
//When 1 is a parallel projection, render_orth_size takes effect. No near big far small, object distance does not affect the size on the screen, use render_orth_size to control the size of an object on the screen
fuItemSetParamd(1,"project_mode",0);
int project_mode = fuItemGetParamd(1, "project_mode");

//Control the camera lens focus position, the default value is [0, 140, 0], the unit is cm, and the model is in the same coordinate system
fuItemSetParamdv(1,"render_center_position",[0, 140, 0]);
fuItemGetParamdv(1, "render_center_position",buf,bufsize);

//Control the camera lens position, the default value is [0, 140, 300], the unit is cm, and the model is in the same coordinate system
fuItemSetParamdv(1,"render_camera_position",[0, 140, 300]);
fuItemGetParamdv(1, "render_camera_position",buf,bufsize);

//It controls the position of the camera lens, which is used to control the z-axis rotation. The default value is [0, 1, 0], and the unit is cm. It is in the same coordinate system with the model
fuItemSetParamdv(1,"render_camera_up",[0, 1, 0]);
fuItemGetParamdv(1, "render_camera_up",buf,bufsize);

//Control the fov of the camera lens, the default value is 8.6, the value range is 0 ~ 90, and the unit is degree (angle)
fuItemSetParamd(1,"render_fov",8.6);
int render_fov = fuItemGetParamd(1, "render_fov");

//Control the rendering size of camera lens, the default value is 100, the unit is cm, and the model is in the same coordinate system
fuItemSetParamd(1,"render_orth_size",100);
int render_orth_size = fuItemGetParamd(1, "render_orth_size");

//Camera near plane, the default value is 30, the unit is cm, and the model in a coordinate system
//Models less than this distance from the camera are not displayed
fuItemSetParamd(1,"znear",30);
int znear = fuItemGetParamd(1, "znear");

//Camera far plane, the default value is 6000, the unit is cm, and the model in a coordinate system
//Models whose distance from the camera is greater than this value will not be displayed
fuItemSetParamd(1,"zfar",6000);
int zfar = fuItemGetParamd(1, "zfar");
```

## Camera Animation Control

```C
//Camera animation control is similar to character animation control, the logic is the same

//1 is on, 0 is off, turn camera animation on or off
fuItemSetParamd(1,"active_camera_animation",1);

//Play camera animation with handle 2 from scratch (loop)
fuItemSetParamd(1, "play_camera_animation", 2);

//Play camera animation with handle 2 from scratch (single shot)
fuItemSetParamd(1, "play_camera_animation_once", 2);

//Set whether the current animation uses the progress value. If 1 is set, the animation will not play over time, but will be set to the progress value. If 0 is set, the animation will play over time
fuItemSetParamd(1, "set_camera_animation_use_progress", 1);

//Set current animation progress
//0 ~ 0.9999 is the first cycle, 1.0 ~ 1.9999 is the second cycle, and so on
fuItemSetParamd(1, "set_camera_animation_progress", 0.5);

//Takes effect only when the current state is in transition
//Set whether the current animation transition uses the progress value. If 1 is set, the animation transition will not play over time, but will be set to the progress value. If 0 is set, the animation will play over time
fuItemSetParamd(1, "set_camera_animation_use_transition_progress", 1);

//It only takes effect when it is currently in transition state (see below for the interface to get whether it is in transition or not)
//Set the current animation transition progress
//The range is 0 ~ 1.0, 0 is the beginning and 1.0 is the end
fuItemSetParamd(1, "set_camera_animation_transition_progress", 0.5);

//Continue to play the current camera animation, the parameters are meaningless
fuItemSetParamd(1, "start_camera_animation", 1);

//Pause the current camera animation, the parameters are meaningless
fuItemSetParamd(1, "pause_camera_animation", 1);

//Reset camera animation, parameters meaningless
fuItemSetParamd(1, "reset_camera_animation", 1);

//Print a log of the current camera animation state
fuItemSetParamd(1, "camera_clipmixer_Print", 1);

//Set the transition time in seconds for camera animation
fuItemSetParamd(1, "camera_animation_transition_time", 1.5); 

//1 is on and 0 is off. When on, 25 frames of camera animation will be interpolated to the actual number of rendered frames (such as 60 frames), so that the camera animation will be smoother. However, in some cases, interpolation is not suitable. For example, camera animation that does not want interpolation, such as flash operation, can be turned off actively.
//This parameter is on by default
//This switch has no effect on the loaded camera animation. The loaded camera animation cannot change the inter frame interpolation in real time
//Turn on or off this switch and then load the camera animation to produce the above effect
fuItemSetParamd(1, "camera_animation_internal_lerp", 1.0); 

//Get the current progress of the camera animation with handle 2
//0 ~ 0.9999 is the first cycle, 1.0 ~ 1.9999 is the second cycle, and so on
//Even if play_animation_once, the progress will break through 1.0 and run as usual
fuItemGetParamd(1, "{\"name\":\"get_camera_animation_progress\", \"anim_id\":2}"); 

//Get the current transition progress of the current camera animation
//When the progress is less than 0, the camera animation is not in the transition state
//When the progress is greater than or equal to 0, the camera animation is in the transition, ranging from 0 to 1.0, with 0 as the start and 1.0 as the end
fuItemGetParamd(1, "{\"name\":\"get_camera_animation_transition_progress\"}"); 

//Get the total number of frames of camera animation with handle 2
fuItemGetParamd(1, "{\"name\":\"get_camera_animation_frame_num\", \"anim_id\":2}"); 

//Print the current camera animation system status
fuItemSetParamd(1, "camera_clipmixer_Print", 1);
```
------
## To use a custom animation system timeline, you must follow these steps
```C
//1.Reset the current animation system, ready to switch the timeline
//Each role calls
fuItemSetParamd(1, "reset_animation", 1); 
fuItemSetParamd(1, "dynamicBone_Reset", 1); // Or dynamicBone_Refresh
//Call once
fuItemSetParamd(1,"reset_camera_animation",1);
fuItemSetParamd(1, "enable_set_time", 1); 

//2.After that, set the current time of the animation system before each rendering, in seconds
fuItemSetParamd(1, "animation_time_current", 0.1); 

//3.If you want to switch back to the system time
//Each role calls
fuItemSetParamd(1, "reset_animation", 1);  
fuItemSetParamd(1, "dynamicBone_Reset", 1); //OrdynamicBone_Refresh
//Call once
fuItemSetParamd(1,"reset_camera_animation",1);
fuItemSetParamd(1, "enable_set_time", 0); 
```

## 2D Animation Control

```C
//Parameter range is 0~uv_anim_frame_num-1. This parameter is used to control playing which frame of animation.
//Only default template bundles are supported, which need to be set during packaging：
//enable_uv_anim：open UV animation
//uv_anim_column：Animation columns
//uv_anim_row：Number of animation lines
//uv_anim_frame_num：Animation frames
fuItemSetParamd(1,'uv_anim_frame_id',1);

//UV animation playback frame rate per second, the default value of 25
fuItemSetParamd(1,'uv_anim_fps',25);
```

## Color Setting

```C
//All input color values are RGB in the range of 0-255
```
------
##### Skin color
```C
//Set the color of the character's head and body
fuItemSetParamdv(1, "skin_color", [255, 0, 0]);
//Get the index of the current skin color in the skin color table, starting from 0
int skin_color_index = fuItemGetParamd(1, "skin_color_index");
```
------
##### Lip color
```C
//Set lip color
fuItemSetParamdv(1, "lip_color", [255, 0, 0]);
//Get the index of the current lip color in the lip color table, starting from 0
int lip_color_index = fuItemGetParamd(1, "lip_color_index");
```
------
##### Pupil color
```C
//Set pupil color
fuItemSetParamdv(1, "iris_color", [255,0,0]);
```
------
##### Glasses color
```C
//Set lens color
fuItemSetParamdv(1, "glass_color", [255,0,0]);
//Set eyeglass frame color
fuItemSetParamdv(1, "glass_frame_color", [255,0,0]);
```
------
##### Hair color
```C
//Set hair color
fuItemSetParamdv(1, "hair_color", [255, 0, 0]);
//Set the color intensity, the parameter is greater than 0.0, the general value is 1.0
fuItemSetParamd(1, "hair_color_intensity", 1.0);
```
------
##### Beard color
```C
//Set beard color
fuItemSetParamdv(1, "beard_color", [255,0,0]);
```
------
##### Beauty color
```C
//Set the color of your makeup
//The beauty parameter is called json structure，
{
    "name":"global",      //Fixed
    "type":"face_detail", //Fixed
    "param":"blend_color",//Fixed
    "UUID":5              //Beauty props of the targetbundle handle id
}
//When the beauty parameter value is RGB setting between 0 and 1, the original beauty color is RGB color value (sRGB space), and RGB / 255 gets the value passed to the controller
//For example, the makeup color to be replaced is [255,0,0], and the value passed to the controller is [1,0,0]
fuItemSetParamdv(1, "{\"name\":\"global\",\"type\":\"face_detail\",\"param\":\"blend_color\",\"UUID\":5}", [1,0,0]);

//Get the color of beauty
//If the returned buf is [1.0, 0.0, 0.0], it means RGB = [255, 0, 0]
//PC/IOS，If size = - 1, the acquisition failed
double* buf;
int size = fuItemGetParamdv(1, "{\"name\":\"global\",\"type\":\"face_detail\",\"param\":\"blend_color\",\"UUID\":5}", buf, 0);
buf = new double[size];
fuItemGetParamdv(1, "{\"name\":\"global\",\"type\":\"face_detail\",\"param\":\"blend_color\",\"UUID\":5}", buf, size);
// Android，If buf = null, the acquisition failed
double[] buf = fuItemGetParamdv(1, "{\"name\":\"global\",\"type\":\"face_detail\",\"param\":\"blend_color\",\"UUID\":5}");
```
------
##### Hat color
```C
//Set hat color
fuItemSetParamdv(1, "hat_color", [255,0,0]);
```
------
##### Set background color
```C
//Turn on enable_background_color，Only after it is turned on can it pass through set_background_color. Set solid background
fuItemSetParamd(1, "enable_background_color", 1.0);
fuItemSetParamdv(1, "set_background_color", [255, 255, 255, 255]);
//Enableenable_background_color, the background props are invalid, so if you want to use the background props, pay attention to turn off enable_background_color
fuItemSetParamd(1, "enable_background_color", 0.0);
```
------

## Shadow Settings

```C
// When the shadow is on, value = 1.0 means on, and value = 0.0 means off
fuItemSetParamd(1, "enable_shadow", 1.0);

// Set the resolution of shadow map
fuItemSetParamd(1, "shadow_map_size", 1024.0);
// Set shadow PCF level， value = 2.0 represents Height， value = 1.0 represents medium, value = 0.0 represents low
fuItemSetParamd(1, "shadow_pcf_level", 2.0);
// Set shadow bias， value[0] represents uniform bias， value[1] represents normal bias
fuItemSetParamdv(1, "shadow_bias", [0.01, 0.1]);
```
------

## Lighting Control

```C
// Switch lighting props
// The parameter name is json structure, and the parameter value is the transition time of switching, in seconds
{
    "name":"switch_light", //Fixed
    "param": 10, // Lighting props handle id, 
}

fuItemSetParamd(1, "{\"name\":\"switch_light\",\"param\":10}", 1.0);
```
------

## Special Mode

### Head tracking mode for animation blending

```C
//When this mode is turned on, it will replace the original head rotation tracking mode. In the original head tracking mode, only one bone is rotated, which makes the neck unnatural when the head rotates a lot. After this mode is turned on, the head tracking bone data will be mixed by six animations to make the neck more natural

//Only when this mode is turned on and six head rotation animation bundles are loaded will it really work
//(new_pta/bundle_db/head_rotate/0_ditou.bundle)
//(new_pta/bundle_db/head_rotate/1_yangtou.bundle)
//(new_pta/bundle_db/head_rotate/2_zuokan.bundle)
//(new_pta/bundle_db/head_rotate/3_youkan.bundle)
//(new_pta/bundle_db/head_rotate/4_zuowaitou.bundle)
//(new_pta/bundle_db/head_rotate/5_youwaitou.bundle)

//Turn on head tracking mode for animation blending
fuItemSetParamd(1, "enable_animation_track", 1.0);
//Turn off head tracking mode for animation blending
fuItemSetParamd(1, "enable_animation_track", 0.0);
```

### AR mode
```C
//Turn on AR mode
fuItemSetParamd(1, "enter_ar_mode", 1.0);
//Turn off AR mode
fuItemSetParamd(1, "quit_ar_mode", 1.0);
//In AR mode, in order to support rotating the hair mask while rotating the screen, the mobile terminal needs to set the current screen rotation direction
//0 means the device is not rotating, 1 means 90 degrees counterclockwise, 2 means 180 degrees counterclockwise, and 3 means 270 degrees counterclockwise
fuItemSetParamd(1, "screen_orientation", 0);
```
------

### Blendshape
```C
//Turn on / off Blendshape：value = 1.0 means on，value = 0.0 means off
fuItemSetParamd(1, "enable_expression_blend", value);
//Set blendshape blending parameters：blend_expression、expression_weight0、expression_weight1, enable_expression_blend only valid when blend is set to 1
//blend_expression is the BS coefficient array input by the user, and the values are 0 ~ 1. The serial number 0-45 represents the base expression BS, 46-56 represents the oral BS, and 57-66 represents the tongue BS
var d = [];
for(var i = 0; i<57; i++){
	d[i] = 0;
}
fuItemSetParamdv(1, "blend_expression", d);
//expression_weight0 is the weight of blend_expression. expression_weight1 is the weight of the returned expression detected by the algorithm or the loaded animation expression coefficient array, and the value is 0 ~ 1
var d = [];
for(var i = 0; i<57; i++){
	d[i] = 0;
}
fuItemSetParamdv(1, "expression_weight0", d);
```
------

### Keep your eyes on the camera
```C
//When the glasses annotation function is enabled, value = 1.0 means enabled, and value = 0.0 means not enabled
fuItemSetParamd(1, "enable_fouce_eye_to_camera", value);
//Set eye gaze camera parameters：fouce_eye_to_camera_height_adjust、fouce_eye_to_camera_distance_adjust、fouce_eye_to_camera_weight
fuItemSetParamd(1, "fouce_eye_to_camera_height_adjust", 30.0); //Adjust the relative height of virtual camera
fuItemSetParamd(1, "fouce_eye_to_camera_distance_adjust", 30.0); //Adjust virtual camera relative distance
fuItemSetParamd(1, "fouce_eye_to_camera_weight", 1.0); //Adjust the influence weight of fixation, 1.0 means fully enabled, 0.0 means no influence
```
------

### Face Processor Facial tracking
```C
//1.Before using face processor for face tracking, you need to load ai_face_processor.bundle
vector<uint8_t> u8_ai_face_processor;
loadbinary("ai_face_processor.bundle", u8_ai_face_processor);
fuLoadAIModelFromPackage(u8_ai_face_processor.data(), (int)u8_ai_face_processor.size(), FUAITYPE::FUAITYPE_FACEPROCESSOR);

//2.Turn face tracking on or off, value = 1.0 means on, value = 0.0 means off
fuItemSetParamd(1, "enable_face_processor", 1.0);

//3.Assign the face index detected by face tracking to the current character, which is 0 by default
fuItemSetParamd(1, "set_face_processor_face_id", 0.0);

//4.Before exiting the program, you need to destroy the resources related to Face Processor
fuReleaseAIModel(FUAITYPE::FUAITYPE_FACEPROCESSOR);

//Whether to rotate the head when setting face tracking (invalid in AR mode)
fuItemSetParamd(controller_bundle, "enable_face_processor_rotate_head", 1.0);

//Adjust the model size according to the face tracking to achieve the effect of near large far small (invalid in AR mode)
//head_ref_translation_follow_face_processor Set the reference position for algorithm detection
//head_scale_sensitivity_follow_face_processor Set the sensitivity of scale
fuItemSetParamdv(1, "head_ref_translation_follow_face_processor", [0.0, 0.0, -20.0]);
fuItemSetParamdv(1, "head_scale_sensitivity_follow_face_processor", 0.5);

//According to the facial tracking, the elevation offset of the model is automatically adjusted to achieve the purpose of elevation correction ([- 20,20] degrees)
fuItemSetParamd(controller_bundle, "head_rot_delta_x", -10.0);
fuItemSetParamd(controller_bundle, "eye_rot_delta_x", -10.0);

//Set whether the rotation of the face tracking head revolves around the center of the head or around the neck (invalid in AR mode)
//Value = 1.0 represents rotation around the center of the head, and value = 0.0 represents rotation around the neck
fuItemSetParamd(controller_bundle, "enable_rotation_by_center_face_processor", 1.0);

//Set the size of transition buffer used to recover the default state of face tracking face loss
fuItemSetParamd(controller_bundle, "face_processor_rotation_filter_size", 10.0);
fuItemSetParamd(controller_bundle, "face_processor_translation_filter_size", 10.0);
fuItemSetParamd(controller_bundle, "face_processor_eye_rotation_filter_size", 10.0);

```
------

### Human Processor Body Tracking
##### Turn body tracking on or off
```C
//1.Before using Human Processor body tracking, you need to loadai_human_processor.bundle
vector<uint8_t> u8_ai_human_processor;
loadbinary("ai_human_processor.bundle", u8_ai_human_processor);
fuLoadAIModelFromPackage(u8_ai_human_processor.data(), (int)u8_ai_human_processor.size(), FUAITYPE::FUAITYPE_HUMAN_PROCESSOR);

//2.Turn body tracking on or off, value = 1.0 means on, value = 0.0 means off
//  enter_human_pose_track_mode and quit_human_pose_track_mode parameter interface was abandoned
fuItemSetParamd(1, "enable_human_processor", 1.0);

//3.Before exiting the program, you need to destroy Human Processor related resources
fuReleaseAIModel(FUAITYPE::FUAITYPE_HUMAN_PROCESSOR);

```
##### Body Tracking Parameter Setting
```C
//Target_angle，target_scale，target_trans，reset_all parameters need to be set before body tracking is turned on, so as to determine the role's default location when tracking fails

//Set whether to turn on follow mode: value = 1.0 means follow, value = 0.0 means not follow
fuItemSetParamd(1, "human_3d_track_is_follow", 1.0);
//If you use follow mode, you can use the parameterhuman_3d_track_render_fov to set the fov size of the rendering, in degrees
fuItemSetParamd(1, "human_3d_track_render_fov", 30.0);
//Set whether it is full body drive or half body drive. 1 is full body drive and 0 is half body drive
fuItemSetParamd(1, "human_3d_track_set_scene", 0);
//Set model scaling in full body driven follow mode
fuItemSetParamd(1, "human_3d_track_set_fullbody_avatar_scale", 1.2);
//Set model scaling in half drive follow mode
fuItemSetParamd(1, "human_3d_track_set_halfbody_avatar_scale", 1.2);
//Set the x-axis and y-axis offset in the half body drive follow mode
fuItemSetParamdv(1, "human_3d_track_set_halfbody_global_offset", [0.0, 30.0]);
//Set the animation transition time of gesture tracking, the default value is 0.1 (seconds)
fuItemSetParamd(1, "anim_transition_max_time_gesture_track", 0.1);
//Set the transition time between body animation and body tracking data. The default value is 0.5 (seconds)
fuItemSetParamd(1, "anim_transition_max_time_human_3d_track", 0.5);
//Set the transition time between face tracking data and face data in body tracking data. The default value is 1.0 (seconds)
fuItemSetParamd(1, "anim_transition_max_time_face_track", 1.0);
```
##### Get body tracking status
```C
//FUAI_HUMAN_NO_BODY = 0,
//FUAI_HUMAN_HALF_LESS_BODY = 1,
//FUAI_HUMAN_HALF_BODY = 2,
//FUAI_HUMAN_HALF_MORE_BODY = 3,
//FUAI_HUMAN_FULL_BODY = 4,
fuItemGetParam(1, "human_status");
```
##### Get two hand gesture ID for body tracking
```C
// Return[x, y], X is the left hand gesture and Y is the right hand gesture
fuItemGetParamdv(1, "human_track_gesture_id");
```
------

### CNN Face tracking (Abandoned)
```C
//1.Before using CNN face tracking, users need to create a face tracking model through fuFaceCaptureCreate
var face_capture = fuFaceCaptureCreate(__pointer data, int sz);
//2.Register the model to the current role of the controller, and assign the face index, which starts from 0
fuItemSetParamu64(1, "register_face_capture_manager", face_capture);
fuItemSetParamd(1, "register_face_capture_face_id", 0.0);
//3.Set close_face_capture，Indicating whether CNN face tracking is enabled or disabled. Value = 0.0 means on and value = 1.0 means off
fuItemSetParamd(1, "close_face_capture", 1.0);

//4. If CNN face tracking is turned on，each frame needs to call fuFaceCaptureProcessFrame to process the input image
fuFaceCaptureProcessFrame(face_capture, __pointer img_data, int image_w, int image_h, int fu_image_format, int rotate_mode)

//5.Finally, the facial tracking model needs to be destroyed before exiting the program
fuFaceCaptureDestory(face_capture)
```
------

### Face-making
##### Enter or exit face-making mode
```C
//Enter face-making mode 
fuItemSetParamd(1, "enter_facepup_mode", 1);
//Exit face-making mode
fuItemSetParamd(1, "quit_facepup_mode", 1);
```
##### Subdivision part adjustment
```C
//Set face-making parameters and save them. Saving will save the current parameters into the bundle
//Parameter name is json structure，
{
    "name":"facepup", //Fixed
    "param":"Head_Fat" //The specific actions are shown in the table below
}
//value range [0, 1]
fuItemSetParamd(1, "{\"name\":\"facepup\",\"param\":\"Head_Fat\"}", 1.0);
```
##### Get the face-making parameters saved in the bundle
```C
//Parameter name is json structure，
{
    "name":"facepup", //Fixed
    "param":"Head_Fat" //The specific actions are shown in the table below
}
//value range [0,1]
fuItemGetParamd(1,"{\"name\":\"facepup\",\"param\":\"Head_Fat\"}");

//Get all the face-making parameters saved in the bundle
fuItemGetParamfv(1, "facepup_expression", (float*)buf, (int)sz);
```

##### Parameter Table：
__Face Shape__：  

| param              | meaning         |
| ------------------ | ------------ |
| "HeadBone_wide " | head widening  |
| "Head_narrow " |head narrowing  |
| "head_shrink " |head shrinking  |
| "head_stretch " |head stretching  |
| "head_fat " |fat  |
| "head_thin " |thin  |
| "cheek_wide " |cheek widening  |
| "cheekbone_narrow " |cheekbone narrowing  |
| "jawbone_Wide " |Mandibular angle down  |
| "jawbone_Narrow " |Mandibular angle down  |
| "jaw_m_wide " |jawbone widening  |
| "jaw_M_narrow " |jawbone narrowing  |
| "jaw_wide " |jaw widening  |
| "jaw_narrow " |jaw narrowing  |
| "jaw_up " |jaw shortening  |
| "jaw_lower " |jaw lengthening  |
| "jawTip_forward " |jaw tip forward  |
| "jawTip_backward " |jaw tip backward  |
| "jawBone_m_up " |jaw bone narrowing  |
| "jawBone_m_down " |jaw bone widening  |

__Eye__：  

| param                | meaning      |
| -------------------- | ---------- |
| "Eye_wide " |eye widening  |
| "Eye_shrink " |eye narrowing  |
| "Eye_up " |eye up |
| "Eye_down " |eye down |
| "Eye_in " |eye in  |
| "Eye_out " |eye out  |
| "Eye_close_L " |left eye closing  |
| "Eye_close_R " |right eye closing  |
| "Eye_open_L " |left eye opening  |
| "Eye_open_R " |right eye opening  |
| "Eye_upper_up_L " |left upper eyelid up |
| "Eye_upper_up_R " |right upper eyelid up  |
| "Eye_upper_down_L " |left upper eyelid down  |
| "Eye_upper_down_R " |right upper eyelid down  |
| "Eye_upperBend_in_L " |left upper eyelid in  |
| "Eye_upperBend_in_R " |right upper eyelid in |
| "Eye_upperBend_out_L " |left upper eyelid out |
| "Eye_upperBend_out_R " |right upper eyelid out  |
| "Eye_downer_up_L " |left lower eyelid up |
| "Eye_downer_up_R " |right lower eyelid up  |
| "Eye_downer_dn_L " |left lower eyelid down   |
| "Eye_downer_dn_R " |right lower eyelid down   |
| "Eye_downerBend_in_L " |left lower eyelid in  |
| "Eye_downerBend_in_R " |right lower eyelid in |
| "Eye_downerBend_out_L " |left lower eyelid out  |
| "Eye_downerBend_out_R " |right lower eyelid out  |
| "Eye_outter_in " |outer canthus in  |
| "Eye_outter_out " |outer canthus out |
| "Eye_outter_up " |outer canthus up  |
| "Eye_outter_down " |outer canthus down  |
| "Eye_inner_in " |inner canthus in  |
| "Eye_inner_out " |inner canthus out  |
| "Eye_inner_up " |inner canthus up  |
| "Eye_inner_down " |inner canthus down  |
| "Eye_forward " |eye forward  |

__Mouth__：

| param                | meaning         |
| -------------------- | ------------ |
| "upperLip_Thick " |upper lip thickening  |
| "upperLipSide_Thick " |upper lip side thickening  |
| "lowerLip_Thick " |lower lip thickening  |
| "lowerLipSide_Thin " |lower lip side thining  |
| "lowerLipSide_Thick " |lower lip side thickening  |
| "upperLip_Thin " |upper lip thining  |
| "lowerLip_Thin " |lower lip thining  |
| "mouth_magnify " |mouth magnifying  |
| "mouth_shrink " |mouth shrinking  |
| "lipCorner_Out " |lip corner out  |
| "lipCorner_In " |lip corner in  |
| "lipCorner_up " |lip corner up  |
| "lipCorner_down " |lip corner down  |
| "mouth_m_down " |lip down  |
| "mouth_m_up " |lip up  |
| "mouth_Up " |mouth up  |
| "mouth_Down " |mouth down  |
| "mouth_side_up " |mouth side up  |
| "mouth_side_down " |mouth side down  |
| "mouth_forward " |mouth forward  |
| "mouth_backward " |mouth backward |
| "upperLipSide_thin " |upper lip side thining  |

__Nose__：

| param          | meaning      |
| -------------- | ---------- |
| "nostril_Out " |nosewing widening  |
| "nostril_In " |nosewing narrowing  |
| "noseTip_Up " |nose tip up  |
| "noseTip_Down " |nose tip down  |
| "nose_Up " |nose up  |
| "nose_tall " |nose tall  |
| "nose_low " |nose low  |
| "nose_Down " |nose down  |
| "noseTip_forward " |nose tip forward  |
| "noseTip_backward " |nose tip backward  |
| "noseTip_magnify " |nose tip magnifying  |
| "noseTip_shrink " |nose tip shrinking  |
| "nostril_up " |nosewing up  |
| "nostril_down " |nosewing down  |
| "noseBone_tall " |nose bone tall  |
| "noseBone_low " |nose bone low  |
| "nose_wide " |nose widening  |
| "nose_shrink " |nose shrinking  |

------
### Bone Modeling

```C
//Pamameter name is json structure，
{
    "name":"deformation", //Fixed
    "param":"tall" //The specific actions are shown in the table below
}

//In principle, the range of setting a channel coefficient is 0 ~ 1. However, if the effect is acceptable, it can be run if it is less than 0 or greater than 1
fuItemSetParamd(1,"{\"name\":\"deformation\",\"param\":\"channelName\"}",0);

//Get the coefficient of a certain shaping dimention (channel)
fuItemGetParamd(1, "{\"name\":\"deformation\",\"param\":\"channelName\"}");

//Get all the current shaping parameters
fuItemGetParamfv(1, "deformationData", (float*)buf, (int)sz);
```

__Figure__：

| param          | meaning      |
| -------------- | ---------- |
| "tall" |tall  |
| "short" |short  |
| "fat" |fat  |
| "thin" |thin  |

__Face Shape__：

| param          | meaning       |
| -------------- | ---------- |                                                                                           
| "eye_narrow" | eye narrow  |
| "eye_wide" |  eye wide |
| "eye_down" | eye down  |
| "eye_up" |  eye up |
| "eye_inner" |  eye inner |
| "eye_backward" | eye small |
| "eye_forward" | eye big  |
| "upperLidOut_narrow" | Outer upper eyelid right  |
| "upperLidOut_wide" |  Outer upper eyelid left |
| "upperLidOut_down" | Outer upper eyelid left lower |
| "upperLidOut_up" | Outer upper eyelid upper left  |
| "upperLidMid_narrow" | Middle upper eyelid right |
| "upperLidMid_wide" |  Middle upper eyelid left |
| "upperLidMid_down" |  Middle upper eyelid down |
| "upperLidMid_up" |  Middle upper eyelid up |
| "upperLidIn_narrow" | Inner upper eyelid right  |
| "upperLidIn_wide" |  Inner upper eyelid left |
| "upperLidIn_down" | Inner upper eyelid down |
| "upperLidIn_up" |  Inner upper eyelid up and down |
| "lidInner_narrow" | Inner eyelid in |
| "lidInner_wide" | Inner eyelid out  |
| "lidInner_down" | Inner eyelid down  |
| "lidInner_up" |  Inner eyelid up |
| "lowerLidIn_narrow" | Inner lower eyelid right |
| "lowerLidIn_wide" | Inner lower eyelid left  |
| "lowerLidIn_down" |  Inner lower eyelid down |
| "lowerLidIn_up" | Inner lower eyelid up  |
| "lowerLidMid_narrow" | Middle lower eyelid right  |
| "lowerLidMid_wide" | Middle lower eyelid left  |
| "lowerLidMid_down" | Middle lower eyelid down  |
| "lowerLidMid_up" |  Middle lower eyelid up |
| "lowerLidOut_narrow" |  Outer lower eyelid right |
| "lowerLidOut_wide" | Outer lower eyelid left |
| "lowerLidOut_down" |  Outer lower eyelid down |
| "lowerLidOut_up" | Outer lower eyelid up |
| "lidOuter_narrow" | Outer eyelid in |
| "lidOuter_wide" |  Outer eyelid out |
| "lidOuter_down" | Outer eyelid down  |
| "lidOuter_up" | Outer eyelid up  |
| "nose_down" | nose down  |
| "nose_up" | nose up  |
| "nose_backward" | nose backward  |
| "nose_forward" | nose forward  |
| "noseTip_down" |  nose tip down |
| "noseTip_up" | nose tip up  |
| "noseTip_backward" |  nose tip backward |
| "noseTip_forward" |  nose tip forward |
| "upperHead_narrow" |  face narrow |
| "upperHead_wide" |  face wide |
| "upperHead_down" |  upper face short |
| "upperHead_up" | upper face long  |
| "upperHead_backward" | upper face backward  |
| "upperHead_forward" | upper face forward  |
| "lowerHead_down" | lower face long  |
| "lowerHead_up" | lower face short |
| "lowerHead_backward" |  lower face backward |
| "lowerHead_forward" | lower face forward  |
| "upperJaw_narrow" | cheek thin  |
| "upperJaw_wide" | cheek fat  |
| "midJaw_narrow" | lower jaw thin |
| "midJaw_wide" | lower jaw fat |
| "midJaw_down" | lower jaw down |
| "midJaw_up" | lower jaw up  |
| "lowerJaw_narrow" | cheek thin  |
| "lowerJaw_wide" | cheek fat |
| "lowerJaw_down" | cheek down  |
| "lowerJaw_up" | cheek up  |
| "jawLine_narrow" |  jaw line narrow |
| "jawLine_wide" |  jaw line wide |
| "jawLine_down" |  jaw line down |
| "jawLine_up" |  jaw line up |
| "jawTip_narrow" |  lower jaw narrow |
| "jawTip_wide" | lower jaw wide  |
| "jawTip_down" | lower jaw down  |
| "jawTip_up" |  lower jaw up |
| "jawTip_backward" | lower jaw backward  |
| "jawTip_forward" | lower jaw forward |
| "jawTip_peak_narrow" | jaw tip narrow  |
| "jawTip_peak_wide" |  jaw tip wide |
| "jawTip_peak_down" |  jaw tip long |
| "jawTip_peak_up" |  jaw tip up |
| "jawTip_peak_backward" |  jaw tip backward |
| "jawTip_peak_forward" | jaw tip forward  |
| "lowerChin_down" |  lower chin down |
| "lowerChin_up" | lower chin up  |
| "mouth_narrow" |  mouth small |
| "mouth_wide" | mouth big  |
| "mouth_down" | mouth down  |
| "mouth_up" |  mouth up |
| "mouth_backward" |  mouth backward |
| "mouth_forward" |  mouth forward |
| "globalBrow_down" |  eyebrow down |
| "globalBrow_up" |  eyebrow up |
| "InnerBrow_down" | inner eyebrow down  |
| "InnerBrow_up" | inner eyebrow up  |
| "middleBrow_down" |  middle eyebrow down |
| "middleBrow_up" |  middle eyebrow up |
| "outerBrow_down" |  middle eyebrow down |
| "outerBrow_up" | outer brow up  |
| "ear_narrow" | ear small  |
| "ear_wide" | ear big  |
| "ear_down" | ear down  |
| "ear_up" | ear up  |
| "upperEar_down" |  upper ear down |
| "upperEar_up" |  upper ear up |

------

## Other

### Update background prop stickers
```C
//Background props include background map and picture in picture map
//Update background sticker
fuCreateTexForItem(1, "background_bg_tex", __pointer data, int width, int height)
//Update picture in picture sticker
fuCreateTexForItem(1, "background_live_tex", __pointer data, int width, int height)
```
------
### Hide the neck
```C
fuItemSetParam(1, "hide_neck", 1.0);
```
------
### Enter the mesh vertex number of the face to get its coordinates in screen space

```C
//Calculate the coordinates of vertex with the number of 1 in screen space
fuItemSetParamd(1, "query_vert", 1);
//Get the coordinate x
fuItemGetParamd(1, "query_vert_x");
//Get the coordinate y
fuItemGetParamd(1, "query_vert_y");
```
------
### Get serverinfo information
```C
//The parameter name is in json format, the fixed name is serverinfo, and param is the parameter name.
```
##### Get hair category
```C  
var ret = fuItemGetParamd(1, "{\"name\":\"serverinfo\", \"param\":\"hair_label\"}");
```
##### Set whether the props are visible (not available for beauty props and background props)
```C 
//The parameter name is the json structure，
{
    "name":"is_visible",  //Fixed
    "UUID":5              //the target prop bundle handle id
}
// value = 0.0 means invisible，value = 1.0 means visible
fuItemSetParamdv(1, "{\"name\":\"is_visible\",\"UUID\":5}", 1.0);
```
##### Set the composition order of beauty props (only works for beauty props in normal mixed mode)
```C
// Whether to use the custom makeup synthesis order, value = 1.0 means to use the custom makeup synthesis order, and value = 0.0 means to use the binding order as the synthesis order.
fuItemSetParamd(1, "use_facebeauty_order", 1.0);
// Set the array of composition order. The elements in the array are the bundle handle ID of the beauty props. The lower the array is, the higher the level of beauty rendering will be, and the higher the visual appearance will be.
// For example, there are two handle_id for 6 and 7 beauty props. Using the following synthesis sequence, it visually looks like 7 is above 6.
fuItemSetParamdv(1, "facebeauty_order", [6, 7]);
```
##### Set up the display list of each part of the body props
```C
// Whether to use the display list to display the body props, value = 1.0 means to use the display list, and value = 0.0 means to use the default mode
fuItemSetParamd(1, "use_body_visible_list", 1.0);
// Set the display list of each part of the body props. For example, if you use the display list below, only 6 and 7 parts of the body props will be displayed.
fuItemSetParamdv(1, "body_visible_list", [6, 7]);
```
##### Return the coordinates of the lower left and upper right corners of the bounding box of the current character in model space
```C
// Return the array [x0, y0, z0, x1, y1, z1]，[x0, y0, x0]represents the lower left corner coordinate and [x1, y1, z1] represents the upper right corner coordinate
fuItemGetParamdv(1, "boundingbox");
```
##### Return the 2D coordinates of the center of the current character in screen space
```C
//Suppose the coordinate origin of screen space is in the lower left corner
fuItemGetParamdv(1, "target_position_in_screen_space");
```
##### Return the screen coordinates of the current character's skeleton. The origin of the screen coordinates is in the lower left corner
```C
//The parameter name is the json structure
{
    "name":"get_bone_coordinate_screen", //Fixed
    "param":"Head_M" //bone name
}
// PTA fingertip bones are listed below
{
    "ThumbFinger3_L", "IndexFinger3_L", "MiddleFinger3_L", "RingFinger3_L", "PinkyFinger3_L",
    "ThumbFinger3_R", "IndexFinger3_R", "MiddleFinger3_R", "RingFinger3_R", "PinkyFinger3_R"
}
//Return the 2D coordinates of screen space
fuItemGetParamdv(1, "{\"name\":\"get_bone_coordinate_screen\",\"param\":\"Head_M\"}");
```
##### Return the version number of controller
```C
//Return the string of controller's version number
fuItemGetParams(1, "version");
```
##### Return the type of prop bound to the controller
```C
//Return the string of the prop type
fuItemGetParams(1, "{\"name\":\"get_bundle_type\", \"bundle_id\":3}"); 
```
##### Set low quality lights
```C
//Set whether to turn on the rendering of low quality lights. Value = 1.0 means on, and value = 0.0 means not on
fuItemSetParamd(1, "low_quality_lighting", 1.0);
```
##### Update stickers (create stickers from RGBA buffer)
```C
//The parameter name is the json structure
{
    "name":"update_tex_from_data", //String, fixed
    "UUID":5, //Integer, handle ID of the target item
    "dc_name":"eyeL", //String, the name of the target mesh// If it is a background prop, it can be ignored
}

fuCreateTexForItem(1, "{\"name\":\"update_tex_from_data\", \"UUID\":5, \"dc_name\":\"eyel\"}", __pointer data, int width, int height);
```
##### Update background sticker parameters
```C
//The parameter name is the json structure
{
    "name":"global", //String, fixed
    "type":"background", // String, fixed
    "param":"size_x_tex_live", //String, optional parameter（size_x_tex_live， size_y_tex_live， offset_x_tex_live， offset_y_tex_live， is_foreground）
    "UUID":5, //Integer, handle id of the target item 
}
fuItemSetParamd(1, "{\"name\":\"global\", \"type\":\"background\", \"param\":\"size_x_tex_live\", \"UUID\":5}", 1.0);
```
##### The results of FUAI were processed
```C
// Process the FUAI results, align to the parameters setting for fuSetInputCameraMatrix, and require input camera tex and input camera buffer to be aligned
fuItemSetParamd(1, "fuai_align_input_camera_matrix", 1.0);
```

##### Using low resolution sticker resources
```C
fuItemSetParamd(1, "use_low_resolution_tex", 1.0);
```

##### Restore face making (only effective for face making schemes using face pinching)
```C
fuItemSetParamd(1, "reset_head", 1.0);
```