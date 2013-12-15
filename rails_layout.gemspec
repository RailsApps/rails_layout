# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails_layout/version'

Gem::Specification.new do |spec|
  spec.name          = "rails_layout"
  spec.version       = RailsLayout::VERSION
  spec.authors       = ["Daniel Kehoe"]
  spec.email         = ["daniel@danielkehoe.com"]
  spec.description   = %q{Generates Rails application layout files for use with various front-end frameworks.}
  spec.summary       = %q{Rails generator creates application layout files for Bootstrap and other frameworks.}
  spec.homepage      = "http://github.com/RailsApps/rails_layout/"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
