Pod::Spec.new do |s|
  s.name         = "FUBeautyComponent"
  s.version      = "1.0"
  s.license         = 'MIT'
  s.summary      = "Beauty component"
  s.description  = "The beauty component of FULiveDemo."
  s.homepage     = "https://github.com/Faceunity/FULiveDemo"
  s.author   = { 'faceunity' => 'dev@faceunity.com' }
  s.platform     = :ios, "9.0"
  s.source   = { "http": "https://github.com/Faceunity/FULiveDemo"}
  s.source_files = '**/*.{h,m}'
  s.resources =  'FUBeautyComponent/Resource/**/*.{json}'
  s.requires_arc = true
  s.dependency 'FURenderKit'
  s.dependency 'FUCommonUIComponent'
end
