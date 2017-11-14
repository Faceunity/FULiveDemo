Pod::Spec.new do |s|
  s.name     = 'Nama'
  s.version  = '4.2'
  s.license  = 'MIT'
  s.summary  = 'faceunity nama v4.2-dev'
  s.homepage = 'https://github.com/Faceunity/FULiveDemo/tree/dev'
  s.author   = { 'faceunity' => 'dev@faceunity.com' }
  s.platform     = :ios, "8.0"
  s.source   = { :git => 'https://github.com/Faceunity/FULiveDemo.git', :tag => 'v4.2-dev' }
  s.source_files = 'FULiveDemo/Faceunity/FaceUnity-SDK-iOS/**/*.{h,m}'
  s.resources = 'FULiveDemo/Faceunity/FaceUnity-SDK-iOS/**/*.{bundle}'
  s.ios.vendored_library = 'FULiveDemo/Faceunity/FaceUnity-SDK-iOS/libnama.a'
  s.requires_arc = true
  s.ios.frameworks   = ['OpenGLES', 'Accelerate', 'CoreMedia', 'AVFoundation']
  s.libraries = ["stdc++"]
  end