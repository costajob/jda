# coding: utf-8
$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))
require 'jda/version'

Gem::Specification.new do |s|
  s.name = "jda"
  s.version = Jda::VERSION
  s.authors = ["costajob"]
  s.email = ["costajob@gmail.com"]
  s.summary = %q{JDA paring and utility libraries}
  s.homepage = "https://github.com/costajob/jda.git"
  s.license = "MIT"
  s.required_ruby_version = ">= 1.8.7"
  s.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|s|features)/}) }
  s.bindir = "exe"
  s.executables = s.files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "bundler", "~> 1.10"
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "minitest"
  s.add_development_dependency "rr"
end
