Pod::Spec.new do |s|
  s.name         = "ZZLayout"
  s.version      = "0.1.0"
  s.summary      = "Layout items use masonry-like api.."
  s.description  = <<-DESC
  It use `Rhea` to layout items like `Masonry`.
  It can be use in background thread.
                   DESC

  s.homepage     = "http://github.com/sablib/ZZLayout"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "sablib" => "sablib.iak@gmail.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "http://github.com/sablib/ZZLayout.git", :tag => s.version.to_s }
  s.source_files = "Classes/*.{h,m}"
  s.exclude_files = "Classes/Exclude"
  s.dependency "Rhea", "~> 0.2"

end
