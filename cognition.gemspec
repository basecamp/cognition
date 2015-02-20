# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cognition/version'

Gem::Specification.new do |spec|
  spec.name          = "cognition"
  spec.version       = Cognition::VERSION
  spec.authors       = ["Nathan Anderson"]
  spec.email         = ["andnat@gmail.com"]
  spec.summary       = %q{A rules engine for running commands.}
  spec.description   = %q{Match text; run commands. Works great for building a chatbot!}
  spec.homepage      = "https://github.com/anoldguy/Cognition"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0.0"
end
