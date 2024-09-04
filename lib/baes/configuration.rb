# frozen_string_literal: true

# module to allow configuring various Baes settings
module Baes::Configuration
  class << self
    # return the git wrapper in use, Baes::Git by default
    def git
      @git ||= Baes::Git
    end

    # allow setting the git wrapper, useful in tests
    attr_writer :git

    # return the input stream, $stdin by default
    def input
      @input ||= $stdin
    end

    # allow setting the input stream, useful in tests
    attr_writer :input

    # return the output stream, $stdout by default
    def output
      @output ||= $stdout
    end

    # allow setting the output stream, useful in tests
    attr_writer :output

    # return the configured root_name
    def root_name
      @root_name ||=
        begin
          root = (["main", "master"] & git.branch_names).first

          message = "unable to infer root branch, please specify with -r"
          raise Baes::Git::GitError, message unless root

          root
        end
    end

    # allow setting the root_name
    attr_writer :root_name

    # return the configured ignored branches
    def ignored_branch_names
      @ignored_branch_names ||= []
    end

    # allow setting the ignored branch names
    attr_writer :ignored_branch_names

    # return whether dry run mode has been enabled
    def dry_run?
      !!@dry_run
    end

    # allow setting dry run mode
    attr_writer :dry_run

    # return whether auto skip mode has been enabled
    def auto_skip?
      !!@auto_skip
    end

    # allow setting auto skip mode
    attr_writer :auto_skip

    # clear all configuration
    def reset
      instance_variables.each do |ivar|
        remove_instance_variable(ivar)
      end
    end
  end
end
