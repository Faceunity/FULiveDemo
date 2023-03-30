Pod::Spec.new do |s|
  s.name         = "FUCommonUIComponent"
  s.version      = "1.0"
  s.license         = 'MIT'
  s.summary      = "UI components"
  s.description  = "Some UI components of FULiveDemo."
  s.homepage     = "https://github.com/Faceunity/FULiveDemo"
  s.author   = { 'faceunity' => 'dev@faceunity.com' }
  s.platform     = :ios, "9.0"
  s.source   = { "http": "https://github.com/Faceunity/FULiveDemo"}
  s.source_files = '**/*.{h,m}'
  s.resources =  'FUCommonUIComponent/Resource/**/*.{png,xcassets}'
  s.requires_arc = true
end
