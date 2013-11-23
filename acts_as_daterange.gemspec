# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'acts_as_daterange/version'

Gem::Specification.new do |spec|
  spec.name          = "acts_as_daterange"
  spec.version       = ActsAsDaterange::VERSION
  spec.authors       = ["Gilad Zohari"]
  spec.email         = ["gzohari@gmail.com"]
  spec.description   = %q{foo}
  spec.summary       = %q{bar}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'activerecord', '>= 3.0'
  spec.add_runtime_dependency 'activesupport', '>= 3.0'
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency "rspec"
end
