# Demo运行说明文档-iOS  
级别：Public   
更新日期：2020-09-27   
SDK版本: 7.2.0  

------

### 最新更新内容：

**2020-9-27 v7.2.0:**

- 新增绿幕抠像功能，支持替换图片、视频背景等。
- 美颜模块新增瘦颧骨、瘦下颌骨功能。
- 优化美颜性能以及功耗，优化集成入第三方推流服务时易发热掉帧问题。
- 优化手势识别功能的效果以及性能，提升识别稳定性和手势跟随性效果，优化手势识别时cpu占有率。
- 优化PC版各个功能性能，帧率提升显著。美发、美体、背景分割帧率提升30%以上，美颜、Animoji、美妆、手势等功能也有10%以上的帧率提升。
- 优化包增量，SDK分为lite版，和全功能版本。lite版体积更小，包含人脸相关的功能(海报换脸除外)。
- 优化人脸跟踪稳定性，提升贴纸的稳定性。
- 提供独立核心算法SDK，接口文档详见算法SDK文档(FUAI_C_API_参考文档.md)。
- fuGetFaceInfo接口新增三个参数，分别为：舌头方向(tongue_direction)，表情识别(expression_type)，头部旋转信息欧拉角参数(rotation_euler)。
- 新增人体动作识别动作定义文档(人体动作识别文档.md)。

------
### 目录：
本文档内容目录：

[TOC]

------
### 1. 简介 
本文档旨在说明如何将Faceunity Nama SDK的iOS Demo运行起来，体验Faceunity Nama SDK的功能。FULiveDemo 是集成了 Faceunity 面部跟踪、美颜、Animoji、道具贴纸、AR面具、表情识别、音乐滤镜、人像分割、手势识别、哈哈镜以及Avatar 捏脸功能的Demo。Demo将根据客户证书权限来控制用户可以使用哪些产品。

------
### 2. iOS Demo文件结构
本小节，描述iOS Demo文件结构，各个目录，以及重要文件的功能。

```
+FULiveDemo
  +FULiveDemo 			  	//原代码目录
    +Main                     //基类控制器(主要包含基类UI和视频采集) 
    +Modules                  //所有功能模块
      +Normal                   //普通道具模块
      +Beauty                   //美颜模块
        ...
    +Helpers                //主要业务管理类  
      -FUManager              //nama 业务类
      -FUCamera               //视频采集类     
    +Config					//配置文件目录
      -DataSource             //主界面，权限，item 道具配置类 
      -makeup.json       	  //美妆单个妆数组
      -makeup_whole.json      //美妆整体妆容配置
      -avatar.json            //捏脸颜色，模板配置文件
    +Resource               
       +itmes                 //个个模块道具资源 
    +Lib                    //nama SDK  
      -authpack.h             //权限文件
      +libCNamaSDK.framework      
        +Headers
          -funama.h                //C 接口
          -FURenderer.h            //OC 接口
  +docs						//文档目录
  +Pods                     //三方库管理
  -FULiveDemo.xcworkspace   //工程文件
  
```

------
### 3. 运行Demo 

#### 3.1 开发环境
##### 3.1.1 支持平台
```
iOS 9.0以上系统
```
##### 3.1.2 开发环境
```
Xcode 8或更高版本
```

#### 3.2 准备工作 
- [下载FULiveDemo](https://github.com/Faceunity/FULiveDemo)
- 替换证书文件 **authpack.h**，获取证书 见 **3.3.1**

#### 3.3 相关配置
##### 3.3.1 导入证书
您需要拥有我司颁发的证书才能使用我们的SDK的功能，获取证书方法：

1、拨打电话 **0571-89774660** 

2、发送邮件至 **marketing@faceunity.com** 进行咨询。

iOS端发放的证书为包含在authpack.h中的g_auth_package数组，如果您已经获取到鉴权证书，将authpack.h导入工程中即可。根据应用需求，鉴权数据也可以在运行时提供(如网络下载)，不过要注意证书泄露风险，防止证书被滥用。

#### 3.4 编译运行
![](./imgs/runDemo.png)
![](./imgs/demoHome.png)

------
### 4. 常见问题 

#### 4.1 运行报错

第一次运行Demo会报缺少证书的 error ,如果您已拥有我司颁发的证书，将证书替换到工程中重新运行即可。
