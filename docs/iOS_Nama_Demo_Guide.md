# Demo running documentation-iOS  

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
       +items                 //Prop resource 
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
