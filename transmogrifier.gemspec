# encoding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'transmogrifier/version'

Gem::Specification.new do |spec|
  spec.name = "transmogrifier"
  spec.version = Transmogrifier::VERSION

  spec.authors = ["John Foley"]
  spec.email = ["john@hisfoleyness.com"]
  spec.date = "2013-11-06"

  spec.description = "A tool for manipulating schemas"
  spec.summary = "A tool for manipulating schemas"
  spec.homepage = "http://github.com/jfoley/transmogrifier"
  spec.licenses = ["MIT"]

  spec.require_paths = ["lib"]

  spec.files = `git ls-files -- lib/*`.split("\n")
  spec.files += %w[README.md LICENSE.txt Gemfile]
  spec.test_files = `git ls-files -- spec/*`.split("\n")

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "transpec"
end
