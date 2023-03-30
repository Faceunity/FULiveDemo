Pod::Spec.new do |s|
  s.name         = "FURenderKit"
  s.version      = "1.0"
  s.license         = 'MIT'
  s.summary      = "A framework of FaceUnity"
  s.description  = "A seak and package for sticker object and user do not attention release the sticker. Convenient and easy to user FaceUnity function."
  s.homepage     = "https://github.com/Faceunity/FULiveDemo"
  s.author   = { 'faceunity' => 'dev@faceunity.com' }
  s.platform     = :ios, "9.0"
  s.source   = { "http": "https://github.com/Faceunity/FULiveDemo"}
  s.resources = '**/*.{bundle,txt}'
  s.source_files = '**/*.{h,m}'
  s.ios.vendored_frameworks = 'FURenderKit.framework'
  s.requires_arc = true
  s.ios.frameworks   = ['OpenGLES', 'Accelerate', 'CoreMedia', 'AVFoundation']
  s.libraries = ["stdc++"]
  s.pod_target_xcconfig = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
  }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
end
