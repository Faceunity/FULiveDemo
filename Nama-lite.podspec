Pod::Spec.new do |s|
  s.name     = 'Nama-lite'
  s.version  = '6.0.0'
  s.license  = 'MIT'
  s.summary  = 'faceunity nama v6.0.0-dev-lite'
  s.homepage = 'https://github.com/Faceunity/FULiveDemo/tree/dev'
  s.author   = { 'faceunity' => 'dev@faceunity.com' }
  s.platform     = :ios, "9.0"
  s.source   = { "http": "https://www.faceunity.com/sdk/FaceUnity-SDK-iOS-v6.0.0-dev-lite.zip"}
  s.source_files = '**/*.{h,m}'
  s.resources = '**/*.{bundle,txt}'
  s.ios.vendored_library = '**/libnama.a'
  s.requires_arc = true
  s.ios.frameworks   = ['OpenGLES', 'Accelerate', 'CoreMedia', 'AVFoundation']
  s.libraries = ["stdc++"]
  end