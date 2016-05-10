
Pod::Spec.new do |s|


  s.name         = "QRCode"
  s.version      = "1.0.0"
  s.summary      = "二维码生成和扫描"
  s.description  = <<-DESC

		二维码生成和扫描,使用
                   DESC
  s.homepage     = "https://github.com/TeaseTian/QRCode"
  s.license      = { :type => "MIT", :file => "LICENSE" }


  s.author       = { "TeaseTian" => "330972860@qq.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/TeaseTian/QRCode.git", :tag => s.version }
  s.source_files = "QRCode/*"
  s.resources    = "QRCode/*.png"
  # s.frameworks   = "SomeFramework", "AnotherFramework"
  s.requires_arc = true
  s.dependency "ZXingObjC", "3.1.0"
  s.dependency "Masonry"


end
