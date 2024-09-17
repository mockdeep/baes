# frozen_string_literal: true

require "English"
require "open3"

# module to encapsulate git commands in the shell
module Baes::Git
  extend Baes::Helpers::Commands
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
    def branch_names(cli_args = "")
      stdout = run_or_raise("git branch #{cli_args}".strip)

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

    # prune remote branches and raise on failure
    def remote_prune(remote)
      output.puts("pruning remote branches for #{remote}")
      stdout = run_or_raise("git remote prune #{remote}")

      output.puts(stdout) unless stdout.empty?
    end

    # run git maintenance and raise on failure
    def maintenance
      output.puts("running maintenance tasks")
      stdout = run_or_raise("git maintenance run")

      output.puts(stdout) unless stdout.empty?
    end

    # delete branches and raise on failure
    def delete_branches(branch_names)
      return if branch_names.empty?

      output.puts("deleting branches")
      output.puts(run_or_raise("git branch -d #{branch_names.join(" ")}"))
    end
  end
end
