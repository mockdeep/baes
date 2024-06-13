# frozen_string_literal: true

# class to encapsulate a collection of branches
class Baes::BranchCollection
  include Baes::Configuration::Helpers

  attr_accessor :branches

  def initialize
    self.branches = []
  end

  # return the root branch
  def root
    if root_name
      find_by_name(root_name)
    else
      find_by_name("main") || find_by_name("master")
    end
  end

  # find a branch by name
  def find_by_name(name)
    branches.find { |branch| branch.name == name }
  end

  # add a branch
  def <<(branch)
    branches << branch
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
