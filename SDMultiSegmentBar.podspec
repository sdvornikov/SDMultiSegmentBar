Pod::Spec.new do |s|
  s.name         = "SDMultiSegmentBar"
  s.version      = "0.1"
  s.summary      = "An iOS multi segment indicator bar view."
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'Sergey Dvornikov' => 'sergey.dvornikov@gmail.com' }
  s.source       = { :git => "https://github.com/sdvornikov/SDMultiSegmentBar.git", :tag => s.version.to_s }
  s.platform     = :ios
  s.source_files = '*.{h,m}'
  s.framework    = "CoreGraphics"
  s.requires_arc = true
end