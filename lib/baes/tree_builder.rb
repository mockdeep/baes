# frozen_string_literal: true

SKIP_BRANCHES = ["staging", "main", "master"].freeze

# class that generates a tree of dependent branches
class Baes::TreeBuilder
  # generate a tree of Branch records linked to their children
  def call(branches, root_name:)
    indexed_branches = index_branches(branches)

    branches.each do |branch|
      link_branch_to_parent(branch, indexed_branches, root_name: root_name)
    end

    indexed_branches.fetch(root_name)
  end

  private

  def link_branch_to_parent(branch, indexed_branches, root_name:)
    return if (SKIP_BRANCHES + [root_name]).include?(branch.name)

    root_branch = indexed_branches.fetch(root_name)
    parent_branch =
      indexed_branches[parent_name(branch, root_name: root_name)] || root_branch

    parent_branch.children << branch
  end

  def parent_name(branch, root_name:)
    _, name, number = branch.name.match(/(\A[a-zA-Z_-]+)(\d+)/).to_a

    if number
      "#{name}#{(Integer(number, 10) - 1).to_s.rjust(number.length, "0")}"
    else
      root_name
    end
  end

  def index_branches(branches)
    branches.each_with_object({}) do |branch, result|
      result[branch.name] = branch
    end
  end
end
