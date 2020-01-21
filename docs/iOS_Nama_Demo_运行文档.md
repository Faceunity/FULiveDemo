# Demo运行说明文档-iOS  
级别：Public   
更新日期：2020-01-19   

-------

**FaceUnity Nama SDK v6.6.0 (2020-01-19 )**

更新内容
__版本整体说明:__ SDK 6.6.0 主要针对美颜、美妆进行效果优化，性能优化，稳定性优化，同时新增部分特性，使得美颜、美妆效果进入行业顶尖水平。建议对美颜、美妆需求较高的B端用户更新SDK。  
__注意!!!__：此版本由于底层替换原因，表情识别跟踪能力稍有降低，特别是Animoji、表情触发道具的整体表情表现力稍有减弱。Animoji的皱眉、鼓嘴、嘟嘴等动作表现效果比之较差，表情触发道具的发怒（皱眉）、鼓嘴、嘟嘴的表情触发道具较难驱动。其余ARMesh、明星换脸、动态人像（活照片）的面部跟踪整体稍有10%的效果减弱。故用到表情驱动的功能重度B端用户，仍建议使用SDK6.4.0版，使用其余功能（美颜叠加贴纸等其余功能）的场景不受影响，表情识别跟踪能力将在下一版进行优化更新。   

- 美颜优化：  
  1). 新增美型6款功能，包括开眼角、眼距、眼睛角度、长鼻、缩人中、微笑嘴角。
   2). 新增17款滤镜，其中包含8款自然系列滤镜、8款质感灰系列滤镜、1款个性滤镜。
   3). 优化美颜中亮眼、美牙效果。
   4). 优化美颜中3个脸型，调整优化使得V脸、窄脸、小脸效果更自然。
   5). 优化美白红润强度，美白、红润功能开放2倍参数，详见美颜文档。
- 美妆优化：  
  1). 新增13套自然系组合妆，13套组合妆是滤镜+美妆的整体效果，可自定义。
   2). 新增3款口红质地：润泽、珠光、咬唇。
   3). 提升美妆点位准确度 ，人脸点位由209点增加至 239点。
   4). 优化美妆素材叠加方式，使得妆容效果更加服帖自然。
   5). 优化粉底效果，更加贴合人脸轮廓。
- 提升人脸点位跟踪灵敏度，快速移动时跟踪良好，使美颜美妆效果跟随更紧密。
- 提升人脸点位的稳定性，解决了半张脸屏幕、大角度、遮挡等场景的阈值抖动问题，点位抖动问题也明显优化。
- 提升人脸跟踪角度，人脸最大左右偏转角提升至70度，低抬头检测偏转角也明显提升。
- 优化美发道具CPU占有率，Android/iOS提升约30%
- 新增MSAA抗锯齿接口，fuSetMultiSamples，解决虚拟形象（animoji与捏脸功能）边缘锯齿问题，详见接口文档。
- 架构升级，支持底层AI算法能力和业务逻辑拆分，优化性能，使得系统更加容易扩展和更新迭代：  
  1). 新增加接口 fuLoadAIModelFromPackage 用于加载AI能力模型。
   2). 新增加接口 fuReleaseAIModel 用于释放AI能力模型。
   3). 新增加接口 fuIsAIModelLoaded 用于判断AI能力是否已经加载。

__注__1：6.6.0 FaceUnity Nama SDK，为了更新以及迭代更加方便，由原先一个 libnama.a 拆分成两个库 libnama.a 以及 libfuai.a，其中 libnama.a 为轻量级渲染引擎，libfuai.a 为算法引擎。当升级 6.6.0 时，需要添加 libfuai.a 库。
__注2__: 更新SDK 6.6.0时，在fuSetup之后，需要马上调用 fuLoadAIModelFromPackage 加载 ai_faceprocessor.bundle !!!  
__注3__: SDK 6.6.0 进行较大的架构调整 , 架构上拆分底层算法能力和业务场景，使得SDK更能够按需复用算法模块，节省内存开销，算法能力模块后期更容易维护升级，使用方式详见新增加的一组接口定义fuLoadAIModelFromPackage / fuReleaseAIModel / fuIsAIModelLoaded 。

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