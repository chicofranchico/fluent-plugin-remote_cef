# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'fluent-plugin-remote_cef'
  spec.version       = File.read('VERSION').strip
  spec.authors       = ['chicofranchico']
  spec.email         = ['chicofranchico@gmail.com']
  spec.summary       = 'Fluentd output plugin for outputing CEF format to a remote ArcSight' # rubocop:disable LineLength
  spec.description   = spec.description
  spec.homepage      = 'https://github.com/chicofranchico/fluent-plugin-remote_cef'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'test-unit'
  spec.add_development_dependency 'test-unit-rr'

  spec.add_runtime_dependency 'fluentd'
  # spec.add_runtime_dependency 'cef', '>= 0.8.2' # the dependency should
end
