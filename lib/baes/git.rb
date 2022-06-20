# frozen_string_literal: true

require "open3"
require "English"

# module to encapsulate git commands in the shell
module Baes::Git
  extend Baes::Configuration

  class GitError < StandardError; end

  # checkout git branch and raise error on failure
  def self.checkout(branch_name)
    stdout, stderr, status = Open3.capture3("git checkout #{branch_name}")

    output.puts(stdout)
    output.puts(stderr) unless stderr.empty?

    return if status.success?

    raise GitError, "failed to rebase on '#{branch_name}'"
  end

  # rebase current branch on given branch name and return status
  def self.rebase(branch_name)
    stdout, stderr, status = Open3.capture3("git rebase #{branch_name}")

    output.puts(stdout)
    output.puts(stderr) unless stderr.empty?

    status
  end

  # list branch names and raise on failure
  def self.branch_names
    stdout, stderr, status = Open3.capture3("git branch")

    output.puts(stderr) unless stderr.empty?

    raise GitError, "failed to get branches" unless status.success?

    stdout.lines.map { |line| line.sub(/^\*/, "").strip }
  end

  # skip current commit during rebase and return status
  def self.rebase_skip
    stdout, stderr, status = Open3.capture3("git rebase --skip")

    output.puts(stdout)
    output.puts(stderr) unless stderr.empty?

    status
  end

  # return the commit number the rebase is currently halted on
  def self.next_rebase_step
    File.read("./.git/rebase-apply/next").strip
  end

  # return the number of commits in the rebase
  def self.last_rebase_step
    File.read("./.git/rebase-apply/last").strip
  end
end
