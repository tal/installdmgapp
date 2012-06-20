# -*- encoding: utf-8 -*-
require File.expand_path('../lib/installdmgapp/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Tal Atlas"]
  gem.email         = ["me@tal.by"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "installdmgapp"
  gem.require_paths = ["lib"]
  gem.version       = Installdmgapp::VERSION

  # gem.add_runtime_dependency("thor", ["~> 0.15.1"])
  gem.add_runtime_dependency("ps")
end
