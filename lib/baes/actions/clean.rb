# frozen_string_literal: true

# class that will prune remote branches, garbage collect, and delete merged
# branches
module Baes::Actions::Clean
  class << self
    include Baes::Configuration::Helpers

    # run the command
    def call
      output.puts("cleaning up branches")
      git.checkout(root_name)
      git.remote_prune("origin")
      git.gc
      git.delete_branches(merged_branches)
    end

    private

    def merged_branches
      branches = git.branch_names("--merged")
      branches.select do |branch|
        branch != root_name && !ignored_branch_names.include?(branch)
      end
    end
  end
end
