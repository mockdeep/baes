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
      stdout, stderr, status = Open3.capture3("git checkout #{branch_name}")

      output.puts(stdout)
      output.puts(stderr) unless stderr.empty?

      return if status.success?

      raise GitError, "failed to rebase on '#{branch_name}'"
    end

    # rebase current branch on given branch name and return status
    def rebase(branch_name)
      stdout, stderr, status = Open3.capture3("git rebase #{branch_name}")

      output.puts(stdout)
      output.puts(stderr) unless stderr.empty?

      status
    end

    # get current branch name and raise on error
    def current_branch_name
      stdout, stderr, status = Open3.capture3("git rev-parse --abbrev-ref HEAD")

      output.puts(stderr) unless stderr.empty?

      raise GitError, "failed to get current branch" unless status.success?

      stdout.strip
    end

    # list branch names and raise on failure
    def branch_names
      stdout, stderr, status = Open3.capture3("git branch")

      output.puts(stderr) unless stderr.empty?

      raise GitError, "failed to get branches" unless status.success?

      stdout.lines.map { |line| line.sub(/^\*/, "").strip }
    end

    # skip current commit during rebase and return status
    def rebase_skip
      stdout, stderr, status = Open3.capture3("git rebase --skip")

      output.puts(stdout)
      output.puts(stderr) unless stderr.empty?

      status
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
  end
end
