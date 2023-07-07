platform :ios, '9.0'

use_frameworks!

target 'FULiveDemo' do
  
    # AutoLayout
    pod 'Masonry'
    
    # 网络请求工具
    pod 'AFNetworking', '~> 4.0.0'
    
    # 网络图片展示
    pod 'SDWebImage'
    
    # 数据模型
    pod 'YYModel'
    
    # 解压缩工具
    pod 'SSZipArchive'
    
    # FURenderKit开发库
    #pod 'FURenderKit-dev', :path => '/Users/xiang/Desktop/集成/GitLab/FURenderKit'
    
    # FURenderKit库资源
    #pod 'FURenderKit-assets-dev', :path => '/Users/xiang/Desktop/集成/GitLab/FURenderKit'
    
    #pod 'FURenderKit-dev', :git => 'git@192.168.0.118:liuyang/FURenderKit_Release.git', :branch => 'nama-dev-xlp'
    
    #pod 'FURenderKit-assets-dev', :git => 'git@192.168.0.118:liuyang/FURenderKit_Release.git', :branch => 'nama-dev-xlp'

    pod 'FURenderKit', :path => 'FURenderKit/'
    pod 'FUCommonUIComponent', :git => 'git@192.168.0.118:xiangxiaopenyou/FUCommonUIComponent.git'
    pod 'FUBeautyComponent', :git => 'git@192.168.0.118:xiangxiaopenyou/FUBeautyComponent.git'
    pod 'FUMakeupComponent', :git => 'git@192.168.0.118:xiangxiaopenyou/FUMakeupComponent.git'
    pod 'FUGreenScreenComponent', :git => 'git@192.168.0.118:xiangxiaopenyou/FUGreenScreenComponent.git'
    
end

post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
            config.build_settings['ENABLE_BITCODE'] = 'NO'
         end
    end
  end
end



