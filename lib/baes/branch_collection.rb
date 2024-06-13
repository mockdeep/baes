# frozen_string_literal: true

# class to encapsulate a collection of branches
class Baes::BranchCollection
  attr_accessor :branches

  def initialize
    self.branches = []
  end

  # add a branch
  def <<(branch)
    branches << branch
  end

  # find a branch
  def find(&block)
    branches.find(&block)
  end

  # iterate over each branch with object
  def each_with_object(obj, &block)
    branches.each_with_object(obj, &block)
  end

  # iterate over each branch
  def each(&block)
    branches.each(&block)
  end

  # return the first branch
  def first
    branches.first
  end

  # return a branch by index
  def [](index)
    branches[index]
  end
end
