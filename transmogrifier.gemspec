# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "transmogrifier"
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["John Foley"]
  s.date = "2013-11-06"
  s.description = "A tool for manipulating schemas"
  s.email = ["john@hisfoleyness.com"]
  s.files = [".gitignore", "Gemfile", "LICENSE.txt", "README.md", "Rakefile", "lib/transmogrifier.rb", "lib/transmogrifier/engine.rb", "lib/transmogrifier/nodes.rb", "lib/transmogrifier/nodes/array_node.rb", "lib/transmogrifier/nodes/hash_node.rb", "lib/transmogrifier/nodes/node.rb", "lib/transmogrifier/nodes/value_node.rb", "lib/transmogrifier/rules.rb", "lib/transmogrifier/rules/append.rb", "lib/transmogrifier/rules/delete.rb", "lib/transmogrifier/rules/move.rb", "lib/transmogrifier/selector.rb", "lib/transmogrifier/version.rb", "spec/engine_spec.rb", "spec/nodes/array_node_spec.rb", "spec/nodes/hash_node_spec.rb", "spec/nodes/node_spec.rb", "spec/nodes/value_node_spec.rb", "spec/rules/append_spec.rb", "spec/rules/delete_spec.rb", "spec/rules/move_spec.rb", "spec/selector_spec.rb", "spec/transmogrifier_spec.rb", "transmogrifier.gemspec"]
  s.homepage = "http://github.com/jfoley/transmogrifier"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.7"
  s.summary = "A tool for manipulating schemas"
  s.test_files = ["spec/engine_spec.rb", "spec/nodes/array_node_spec.rb", "spec/nodes/hash_node_spec.rb", "spec/nodes/node_spec.rb", "spec/nodes/value_node_spec.rb", "spec/rules/append_spec.rb", "spec/rules/delete_spec.rb", "spec/rules/move_spec.rb", "spec/selector_spec.rb", "spec/transmogrifier_spec.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, ["~> 1.3"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
    else
      s.add_dependency(%q<bundler>, ["~> 1.3"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<bundler>, ["~> 1.3"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
  end
end
