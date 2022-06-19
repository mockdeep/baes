# frozen_string_literal: true

require "simplecov"

SimpleCov.start do
  enable_coverage :branch
end

require "baes"

class TestingError < StandardError; end

module Kernel
  def `(command)
    raise TestingError,
          "Don't use system calls. " \
          "Use `Open3.capture3` instead. Called with `#{command}`"
  end

  def system(command)
    raise TestingError,
          "Don't use system calls. " \
          "Use `Open3.capture3` instead. Called with `#{command}`"
  end
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before do
    allow(Open3).to receive(:capture3)
  end
end
