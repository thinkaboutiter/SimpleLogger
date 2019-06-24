Pod::Spec.new do |s|
  s.name = "SimpleLogger"
  s.version = "2.2.6"
  s.summary = "Simple logging tool"
  s.homepage = "https://github.com/thinkaboutiter/SimpleLogger"
  s.license = 'MIT'
  s.author = { "Thinka Boutiter" => "thinkaboutiter@gmail.com" }
  s.source = {
    :git => "https://github.com/thinkaboutiter/SimpleLogger.git",
    :tag => s.version }
  s.platforms = { 
    :ios => "11.4", 
    :osx => "10.10,
    :watchos => "4.3",
    :tvos => "11.4" }
  s.requires_arc = true
  s.source_files = 'Sources/SimpleLogger/**/*'
end
