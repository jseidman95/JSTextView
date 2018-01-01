Pod::Spec.new do |s|
s.name             = 'JSTextView'
s.version          = '0.1.1'
s.summary          = 'A TextView with jump scroll capabilities'

s.description      = <<-DESC
This TextView dynamically creates labels within a TextView using NSAttributedString attributes
and allows the user to scroll through TextView by jump scrolling.
DESC

s.homepage         = 'https://github.com/jseidman95/JSTextView'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'Jesse Seidman' => 'seidmanjesse@gmail.com' }
s.source           = { :git => 'https://github.com/jseidman95/JSTextView.git', :tag => s.version.to_s }

s.ios.deployment_target = '11.2'
s.source_files = 'JSTextView/JSTextView/JSTextView.swift', 'JSTextView/JSTextView/JumpingLabel.swift'

end
