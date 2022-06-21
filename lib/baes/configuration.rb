# frozen_string_literal: true

require "optparse"

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

  # return the configured root_name
  def self.root_name
    @root_name
  end

  # allow setting the root_name
  def self.root_name=(root_name)
    @root_name = root_name
  end

  # return whether dry run mode has been configured
  def self.dry_run?
    !!@dry_run
  end

  # allow setting dry run mode
  def self.dry_run=(dry_run)
    @dry_run = dry_run
  end

  # loads options, typically passed via the command line
  def load_options(options)
    parser = OptionParser.new

    configure_dry_run(parser)
    configure_help(parser)
    configure_root_name(parser)

    parser.parse(options)
  end

  # return the configured git wrapper
  def git
    Baes::Configuration.git
  end

  # return the configured input
  def input
    Baes::Configuration.input
  end

  # return the configured output
  def output
    Baes::Configuration.output
  end

  # return the configured root name if given
  def root_name
    Baes::Configuration.root_name
  end

  # return whether dry run has been enabled
  def dry_run?
    Baes::Configuration.dry_run?
  end

  private

  def configure_dry_run(parser)
    parser.on("--dry-run", "prints branch chain without rebasing") do
      Baes::Configuration.dry_run = true
    end
  end

  def configure_help(parser)
    parser.on("-h", "--help", "prints this help") do
      output.puts(parser)
      exit
    end
  end

  def configure_root_name(parser)
    message = "specify a root branch to rebase on"
    parser.on("-r", "--root ROOT", message) do |root_name|
      Baes::Configuration.root_name = root_name
    end
  end
end
