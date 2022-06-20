# frozen_string_literal: true

# module to allow configuring various Baes settings
module Baes::Configuration
  # return the git wrapper in use, Baes::Git by default
  def self.git
    @git ||= Baes::Git
  end

  # allow setting the git wrapper, useful in tests
  def self.git=(git)
    @git = git
  end

  # return the input stream, $stdin by default
  def self.input
    @input ||= $stdin
  end

  # allow setting the input stream, useful in tests
  def self.input=(input)
    @input = input
  end

  # return the output stream, $stdout by default
  def self.output
    @output ||= $stdout
  end

  # allow setting the output stream, useful in tests
  def self.output=(output)
    @output = output
  end

  # return the configured git wrapper
  def git
    Baes::Configuration.git
  end

  # return the configured input
  def input
    Baes::Configuration.input
  end

  # return the configured outpu
  def output
    Baes::Configuration.output
  end
end
