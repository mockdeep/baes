# frozen_string_literal: true

# top-level class to orchestrate rebasing branches
class Baes::Rebaser
  include Baes::Configuration

  # parse options and rebase branches
  def call(options)
    root_branch = find_root_branch(options)
    Baes::TreeBuilder.new.call(branches, root_branch: root_branch)

    if options.any? { |option| option == "--dry" }
      output.puts(root_branch.inspect)
    else
      rebase_children(root_branch)
    end

    git.checkout(root_branch.name)
  end

  private

  def branches
    @branches ||=
      git.branch_names.map do |branch_name|
        Baes::Branch.new(branch_name)
      end
  end

  def find_root_branch(options)
    root_name = options.find { |option| option != "--dry" }

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
