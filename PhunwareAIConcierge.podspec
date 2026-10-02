Pod::Spec.new do |spec|
  spec.name                = 'PhunwareAIConcierge'
  spec.version             = '1.0.0'
  spec.summary             = 'A Phunware module that will allow end users to have AI concierge functionality within their applications.'
  spec.homepage            = 'https://www.phunware.com'
  spec.license             = { :type => 'Copyright', :text => 'Copyright 2009-present Phunware, Inc. All rights reserved.' }
  spec.author              = { 'Phunware, Inc.' => 'https://www.phunware.com' }
  spec.social_media_url    = 'https://twitter.com/Phunware'
  spec.platform            = :ios, '15.5'
  spec.source              = { :git => 'https://github.com/phunware/artifact-ai-concierge-ios.git', :tag => spec.version.to_s }
  spec.vendored_frameworks = 'Frameworks/PhunwareAIConcierge.xcframework'
  spec.cocoapods_version = '>= 1.16.2'

  spec.dependency 'PWCore', '~> 3.13.2'
  spec.dependency 'PhunwareCorePluginSource', '~> 1.2.0' 
  spec.dependency 'PhunwareFoundationSource', '~> 1.1.0'
  spec.dependency 'PhunwareThemingSource', '~> 1.1.2'
  spec.dependency 'PhunwarePermissionPrimingSource/Microphone', '~> 1.5.3'
  spec.dependency 'PhunwarePermissionPrimingSource/SpeechRecognition', '~> 1.5.3'
end
