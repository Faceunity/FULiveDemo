Pod::Spec.new do |s|
  s.name     = 'Nama-lite'
  s.version  = '6.3.0'
  s.license  = 'MIT'
  s.summary  = 'faceunity nama v6.3.0-lite'
  s.homepage = 'https://github.com/Faceunity/FULiveDemo'
  s.author   = { 'faceunity' => 'dev@faceunity.com' }
  s.platform     = :ios, "9.0"
  s.source   = { "http": "https://www.faceunity.com/sdk/FaceUnity-SDK-iOS-v6.3.0-lite.zip"}
  s.source_files = '**/*.{h,m}'
  s.resources = '**/*.{bundle,txt}'
  s.ios.vendored_library = '**/libnama.a'
  s.requires_arc = true
  s.ios.frameworks   = ['OpenGLES', 'Accelerate', 'CoreMedia', 'AVFoundation']
  s.libraries = ["stdc++"]
  end