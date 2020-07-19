platform :ios, '11.3'
install! 'Cocoapods', :disable_input_output_paths => true 
use_modular_headers!
inhibit_all_warnings!

target 'ChargerFinder' do
   use_frameworks!

   pod 'Firebase/Core', :inhibit_warnings => true
   pod 'Firebase/Database', :inhibit_warnings => true
   pod 'Firebase/Auth', :inhibit_warnings => true
   
   target :ChargerFinderTests do
      pod 'ChargerFinder', :path => '.'
   end 

end

target 'ChargerFinderDemoApp' do
   use_frameworks!
   pod 'ChargerFinder', :path => '.'
end