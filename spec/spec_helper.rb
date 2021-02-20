require 'bundler/setup'
require 'support/factory_bot'
require 'support/have_constant_matcher'
require 'support/shared_values'
require 'support/webmock_stubs'
require 'webmock/rspec'
require 'fakefs/spec_helpers'

require 'simplecov'
require 'codecov'
require 'codeclimate-test-reporter'

SimpleCov.start do
  # Don't get coverage on the test cases themselves.
  add_filter '/spec/'
  add_filter '/test/'
  # Codecov doesn't automatically ignore vendored files.
  add_filter '/vendor/'
end
SimpleCov.formatter = SimpleCov::Formatter::Codecov

CodeClimate::TestReporter.start

require 'threema'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
