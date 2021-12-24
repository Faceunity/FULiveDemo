# Demo running documentation-iOS  

------

Level：Public   
Update date：2021-12-24 
SDK version: 8.0.2

### Updates：

1）Fix some bugs

------

Level：Public   
Update date：2021-11-17 
SDK version: 8.0.1

### Updates：

1）Fix some bugs

------

Level：Public   
Update date：2021-10-27 
SDK version: 8.0.0

### Updates：

1）Optimized beauty special effects, optimized 8 functions such as microdermabrasion, big eyes, face shape, etc., and improved multi-dimensional effects such as skin details, contour lines, deformation ratio, etc.
2）Newly added sub-model adaptation strategy, the use of better uniform dermabrasion on high-end machines, and the use of fine dermabrasion with balanced performance and effect on middle and low-end machines, improving the utilization of the overall equipment
3）Optimized beauty, optimized the naturalness of lipstick, eyebrows, eyelashes, and cosmetic contact lenses, and added lipstick texture and style combination makeup
4）Face detection algorithm optimization, optimized detection rate and false detection rate
5）Optimization of portrait segmentation algorithm to optimize segmentation accuracy, segmentation edge smoothness, background misrecognition and other issues in the PC-side bust scene
6）Added the green screen safe area function, which supports the green screen keying of the designated area according to the template, and the template supports customer customization
7）Optimize the rendering timing issue when multiple functions are mixed
8）Fix some bugs

------

Level：Public   
Update date：2021-07-09 
SDK version: 7.4.1

### Updates：

1）Update 8 types of premium stickers, including 2 PK games, 5 decorative and interactive stickers, and 1 full-body drive prop
2）Update 2 Chinese style Animoji models
3）Fix the problem of portrait segmentation sticker effect. After the repair, the portrait segmentation result and sticker effect will appear at the same time
4）Fix some bugs, including high-resolution dermabrasion effects, face detection and sticker drawing timing issues

------

Level：Public   
Update date：2021-04-19 
SDK version: 7.4.0  

------

### Updates：

2021-04-19  7.4.0
1）[Demo layer] Refactoring the special effects Demo, changing process-oriented to object-oriented, the overall structure and logic are clearer, and customer calls are more convenient. At the same time, it has many advantages such as saving memory, optimizing the automatic destruction logic of itemID, simplifying the process of user input information, and low coupling to improve the flexibility of the architecture.
2）Added emotion recognition function, supporting 8 basic full emotion detection
3）Added content service module to display game props and boutique stickers, mainly including rich special effects props such as games, plots, headwear, atmospheres, etc.
4）Added asynchronous interface to improve the problem of insufficient frame rate for users on low-end devices
5）Optimize body performance, the frame rate on the Android side increased by 24%, and the time consumption on the iOS side decreased by 13%
6）Optimize the performance of portrait segmentation, and the frame rate of Andriod is increased by 39%, and the time consumption of iOS is reduced by 39%
7）Optimize the effect of portrait segmentation, mainly including optimizing the gap problem, so that the portrait segmentation fits the human body more closely, and there will be no obvious gaps; improve the accuracy of human body segmentation and reduce background misrecognition
8）Added a new method of portrait segmentation, open the user-defined background interface, which is convenient for users to quickly change the background; support the portrait stroke gameplay, and customize the stroke width, distance, and color
9）Add the Animoji koala model; optimize the Animoji facial driving effect to improve the stability and sensitivity of the driven model
10）Optimize the beauty effect, including the lipstick no longer appears when the lips are blocked; improve the fit of the color contact lenses; add a variety of color contact materials

------

### Updates：

**2021-1-25 v7.3.2:  **

- Optimize the performance of facial expression tracking driver.
- fuSetup function changed to thread safe.
- fuSetUp 、fuCreateItemFromPackage、fuLoadAIModel functions add exception handling and enhances robustness.
- Fix the effect of custom haha mirror function.
- Fix the SDK crash problem on Mac 10.11.
- Fix the crash problem when the SDK is mixed with "Sticker" and "Animoji".

------

### Updates：

2019-04-29 v1.0:

1. Added a pinch function demo
2. Optimized interaction
3. Updates props

------
### Contents：
[TOC]

------
### 1. Introduction 
This document shows you how to run the IOS demo of the Faceunity Nama SDK and experience the functions of the Faceunity Nama SDK.

FULiveDemo is a demo that integrates Faceunity facial tracking, beauty, Animoji, props stickers, AR masks, face changing, expression recognition, music filters, background segmentation, gesture recognition, distorting mirrors, portrait drivers, and Avatar pinch features. Demo will control which products users can use based on client certificate permissions.



Tips 1：the first time you run Demo, you will report an error with missing certificate. If you already have a certificate issued by our company, replace the certificate with the project and run it again.

Tips 2：since the latest libnama.a with deep learning has a size of more than 100M, we have not uploaded the original file of libnama.a, just uploaded a libnama.zip file, we will extract libnama.zip when you first compile the project. . If you want to get libnama.a with deep learning from the project directory, and you have not compiled the project, you need to extract libnama.zip to get libnama.a.  

------
### 2. File structure
This section describes the structure of the Demo file, the various directories, and the functions of important files.

```obj
+FULiveDemo
  +FULiveDemo                   //Source code directory
    +Main                     //Main module (homepage and public page UI, model, main business management class)
    +Modules                  //All function modules
      +Normal                   //Ordinary prop module
      +Beauty                   //Beauty module
        ...
    +Helpers                //Main business management class  
      -FUManager              //Nama business class
      +VC                      //Base controller
      +Manager                 //Base Management class
          ...   
    +Config                    //Configuration file directory
      -DataSource             //Main interface, permissions, item prop configuration class
      -makeup.json             //Makeup single array
      -makeup_whole.json      //Makeup configuration
      -avatar.json            //Pinch face color, template profile
    +Resource               
       +itmes                 //Prop resource 
    +Lib                    //Nama SDK  
      -authpack.h             //Permission file
      -FURenderKit.framework   //FURenderKit dynamic library      
      +Resources               //Resources related to each capability
  +docs                        //Docs
  +Pods                     //Rripartite library management
  -FULiveDemo.xcworkspace   //Project file
  
```

------
### 3. Demo Running 

#### 3.1 Develop environment
##### 3.1.1 Platform
```
iOS 9.0 or above
```
##### 3.1.2 Develop environment
```
Xcode 8 or above
```

#### 3.2 Preparing 
- [Downlaod FULiveDemo](https://github.com/Faceunity/FULiveDemo)
- Replace the file **authpack.h**，get certificates please refer to  **3.3.1**

#### 3.3 Configurations
##### 3.3.1 Import certificates
You need to have a certificate issued by our company in order to use the function of our SDK.

1. Call 0571-89774660

2. Send an email to marketing@faceunity.com for consultation.

The certificate issued by iOS is the g_auth_package array contained in authpack.h. If you have obtained the authentication certificate, import authpack.h into the project. Depending on the application requirements, authentication data can also be provided at runtime (such as network downloads), but pay attention to the risk of certificate leakage and prevent the certificate from being abused.

#### 3.4 Compile and running
![](./imgs/runDemo.jpg)
![](./imgs/demoHome.png)

------
###  
