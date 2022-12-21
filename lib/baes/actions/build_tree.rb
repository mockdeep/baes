# frozen_string_literal: true

SKIP_BRANCHES = ["staging", "main", "master"].freeze

# class that generates a tree of dependent branches
class Baes::Actions::BuildTree
  include Baes::Configuration

  # generate a tree of Branch records linked to their children
  def call(branches, root_branch:)
    indexed_branches = index_branches(branches)

    branches.each do |branch|
      link_branch_to_parent(branch, indexed_branches, root_branch: root_branch)
    end

    prune(root_branch)
  end

  private

  def prune(branch)
    branch.children.delete_if do |child|
      ignored_branch_names.include?(child.name)
    end

    branch.children.each { |child| prune(child) }
  end

  def link_branch_to_parent(branch, indexed_branches, root_branch:)
    return if branch == root_branch || SKIP_BRANCHES.include?(branch.name)

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
