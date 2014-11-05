# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'crystal_forge/version'

Gem::Specification.new do |spec|
  spec.name          = 'crystal_forge'
  spec.version       = CrystalForge::VERSION
  spec.authors       = ['Benjamin Falk']
  spec.email         = %w("benjamin.falk@yahoo.com")
  spec.summary       = 'API Blueprint Stub-Server'
  spec.description   = 'Simple testing service to stub server calls with blueprint files'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = ['lib']
  spec.add_dependency 'redsnow', '~> 0.2'
  spec.add_dependency 'rack', '~> 1.5'
  spec.add_dependency 'gli', '~> 2.12'
  spec.add_dependency 'addressable'
  # spec.add_dependency 'raml-rb'

  spec.add_development_dependency 'bundler', '~> 1.7.0'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec-its'
  spec.add_development_dependency 'cucumber'
  spec.add_development_dependency 'faraday'
  spec.add_development_dependency 'aruba'
end
