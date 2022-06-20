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
  end
end
