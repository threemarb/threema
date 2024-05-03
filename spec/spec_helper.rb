# frozen_string_literal: true

require 'bundler/setup'
require 'support/factory_bot'
require 'support/have_constant_matcher'
require 'support/shared_values'
require 'support/webmock_stubs'
require 'webmock/rspec'
require 'fakefs/spec_helpers'
require 'pry'

require 'simplecov'

SimpleCov.start do
  # Don't get coverage on the test cases themselves.
  add_filter '/spec/'
  add_filter '/test/'
end
SimpleCov.formatter = SimpleCov::Formatter::HTMLFormatter

require 'threema'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
