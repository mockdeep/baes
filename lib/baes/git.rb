# frozen_string_literal: true

require "English"
require "open3"

# module to encapsulate git commands in the shell
module Baes::Git
  extend Baes::Configuration::Helpers

  class GitError < StandardError; end

  class << self
    # checkout git branch and raise error on failure
    def checkout(branch_name)
      stdout = run_or_raise("git checkout #{branch_name}")

      output.puts(stdout)
    end

    # rebase current branch on given branch name and return status
    def rebase(branch_name)
      run_returning_status("git rebase #{branch_name}")
    end

    # get current branch name and raise on error
    def current_branch_name
      run_or_raise("git rev-parse --abbrev-ref HEAD")
    end

    # list branch names and raise on failure
    def branch_names
      stdout = run_or_raise("git branch")

      stdout.lines.map { |line| line.sub(/^\*/, "").strip }
    end

    # skip current commit during rebase and return status
    def rebase_skip
      run_returning_status("git rebase --skip")
    end

    # return the commit number the rebase is currently halted on
    def next_rebase_step
      if Dir.exist?("./.git/rebase-apply")
        Integer(File.read("./.git/rebase-apply/next"))
      else
        Integer(File.read("./.git/rebase-merge/msgnum"))
      end
    end

    # return the number of commits in the rebase
    def last_rebase_step
      if Dir.exist?("./.git/rebase-apply")
        Integer(File.read("./.git/rebase-apply/last"))
      else
        Integer(File.read("./.git/rebase-merge/end"))
      end
    end

    private

    def run_or_raise(command)
      stdout, stderr, status = Open3.capture3(command)

      unless status.success?
        output.puts(stderr)

        raise GitError, "failed to run '#{command}'"
      end

      stdout.strip
    end

    def run_returning_status(command)
      stdout, stderr, status = Open3.capture3(command)

      output.puts(stdout)
      output.puts(stderr) unless stderr.empty?

      status
    end
  end
end
