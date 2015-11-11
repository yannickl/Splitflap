Pod::Spec.new do |s|
  s.name             = 'Splitflap'
  s.version          = '0.1.0'
  s.license          = 'MIT'
  s.summary          = 'A simple to use split-flap display for your Swift applications'
  s.homepage         = 'https://github.com/yannickl/Splitflap.git'
  s.social_media_url = 'https://twitter.com/yannickloriot'
  s.authors          = { 'Yannick Loriot' => 'contact@yannickloriot.com' }
  s.source           = { :git => 'https://github.com/yannickl/Splitflap.git', :tag => s.version }
  s.screenshot       = 'http://yannickloriot.com/resources/dynamicbutton.gif'

  s.ios.deployment_target = '8.0'
  s.ios.frameworks        = 'UIKit', 'QuartzCore'

  s.source_files = 'Splitflap/*.swift'
  s.requires_arc = true
end
