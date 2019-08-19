#
#  Be sure to run `pod spec lint JapiFlat.podspec` to ensure this a
#  valid spec and to remove all comments including this vefore submiting the spec.
#
Pod::Spec.new do |spec|

spec.name         = "JapiFlat"
spec.version      = "0.0.1"
spec.summary      = "JapiFlat Converter from JSON-API to ordinary JSON."

spec.platform = :ios, "10.0"
spec.ios.deployment_target = '10.0'
spec.homepage     = 'https://github.com/Alamofire/Alamofire'
spec.license      = { :type => 'MIT', :text => 'LICENSE' }
spec.author       = { "Saminos" => "syaifulamin@styletheory.co" }
spec.source = { git: "file:///Users/saminos/LocalGit/JapiFlat.git", tag: "v#{spec.version}", submodules: true }
spec.source_files  = "JapiFlat/**/*.{h,swift}"

spec.swift_version = '5.0'

end
