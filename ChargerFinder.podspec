Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.name         = 'ChargerFinder'
  spec.version      = '0.1.0'
  spec.summary      = 'Electric charger finder app module'
  spec.description  = <<-DESC
  Is an electric charger finder app that uses ARKit, Maps, CoreLocation to build an user friendly application.
                       DESC
  spec.homepage     = 'https://github.com/oscarodon19/ChargerFinder'

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.license          = { :type => 'MIT', :file => 'LICENSE' }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.author             = { 'Oscar Odon' => 'oscarodon19@gmail.com' }

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.platform     = :ios
  spec.ios.deployment_target = '11.3'

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.source       = { :git => 'https://github.com/oscarodon19/ChargerFinder.git', :tag => "#{spec.version}" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.source_files  = 'ChargerFinder/**/*.{h,m,swift}'
  spec.public_header_files = 'ChargerFinder/**/*.h'
  spec.exclude_files = 'ChargerFinder/*.plist'

  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #
  spec.resource_bundles = {'ChargerFinder' => ['ChargerFinder/**/*.{png,jpg,jpeg,xcassets,strings,json}']}

  # spec.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.frameworks = 'UIKit', 'MapKit', 'ARKit'  

  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.swift_version = ['5.0']
  spec.static_framework = true
  spec.dependency 'Firebase/Core'
  spec.dependency 'Firebase/Database'
  spec.dependency 'Firebase/Auth'
  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }

  # ――― Test Configuration ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.test_spec "ChargerFinderTests" do |test_spec|
    test_spec.frameworks = 'XCTest'
    test_spec.source_files = 'ChargerFinderTests/**/*.{h,m,swift}', 'ChargerFinder/**/*.{h,m,swift}'
  end  

end