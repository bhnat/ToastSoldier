Pod::Spec.new do |s|

  s.name         = "ToastSoldier"
  s.version      = "0.0.1"
  s.summary      = "A short description of ToastSoldier."

  s.description  = <<-DESC
                   A longer description of ToastSoldier in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

  # s.homepage     = "http://EXAMPLE/ToastSoldier"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "bhnat" => "brian@mitrapps.com" }
  # Or just: s.author    = "bhnat"

  s.platform     = :ios, "8.0"
  s.source       = { :git => "http://github.com/bhnat/ToastSoldier.git", :tag => "0.0.1" }
  s.source_files  = 'Source/*.swift'
  # s.exclude_files = "Classes/Exclude"
  s.requires_arc = true

end
