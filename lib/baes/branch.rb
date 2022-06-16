require 'English'
require 'open3'

class Baes::Branch
  attr_accessor :name
  attr_accessor :children

  def initialize(name)
    @name = name
    @children = []
  end

  def rebase(other_branch)
    print `git checkout #{name}`
    stdout, stderr, status = Open3.capture3("git rebase #{other_branch.name}")
    puts stdout
    puts stderr unless stderr.empty?
    skip_through(other_branch) unless status.success?
  end

  def skip_through(other_branch)
    puts "conflict rebasing branch #{name} on #{other_branch.name}"
    print "skip commit #{next_step} of #{last_step}? (y/n)"
    answer = gets.chomp
    if answer == 'y'
      print `git rebase --skip`
      skip_through(other_branch) if !$CHILD_STATUS.success?
    else
      abort 'failed to rebase'
    end
  end

  def next_step
    File.read('./.git/rebase-apply/next').strip
  end

  def last_step
    File.read('./.git/rebase-apply/last').strip
  end

  def inspect(indentation = '')
    children_strings = children.map do |child|
      "\n#{child.inspect(indentation + '  ')}"
    end
    "#{indentation}#{name}#{children_strings.join}"
  end
end
