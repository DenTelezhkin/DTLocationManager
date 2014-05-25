Pod::Spec.new do |s|

  s.name         = "DTLocationManager"
  s.version      = "0.1.0"
  s.summary      = "Simple location manager for iOS and Mac OS X"

  s.homepage     = "https://github.com/DenHeadless/DTLocationManager"
  s.license      = "MIT"
  
  s.author             = { "Denys Telezhkin" => "denys.telezhkin@yandex.ru" }
  s.social_media_url   = "https://twitter.com/DTCoder"

  s.ios.deployment_target = "6.0"
  s.osx.deployment_target = "10.9"

  s.source       = { :git => "https://github.com/DenHeadless/DTLocationManager.git", :tag => s.version.to_s }
  s.source_files  = "DTLocationManager/**/*.{h,m}"
  s.framework  = "CoreLocation"
  s.requires_arc = true
end
