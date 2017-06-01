Pod::Spec.new do |spec|
    spec.name         = 'SwiftyChrono'
    spec.version      = '1.0.3'
    spec.osx.deployment_target = "10.10"
    spec.ios.deployment_target = "9.0"
    spec.tvos.deployment_target = "9.0"
    spec.watchos.deployment_target = "2.0"
    spec.summary      = 'A natural language date parser in Swift (ported from chrono.js)'
    spec.author       = 'Jerrywell'
    spec.homepage     = 'https://github.com/Herbal7ea/SwiftyChrono'
    spec.license      = { :type => 'MIT', :file => 'LICENSE' }
    spec.source       = { :git => 'https://github.com/Herbal7ea/SwiftyChrono.git', :tag => 'v1.0.3' }
    spec.source_files = 'Sources/**/*.swift'
    spec.social_media_url = 'https://twitter.com/Herbal7ea'
    spec.documentation_url = 'https://github.com/Herbal7ea/SwiftyChrono'
end
