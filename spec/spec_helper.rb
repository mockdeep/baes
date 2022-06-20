# frozen_string_literal: true

# coverage setup must come before loading lib/ code
require "support/coverage"

require "baes"

require_relative "support/fake_git"
require_relative "support/matchers"
require_relative "support/stub_system"

class TestingError < StandardError; end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.include(Matchers)

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
