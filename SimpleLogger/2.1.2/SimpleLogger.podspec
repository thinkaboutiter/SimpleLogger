Pod::Spec.new do |s|
  s.name = "SimpleLogger"
  s.version = "2.1.2"
  s.summary = "Simple logging tool"
  s.homepage = "https://github.com/thinkaboutiter/SimpleLogger"
  s.license = 'MIT'
  s.author = { "Thinka Boutiter" => "thinkaboutiter@gmail.com" }
  s.source = {
    :git => "https://github.com/thinkaboutiter/SimpleLogger.git",
    :tag => s.version }
  s.platforms = { :ios => "10.0", :osx => "10.13", :watchos => "4.0", :tvos => "11.0" }
  s.requires_arc = true
  s.source_files = 'Sources/SimpleLogger/**/*'
end
