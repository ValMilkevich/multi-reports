$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "reports/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "reports"
  s.version     = Reports::VERSION
  s.authors     = ["Val Milkevich"]
  s.email       = ["milkevich@gmail.com"]
  s.homepage    = "http://stopbreaththink.org"
  s.summary     = "Reports generation software"
  s.description = "Reports generation description"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.4"
  s.add_dependency "pg"
  s.add_dependency 'ar-octopus'

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
end
