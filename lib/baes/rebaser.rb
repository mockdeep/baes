class Baes::Rebaser
  def call(options)
    root_name =
      options.detect { |option| option != '--dry' } || detect_root_name
    root_branch = Baes::TreeBuilder.new.(branches, root_name: root_name)

    if options.any? { |option| option == '--dry' }
      puts root_branch.inspect
    else
      rebase_children(root_branch)
    end

    git.checkout(root_branch.name)
  end

  def branches
    @branches ||= git.branch_names.map do |branch_name|
      Baes::Branch.new(branch_name)
    end
  end

  def detect_root_name
    root ||= 'main' if branches.any? { |branch| branch.name == 'main' }
    root || 'master'
  end

  def rebase_children(branch)
    branch.children.each do |child_branch|
      child_branch.rebase(branch)
      rebase_children(child_branch)
    end
  end

  def git
    Baes.git
  end
end
