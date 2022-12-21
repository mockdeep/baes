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

  # return the configured ignored branches
  def self.ignored_branch_names
    @ignored_branch_names ||= []
  end

  # allow setting the ignored branch names
  def self.ignored_branch_names=(ignored_branch_names)
    @ignored_branch_names = ignored_branch_names
  end

  # return whether dry run mode has been enabled
  def self.dry_run?
    !!@dry_run
  end

  # allow setting dry run mode
  def self.dry_run=(dry_run)
    @dry_run = dry_run
  end

  # return whether auto skip mode has been enabled
  def self.auto_skip?
    !!@auto_skip
  end

  # allow setting auto skip mode
  def self.auto_skip=(auto_skip)
    @auto_skip = auto_skip
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

  # return the configured ignored branch names
  def ignored_branch_names
    Baes::Configuration.ignored_branch_names
  end

  # return whether dry run has been enabled
  def dry_run?
    Baes::Configuration.dry_run?
  end
end
