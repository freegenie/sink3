# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sink3/version'

Gem::Specification.new do |spec|
  spec.name          = "sink3"
  spec.version       = Sink3::VERSION
  spec.authors       = ["Fabrizio Regini"]
  spec.email         = ["freegenie@gmail.com"]
  spec.summary       = %q{S3 backup designed for servers}
  spec.description   = %q{Sink3 is an S3 backup designed to work with write-only keys.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "aws-sdk", "< 2.0"
  spec.add_dependency "dotenv", "~> 0.11.1"
  spec.add_dependency "thor", "~> 0.19.1"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
