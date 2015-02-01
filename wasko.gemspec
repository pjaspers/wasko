# -*- encoding: utf-8 -*-
require File.expand_path('../lib/wasko/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["pjaspers"]
  gem.email         = ["piet@jaspe.rs"]
  gem.description   = %q{Wasko colors your day/terminal}
  gem.summary       = %q{Wasko will allow you to quickly set a new background color for your terminal}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "wasko"
  gem.require_paths = ["lib"]
  gem.version       = Wasko::VERSION

  gem.add_runtime_dependency 'color'
  gem.add_runtime_dependency 'thor'
  gem.add_runtime_dependency 'rake'
  gem.add_development_dependency 'shoulda'
  gem.add_development_dependency 'mocha'
end
