# frozen_string_literal: true

# class that generates a tree of dependent branches
class Baes::Actions::BuildTree
  class << self
    include Baes::Configuration::Helpers

    # generate a tree of Branch records linked to their children
    def call
      branches = generate_branches
      indexed_branches = index_branches(branches)

      branches.each do |branch|
        link_branch_to_parent(
          branch,
          indexed_branches,
          root_branch: branches.root
        )
      end

      prune(branches.root, skipped_branch_names)
      branches
    end

    private

    def skipped_branch_names
      ignored_branch_names + git.worktree_branch_names
    end

    def generate_branches
      branches = Baes::BranchCollection.new
      git.branch_names.each do |branch_name|
        branches << Baes::Branch.new(branch_name)
      end
      branches
    end

    def prune(branch, skipped_names)
      branch.children.delete_if { |child| skipped_names.include?(child.name) }

      branch.children.each { |child| prune(child, skipped_names) }
    end

    def link_branch_to_parent(branch, indexed_branches, root_branch:)
      return if branch == root_branch

      parent_branch = indexed_branches.fetch(parent_name(branch), root_branch)

      parent_branch.children << branch
    end

    def parent_name(branch)
      _, name, number = branch.name.match(/(\A[a-zA-Z_-]+)(\d+)$/).to_a

      return [name] unless number

      [name, Integer(number, 10) - 1]
    end

    def index_branches(branches)
      branches.each_with_object({}) do |branch, result|
        index = branch.index

        raise Baes::Error, "duplicate branch index #{index}" if result[index]

        result[index] = branch
      end
    end
  end
end
