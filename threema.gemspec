# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'threema/version'

Gem::Specification.new do |spec|
  spec.name          = 'threema'
  spec.version       = Threema::VERSION
  spec.authors       = ['Thorsten Eckel']
  spec.email         = ['te@znuny.com']

  spec.summary       = 'Ruby SDK for the Threema Gateway.'
  spec.description   = 'Ruby SDK for the Threema Gateway.'
  spec.homepage      = 'https://github.com/thorsteneckel/threema'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 2.6.0'

  spec.files         = Dir['{lib}/**/*']
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'case_transform'
  spec.add_runtime_dependency 'dotenv'
  spec.add_runtime_dependency 'mimemagic'
  spec.add_runtime_dependency 'mime-types'
  spec.add_runtime_dependency 'multipart-post'
  spec.add_runtime_dependency 'rbnacl'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'codeclimate-test-reporter', '~> 0.6'
  spec.add_development_dependency 'codecov'
  spec.add_development_dependency 'factory_bot'
  spec.add_development_dependency 'fakefs'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'webmock'
end
