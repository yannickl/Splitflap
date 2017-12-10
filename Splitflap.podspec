Pod::Spec.new do |s|
  s.name             = 'Splitflap'
  s.version          = '3.0.1'
  s.license          = 'MIT'
  s.summary          = 'A simple split-flap display for your Swift applications'
  s.description      = <<-DESC
                        Splitflap is a simple to use component to present changeable alphanumeric text like often used as a public transport timetable in airports or railway stations or with some flip clocks.
                       DESC
  s.homepage         = 'https://github.com/yannickl/Splitflap.git'
  s.social_media_url = 'https://twitter.com/yannickloriot'
  s.authors          = { 'Yannick Loriot' => 'contact@yannickloriot.com' }
  s.source           = { :git => 'https://github.com/yannickl/Splitflap.git', :tag => s.version }
  s.screenshot       = 'http://yannickloriot.com/resources/splitflap-logo.gif'

  s.ios.deployment_target  = '8.0'
  s.tvos.deployment_target = '9.0'

  s.ios.frameworks  = 'UIKit', 'QuartzCore'
  s.tvos.frameworks = 'UIKit', 'QuartzCore'

  s.source_files = 'Sources/*.swift'
  s.requires_arc = true
end
