Gem::Specification.new do |s|
  s.name        = "jsongram"
  s.version     = "0.0.1"
  s.date        = "2013-11-10"
  s.summary     = "Lite json serializer"
  s.description = "Lite json serializer, using only ruby and oj gem"
  s.authors     = ["Martynas Povilaitis"]
  s.email       = "martynas.px@gmail.com"
  s.homepage    = 'http://github.com/martynasp/jsongram'
  s.license     = 'MIT'

  s.files = Dir["{lib}/**/*"] + %w(README.md LICENSE)
  s.add_dependency "oj", ">= 2.1.7"
  s.add_development_dependency "rspec", ">= 2.14.1"

  s.require_paths = ["lib"]

end