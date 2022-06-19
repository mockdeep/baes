class Baes::Branch
  attr_accessor :name
  attr_accessor :children

  def initialize(name)
    @name = name
    @children = []
  end

  def rebase(other_branch)
    git.checkout(name)

    result = git.rebase(other_branch.name)

    skip_through(other_branch) if !result.success?
  end

  def skip_through(other_branch)
    puts "conflict rebasing branch #{name} on #{other_branch.name}"
    print "skip commit #{git.next_rebase_step} of #{git.last_rebase_step}? (y/n)"
    answer = gets.chomp

    if answer == 'y'
      result = git.rebase_skip

      skip_through(other_branch) if !result.success?
    else
      abort 'failed to rebase'
    end
  end

  def inspect(indentation = '')
    children_strings = children.map do |child|
      "\n#{child.inspect(indentation + '  ')}"
    end
    "#{indentation}#{name}#{children_strings.join}"
  end

  def git
    Baes.git
  end
end
