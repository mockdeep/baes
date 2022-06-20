SKIP_BRANCHES = ["staging", "main", "master"]

class Baes::TreeBuilder
  def initialize
    @branch_cache = {}
  end

  def call(branches, root_name:)
    branches.each do |branch|
      link_branch_to_parent(branch, branches, root_name: root_name)
    end
    find_branch(branches, root_name)
  end

  def link_branch_to_parent(branch, branches, root_name:)
    return if (SKIP_BRANCHES + [root_name]).include?(branch.name)

    root_branch = find_branch(branches, root_name)
    parent_branch =
      find_branch(branches, parent_name(branch, root_name: root_name)) ||
      root_branch

    parent_branch.children << branch
  end

  def parent_name(branch, root_name:)
    _, name, number = branch.name.match(/(\A[a-zA-Z_-]+)(\d+)/).to_a

    number ? "#{name}#{(number.to_i - 1).to_s.rjust(number.length, '0')}" : root_name
  end

  def find_branch(branches, name)
    @branch_cache[name] ||=
      branches.detect { |branch| branch.name == name } ||
      branches.detect { |branch| branch.name.end_with?(name) }
  end
end
