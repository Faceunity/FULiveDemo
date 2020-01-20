# Demo运行说明文档-iOS  
级别：Public   
更新日期：2020-01-19   

-------

**FaceUnity Nama SDK v6.6.0 (2020-01-19 )**

注意: 更新SDK 6.6.0时，在fuSetup之后，需要马上调用 fuLoadAIModelFromPackage 加载ai_faceprocessor.bundle 到 FUAITYPE::FUAITYPE_FACEPROCESSOR!!!

在Nama 6.6.0及以上，AI能力的调用会按道具需求调用，避免同一帧多次调用；同时由Nama AI子系统管理推理，简化调用过程；将能力和产品功能进行拆分，避免在道具bundle内的冗余AI模型资源，方便维护升级，同时加快道具的加载；方便各新旧AI能力集成，后续的升级迭代。

基本逻辑：Nama初始化后，可以预先加载一个或多个将来可能使用到的AI能力模块。调用实时render处理接口时，Nama主pipe会在最开始的时候，分析当前全部道具需要AI能力，然后由AI子系统执行相关能力推理，然后开始调用各个道具的‘生命周期’函数，各道具只需要按需在特定的‘生命周期’函数调用JS接口获取AI推理的结果即可，并用于相关逻辑处理或渲染。

1. 新增加接口 fuLoadAIModelFromPackage 用于加载AI能力模型。
2. 新增加接口 fuReleaseAIModel 用于释放AI能力模型。
3. 新增加接口 fuIsAIModelLoaded 判断AI能力是否已经加载。

例子1：背景分割
	a. 加载AI能力模型，fuLoadAIModelFromPackage加载ai_bgseg.bundle 到 FUAITYPE::FUAITYPE_BACKGROUNDSEGMENTATION上。
	b. 加载产品业务道具A，A道具使用了背景分割能力。
	c. 切换产品业务道具B，B道具同样使用了背景分割能力，但这时AI能力不需要重新加载。

__注__：6.6.0 FaceUnity Nama SDK，为了更新以及迭代更加方便，由原先一个 libnama.a 拆分成两个库 libnama.a 以及 libfuai.a，其中 libnama.a 为轻量级渲染引擎，libfuai.a 为算法引擎。当升级 6.6.0 时，需要添加 libfuai.a 库。

------
### 目录：
本文档内容目录：

[TOC]

------
### 1. 简介 
本文档旨在说明如何将Faceunity Nama SDK的iOS Demo运行起来，体验Faceunity Nama SDK的功能。FULiveDemo 是集成了 Faceunity 面部跟踪、美颜、Animoji、道具贴纸、AR面具、换脸、表情识别、音乐滤镜、背景分割、手势识别、哈哈镜、人像驱动以及Avatar 捏脸功能的Demo。Demo将根据客户证书权限来控制用户可以使用哪些产品。

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
    +Lib                    //nama SDK  
      -authpack.h             //权限文件
      +FaceUnity-SDK-iOS      
        +Headers
          -funama.h                //C 接口
          -FURenderer.h            //OC 接口
        +Resources               //SDK 重要功能资源
        -libnama.a               //Nama图形库
        -libfuai.a               //Nama算法库
        +items                   //个个模块道具资源 
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
![](./imgs/runDemo.jpg)
![](./imgs/demoHome.png)

------
### 4. 常见问题 

#### 4.1 运行报错

第一次运行Demo会报缺少证书的 error ,如果您已拥有我司颁发的证书，将证书替换到工程中重新运行即可。

#### 4.2 工程找不到libnama.a

由于最新的含有深度学习的libnama.a大小已超过100M，我们没有上传libnama.a的原文件，只是上传了一个libnama.zip的文件，在你第一次编译工程的时候我们会解压libnama.zip。如果你想从工程目录中获取含有深度学习的libnama.a，并且你没有编译过工程的话，则需要先解压libnama.zip获得libnama.a才行。