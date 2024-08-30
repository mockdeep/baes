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
    find_by_name(root_name)
  end

  # find a branch by name
  def find_by_name(name)
    branches.find { |branch| branch.name == name }
  end

  # find a branch by base name
  def find_by_base_name(base_name)
    branches.find { |branch| branch.base_name == base_name }
  end

  # add a branch
  def <<(branch)
    branches << branch
  end

  # delete a branch if the block returns true
  def delete_if(&block)
    branches.delete_if(&block)
  end

  # iterate over each branch with object
  def each_with_object(obj, &block)
    branches.each_with_object(obj, &block)
  end

  # iterate over each branch
  def each(&block)
    branches.each(&block)
  end

  # return true if there are no branches
  def empty?
    branches.empty?
  end

  # iterate over each branch and return the result
  def map(&block)
    branches.map(&block)
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
