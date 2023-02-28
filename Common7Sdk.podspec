Pod::Spec.new do |s|
  s.name             = 'Common7Sdk'
  s.version          = '0.0.1'
  s.summary          = 'Common7Sdk.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/RC-Liang/Common7Sdk.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'gogopaly@163.com' => '116050908+GigoGogo790@users.noreply.github.com' }
  s.source           = { :git => 'https://github.com/RC-Liang/Common7Sdk.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'
  s.swift_version = '5.0'

  s.source_files = 'Common7Sdk/Classes/**/*'
  
#  s.subspec 'Alert' do |alert|
#      alert.source_files = 'Common7Sdk/Classes/AlertView/**/*'
#      alert.dependency 'SnapKit'
#      alert.dependency 'RxSwift'
#      alert.dependency 'RxCocoa'
#  end
#
#  s.subspec 'Extension' do |extension|
#      extension.source_files = 'Common7Sdk/Classes/Extension/**/*'
#  end
  
  s.resource_bundles = {
      'Common' => ['Common7Sdk/Assets/**/*.{png,jpeg,jpg,storyboard,xib,xcassets,ttf,plist}']
  }
  
  s.dependency 'SnapKit'
  s.dependency 'RxSwift'
  s.dependency 'RxCocoa'
  s.dependency 'MBProgressHUD'
  s.dependency 'Kingfisher'
  
end
