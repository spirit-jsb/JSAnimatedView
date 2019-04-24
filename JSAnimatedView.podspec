Pod::Spec.new do |s|

    s.name             = 'JSAnimatedView'
    s.version          = '1.1.0'
    s.summary          = '一个简便易用的本地 GIF 播放框架。'
  
    s.description      = <<-DESC
    一个简便易用的本地 GIF 播放框架，更低的CPU和内存占用，更加流畅的动画体验。
                         DESC
  
    s.homepage         = 'https://github.com/spirit-jsb/JSAnimatedView.git'
  
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
  
    s.author           = { 'spirit-jsb' => 'sibo_jian_29903549@163.com' }
  
    s.swift_version = '5.0'
  
    s.ios.deployment_target = '9.0'
  
    s.source           = { :git => 'https://github.com/spirit-jsb/JSAnimatedView.git', :tag => s.version.to_s }
    
    s.source_files = 'Sources/**/*.swift'
    
    s.requires_arc = true
    s.frameworks = 'UIKit', 'Foundation'
  
  end