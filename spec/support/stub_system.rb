# frozen_string_literal: true

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
  config.before do
    allow(Open3).to receive(:capture3)
    Baes::Configuration.output = StringIO.new
    Baes::Configuration.input = StringIO.new
    Baes::Configuration.root_name = nil
    Baes::Configuration.dry_run = false
    Baes::Configuration.auto_skip = false
  end

  config.around do |example|
    example.run
  rescue SystemExit => e
    puts(e.backtrace)
    raise StandardError, "uncaught SystemExit"
  end
end
