Pod::Spec.new do |s|
  	s.name             = "UUSwiftImage"
  	s.version          = "1.0.0"

  	s.description      = <<-DESC
                       UUSwiftImage is a framework to extend the base Foundation and UIKit classes. UUSwiftImage eliminates many of the tedious tasks associated with Swift development such as date formating and string manipulation.
                       DESC
  	s.summary          = "UUSwiftImage extends Foundation and UIKit to add additional functionality to make development more efficient."

  	s.homepage         = "https://github.com/SilverPineSoftware/UUSwiftImage"
  	s.author           = "Silverpine Software"
  	s.license          = { :type => 'MIT' }
  	s.source           = { :git => "https://github.com/SilverPineSoftware/UUSwiftImage.git", :tag => s.version.to_s }

	s.ios.deployment_target = "10.0"
	s.osx.deployment_target = "10.10"
	s.swift_version = "5.0"

	s.subspec 'Core' do |ss|
    	ss.source_files = 'UUSwiftImage/*.{swift}'
    	ss.ios.frameworks = 'UIKit', 'Foundation'
		ss.osx.frameworks = 'CoreFoundation'
		ss.tvos.frameworks = 'UIKit', 'Foundation'
  	end

end

