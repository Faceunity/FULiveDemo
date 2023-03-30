Pod::Spec.new do |s|
  s.name         = "FUGreenScreenComponent"
  s.version      = "1.0"
  s.license         = 'MIT'
  s.summary      = "Green screen component"
  s.description  = "The green screen component of FULiveDemo."
  s.homepage     = "https://github.com/Faceunity/FULiveDemo"
  s.author   = { 'faceunity' => 'dev@faceunity.com' }
  s.platform     = :ios, "9.0"
  s.source   = { "http": "https://github.com/Faceunity/FULiveDemo"}
  s.source_files = '**/*.{h,m}'
  s.resources =  'FUGreenScreenComponent/Resource/**/*.{json}'
  s.requires_arc = true
  s.dependency 'FURenderKit'
  s.dependency 'FUCommonUIComponent'
end
