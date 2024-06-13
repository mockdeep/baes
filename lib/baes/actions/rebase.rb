# frozen_string_literal: true

# top-level class to orchestrate rebasing branches
class Baes::Actions::Rebase
  class << self
    include Baes::Configuration::Helpers

    # rebase branches
    def call
      branches = Baes::Actions::BuildTree.call
      root_branch = find_root_branch(branches)

      if dry_run?
        output.puts(root_branch.inspect)
      else
        rebase_children(root_branch)
      end

      git.checkout(root_branch.name)
    end

    private

    def find_root_branch(branches)
      if root_name
        branches.find { |branch| branch.name == root_name }
      else
        branches.find { |branch| ["main", "master"].include?(branch.name) }
      end
    end

    def rebase_children(branch)
      branch.children.each do |child_branch|
        child_branch.rebase(branch)
        rebase_children(child_branch)
      end
    end
  end
end
