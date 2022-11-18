# Demo运行说明文档-iOS 

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

```obj
+FULiveDemo
  +docs                     //文档
  +FUCommonUIComponent      //UI组件
  +FUVideoComponent         //视频解码编码组件
  +FUBeautyComponent        //美颜组件（UI和加载逻辑）
  +FUMakeupComponent        //美妆组件（UI和加载逻辑）
  +FUGreenScreenComponent   //绿幕组件（UI和加载逻辑）
  +FULiveDemo 			  	//原代码目录
    +Homepage                   //主页模块
    +Render                     //相机、视频、图片渲染模块，所有特效渲染模块基于此模块
    +MediaPicker                //视频、图片选择模块
    +Modules                    //所有特效功能模块
        +Beauty                       //美颜模块
        +Makeup                       //美妆模块
        ...
    +Helper                     //工具类  
        +Category                     //类别
        -FULiveDefine                 //宏、枚举、内联函数等
        -FUNetworkingHelper           //网络请求工具
        -FUUtility                    //共用方法类
    +Resource                   //资源文件（JSON、Bundle）              
        +Homepage                    //主页模块资源
        +Render                      //相机、视频、图片渲染模块资源
        +Sticker                     //贴纸模块资源
        ...
    +Application                //工程文件  
        -Assets                       //图片资源
        -Localizable.strings          //国际化支持字符串文件      
        ...
    +FURenderKit
        +FURenderKit.framework  //FURenderKit动态库
        +Resources              //FURenderKit必要资源
        -FURenderKitManger      //FURenderKit管理类
        -authpack.h             //鉴权文件（需要替换自己的鉴权文件）
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
