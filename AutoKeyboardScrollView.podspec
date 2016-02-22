Pod::Spec.new do |s|
  s.name             = "AutoKeyboardScrollView"
  s.version          = "1.4.1"
  s.summary          = "AutoKeyboardScrollView moves text fileds up when keyboard appears"
  s.description      = <<-DESC
                       AutoKeyboardScrollView is an UIScrollView subclass which makes showing and dismissing keyboard for UITextFields much easier. It works with Auto Layout

                       DESC
  s.homepage         = "https://github.com/honghaoz/AutoKeyboardScrollView"
  s.screenshots      = "https://raw.githubusercontent.com/honghaoz/AutoKeyboardScrollView/master/demo.gif"
  s.license          = 'MIT'
  s.author           = { "Honghao Zhang" => "zhh358@gmail.com" }
  s.source           = { :git => "https://github.com/honghaoz/AutoKeyboardScrollView.git", :tag => s.version.to_s }

  s.platform     	 = :ios, '8.0'
  s.requires_arc 	 = true

  s.source_files = 'Source/*'

  s.frameworks = 'UIKit'
  
end
