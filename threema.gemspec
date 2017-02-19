# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'threema/version'

Gem::Specification.new do |spec|
  spec.name          = "threema"
  spec.version       = Threema::VERSION
  spec.authors       = ["Thorsten Eckel"]
  spec.email         = ["te@znuny.com"]

  spec.summary       = %q{TODO: Write a short summary, because Rubygems requires one.}
  spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

  spec.required_ruby_version = '>= 2.2'

  spec.files         = Dir['{lib}/**/*']
  spec.executables   = ['yeah', 'yeah-dev']
  spec.require_paths = ['lib']

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
