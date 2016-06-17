
Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "SegueExtension"
  s.version      = "0.1"
  s.summary      = "SegueExtension make work this segues easy"

  s.description  = <<-DESC
                    SegueExtensuin is a simple lib what allow to call performSegueWithIdentifier with block of code(handler for that segue).
                   DESC

  s.homepage     = "https://github.com/matyushenkoMaxim/SegueExtension"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "matyushenko" => "matyushenko@tutu.ru" }

  s.ios.deployment_target = "8.0"

  s.source           = { :git => 'https://github.com/matyushenkoMaxim/SegueExtension.git', :tag => s.version }

  s.source_files  = "SegueExtension/SegueExtension/*.swift"
  s.exclude_files = "SegueExtension/Exclude"

#s.resources = "Resources/*.*"

  s.framework  = "Foundation"

  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
