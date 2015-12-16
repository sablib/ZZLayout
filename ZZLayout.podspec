Pod::Spec.new do |s|
  s.name         = "ZZLayout"
  s.version      = "0.2.0"
  s.summary      = "Layout items use masonry-like api.."
  s.description  = <<-DESC
  It use `Rhea` to layout items like `Masonry`.
  It can be use in background thread.
                   DESC
  s.homepage     = "https://github.com/sablib/ZZLayout"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "sablib" => "sablib.iak@gmail.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/sablib/ZZLayout.git", :tag => s.version.to_s }
  s.source_files = "ZZLayout/Classes/*.{h,m,mm}"
  s.dependency "Rhea", "~> 0.2"
end
