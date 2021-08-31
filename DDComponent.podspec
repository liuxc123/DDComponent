Pod::Spec.new do |s|
  s.name             = 'DDComponent'
  s.version          = '1.0.0'
  s.summary          = 'Make a collection and table controller to several component'
  s.description      = <<-DESC
  Make a collection and table controller to several component. Make the controller smaller.
                       DESC
  s.homepage         = 'https://github.com/liuxc123/DDComponent'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'liuxc123' => 'lxc_work@126.com' }
  s.source           = { :git => 'https://github.com/liuxc123/DDComponent.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'

  s.source_files = 'DDComponent/**/*.{h,m,mm,swift}'
  s.framework  = "UIKit"
end
