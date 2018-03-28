Pod::Spec.new do |spec|
  spec.name = 'ReactiveOauth'
  spec.version = '1.0.3'
  spec.summary = 'ReactiveSwift + OAuthSwift = ❤️🔥'
  spec.license = { :type => 'MIT' }
  spec.homepage = 'https://github.com/swifteroid/reactiveoauth'
  spec.authors = { 'Ian Bytchek' => 'ianbytchek@gmail.com' }

  spec.platform = :osx, '10.11'

  spec.source = { :git => 'https://github.com/swifteroid/reactiveoauth.git', :tag => "#{spec.version}" }
  spec.source_files = 'source/ReactiveOauth/**/*.{swift,h,m}'
  spec.exclude_files = 'source/ReactiveOauth/{Test,Testing}/**/*'
  spec.swift_version = '4'

  spec.pod_target_xcconfig = { 'OTHER_SWIFT_FLAGS[config=Release]' => '-suppress-warnings' }
  
  spec.dependency 'Alamofire', '~> 4.0'
  spec.dependency 'OAuthSwift', '~> 1.0'
  spec.dependency 'ReactiveCocoa', '~> 7.0'
  spec.dependency 'SwiftyJSON', '~> 4.0'
end