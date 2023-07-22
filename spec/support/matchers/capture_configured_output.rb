# frozen_string_literal: true

module CaptureConfiguredOutput
  def self.name
    "configured output"
  end

  def self.capture(block)
    old_output = Baes::Configuration.output
    new_output = StringIO.new
    Baes::Configuration.output = new_output

    block.call

    new_output.string
  ensure
    Baes::Configuration.output = old_output
  end
end

module Matchers::OutputExtensions
  def to_configured_output
    @stream_capturer = CaptureConfiguredOutput
    self
  end
end

RSpec::Matchers::BuiltIn::Output.include(Matchers::OutputExtensions)
