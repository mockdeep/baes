# frozen_string_literal: true

module Baes::Configuration
  def self.git
    @git ||= Baes::Git
  end

  def self.git=(git)
    @git = git
  end

  def self.input
    @input ||= $stdin
  end

  def self.input=(input)
    @input = input
  end

  def self.output
    @output ||= $stdout
  end

  def self.output=(output)
    @output = output
  end

  def git
    Baes::Configuration.git
  end

  def input
    Baes::Configuration.input
  end

  def output
    Baes::Configuration.output
  end
end
