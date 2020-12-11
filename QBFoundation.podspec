#
# Be sure to run `pod lib lint QBFoundation.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'QBFoundation'
  s.version          = '0.2.5'
  s.summary          = 'iOS基础库'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                            QBFoundation iOS基础库 OC
                       DESC

  s.homepage         = 'https://github.com/luqinbin/QBFoundation'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'luqinbin' => '751536545@qq.com' }
  s.source           = { :git => 'https://github.com/luqinbin/QBFoundation.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'QBFoundation/QBFoundation/**/*'
  
  # s.resource_bundles = {
  #   'QBFoundation' => ['QBFoundation/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'Foundation', 'CoreServices'
  # s.dependency 'AFNetworking', '~> 2.3'
end
