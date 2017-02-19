# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'threema/version'

Gem::Specification.new do |spec|
  spec.name          = 'threema'
  spec.version       = Threema::VERSION
  spec.authors       = ['Thorsten Eckel']
  spec.email         = ['te@znuny.com']

  spec.summary       = 'Ruby SDK for the Threema Gateway.'
  spec.description   = 'Ruby SDK for the Threema Gateway.'
  spec.homepage      = 'https://github.com/thorsteneckel/threema.rb'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 2.2'

  spec.files         = Dir['{lib}/**/*']
  spec.executables   = ['yeah', 'yeah-dev']
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'
end
