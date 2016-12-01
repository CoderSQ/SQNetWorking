
Pod::Spec.new do |s|

  s.name         = "SQNetWorking"
  s.version      = "0.0.2"
  s.summary      = "SQNetWorking."

  s.homepage     = "https://github.com/CoderSQ/SQNetWorking.git"
  s.license      = "MIT"

  s.author             = { "CoderSQ" => "steven_shuang@126.com" }

  # s.platform     = :ios
  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/CoderSQ/SQNetWorking.git", :tag => "#{s.version}" }


  s.source_files  = "SQNetWorking", "SQNetWorking/**/*.{h,m}"
  #s.exclude_files = "SQNetWorking/Customs/Configurations/SQNetWorkingConfig.h"

  #s.public_header_files = "SQNetWorking/Customs/Configurations/SQNetWorkingConfig.h"

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"

  s.framework  = "UIKit"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  s.dependency "AFNetworking", "~> 3.1.0"

end
