# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'roffle/version'

Gem::Specification.new do |spec|
  spec.name          = "roffle"
  spec.version       = Roffle::VERSION
  spec.authors       = ["Leo Cassarani"]
  spec.email         = ["leo.cassarani@me.com"]
  spec.description   = ""
  spec.summary       = "A Ruby refactoring tool."
  spec.homepage      = "https://github.com/leocassarani/roffle"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "pry", "~> 0.9.12"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "turn", "~> 0.9.6"
  spec.add_runtime_dependency "ruby_parser", "~> 3.2.2"
end
