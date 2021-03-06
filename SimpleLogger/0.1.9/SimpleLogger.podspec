Pod::Spec.new do |s|
  s.name = "SimpleLogger"
  s.version = "0.1.9"
  s.summary = "Simple logging tool"
  s.homepage = "https://github.com/thinkaboutiter/SimpleLogger"
  s.license = 'MIT'
  s.author = { "Thinka Boutiter" => "thinkaboutiter@gmail.com" }
  s.source = {
    :git => "https://github.com/thinkaboutiter/SimpleLogger.git",
    :tag => s.version }
  s.platform = :ios, "8.3"
  s.requires_arc = true
  s.source_files = 'PublicFiles/**/*'
end
