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

  # return the configured root_name
  def self.root_name
    @root_name ||=
      begin
        root = (["main", "master"] & git.branch_names).first

        message = "unable to infer root branch, please specify with -r"
        raise Baes::Git::GitError, message unless root

        root
      end
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

  # clear all configuration
  def self.reset
    instance_variables.each do |ivar|
      remove_instance_variable(ivar)
    end
  end
end
