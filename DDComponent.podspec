Pod::Spec.new do |s|
  s.name             = 'DDComponent'
  s.version          = '0.1.0'
  s.summary          = 'A short description of DDComponent.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/liuxc123/DDComponent'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'liuxc123' => 'lxc_work@126.com' }
  s.source           = { :git => 'https://github.com/liuxc123/DDComponent.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'

  s.source_files = 'DDComponent/**/*'
  
  # s.resource_bundles = {
  #   'DDComponent' => ['DDComponent/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
