use_frameworks!
platform :ios, '11.3'
inhibit_all_warnings!

target 'ChargerFinder' do
   pod 'Firebase/Core', :inhibit_warnings => true
   pod 'Firebase/Database', :inhibit_warnings => true
   pod 'Firebase/Auth', :inhibit_warnings => true
end

target 'ChargerFinderDemoApp' do
   pod 'ChargerFinder', :path => '.'
end

target :ChargerFinderTests do
   pod 'ChargerFinder', :path => '.'
end 