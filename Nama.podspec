Pod::Spec.new do |s|
  s.name     = 'Nama'
  s.version  = '5.4.0'
  s.license  = 'MIT'
  s.summary  = 'faceunity nama v5.5.0-dev'
  s.homepage = 'https://github.com/Faceunity/FULiveDemo/tree/dev'
  s.author   = { 'faceunity' => 'dev@faceunity.com' }
  s.platform     = :ios, "8.0"
  s.source   = { :git => 'https://github.com/Faceunity/FULiveDemo.git', :tag => 'v5.5.0-dev' }
  s.source_files = 'FULiveDemo/Faceunity/FaceUnity-SDK-iOS/**/*.{h,m}'
  s.resources = 'FULiveDemo/Faceunity/FaceUnity-SDK-iOS/**/*.{bundle,txt}'
  s.ios.vendored_library = 'FULiveDemo/Faceunity/FaceUnity-SDK-iOS/libnama.a'
  s.requires_arc = true
  s.ios.frameworks   = ['OpenGLES', 'Accelerate', 'CoreMedia', 'AVFoundation']
  s.libraries = ["stdc++"]
  end