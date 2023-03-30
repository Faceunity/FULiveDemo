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
### 2. Demo Running 

#### 2.1 Develop environment
##### 2.1.1 Platform
```
iOS 9.0 or above
```
##### 2.1.2 Develop environment
```
Xcode 8 or above
```

#### 2.2 Preparing 
- [Downlaod FULiveDemo](https://github.com/Faceunity/FULiveDemo)
- Replace the file **authpack.h**，get certificates please refer to  **2.3.1**

#### 2.3 Configurations
##### 2.3.1 Import certificates
You need to have a certificate issued by our company in order to use the function of our SDK.

1. Call 0571-89774660

2. Send an email to marketing@faceunity.com for consultation.

The certificate issued by iOS is the g_auth_package array contained in authpack.h. If you have obtained the authentication certificate, import authpack.h into the project. Depending on the application requirements, authentication data can also be provided at runtime (such as network downloads), but pay attention to the risk of certificate leakage and prevent the certificate from being abused.

#### 2.4 Compile and running
![](./imgs/runDemo.jpg)
![](./imgs/demoHome.png)

------
###  
