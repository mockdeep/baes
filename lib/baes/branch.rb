# frozen_string_literal: true

# class to encapsulate git branch and rebase behavior
class Baes::Branch
  attr_accessor :name, :base_name, :number, :children

  include Baes::Configuration::Helpers

  # instantiate a new Baes::Branch with the given name
  def initialize(name)
    self.name = name
    _, base_name, number = name.match(/(\A[a-zA-Z_-]+)(\d+)$/).to_a
    self.base_name = base_name || name
    self.number = number && Integer(number, 10)
    self.children = []
  end

  # return an array for use as a hash key
  def index
    [base_name, number].compact
  end

  # rebase this branch on top of passed branch
  def rebase(other_branch)
    git.checkout(name)

    result = git.rebase(other_branch.name)

    skip_through(other_branch) unless result.success?
  end

  # return a formatted string of branch with children
  def inspect(indentation = "")
    children_strings =
      children.map do |child|
        "\n#{child.inspect("#{indentation}  ")}"
      end

    "#{indentation}#{name}#{children_strings.join}"
  end

  private

  def skip_through(other_branch)
    if auto_skip? || confirm_skip(other_branch) == "y"
      result = git.rebase_skip

      skip_through(other_branch) unless result.success?
    else
      abort "failed to rebase, please resolve manually and then re-run baes"
    end
  end

  def confirm_skip(other_branch)
    output.puts("conflict rebasing branch #{name} on #{other_branch.name}")
    output.print(skip_rebase_message)
    answer = input.gets.chomp
    output.puts

    answer
  end

  def auto_skip?
    Baes::Configuration.auto_skip? &&
      git.next_rebase_step < git.last_rebase_step
  end

  def skip_rebase_message
    "skip commit #{git.next_rebase_step} of #{git.last_rebase_step}? (y/n)"
  end
end
