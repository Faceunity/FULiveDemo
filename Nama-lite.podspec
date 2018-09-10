Pod::Spec.new do |s|
  s.name     = 'Nama-lite'
  s.version  = '5.5.0'
  s.license  = 'MIT'
  s.summary  = 'faceunity nama v5.5.0-dev-lite'
  s.homepage = 'https://www.faceunity.com'
  s.author   = { 'faceunity' => 'dev@faceunity.com' }
  s.platform     = :ios, "8.0"
  s.source   = { :git => 'https://github.com/Faceunity/FULiveDemo.git', :tag => 'v5.5.0-dev' }
  s.source_files = 'FULiveDemo/Faceunity/FaceUnity-SDK-iOS-lite/**/*.{h,m}'
  s.resources = 'FULiveDemo/Faceunity/FaceUnity-SDK-iOS-lite/**/*.{bundle,txt}'
  s.ios.vendored_library = 'FULiveDemo/Faceunity/FaceUnity-SDK-iOS-lite/libnama.a'
  s.requires_arc = true
  s.ios.frameworks   = ['OpenGLES', 'Accelerate', 'CoreMedia', 'AVFoundation']
  s.libraries = ["stdc++"]
  end